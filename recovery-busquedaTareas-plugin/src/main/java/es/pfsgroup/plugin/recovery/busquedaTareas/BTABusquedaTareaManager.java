package es.pfsgroup.plugin.recovery.busquedaTareas;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.PluginCoreextensionConstantes;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTASubtipoTareaDao;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTATareaNotificacionDao;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTATipoEntidadDao;
import es.pfsgroup.plugin.recovery.busquedaTareas.dto.BTADtoBusquedaTareas;
import es.pfsgroup.plugin.recovery.busquedaTareas.model.BTATareaEncontrada;
import es.pfsgroup.recovery.ext.impl.tareas.ExportarTareasBean;

/**
 * Manager de Notificaciones.
 * 
 * @author pamuller
 * 
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = false)
public class BTABusquedaTareaManager {

	private final Log logger = LogFactory.getLog(getClass());

	@Resource
	private Properties appProperties;

	@Autowired
	private Executor executor;

	@Autowired
	private BTATareaNotificacionDao btaTareaNotificacionDao;

	@Autowired
	private BTASubtipoTareaDao btaSubtipoTareaDao;

	@Autowired
	private BTATipoEntidadDao btaTipoEntidadDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	// Constantes la exporación
	private static final long DAY_MILISECONDS = 1000 * 60 * 60 * 24;
	private final static String[] NOMBRES_COLUMNAS = new String[] { "ID",
			"Unidad de Gestión", "Unidad de Gestión ID", "Nombre",
			"Descripción", "Inicio", "Vencimiento", "Fin", "Días Vencida",
			"Gestor", "Supervisor", "Clasificación", "Tipo" };
	private final static String LISTA_TAREAS_XLS = "ListaTarea.xls";
	private final static String LISTA_TAREAS = "Lista Tareas";
	private final static String VACIO = "";
	public final static String EXPORTAR_BTA_LIMITE_SIMULTANEO = "exportar.excel.limite.busqueda.tareas.simultaneos";
	private final static String EXPORTAR_BTA_RUTA = "exportar.excel.limite.busqueda.tareas.ruta";
	private static ExportarTareasBean[] exportarExcelPool = null;

	private SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

	/**
	 * Realiza la b�squeda de Tareas NOtificaciones para reporte Excel. Este método para exportar es el que se utiliza desde las autoprorrogas
	 * 
	 * @param dto
	 *            DtoBuscarTareaNotificacion
	 * @return lista de tareas
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.busquedaTareas.BTABusquedaTareaManager.buscarTareasParaExcel")
	public List<TareaNotificacion> buscarTareasParaExcel(BTADtoBusquedaTareas dto) {
		EventFactory.onMethodStart(this.getClass());

		dto.setLimit(Integer.MAX_VALUE -1);
		Usuario usuarioLogado = (Usuario) executor
				.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<Perfil> perfiles = usuarioLogado.getPerfiles();
		List<DDZona> zonas = usuarioLogado.getZonas();
		dto.setPerfiles(perfiles);
		dto.setZonas(zonas);
		dto.setUsuarioLogado(usuarioLogado);
		List<TareaNotificacion> listaRetorno = new ArrayList<TareaNotificacion>();
		PageHibernate page = (PageHibernate) btaTareaNotificacionDao.buscarTareas(dto);
		listaRetorno.addAll((List<TareaNotificacion>) page.getResults());
		replaceGestorInList(listaRetorno, usuarioLogado);
		replaceSupervisorInList(listaRetorno, usuarioLogado);
		page.setResults(listaRetorno);

		EventFactory.onMethodStop(this.getClass());
		return (List<TareaNotificacion>) page.getResults();
	}
	
	@SuppressWarnings("unchecked")
	private List<BTATareaEncontrada> buscarTareasParaExcelDinamico(BTADtoBusquedaTareas dto, String params) {
		EventFactory.onMethodStart(this.getClass());
		
		dto.setLimit(Integer.MAX_VALUE -1);
		Usuario usuarioLogado = (Usuario) executor
				.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<Perfil> perfiles = usuarioLogado.getPerfiles();
		List<DDZona> zonas = usuarioLogado.getZonas();
		dto.setPerfiles(perfiles);
		dto.setZonas(zonas);
		dto.setUsuarioLogado(usuarioLogado);
		dto.setDynamicParams(params);

		long t1 = System.currentTimeMillis();
		PageHibernate page = (PageHibernate) btaTareaNotificacionDao.buscarTareas(dto);
		long t2 = System.currentTimeMillis();
		logger.warn("consulta tareas en " + (t2 - t1) + " milisiegundos");
		
		return (List<BTATareaEncontrada>) page.getResults();
	}

	/**
	 * Devuelve la lista de tipos de unidades de gesti�n.
	 * 
	 * @param codigoTipo
	 *            string
	 * @return la lista de sub tipos de tarea.
	 */
	@BusinessOperation("plugin.busquedaTareas.BTABusquedaTareaManager.getTiposUnnidadGestion")
	public List<DDTipoEntidad> getTiposUnnidadGestion() {
		return btaTipoEntidadDao.getList();
	}

	/**
	 * Devuelve la lista de sub tipos de tareas a partir del tipo recivido.
	 * 
	 * @param codigoTipo
	 *            string
	 * @return la lista de sub tipos de tarea.
	 */
	@BusinessOperation("plugin.busquedaTareas.BTABusquedaTareaManager.subtiposPorTipoTarea")
	public List<SubtipoTarea> getSubtiposByTipoTarea(String codigoTipoTarea) {
		return btaSubtipoTareaDao.buscarPorCodigoTipo(codigoTipoTarea);
	}
	
	@BusinessOperation("plugin.busquedaTareas.BTABusquedaTareaManager.BuscarTareasCount")
	public Integer buscarTareasCount(BTADtoBusquedaTareas dto) {
		
		try {
			EventFactory.onMethodStart(this.getClass());

			Usuario usuarioLogado = (Usuario) executor
					.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			List<Perfil> perfiles = usuarioLogado.getPerfiles();
			List<DDZona> zonas = usuarioLogado.getZonas();
			dto.setPerfiles(perfiles);
			dto.setZonas(zonas);
			dto.setUsuarioLogado(usuarioLogado);
			dto.setLimit(Integer.MAX_VALUE - 1);
			Integer count = btaTareaNotificacionDao.buscarTareasCount(dto);	
			
			return count;
			
		} catch (Throwable t) {
			logger.error("Ha fallado la búsqueda de tareas", t);
			return null;
		}
	}

	/**
	 * Buscar las tareas seg�n criterios recividos.
	 * 
	 * @param dto
	 *            dto
	 * @return lista de tareas
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.busquedaTareas.BTABusquedaTareaManager.BuscarTareas")
	@Transactional
	public Page buscarTareas(BTADtoBusquedaTareas dto) {
		try {
			EventFactory.onMethodStart(this.getClass());

			Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			List<Perfil> perfiles = usuarioLogado.getPerfiles();
			List<DDZona> zonas = usuarioLogado.getZonas();
			dto.setPerfiles(perfiles);
			dto.setZonas(zonas);
			dto.setUsuarioLogado(usuarioLogado);
			
			List<Class<? extends BTATareaEncontrada>> listaRetorno = new ArrayList<Class<? extends BTATareaEncontrada>>();
			// if ((!dto.isBusqueda() && dto.getStart() == 0) ||
			// (dto.getTraerGestionVencidos() != null &&
			// dto.getTraerGestionVencidos())) {
			// agregarTareasGestionVencidosSeguimiento(dto, listaRetorno);
			// }
			PageHibernate page = (PageHibernate) btaTareaNotificacionDao.buscarTareas(dto);
			if (page != null) {
				listaRetorno.addAll((List<Class<? extends BTATareaEncontrada>>) page.getResults());
				//replaceGestorInList(listaRetorno, usuarioLogado);
				//replaceSupervisorInList(listaRetorno, usuarioLogado);
				page.setResults(listaRetorno);
			}

			EventFactory.onMethodStop(this.getClass());
			return page;
		} catch (Throwable t) {
			logger.error("Ha fallado la b�squeda de tareas", t);
			return null;
		}
	}

	/**
	 * agrega la zona al supervisor.
	 * 
	 * @param lista
	 *            lista
	 * @param zona
	 *            zona
	 */
	private void replaceSupervisorInList(List<TareaNotificacion> lista,
			Usuario usuario) {
		for (TareaNotificacion tarea : lista) {
			if (tarea.getDescSupervisor() != null
					&& tarea.getDescSupervisor().trim().length() > 0) {
				String descZona = "";
				if (tarea.getSupervisor() != null) {
					for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
						if (tarea.getSupervisor().longValue() == zp.getPerfil()
								.getId().longValue()) {
							descZona = zp.getZona().getDescripcion();
							break;
						}
					}
				}
				tarea.setDescSupervisor(tarea.getDescSupervisor() + " "
						+ descZona);
			}
		}
	}

	/**
	 * agrega la zona al gestor.
	 * 
	 * @param lista
	 *            lista
	 * @param zona
	 *            zona
	 */
	private void replaceGestorInList(List<TareaNotificacion> lista,
			Usuario usuario) {
		for (TareaNotificacion tarea : lista) {
			if (tarea.getDescGestor() != null
					&& tarea.getDescGestor().trim().length() > 0) {
				String descZona = "";
				if (tarea.getGestor() != null) {
					for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
						if (tarea.getGestor().longValue() == zp.getPerfil()
								.getId().longValue()) {
							descZona = zp.getZona().getDescripcion();
							break;
						}
					}
				}
				tarea.setDescGestor(tarea.getDescGestor() + " " + descZona);
			}
		}
	}

	@BusinessOperation("plugin.busquedaTareas.web.buttons.left")
	public List<DynamicElement> getButtonsBuscaTareasLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements("plugin.busquedaTareas.web.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.busquedaTareas.web.buttons.right")
	public List<DynamicElement> getButtonsBuscaTareasRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements("plugin.busquedaTareas.web.buttons.right",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}
	
	@BusinessOperation("plugin.busquedaTareas.web.getTabs")
    public List<DynamicElement> getTabs() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.busquedaTareas.web.tareas.tabs", null);
        if (l == null) {
            return new ArrayList<DynamicElement>();
        } else {
            return l;
        }
    }

	/**
	 * agregarGestionVencidos.
	 * 
	 * @param dto
	 *            dtoparametro
	 */
	/*
	 * private void agregarTareasGestionVencidosSeguimiento(BTADtoBuscarTareas
	 * dto, List<TareaNotificacion> listaRetorno) {
	 * 
	 * if (!dto.isEnEspera() && !dto.isEsAlerta() &&
	 * TipoTarea.TIPO_TAREA.equals(dto.getCodigoTipoTarea())) {
	 * 
	 * DDEstadoItinerario estadoItinerario = (DDEstadoItinerario)
	 * executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	 * DDEstadoItinerario.class, DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
	 * 
	 * //Comprueba si el usuario es gestor para alguno de sus perfiles en el
	 * estado de GESTION DE VENCIDOS Usuario usuario = (Usuario)
	 * executor.execute
	 * (ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
	 * 
	 * Boolean isGestor = (Boolean)
	 * executor.execute(ConfiguracionBusinessOperation
	 * .BO_EST_MGR_EXISTE_GESTOR_BY_PERFIL, usuario.getPerfiles(),
	 * estadoItinerario);
	 * 
	 * if (isGestor) { Long cantidadVencidos = (Long)
	 * executor.execute(PrimariaBusinessOperation
	 * .BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO); if (cantidadVencidos > 0)
	 * { TareaNotificacion tareaGV = new TareaNotificacion();
	 * tareaGV.setTarea("Gestion de Vencidos");
	 * tareaGV.setDescripcionTarea("Clientes por gestionar: " +
	 * cantidadVencidos); tareaGV.setTipoEntidad((DDTipoEntidad)
	 * executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	 * DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
	 * tareaGV.setSubtipoTarea
	 * (subtipoTareaDao.buscarPorCodigo(SubtipoTarea.CODIGO_GESTION_VENCIDOS));
	 * listaRetorno.add(tareaGV); }
	 * 
	 * Long cantidadSeguimientoSintomatico = (Long) executor
	 * .execute(PrimariaBusinessOperation
	 * .BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO); if
	 * (cantidadSeguimientoSintomatico > 0) { TareaNotificacion tareaGV = new
	 * TareaNotificacion();
	 * tareaGV.setTarea("Gestion de Seguimiento Sintomatico");
	 * tareaGV.setDescripcionTarea("Clientes por gestionar: " +
	 * cantidadSeguimientoSintomatico); tareaGV.setTipoEntidad((DDTipoEntidad)
	 * executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	 * DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
	 * tareaGV.setSubtipoTarea(subtipoTareaDao.buscarPorCodigo(SubtipoTarea.
	 * CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO)); listaRetorno.add(tareaGV); }
	 * 
	 * Long cantidadSeguimientoSistematico = (Long) executor
	 * .execute(PrimariaBusinessOperation
	 * .BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO); if
	 * (cantidadSeguimientoSistematico > 0) { TareaNotificacion tareaGV = new
	 * TareaNotificacion();
	 * tareaGV.setTarea("Gestion de Seguimiento Sistematico");
	 * tareaGV.setDescripcionTarea("Clientes por gestionar: " +
	 * cantidadSeguimientoSistematico); tareaGV.setTipoEntidad((DDTipoEntidad)
	 * executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	 * DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
	 * tareaGV.setSubtipoTarea(subtipoTareaDao.buscarPorCodigo(SubtipoTarea.
	 * CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO)); listaRetorno.add(tareaGV); } }
	 * } }
	 */
	
	
	@BusinessOperation("busquedaTareaManager.exportaTareasExcel")
    public FileItem exportaTareasExcel(BTADtoBusquedaTareas dto, String params) {
        try {
            dto.setDescripcionTarea(URLDecoder.decode(dto.getDescripcionTarea(), "iso-8859-1"));
            dto.setNombreTarea(URLDecoder.decode(dto.getNombreTarea(), "iso-8859-1"));
        } catch (UnsupportedEncodingException e) {
            logger.error(e);
        }
        // Conversión de los operadores para evitar el carácter = en las urls
        if (dto.getFechaVencDesdeOperador() != null) {
            if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencDesdeOperador(">=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("<=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("=");
            }
        }
        if (dto.getFechaVencimientoHastaOperador() != null) {
            if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador(">=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("<=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("=");
            }
        }

        List<BTATareaEncontrada> result = buscarTareasParaExcelDinamico(dto, params);
        ExportarTareasBean bean = null;
        FileItem fileItem = null;
        try {
            bean = operationExportToExcel(result);
            fileItem = bean.getFileItem();
        } catch (Throwable e) {
            logger.error(e);
        } finally {
            if (bean != null)
                bean.setEnUso(false);
        }
        return fileItem;
    }
	
	private ExportarTareasBean operationExportToExcel(List<BTATareaEncontrada> listaDto) {
        WritableWorkbook workbook1 = null;
        BTATareaEncontrada dto = null;
        FileItem fileItem = null;
        File file = null;
        Label row = null;
        try {
            if (exportarExcelPool == null)
                inicializaPoolExportacionExcel();
            int numeroColumnas = NOMBRES_COLUMNAS.length;
            int j = 0;
            for (j = 0; j < exportarExcelPool.length; j++) {
                if (!exportarExcelPool[j].isEnUso()) {
                    exportarExcelPool[j].setEnUso(true);
                    file = new File(exportarExcelPool[j].getRuta());
                    if (!file.exists())
                        file.createNewFile();
                    if (file.canWrite()) {

                        workbook1 = Workbook.createWorkbook(file);
                        WritableSheet sheet1 = workbook1.createSheet(LISTA_TAREAS, 0);

                        // Pintamos las cabeceras de las columnas.
                        WritableFont cellFontBold10 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
                        WritableFont cellFontBold12 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD);

                        WritableCellFormat cellFormatCabeceras = new WritableCellFormat(cellFontBold12);
                        cellFormatCabeceras.setFont(cellFontBold10);
                        cellFormatCabeceras.setAlignment(Alignment.CENTRE);
                        cellFormatCabeceras.setBackground(Colour.PLUM2);
                        cellFormatCabeceras.setBorder(Border.ALL, BorderLineStyle.THIN);
                        cellFormatCabeceras.setWrap(false);
                        for (int i = 0; i < numeroColumnas; i++) {
                            Label column = new Label(i, 0, NOMBRES_COLUMNAS[i], cellFormatCabeceras);
                            sheet1.addCell(column);
                        }

                        int i = 1;

                        Iterator<BTATareaEncontrada> it = listaDto.iterator();
                        while (it.hasNext()) {
                            dto = it.next();

                            if (dto.getId() != null) {
                                row = new Label(0, i, dto.getId().toString());
                            } else {
                                row = new Label(0, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getTipoEntidad() != null) {
                                row = new Label(1, i, dto.getTarea().getTipoEntidad().getDescripcion());
                            } else {
                                row = new Label(1, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getEntidadInformacion() != null) {
                            	Integer indice1 = dto.getTarea().getEntidadInformacion().indexOf("[");
                            	Integer indice2 = dto.getTarea().getEntidadInformacion().indexOf("]");
                            	String idEntidad = dto.getTarea().getEntidadInformacion().substring(indice1 +1, indice2);
                                row = new Label(2, i, idEntidad);
                            } else {
                                row = new Label(2, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getDescripcionTarea() != null) {
                                row = new Label(3, i, dto.getTarea().getDescripcionTarea());
                            } else {
                                row = new Label(3, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getAsunto() != null && dto.getTarea().getAsunto().getNombre() != null) {
                            	String desc = dto.getTarea().getAsunto().getNombre();
                            	if (dto.getTarea().getProcedimiento() != null && dto.getTarea().getProcedimiento().getTipoProcedimiento() != null && dto.getTarea().getProcedimiento().getTipoProcedimiento().getDescripcion() != null){
                            		desc = desc + " - " + dto.getTarea().getProcedimiento().getTipoProcedimiento().getDescripcion();
                            	}
                                row = new Label(4, i, desc);
                            } else {
                                row = new Label(4, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getFechaInicio() != null) {
                                row = new Label(5, i, formatter.format(dto.getTarea().getFechaInicio()));
                            } else {
                                row = new Label(5, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getFechaVenc() != null) {
                                row = new Label(6, i, formatter.format(dto.getTarea().getFechaVenc()));
                            } else {
                                row = new Label(6, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getFechaFin() != null) {
                                row = new Label(7, i, formatter.format(dto.getTarea().getFechaFin()));
                            } else {
                                row = new Label(7, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getFechaVenc() != null) {
                                Long dif = new Date().getTime() - dto.getTarea().getFechaVenc().getTime();
                                Integer diasVenc = Math.round(dif / DAY_MILISECONDS);
                                if (diasVenc > 0 && dto.getTarea().getFechaFin() == null) {
                                    row = new Label(8, i, diasVenc.toString());
                                } else {
                                    row = new Label(8, i, VACIO);
                                }
                            } else {
                                row = new Label(8, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getDescGestor() != null) {
                                row = new Label(9, i, dto.getTarea().getDescGestor());
                            } else {
                                row = new Label(9, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getDescSupervisor() != null) {
                                row = new Label(10, i, dto.getTarea().getDescSupervisor());
                            } else {
                                row = new Label(10, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getSubtipoTarea() != null 
                            		&& dto.getTarea().getSubtipoTarea().getTipoTarea() != null) {
                                row = new Label(11, i, dto.getTarea().getSubtipoTarea().getTipoTarea().getDescripcion());
                            } else {
                                row = new Label(11, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getTarea() != null && dto.getTarea().getSubtipoTarea() != null) {
                                row = new Label(12, i, dto.getTarea().getSubtipoTarea().getDescripcion());
                            } else {
                                row = new Label(12, i, VACIO);
                            }
                            sheet1.addCell(row);
                            i++;
                        }
                        workbook1.write();
                        fileItem = new FileItem(file);
                        fileItem.setFileName(LISTA_TAREAS_XLS);
                        exportarExcelPool[j].setFileItem(fileItem);
                        return exportarExcelPool[j];
                    }
                }
            }
        } catch (Throwable ex) {
            logger.error(ex);
        } finally {
            try {
                workbook1.close();
            } catch (Throwable e) {
                logger.error(e);
            }
        }
        return null;
    }

    private void inicializaPoolExportacionExcel() {
        String fileNameExtension = ".xls";
        exportarExcelPool = new ExportarTareasBean[Integer.parseInt(appProperties.getProperty(EXPORTAR_BTA_LIMITE_SIMULTANEO))];
        ExportarTareasBean bean = null;
        for (int i = 0; i < exportarExcelPool.length; i++) {
            bean = new ExportarTareasBean();
            bean.setEnUso(false);
            bean.setRuta(appProperties.getProperty(EXPORTAR_BTA_RUTA) + i + fileNameExtension);
            exportarExcelPool[i] = bean;
        }

    } 
}
