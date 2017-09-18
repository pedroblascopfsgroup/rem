package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.agenda.adapter.NotificacionAdapter;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAvisadorApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.gestor.GestorExpedienteComercialManager;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManagerApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoCargas;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.ActivoDistribucion;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoLlave;
import es.pfsgroup.plugin.rem.model.ActivoMovimientoLlave;
import es.pfsgroup.plugin.rem.model.ActivoObservacion;
import es.pfsgroup.plugin.rem.model.ActivoOcupanteLegal;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoCargas;
import es.pfsgroup.plugin.rem.model.DtoActivoCatastro;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivoOcupanteLegal;
import es.pfsgroup.plugin.rem.model.DtoActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesActivo;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoCondicionHistorico;
import es.pfsgroup.plugin.rem.model.DtoDistribucion;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoIncrementoPresupuestoActivo;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.DtoListadoTareas;
import es.pfsgroup.plugin.rem.model.DtoListadoTramites;
import es.pfsgroup.plugin.rem.model.DtoLlaves;
import es.pfsgroup.plugin.rem.model.DtoMovimientoLlave;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoPresupuestoGraficoActivo;
import es.pfsgroup.plugin.rem.model.DtoPropietario;
import es.pfsgroup.plugin.rem.model.DtoTasacion;
import es.pfsgroup.plugin.rem.model.DtoTramite;
import es.pfsgroup.plugin.rem.model.DtoUsuario;
import es.pfsgroup.plugin.rem.model.DtoValoracion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.IncrementoPresupuesto;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VAdmisionDocumentos;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.model.VBusquedaPresupuestosActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaTramitesActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaVisitasDetalle;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoObservacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.OperationResultResponse;
import es.pfsgroup.plugin.rem.service.TabActivoDatosBasicos;
import es.pfsgroup.plugin.rem.service.TabActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.service.TabActivoSitPosesoriaLlaves;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Service
public class ActivoAdapter {

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private coreextensionApi coreextensionApi;

	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;

	@Autowired
	private TareaActivoApi tareaActivoApi;

	@Autowired
	private JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;

	@Autowired
	protected JBPMProcessManagerApi jbpmProcessManagerApi;

	@Autowired
	protected TipoProcedimientoManager tipoProcedimiento;

	@Autowired
	private ActivoAvisadorApi activoAvisadorApi;

	@Autowired
	private TrabajoApi trabajoApi;

	@Resource
	private Properties appProperties;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private TabActivoFactoryApi tabActivoFactory;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	GestorDocumentalFotosApi gestorDocumentalFotos;

	@Autowired
	private AnotacionApi anotacionApi;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ProveedoresApi proveedoresApi;

	@Autowired
	private NotificationOfertaManager notificationOfertaManager;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
    @Autowired
    private NotificacionAdapter notificacionAdapter;
    
    @Autowired 
    private GestorExpedienteComercialManager gestorExpedienteComercialManager;
    

	@Resource
	MessageService messageServices;

	// private static final String PROPIEDAD_ACTIVAR_REST_CLIENT =
	// "rest.client.gestor.documental.activar";
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	public static final String OFERTA_INCOMPATIBLE_MSG = "El tipo de oferta es incompatible con el destino comercial del activo";
	public static final String AVISO_TITULO_MODIFICADAS_CONDICIONES_JURIDICAS = "activo.aviso.titulo.modificadas.condiciones.juridicas";
	public static final String AVISO_DESCRIPCION_MODIFICADAS_CONDICIONES_JURIDICAS = "activo.aviso.descripcion.modificadas.condiciones.juridicas";

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	protected static final Log logger = LogFactory.getLog(ActivoAdapter.class);

	public Activo getActivoById(Long id) {

		return activoApi.get(id);

	}

	

	@Transactional(readOnly = false)
	public boolean saveDistribucion(DtoDistribucion dtoDistribucion, Long idDistribucion) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idDistribucion);
		ActivoDistribucion activoDistribucion = genericDao.get(ActivoDistribucion.class, filtro);

		try {

			beanUtilNotNull.copyProperties(activoDistribucion, dtoDistribucion);
			if (dtoDistribucion.getTipoHabitaculoCodigo() != null) {
				DDTipoHabitaculo tipoHabitaculo = (DDTipoHabitaculo) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDTipoHabitaculo.class, dtoDistribucion.getTipoHabitaculoCodigo());

				activoDistribucion.setTipoHabitaculo(tipoHabitaculo);
			}
			genericDao.save(ActivoDistribucion.class, activoDistribucion);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean saveCatastro(DtoActivoCatastro dtoCatastro, Long idCatastro) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idCatastro);
		ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, filtro);

		try {

			beanUtilNotNull.copyProperties(activoCatastro, dtoCatastro);
			genericDao.save(ActivoCatastro.class, activoCatastro);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean saveFoto(DtoFoto dtoFoto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoFoto.getId());
		ActivoFoto activoFoto = genericDao.get(ActivoFoto.class, filtro);
		boolean resultado = true;
		try {

			if (gestorDocumentalFotos.isActive()) {
				PRINCIPAL principal = null;
				SITUACION situacion = null;
				if (dtoFoto.getPrincipal() != null) {
					if (dtoFoto.getPrincipal()) {
						principal = PRINCIPAL.SI;
					} else {
						principal = PRINCIPAL.NO;
					}
				}
				if (dtoFoto.getInteriorExterior() != null) {
					if (dtoFoto.getInteriorExterior()) {
						situacion = SITUACION.INTERIOR;
					} else {
						situacion = SITUACION.EXTERIOR;
					}
				}
				FileResponse fileReponse = gestorDocumentalFotos.update(activoFoto.getRemoteId(), dtoFoto.getNombre(),
						null, dtoFoto.getDescripcion(), principal, situacion, dtoFoto.getOrden());
				if (fileReponse.getError() != null && !fileReponse.getError().isEmpty()) {
					throw new Exception(fileReponse.getError());
				}
			}
			beanUtilNotNull.copyProperties(activoFoto, dtoFoto);
			genericDao.save(ActivoFoto.class, activoFoto);

		} catch (Exception e) {
			logger.error(e);
			resultado = false;
		}

		return resultado;

	}

	@Transactional(readOnly = false)
	public boolean saveOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivoOcupanteLegal) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idActivoOcupanteLegal);
		ActivoOcupanteLegal activoOcupanteLegal = genericDao.get(ActivoOcupanteLegal.class, filtro);

		try {

			beanUtilNotNull.copyProperties(activoOcupanteLegal, dtoOcupanteLegal);
			genericDao.save(ActivoOcupanteLegal.class, activoOcupanteLegal);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean deleteDistribucion(DtoDistribucion dtoDistribucion, Long idDistribucion) {

		try {
			genericDao.deleteById(ActivoDistribucion.class, idDistribucion);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteCatastro(DtoActivoCatastro dtoCatastro, Long idCatastro) {

		try {
			genericDao.deleteById(ActivoCatastro.class, idCatastro);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivoOcupanteLegal) {

		try {
			genericDao.deleteById(ActivoOcupanteLegal.class, idActivoOcupanteLegal);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteObservacion(Long idObservacion) {

		try {

			genericDao.deleteById(ActivoObservacion.class, idObservacion);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean saveObservacionesActivo(DtoObservacion dtoObservacion) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		ActivoObservacion activoObservacion = genericDao.get(ActivoObservacion.class, filtro);

		try {

			beanUtilNotNull.copyProperties(activoObservacion, dtoObservacion);
			if(dtoObservacion.getTipoObservacionCodigo() != null) {
				DDTipoObservacionActivo tipoObservacion = (DDTipoObservacionActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoObservacionActivo.class, dtoObservacion.getTipoObservacionCodigo());
				if(tipoObservacion != null) {
					activoObservacion.setTipoObservacion(tipoObservacion);
				}
			}
			genericDao.save(ActivoObservacion.class, activoObservacion);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createObservacionesActivo(DtoObservacion dtoObservacion, Long idActivo) {

		ActivoObservacion activoObservacion = new ActivoObservacion();
		Activo activo = activoApi.get(idActivo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		try {

			// beanUtilNotNull.copyProperties(activoObservacion,
			// dtoObservacion);
			activoObservacion.setObservacion(dtoObservacion.getObservacion());
			activoObservacion.setFecha(new Date());
			activoObservacion.setUsuario(usuarioLogado);
			activoObservacion.setActivo(activo);

			if(dtoObservacion.getTipoObservacionCodigo() != null) {
				DDTipoObservacionActivo tipoObservacion = (DDTipoObservacionActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoObservacionActivo.class, dtoObservacion.getTipoObservacionCodigo());
				if(tipoObservacion != null) {
					activoObservacion.setTipoObservacion(tipoObservacion);
				}
			}

			genericDao.save(ActivoObservacion.class, activoObservacion);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createCondicionHistorico(DtoCondicionHistorico dtoCondicionHistorico, Long idActivo) {

		ActivoCondicionEspecifica activoCondicionEspecifica = new ActivoCondicionEspecifica();
		Activo activo = activoApi.get(idActivo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		try {
			activoCondicionEspecifica.setFechaDesde(dtoCondicionHistorico.getFechaAlta());
			activoCondicionEspecifica.setUsuarioAlta(usuarioLogado);
			activoCondicionEspecifica.setTexto(dtoCondicionHistorico.getCondicion());
			activoCondicionEspecifica.setActivo(activo);

			genericDao.save(ActivoCondicionEspecifica.class, activoCondicionEspecifica);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createDistribucion(DtoDistribucion dtoDistribucion, Long idActivo) {

		ActivoDistribucion activoDistribucion = new ActivoDistribucion();
		Activo activo = activoApi.get(idActivo);
		ActivoInfoComercial infoComercial = activo.getInfoComercial();

		try {

			beanUtilNotNull.copyProperties(activoDistribucion, dtoDistribucion);
			if (dtoDistribucion.getTipoHabitaculoCodigo() != null) {
				DDTipoHabitaculo tipoHabitaculo = (DDTipoHabitaculo) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDTipoHabitaculo.class, dtoDistribucion.getTipoHabitaculoCodigo());

				activoDistribucion.setTipoHabitaculo(tipoHabitaculo);
			}
			activoDistribucion.setInfoComercial(infoComercial);
			ActivoDistribucion distribucionNueva = genericDao.save(ActivoDistribucion.class, activoDistribucion);

			ActivoVivienda viviendaTemp = (ActivoVivienda) activo.getInfoComercial();
			viviendaTemp.getDistribucion().add(distribucionNueva);
			activo.setInfoComercial(viviendaTemp);
			activoApi.saveOrUpdate(activo);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createCatastro(DtoActivoCatastro dtoCatastro, Long idActivo) {

		ActivoCatastro activoCatastro = new ActivoCatastro();
		Activo activo = activoApi.get(idActivo);
		try {

			beanUtilNotNull.copyProperties(activoCatastro, dtoCatastro);
			activoCatastro.setActivo(activo);
			ActivoCatastro catastroNuevo = genericDao.save(ActivoCatastro.class, activoCatastro);

			activo.getCatastro().add(catastroNuevo);
			activoApi.saveOrUpdate(activo);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivo) {

		ActivoOcupanteLegal activoOcupanteLegal = new ActivoOcupanteLegal();
		Activo activo = activoApi.get(idActivo);
		ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();
		try {

			beanUtilNotNull.copyProperties(activoOcupanteLegal, dtoOcupanteLegal);
			activoOcupanteLegal.setSituacionPosesoria(situacionPosesoria);
			ActivoOcupanteLegal ocupanteLegalNuevo = genericDao.save(ActivoOcupanteLegal.class, activoOcupanteLegal);

			situacionPosesoria.getActivoOcupanteLegal().add(ocupanteLegalNuevo);
			activo.setSituacionPosesoria(situacionPosesoria);
			activoApi.saveOrUpdate(activo);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	public List<DtoActivoCargas> getListCargasById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoActivoCargas> listaDtoCarga = new ArrayList<DtoActivoCargas>();

		if (activo.getCargas() != null) {

			for (int i = 0; i < activo.getCargas().size(); i++) {
				DtoActivoCargas cargaDto = new DtoActivoCargas();
				try {
					ActivoCargas activoCarga = activo.getCargas().get(i);
					beanUtilNotNull.copyProperties(cargaDto, activoCarga);
					beanUtilNotNull.copyProperties(cargaDto, activoCarga.getCargaBien());
					beanUtilNotNull.copyProperty(cargaDto, "idActivoCarga", activoCarga.getId());

					if (activoCarga.getTipoCargaActivo() != null) {
						beanUtilNotNull.copyProperty(cargaDto, "tipoCargaDescripcion",
								activoCarga.getTipoCargaActivo().getDescripcion());
						beanUtilNotNull.copyProperty(cargaDto, "tipoCargaCodigo",
								activoCarga.getTipoCargaActivo().getCodigo());
					}
					if (activoCarga.getSubtipoCarga() != null) {
						beanUtilNotNull.copyProperty(cargaDto, "subtipoCargaDescripcion",
								activoCarga.getSubtipoCarga().getDescripcion());
						beanUtilNotNull.copyProperty(cargaDto, "subtipoCargaCodigo",
								activoCarga.getSubtipoCarga().getCodigo());
					}
					//HREOS-2733
					if(!Checks.esNulo(activoCarga.getOrigenDato())) {
						beanUtilNotNull.copyProperty(cargaDto, "origenDatoCodigo", activoCarga.getOrigenDato().getCodigo());
						beanUtilNotNull.copyProperty(cargaDto, "origenDatoDescripcion", activoCarga.getOrigenDato().getDescripcion());
					}
					
					if (activoCarga.getCargaBien() != null) {
						// HREOS-1666 - Si tiene F. Cancelacion debe mostrar el
						// estado Cancelado (independientemente del registrado
						// en DD_SIC_ID)
						if (!Checks.esNulo(activoCarga.getTipoCargaActivo())
								&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_REG
										.equals(activoCarga.getTipoCargaActivo().getCodigo())
								&& (!Checks.esNulo(activoCarga.getCargaBien().getFechaCancelacion())
										|| !Checks.esNulo(activoCarga.getFechaCancelacionRegistral()))) {
							DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
							beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",
									situacionCancelada.getDescripcion());
							beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo", situacionCancelada.getCodigo());

							// Fecha de cancelacion de una carga registral
							if (Checks.esNulo(activoCarga.getFechaCancelacionRegistral())) {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getCargaBien().getFechaCancelacion());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionRegistral",
										activoCarga.getCargaBien().getFechaCancelacion());
							} else {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getFechaCancelacionRegistral());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionRegistral",
										activoCarga.getFechaCancelacionRegistral());
							}
							cargaDto.setFechaCancelacionEconomica(null);
						} else {
							if (activoCarga.getCargaBien().getSituacionCarga() != null) {
								beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",
										activoCarga.getCargaBien().getSituacionCarga().getDescripcion());
								beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo",
										activoCarga.getCargaBien().getSituacionCarga().getCodigo());
							}
						}

						// HREOS-1666 - Si tiene F. Cancelacion debe mostrar el
						// estado Cancelado (independientemente del registrado
						// en DD_SIC_ID)
						if (!Checks.esNulo(activoCarga.getTipoCargaActivo())
								&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_ECO
										.equals(activoCarga.getTipoCargaActivo().getCodigo())
								&& (!Checks.esNulo(activoCarga.getCargaBien().getFechaCancelacion())
										|| !Checks.esNulo(activoCarga.getFechaCancelacionRegistral()))) {
							DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
							beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaDescripcion",
									situacionCancelada.getDescripcion());
							beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaCodigo",
									situacionCancelada.getCodigo());

							// Fecha de cancelacion de una carga economica
							if (Checks.esNulo(activoCarga.getFechaCancelacionRegistral())) {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getCargaBien().getFechaCancelacion());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionEconomica",
										activoCarga.getCargaBien().getFechaCancelacion());
							} else {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getFechaCancelacionRegistral());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionEconomica",
										activoCarga.getFechaCancelacionRegistral());
							}
							cargaDto.setFechaCancelacionRegistral(null);
						} else {
							if (activoCarga.getCargaBien().getSituacionCargaEconomica() != null) {
								beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaDescripcion",
										activoCarga.getCargaBien().getSituacionCargaEconomica().getDescripcion());
								beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaCodigo",
										activoCarga.getCargaBien().getSituacionCargaEconomica().getCodigo());
							}
						}

						// HREOS-1666 - Si tiene F. Cancelacion debe mostrar el
						// estado Cancelado (independientemente del registrado
						// en DD_SIC_ID)
						if (!Checks.esNulo(activoCarga.getTipoCargaActivo())
								&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_REGECO
										.equals(activoCarga.getTipoCargaActivo().getCodigo())
								&& (!Checks.esNulo(activoCarga.getCargaBien().getFechaCancelacion())
										|| !Checks.esNulo(activoCarga.getFechaCancelacionRegistral()))) {
							DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
							beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",
									situacionCancelada.getDescripcion());
							beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo", situacionCancelada.getCodigo());
							beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaDescripcion",
									situacionCancelada.getDescripcion());
							beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaCodigo",
									situacionCancelada.getCodigo());

							// Fecha de cancelacion de una carga economica
							if (Checks.esNulo(activoCarga.getFechaCancelacionRegistral())) {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getCargaBien().getFechaCancelacion());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionRegistral",
										activoCarga.getCargaBien().getFechaCancelacion());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionEconomica",
										activoCarga.getCargaBien().getFechaCancelacion());
							} else {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getFechaCancelacionRegistral());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionRegistral",
										activoCarga.getFechaCancelacionRegistral());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionEconomica",
										activoCarga.getFechaCancelacionRegistral());
							}

						} else {
							if (activoCarga.getCargaBien().getSituacionCarga() != null) {
								beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",
										activoCarga.getCargaBien().getSituacionCarga().getDescripcion());
								beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo",
										activoCarga.getCargaBien().getSituacionCarga().getCodigo());
							}
							if (activoCarga.getCargaBien().getSituacionCargaEconomica() != null) {
								beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaDescripcion",
										activoCarga.getCargaBien().getSituacionCargaEconomica().getDescripcion());
								beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaCodigo",
										activoCarga.getCargaBien().getSituacionCargaEconomica().getCodigo());
							}
						}
					}

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoCarga.add(cargaDto);
			}
		}

		return listaDtoCarga;

	}

	public DtoActivoCargas getCargaById(Long id) {

		DtoActivoCargas dtoCarga = new DtoActivoCargas();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoCargas cargaSeleccionada = (ActivoCargas) genericDao.get(ActivoCargas.class, filtro);

		try {

			beanUtilNotNull.copyProperties(dtoCarga, cargaSeleccionada);
			beanUtilNotNull.copyProperties(dtoCarga, cargaSeleccionada.getCargaBien());

			if (cargaSeleccionada.getTipoCargaActivo() != null) {
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaCodigo",
						cargaSeleccionada.getTipoCargaActivo().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaDesc",
						cargaSeleccionada.getTipoCargaActivo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaCodigoEconomica",
						cargaSeleccionada.getTipoCargaActivo().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaDescEconomica",
						cargaSeleccionada.getTipoCargaActivo().getDescripcion());
			}

			if (cargaSeleccionada.getSubtipoCarga() != null) {
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaCodigo",
						cargaSeleccionada.getSubtipoCarga().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaDesc",
						cargaSeleccionada.getSubtipoCarga().getDescripcion());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaCodigoEconomica",
						cargaSeleccionada.getSubtipoCarga().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaDescEconomica",
						cargaSeleccionada.getSubtipoCarga().getDescripcion());
			}

			if (cargaSeleccionada.getCargaBien().getSituacionCarga() != null) {
				// HREOS-1666 - Si tiene F. Cancelacion debe mostrar el estado
				// Cancelado (independientemente del registrado en DD_SIC_ID)
				// REG
				if (!Checks.esNulo(cargaSeleccionada.getTipoCargaActivo())
						&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_REG
								.equals(cargaSeleccionada.getTipoCargaActivo().getCodigo())
						&& (!Checks.esNulo(cargaSeleccionada.getCargaBien().getFechaCancelacion())
								|| !Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral()))) {
					DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigo", situacionCancelada.getCodigo());

					// Fecha de cancelacion de una carga registral
					if (Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral())) {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionRegistral",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
					} else {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getFechaCancelacionRegistral());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionRegistral",
								cargaSeleccionada.getFechaCancelacionRegistral());
					}
					dtoCarga.setFechaCancelacionEconomica(null);
				} else {
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigo",
							cargaSeleccionada.getCargaBien().getSituacionCarga().getCodigo());
				}

				// ECO
				if (!Checks.esNulo(cargaSeleccionada.getTipoCargaActivo())
						&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_ECO
								.equals(cargaSeleccionada.getTipoCargaActivo().getCodigo())
						&& (!Checks.esNulo(cargaSeleccionada.getCargaBien().getFechaCancelacion())
								|| !Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral()))) {
					DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
							situacionCancelada.getCodigo());

					// Fecha de cancelacion de una carga economica
					if (Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral())) {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
					} else {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getFechaCancelacionRegistral());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
								cargaSeleccionada.getFechaCancelacionRegistral());
					}
					dtoCarga.setFechaCancelacionRegistral(null);
				} else {
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
							cargaSeleccionada.getCargaBien().getSituacionCarga().getCodigo());
				}

				// REGECO
				if (!Checks.esNulo(cargaSeleccionada.getTipoCargaActivo())
						&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_REGECO
								.equals(cargaSeleccionada.getTipoCargaActivo().getCodigo())
						&& (!Checks.esNulo(cargaSeleccionada.getCargaBien().getFechaCancelacion())
								|| !Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral()))) {
					DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigo", situacionCancelada.getCodigo());
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
							situacionCancelada.getCodigo());

					// Fecha de cancelacion de una carga economica
					if (Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral())) {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionRegistral",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
					} else {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getFechaCancelacionRegistral());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
								cargaSeleccionada.getFechaCancelacionRegistral());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionRegistral",
								cargaSeleccionada.getFechaCancelacionRegistral());
					}
				} else {
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
							cargaSeleccionada.getCargaBien().getSituacionCarga().getCodigo());
				}
			}

			beanUtilNotNull.copyProperty(dtoCarga, "titularEconomica", cargaSeleccionada.getCargaBien().getTitular());
			beanUtilNotNull.copyProperty(dtoCarga, "importeEconomicoEconomica",
					cargaSeleccionada.getCargaBien().getImporteEconomico());

			beanUtilNotNull.copyProperty(dtoCarga, "descripcionCargaEconomica",
					cargaSeleccionada.getDescripcionCarga());

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return dtoCarga;

	}

	public List<DtoDistribucion> getListDistribucionesById(Long id) {
		Activo activo = activoApi.get(id);
		List<DtoDistribucion> listaDtoDistribucion = new ArrayList<DtoDistribucion>();

		// if (activo.getInfoComercial() instanceof ActivoVivienda) {
		ActivoInfoComercial infoComercial = (ActivoInfoComercial) activo.getInfoComercial();

		if (infoComercial.getDistribucion() != null) {
			for (int i = 0; i < infoComercial.getDistribucion().size(); i++) {
				DtoDistribucion distribucionDto = new DtoDistribucion();
				try {
					ActivoDistribucion distribucion = infoComercial.getDistribucion().get(i);
					BeanUtils.copyProperties(distribucionDto, distribucion);
					BeanUtils.copyProperty(distribucionDto, "idDistribucion", distribucion.getId());
					if (distribucion.getTipoHabitaculo() != null) {
						distribucionDto.setTipoHabitaculoCodigo(distribucion.getTipoHabitaculo().getCodigo());
						distribucionDto.setTipoHabitaculoDescripcion(distribucion.getTipoHabitaculo().getDescripcion());
					}
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoDistribucion.add(distribucionDto);
			}
		}
		// }

		return listaDtoDistribucion;
	}

	public List<DtoObservacion> getListObservacionesById(Long id) {

		Activo activo = activoApi.get(id);
		// DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<DtoObservacion> listaDtoObservaciones = new ArrayList<DtoObservacion>();

		if (activo.getObservacion() != null) {

			for (int i = 0; i < activo.getObservacion().size(); i++) {
				DtoObservacion observacionDto = new DtoObservacion();

				try {
					BeanUtils.copyProperties(observacionDto, activo.getObservacion().get(i));

					if (activo.getObservacion().get(i).getUsuario() != null) {
						String nombreCompleto = activo.getObservacion().get(i).getUsuario().getNombre();
						Long idUsuario = activo.getObservacion().get(i).getUsuario().getId();
						if (activo.getObservacion().get(i).getUsuario().getApellido1() != null) {
							nombreCompleto += activo.getObservacion().get(i).getUsuario().getApellido1();

							if (activo.getObservacion().get(i).getUsuario().getApellido2() != null) {
								nombreCompleto += activo.getObservacion().get(i).getUsuario().getApellido2();
							}
						}

						if(activo.getObservacion().get(i).getTipoObservacion() != null) {
							BeanUtils.copyProperty(observacionDto, "tipoObservacionCodigo", activo.getObservacion().get(i).getTipoObservacion().getCodigo());
						}

						BeanUtils.copyProperty(observacionDto, "nombreCompleto", nombreCompleto);
						BeanUtils.copyProperty(observacionDto, "idUsuario", idUsuario);
					}
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoObservaciones.add(observacionDto);
			}
		}

		return listaDtoObservaciones;

	}

	public List<DtoAgrupacionesActivo> getListAgrupacionesActivoById(Long id) {

		Activo activo = activoApi.get(id);

		List<DtoAgrupacionesActivo> listaDtoAgrupaciones = new ArrayList<DtoAgrupacionesActivo>();

		if (activo.getAgrupaciones() != null) {

			for (int i = 0; i < activo.getAgrupaciones().size(); i++) {
				DtoAgrupacionesActivo dtoActivoAgrupaciones = new DtoAgrupacionesActivo();
				try {

					BeanUtils.copyProperties(dtoActivoAgrupaciones, activo.getAgrupaciones().get(i));
					BeanUtils.copyProperties(dtoActivoAgrupaciones, activo.getAgrupaciones().get(i).getAgrupacion());

					BeanUtils.copyProperty(dtoActivoAgrupaciones, "fechaInclusion",
							activo.getAgrupaciones().get(i).getFechaInclusion());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "tipoAgrupacionDescripcion",
							activo.getAgrupaciones().get(i).getAgrupacion().getTipoAgrupacion().getDescripcion());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "tipoAgrupacionCodigo",
							activo.getAgrupaciones().get(i).getAgrupacion().getTipoAgrupacion().getCodigo());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "idAgrupacion",
							activo.getAgrupaciones().get(i).getAgrupacion().getId());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "numActivos",
							activo.getAgrupaciones().get(i).getAgrupacion().getActivos().size());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "numActivosPublicados",
							activoApi.getNumActivosPublicadosByAgrupacion(
									activo.getAgrupaciones().get(i).getAgrupacion().getActivos()));

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoAgrupaciones.add(dtoActivoAgrupaciones);

			}
		}

		return listaDtoAgrupaciones;

	}

	public List<VBusquedaVisitasDetalle> getListVisitasActivoById(Long id)
			throws IllegalAccessException, InvocationTargetException {

		Activo activo = activoApi.get(id);

		List<VBusquedaVisitasDetalle> visitasDetalles = new ArrayList<VBusquedaVisitasDetalle>();

		if (!Checks.esNulo(activo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId().toString());
			visitasDetalles = genericDao.getList(VBusquedaVisitasDetalle.class, filtro);
		}

		return visitasDetalles;

	}

	public List<DtoActivoCatastro> getListCatastroById(Long id) {

		Activo activo = activoApi.get(id);
		// DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<DtoActivoCatastro> listaDtoCatastro = new ArrayList<DtoActivoCatastro>();

		if (activo.getInfoAdministrativa() != null && activo.getCatastro() != null) {

			for (int i = 0; i < activo.getCatastro().size(); i++) {
				DtoActivoCatastro catastroDto = new DtoActivoCatastro();
				try {
					BeanUtils.copyProperties(catastroDto, activo.getCatastro().get(i));
					BeanUtils.copyProperty(catastroDto, "idCatastro", activo.getCatastro().get(i).getId());

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoCatastro.add(catastroDto);

			}
		}

		return listaDtoCatastro;

	}

	public DtoActivoValoraciones getValoresPreciosActivoById(Long id) {

		Activo activo = activoApi.get(id);
		DtoActivoValoraciones valoracionesDto = new DtoActivoValoraciones();

		try {
			BeanUtils.copyProperties(valoracionesDto, activo);
			if (activo.getAdjJudicial() != null && activo.getAdjJudicial().getAdjudicacionBien() != null) {
				BeanUtils.copyProperty(valoracionesDto, "importeAdjudicacion",
						activo.getAdjJudicial().getAdjudicacionBien().getImporteAdjudicacion());
			}

			if (activo.getAdjNoJudicial() != null) {
				BeanUtils.copyProperty(valoracionesDto, "valorAdquisicion",
						activo.getAdjNoJudicial().getValorAdquisicion());
			}

			if (activo.getGestorBloqueoPrecio() != null) {
				BeanUtils.copyProperty(valoracionesDto, "gestorBloqueoPrecio",
						activo.getGestorBloqueoPrecio().getApellidoNombre());
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return valoracionesDto;
	}

	public List<DtoActivoOcupanteLegal> getListOcupantesLegalesById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoActivoOcupanteLegal> listaDtoOcupanteLegal = new ArrayList<DtoActivoOcupanteLegal>();

		if (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getActivoOcupanteLegal() != null) {

			for (int i = 0; i < activo.getSituacionPosesoria().getActivoOcupanteLegal().size(); i++) {
				DtoActivoOcupanteLegal ocupanteLegalDto = new DtoActivoOcupanteLegal();
				try {
					BeanUtils.copyProperties(ocupanteLegalDto,
							activo.getSituacionPosesoria().getActivoOcupanteLegal().get(i));
					BeanUtils.copyProperty(ocupanteLegalDto, "idActivoOcupanteLegal",
							activo.getSituacionPosesoria().getActivoOcupanteLegal().get(i).getId());
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoOcupanteLegal.add(ocupanteLegalDto);

			}
		}

		return listaDtoOcupanteLegal;

	}

	public List<DtoAdmisionDocumento> getListDocumentacionAdministrativaById(Long id) {

		Activo activo = activoApi.get(id);

		List<DtoAdmisionDocumento> listaDtoAdmisionDocumento = new ArrayList<DtoAdmisionDocumento>();

		if (activo.getAdmisionDocumento() != null) {

			for (int i = 0; i < activo.getAdmisionDocumento().size(); i++) {
				DtoAdmisionDocumento catastroDto = new DtoAdmisionDocumento();
				try {

					BeanUtils.copyProperties(catastroDto, activo.getAdmisionDocumento().get(i));
					BeanUtils.copyProperty(catastroDto, "descripcionTipoDocumentoActivo", activo.getAdmisionDocumento()
							.get(i).getConfigDocumento().getTipoDocumentoActivo().getDescripcion());

					if (activo.getAdmisionDocumento() != null) {
						if (activo.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica() != null) {
							BeanUtils.copyProperty(catastroDto, "tipoCalificacionCodigo",
									activo.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica().getCodigo());
							BeanUtils.copyProperty(catastroDto, "tipoCalificacionDescripcion", activo
									.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica().getDescripcion());
						}
					}

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoAdmisionDocumento.add(catastroDto);

			}
		}

		return listaDtoAdmisionDocumento;

	}

	public List<DtoFoto> getFotosById(Long id) {

		Activo activo = activoApi.get(id);

		List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();

		if (activo.getFotos() != null) {

			for (int i = 0; i < activo.getFotos().size(); i++) {
				DtoFoto fotoDto = new DtoFoto();
				try {

					BeanUtils.copyProperties(fotoDto, activo.getFotos().get(i));
					BeanUtils.copyProperty(fotoDto, "fileItem", activo.getFotos().get(i).getAdjunto().getFileItem());
					BeanUtils.copyProperty(fotoDto, "path",
							activo.getFotos().get(i).getAdjunto().getFileItem().getFile().getPath());

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaFotos.add(fotoDto);

			}
		}

		return listaFotos;

	}

	public DtoTasacion getTasacionById(Long id) {

		DtoTasacion dtoTasacion = new DtoTasacion();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoTasacion tasacionSeleccionada = (ActivoTasacion) genericDao.get(ActivoTasacion.class, filtro);

		if (tasacionSeleccionada != null) {
			try {
				BeanUtils.copyProperties(dtoTasacion, tasacionSeleccionada);
				BeanUtils.copyProperties(dtoTasacion, tasacionSeleccionada.getValoracionBien());
				if (tasacionSeleccionada.getTipoTasacion() != null) {
					BeanUtils.copyProperty(dtoTasacion, "tipoTasacionDescripcion",
							tasacionSeleccionada.getTipoTasacion().getDescripcion());
				}
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		}

		return dtoTasacion;
	}

	public ActivoFoto getFotoActivoById(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);

		return genericDao.get(ActivoFoto.class, filtro);

	}

	public ActivoFoto getFotoActivoByRemoteId(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "remoteId", id);
		return genericDao.get(ActivoFoto.class, filtro);

	}

	public List<ActivoFoto> getListFotosActivoById(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Order order = new Order(OrderType.ASC, "orden");

		List<ActivoFoto> listaActivoFoto = genericDao.getListOrdered(ActivoFoto.class, order, filtro);
		Activo activo = this.getActivoById(id);

		if (activo != null) {
			if (gestorDocumentalFotos.isActive() && (listaActivoFoto == null || listaActivoFoto.isEmpty())) {
				FileListResponse fileListResponse = null;
				try {
					fileListResponse = gestorDocumentalFotos.get(PROPIEDAD.ACTIVO, activo.getNumActivo());

					if (fileListResponse.getError() == null || fileListResponse.getError().isEmpty()) {
						for (es.pfsgroup.plugin.rem.rest.dto.File fileGD : fileListResponse.getData()) {
							activoApi.uploadFoto(fileGD);
						}
						listaActivoFoto = genericDao.getListOrdered(ActivoFoto.class, order, filtro);
					}
				} catch (Exception e) {
					logger.error("Error obteniendo las fotos del CDN", e);
				}

			}
		}
		return listaActivoFoto;

	}

	public List<ActivoFoto> getListFotosActivoByIdOrderPrincipal(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Order order = new Order(OrderType.ASC, "principal, orden");

		return genericDao.getListOrdered(ActivoFoto.class, order, filtro);

	}

	public Page getActivos(DtoActivoFilter dtoActivoFiltro) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if (!Checks.esNulo(usuarioCartera))
			dtoActivoFiltro.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
		return (Page) activoApi.getListActivos(dtoActivoFiltro, usuarioLogado);
	}

	public List<DtoUsuario> getComboUsuarios(long idTipoGestor) {
		List<DespachoExterno> listDespachoExterno = coreextensionApi.getListAllDespachos(idTipoGestor, false);
		List<DtoUsuario> listaUsuariosDto = new ArrayList<DtoUsuario>();

		if (!Checks.estaVacio(listDespachoExterno)) {
			DespachoExterno despachoExterno = listDespachoExterno.get(0);
			List<Usuario> listaUsuarios = coreextensionApi.getListAllUsuariosData(despachoExterno.getId(), false);

			try {
				for (Usuario usuario : listaUsuarios) {
					DtoUsuario dtoUsuario = new DtoUsuario();
					BeanUtils.copyProperties(dtoUsuario, usuario);
					listaUsuariosDto.add(dtoUsuario);
				}
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		}
		
		Collections.sort(listaUsuariosDto);
		

		return listaUsuariosDto;
	}
	
/*	public List<DtoUsuario> getComboUsuariosGrupos(long idTipoGestor) {
		List<DespachoExterno> listDespachoExterno = coreextensionApi.getListAllDespachos(idTipoGestor, false);
		List<DtoUsuario> listaUsuariosDto = new ArrayList<DtoUsuario>();

		if (!Checks.estaVacio(listDespachoExterno)) {
			DespachoExterno despachoExterno = listDespachoExterno.get(0);
			List<Usuario> listaUsuarios = coreextensionApi.getListAllUsuariosData(despachoExterno.getId(), false);

			try {
				for (Usuario usuario : listaUsuarios) {
					DtoUsuario dtoUsuario = new DtoUsuario();
					BeanUtils.copyProperties(dtoUsuario, usuario);
					if(usuario.getUsuarioGrupo()){
						listaUsuariosDto.add(dtoUsuario);
					}
				}
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		}

		return listaUsuariosDto;
	}
*/


	public List<DtoUsuario> getComboUsuariosGestoria() {
		
		EXTDDTipoGestor tipoGestorGestoria = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION));
		return getComboUsuarios(tipoGestorGestoria.getId());
	}
	
	

	public List<DtoListadoGestores> getGestores(Long idActivo) {
		GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
		gestorEntidadDto.setIdEntidad(idActivo);
		gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
		List<GestorEntidadHistorico> gestoresEntidad = gestorActivoApi
				.getListGestoresAdicionalesHistoricoData(gestorEntidadDto);

		List<DtoListadoGestores> listadoGestoresDto = new ArrayList<DtoListadoGestores>();

		for (GestorEntidadHistorico gestor : gestoresEntidad) {
			DtoListadoGestores dtoGestor = new DtoListadoGestores();
			try {
				BeanUtils.copyProperties(dtoGestor, gestor);
				BeanUtils.copyProperties(dtoGestor, gestor.getUsuario());
				BeanUtils.copyProperties(dtoGestor, gestor.getTipoGestor());
				BeanUtils.copyProperty(dtoGestor, "id", gestor.getId());
				BeanUtils.copyProperty(dtoGestor, "idUsuario", gestor.getUsuario().getId());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}

			listadoGestoresDto.add(dtoGestor);
		}

		return listadoGestoresDto;

	}

	public Boolean insertarGestorAdicional(GestorEntidadDto dto) {
		dto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
		return gestorActivoApi.insertarGestorAdicionalActivo(dto);
		// return true;
	}

	public List<DtoListadoTramites> getTramitesActivo(Long idActivo, WebDto webDto) {

		// List<ActivoTramite> tramitesActivo = (List<ActivoTramite>)
		// activoTramiteApi.getTramitesActivo(idActivo, webDto).getResults();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		List<VBusquedaTramitesActivo> tramitesActivo = genericDao.getList(VBusquedaTramitesActivo.class, filtro);
		List<DtoListadoTramites> listadoTramitesDto = new ArrayList<DtoListadoTramites>();

		for (VBusquedaTramitesActivo tramite : tramitesActivo) {
			DtoListadoTramites dtoTramite = new DtoListadoTramites();
			try {
				beanUtilNotNull.copyProperties(dtoTramite, tramite);

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			listadoTramitesDto.add(dtoTramite);
		}

		return listadoTramitesDto;
	}

	public List<DtoPropietario> getListPropietarioById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoPropietario> listaDtoPropietarios = new ArrayList<DtoPropietario>();

		for (int i = 0; i < activo.getPropietariosActivo().size(); i++) {
			if (activo.getPropietariosActivo() != null && activo.getPropietariosActivo().size() > 0) {
				DtoPropietario propietarioDto = new DtoPropietario();
				ActivoPropietarioActivo propietario = activo.getPropietariosActivo().get(i);
				try {
					BeanUtils.copyProperties(propietarioDto, propietario);
					BeanUtils.copyProperties(propietarioDto, propietario.getPropietario());
					BeanUtils.copyProperty(propietarioDto, "nombreCompleto",
							propietario.getPropietario().getFullName());
					BeanUtils.copyProperty(propietarioDto, "idActivo", propietario.getActivo().getId());
					if (!Checks.esNulo(propietario.getTipoGradoPropiedad()))
						BeanUtils.copyProperty(propietarioDto, "tipoGradoPropiedadDescripcion",
								propietario.getTipoGradoPropiedad().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getLocalidad()))
						BeanUtils.copyProperty(propietarioDto, "localidadDescripcion",
								propietario.getPropietario().getLocalidad().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getProvincia()))
						BeanUtils.copyProperty(propietarioDto, "provinciaDescripcion",
								propietario.getPropietario().getProvincia().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getTipoPersona()))
						BeanUtils.copyProperty(propietarioDto, "tipoPersonaDescripcion",
								propietario.getPropietario().getTipoPersona().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getLocalidadContacto()))
						BeanUtils.copyProperty(propietarioDto, "localidadContactoDescripcion",
								propietario.getPropietario().getLocalidadContacto().getDescripcion());

					if (!Checks.esNulo(propietario.getPropietario().getProvinciaContacto()))
						BeanUtils.copyProperty(propietarioDto, "provinciaContactoDescripcion",
								propietario.getPropietario().getProvinciaContacto().getDescripcion());

					if (!Checks.esNulo(propietario.getPropietario().getTipoDocIdentificativo())) {
						BeanUtils.copyProperty(propietarioDto, "tipoDocIdentificativoDesc",
								propietario.getPropietario().getTipoDocIdentificativo().getDescripcion());
					}

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoPropietarios.add(propietarioDto);
			}

		}

		return listaDtoPropietarios;

	}

	public List<DtoValoracion> getListValoracionesById(Long id) {

		// FIXME Hacer el get bien del listado de cargas cuando estén las tablas
		// de activo.
		Activo activo = activoApi.get(id);
		List<DtoValoracion> listaDtoValoracion = new ArrayList<DtoValoracion>();

		for (int i = 0; i < activo.getValoracion().size(); i++) {
			if (activo.getValoracion() != null && activo.getValoracion().size() > 0) {
				DtoValoracion valoracionDto = new DtoValoracion();
				try {
					BeanUtils.copyProperties(valoracionDto, activo.getValoracion().get(i));
					BeanUtils.copyProperty(valoracionDto, "tipoPrecioCod",
							activo.getValoracion().get(i).getTipoPrecio().getCodigo());
					BeanUtils.copyProperty(valoracionDto, "tipoPrecioDescripcion",
							activo.getValoracion().get(i).getTipoPrecio().getDescripcion());

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoValoracion.add(valoracionDto);
			}

		}

		return listaDtoValoracion;

	}

	public List<DtoTasacion> getListTasacionById(Long id) {

		// FIXME Hacer el get bien del listado de cargas cuando estén las tablas
		// de activo.
		Activo activo = activoApi.get(id);
		List<DtoTasacion> listaDtoTasacion = new ArrayList<DtoTasacion>();

		if (activo.getTasacion() != null) {
			for (int i = 0; i < activo.getTasacion().size(); i++) {

				DtoTasacion tasacionDto = new DtoTasacion();
				try {
					BeanUtils.copyProperties(tasacionDto, activo.getTasacion().get(i));
					if (activo.getTasacion().get(i).getTipoTasacion() != null) {
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionCodigo",
								activo.getTasacion().get(i).getTipoTasacion().getCodigo());
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionDescripcion",
								activo.getTasacion().get(i).getTipoTasacion().getDescripcion());
					}
					if (activo.getTasacion().get(i).getValoracionBien() != null) {
						BeanUtils.copyProperty(tasacionDto, "fechaValorTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaValorTasacion());
						BeanUtils.copyProperty(tasacionDto, "fechaSolicitudTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaSolicitudTasacion());
						BeanUtils.copyProperty(tasacionDto, "importeValorTasacion",
								activo.getTasacion().get(i).getImporteTasacionFin());
					}
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoTasacion.add(tasacionDto);
			}
		}

		return listaDtoTasacion;

	}
	
	public List<DtoTasacion> getListTasacionByIdGrid(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoTasacion> listaDtoTasacion = new ArrayList<DtoTasacion>();

		if (activo.getTasacion() != null) {
			for (int i = 0; i < activo.getTasacion().size(); i++) {

				DtoTasacion tasacionDto = new DtoTasacion();
				try {
					BeanUtils.copyProperties(tasacionDto, activo.getTasacion().get(i));
					if (activo.getTasacion().get(i).getTipoTasacion() != null) {
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionCodigo",
								activo.getTasacion().get(i).getTipoTasacion().getCodigo());
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionDescripcion",
								activo.getTasacion().get(i).getTipoTasacion().getDescripcion());
					}
					if (activo.getTasacion().get(i).getValoracionBien() != null) {
						BeanUtils.copyProperty(tasacionDto, "fechaValorTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaValorTasacion());
						BeanUtils.copyProperty(tasacionDto, "fechaSolicitudTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaSolicitudTasacion());
						BeanUtils.copyProperty(tasacionDto, "importeValorTasacion",
								activo.getTasacion().get(i).getImporteTasacionFin());
					}
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				
				ActivoProveedor tasadora = this.getTasadoraByCodProveedorUvem(tasacionDto.getCodigoFirma());
				if(!Checks.esNulo(tasadora)){
					tasacionDto.setNomTasador(tasadora.getNombre());
				}
				listaDtoTasacion.add(tasacionDto);
			}
		}

		return listaDtoTasacion;

	}
	
	/**
	 * Obtiene la tasadora dado un codProveedorUvem
	 * 
	 * @param codProveedorUvem
	 * @return
	 */
	public ActivoProveedor getTasadoraByCodProveedorUvem(String codProveedorUvem) {
		ActivoProveedor tasadora = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codProveedorUvem", codProveedorUvem);
		Filter filtroTasadora = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_TASADORA);
		List<ActivoProveedor> tasadoras = genericDao.getList(ActivoProveedor.class, filtro,filtroTasadora);
		if (!Checks.estaVacio(tasadoras)) {
			tasadora = tasadoras.get(0);
		}
		return tasadora;
	}

	public DtoTramite getTramite(Long idTramite) {
		DtoTramite dtoTramite = new DtoTramite();
		ActivoTramite tramite = activoTramiteApi.get(idTramite);
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");

		try {
			beanUtilNotNull.copyProperty(dtoTramite, "idTramite", tramite.getId());
			beanUtilNotNull.copyProperty(dtoTramite, "idTipoTramite", tramite.getTipoTramite().getId());
			beanUtilNotNull.copyProperty(dtoTramite, "tipoTramite", tramite.getTipoTramite().getDescripcion());
			if (!Checks.esNulo(tramite.getTramitePadre()))
				beanUtilNotNull.copyProperty(dtoTramite, "idTramitePadre", tramite.getTramitePadre().getId());
			beanUtilNotNull.copyProperty(dtoTramite, "idActivo", tramite.getActivo().getId());
			beanUtilNotNull.copyProperty(dtoTramite, "nombre", tramite.getTipoTramite().getDescripcion());
			beanUtilNotNull.copyProperty(dtoTramite, "estado", tramite.getEstadoTramite().getDescripcion());
			if (!Checks.esNulo(tramite.getTrabajo())) {
				beanUtilNotNull.copyProperty(dtoTramite, "idTrabajo", tramite.getTrabajo().getId());
				beanUtilNotNull.copyProperty(dtoTramite, "numTrabajo", tramite.getTrabajo().getNumTrabajo());
				beanUtilNotNull.copyProperty(dtoTramite, "tipoTrabajo",
						tramite.getTrabajo().getTipoTrabajo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoTramite, "subtipoTrabajo",
						tramite.getTrabajo().getSubtipoTrabajo().getDescripcion());
			}
			if (!Checks.esNulo(tramite.getActivo().getTipoActivo()))
				beanUtilNotNull.copyProperty(dtoTramite, "tipoActivo",
						tramite.getActivo().getTipoActivo().getDescripcion());
			if (!Checks.esNulo(tramite.getActivo().getSubtipoActivo()))
				beanUtilNotNull.copyProperty(dtoTramite, "subtipoActivo",
						tramite.getActivo().getSubtipoActivo().getDescripcion());
			if (!Checks.esNulo(tramite.getActivo().getCartera()))
				beanUtilNotNull.copyProperty(dtoTramite, "cartera", tramite.getActivo().getCartera().getDescripcion());
			if (!Checks.esNulo(tramite.getFechaInicio()))
				beanUtilNotNull.copyProperty(dtoTramite, "fechaInicio", formato.format(tramite.getFechaInicio()));
			if (!Checks.esNulo(tramite.getFechaFin()))
				beanUtilNotNull.copyProperty(dtoTramite, "fechaFinalizacion", formato.format(tramite.getFechaFin()));

			if((tramite.getTrabajo() != null) && (tramite.getTrabajo().getAgrupacion() != null)) {
				beanUtilNotNull.copyProperty(dtoTramite, "numActivo", tramite.getTrabajo().getAgrupacion().getNumAgrupRem());
			} else {
				beanUtilNotNull.copyProperty(dtoTramite, "numActivo", tramite.getActivo().getNumActivo());
			}

			beanUtilNotNull.copyProperty(dtoTramite, "esMultiActivo", tramite.getActivos().size() > 1 ? true : false);
			beanUtilNotNull.copyProperty(dtoTramite, "countActivos", tramite.getActivos().size());
			if (!Checks.esNulo(tramite.getTipoTramite())){
				if (!ActivoTramiteApi.CODIGO_TRAMITE_ACTUACION_TECNICA.equals(tramite.getTipoTramite().getCodigo())
						&& !ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC.equals(tramite.getTipoTramite().getCodigo())) {
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonCierre", true);
				}
				if (!ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA.equals(tramite.getTipoTramite().getCodigo())) {
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonResolucion", true);
				}
				
				if (!ActivoTramiteApi.CODIGO_TRAMITE_PROPUESTA_PRECIOS.equals(tramite.getTipoTramite().getCodigo())) {
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonAnular", true);
				}
			}
				
				
			beanUtilNotNull.copyProperty(dtoTramite, "tieneEC", false);
			if (!Checks.esNulo(tramite.getTrabajo())) {
				// Trabajos asociados con expediente comercial
				Filter filtroEC = genericDao.createFilter(FilterType.EQUALS, "trabajo.id",
						tramite.getTrabajo().getId());
				ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filtroEC);
				if (!Checks.esNulo(expedienteComercial)) {
					beanUtilNotNull.copyProperty(dtoTramite, "tieneEC", true);
					beanUtilNotNull.copyProperty(dtoTramite, "idExpediente", expedienteComercial.getId());
					beanUtilNotNull.copyProperty(dtoTramite, "descripcionEstadoEC",
							expedienteComercial.getEstado().getDescripcion());
					beanUtilNotNull.copyProperty(dtoTramite, "numEC", expedienteComercial.getNumExpediente());
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return dtoTramite;
	}

	public List<DtoListadoTareas> getTareasTramite(Long idTramite) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		List<TareaExterna> tareasTramite = new ArrayList<TareaExterna>();
		ActivoTramite tramite = activoTramiteApi.get(idTramite);

		if (!genericAdapter.isSuper(usuarioLogado)
				&& !gestorActivoApi.isSupervisorActivo(tramite.getActivo(), usuarioLogado))
			tareasTramite = activoTareaExternaApi.getActivasByIdTramite(idTramite, usuarioLogado);
		else
			tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(idTramite);

		List<DtoListadoTareas> tareasTramiteDto = new ArrayList<DtoListadoTareas>();

		for (TareaExterna tarea : tareasTramite) {
			DtoListadoTareas dtoListadoTareas = new DtoListadoTareas();
			TareaActivo tareaActivo = tareaActivoApi.get(tarea.getTareaPadre().getId());

			try {
				beanUtilNotNull.copyProperty(dtoListadoTareas, "id", tarea.getTareaPadre().getId());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna", tarea.getId());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea",
						tarea.getTareaProcedimiento().getDescripcion());
				// beanUtilNotNull.copyProperty(dtoListadoTareas, "idTramite",
				// value);

				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio", tarea.getTareaPadre().getFechaInicio());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc", tarea.getTareaPadre().getFechaVenc());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin", tarea.getTareaPadre().getFechaFin());

				if (!Checks.esNulo(tareaActivo.getUsuario())) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor", tareaActivo.getUsuario().getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor", tareaActivo.getUsuario().getUsername());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "nombreUsuarioGestor", tareaActivo.getUsuario().getApellidoNombre());
				}
				if(!Checks.esNulo(tareaActivo.getSupervisorActivo())){
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idSupervisor", tareaActivo.getSupervisorActivo().getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "nombreUsuarioSupervisor", tareaActivo.getSupervisorActivo().getApellidoNombre());
				}
				beanUtilNotNull.copyProperty(dtoListadoTareas, "subtipoTareaCodigoSubtarea",
						tareaActivo.getSubtipoTarea().getCodigoSubtarea());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "codigoTarea",
						tarea.getTareaProcedimiento().getCodigo());

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			tareasTramiteDto.add(dtoListadoTareas);
		}

		return tareasTramiteDto;

	}

	public List<DtoListadoTareas> getTareasTramiteHistorico(Long idTramite) {

		List<TareaActivo> tareasTramite = tareaActivoApi.getTareasActivoByIdTramite(idTramite);
		List<DtoListadoTareas> tareasTramiteDto = new ArrayList<DtoListadoTareas>();

		for (TareaActivo tareaActivo : tareasTramite) {
			DtoListadoTareas dtoListadoTareas = new DtoListadoTareas();

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", tareaActivo.getId());
			TareaExterna tareaExterna = genericDao.get(TareaExterna.class, filtro);

			try {
				beanUtilNotNull.copyProperty(dtoListadoTareas, "id", tareaActivo.getId());
				if (!Checks.esNulo(tareaExterna)) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna", tareaExterna.getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea",
							tareaExterna.getTareaProcedimiento().getDescripcion());
				} else {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", tareaActivo.getDescripcionTarea());
				}
				// beanUtilNotNull.copyProperty(dtoListadoTareas, "idTramite",
				// value);

				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio", tareaActivo.getFechaInicio());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc", tareaActivo.getFechaVenc());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin", tareaActivo.getFechaFin());

				if (!Checks.esNulo(tareaActivo.getUsuario())) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor", tareaActivo.getUsuario().getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor", tareaActivo.getUsuario().getUsername());
				}
				beanUtilNotNull.copyProperty(dtoListadoTareas, "subtipoTareaCodigoSubtarea",
						tareaActivo.getSubtipoTarea().getCodigoSubtarea());

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			tareasTramiteDto.add(dtoListadoTareas);
		}

		return tareasTramiteDto;

	}

	/*
	 * Este método tiraba de la TEX, al añadir las prórrogas se ha tenido que
	 * modificar.
	 * 
	 * public List<DtoListadoTareas> getTareasTramiteHistorico(Long idTramite){
	 * 
	 * List<TareaExterna> tareasTramite =
	 * activoTareaExternaApi.getTareasByIdTramite(idTramite);
	 * List<DtoListadoTareas> tareasTramiteDto = new
	 * ArrayList<DtoListadoTareas>();
	 * 
	 * for(TareaExterna tarea : tareasTramite){ DtoListadoTareas
	 * dtoListadoTareas = new DtoListadoTareas(); TareaActivo tareaActivo =
	 * tareaActivoApi.get(tarea.getTareaPadre().getId());
	 * 
	 * try{ beanUtilNotNull.copyProperty(dtoListadoTareas, "id",
	 * tarea.getTareaPadre().getId());
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna",
	 * tarea.getId()); beanUtilNotNull.copyProperty(dtoListadoTareas,
	 * "tipoTarea", tarea.getTareaProcedimiento().getDescripcion());
	 * //beanUtilNotNull.copyProperty(dtoListadoTareas, "idTramite", value);
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio",
	 * tarea.getTareaPadre().getFechaInicio());
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin",
	 * tarea.getTareaPadre().getFechaFin());
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc",
	 * tarea.getTareaPadre().getFechaVenc());
	 * 
	 * if(!Checks.esNulo(tareaActivo.getUsuario())){
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor",
	 * tareaActivo.getUsuario().getId());
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor",
	 * tareaActivo.getUsuario().getUsername()); }
	 * beanUtilNotNull.copyProperty(dtoListadoTareas,
	 * "subtipoTareaCodigoSubtarea",
	 * tareaActivo.getSubtipoTarea().getCodigoSubtarea());
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); }
	 * tareasTramiteDto.add(dtoListadoTareas); }
	 * 
	 * return tareasTramiteDto;
	 * 
	 * }
	 */

	public Long crearTramiteAdmision(Long idActivo) {

		TipoProcedimiento tprc = tipoProcedimiento.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ADMISION); // Trámite
																		// de
																		// admisión

		ActivoTramite tramite = jbpmActivoTramiteManagerApi.creaActivoTramite(tprc, activoApi.get(idActivo));
		Long idBpm = jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());

		jbpmActivoTramiteManagerApi.paralizarTareasChecking(tramite);

		return idBpm;
	}

	@Transactional(readOnly = false)
	public Long crearTramitePublicacion(Long idActivo) {

		TipoProcedimiento tprc = tipoProcedimiento.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_PUBLICACION);// Trámite
																		// de
																		// publicación

		ActivoTramite tramite = jbpmActivoTramiteManagerApi.creaActivoTramite(tprc, activoApi.get(idActivo));
		
		//Creación registro historial comercial con estado informe emision
		ActivoEstadosInformeComercialHistorico estadoInformeComercialHistorico= new ActivoEstadosInformeComercialHistorico();
		estadoInformeComercialHistorico.setActivo(activoApi.get(idActivo));
		DDEstadoInformeComercial estadoInformeComercial = (DDEstadoInformeComercial) proxyFactory.proxy(UtilDiccionarioApi.class)
				.dameValorDiccionarioByCod(DDEstadoInformeComercial.class, DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_EMISION);
		estadoInformeComercialHistorico.setEstadoInformeComercial(estadoInformeComercial);
		estadoInformeComercialHistorico.setFecha(new Date());
		
		genericDao.save(ActivoEstadosInformeComercialHistorico.class, estadoInformeComercialHistorico);
		
		
		Long idBpm = jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());

		return idBpm;
	}

	public List<VAdmisionDocumentos> getListAdmisionCheckDocumentos(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());
		Order order = new Order(OrderType.ASC, "descripcionTipoDoc");

		return genericDao.getListOrdered(VAdmisionDocumentos.class, order, filtro);

	}

	public List<VOfertasActivosAgrupacion> getListOfertasActivos(Long idActivo) {

		return activoDao.getListOfertasActivo(idActivo);

	}

	public List<VPreciosVigentes> getPreciosVigentesById(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());
		Order order = new Order(OrderType.ASC, "orden");

		return genericDao.getListOrdered(VPreciosVigentes.class, order, filtro);

	}

	@Transactional(readOnly = false)
	public boolean saveAdmisionDocumento(DtoAdmisionDocumento dtoAdmisionDocumento) {

		ActivoAdmisionDocumento activoAdmisionDocumento = null;

		if (dtoAdmisionDocumento.getIdAdmisionDoc() != null) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdAdmisionDoc());
			activoAdmisionDocumento = genericDao.get(ActivoAdmisionDocumento.class, filtro);

			if (!BooleanUtils.toBoolean(dtoAdmisionDocumento.getAplica())) {

				activoAdmisionDocumento.setAplica(false);
				activoAdmisionDocumento.setFechaObtencion(null);
				activoAdmisionDocumento.setFechaSolicitud(null);
				activoAdmisionDocumento.setFechaVerificado(null);
				activoAdmisionDocumento.setEstadoDocumento(null);
				activoAdmisionDocumento.setTipoCalificacionEnergetica(null);
				activoAdmisionDocumento.setNumDocumento(null);
				activoAdmisionDocumento.setFechaEtiqueta(null);
				activoAdmisionDocumento.setFechaEmision(null);
				activoAdmisionDocumento.setFechaCaducidad(null);

			} else {

				rellenaCheckingDocumentoAdmision(activoAdmisionDocumento, dtoAdmisionDocumento);
			}

			genericDao.update(ActivoAdmisionDocumento.class, activoAdmisionDocumento);

		} else {

			activoAdmisionDocumento = new ActivoAdmisionDocumento();

			rellenaCheckingDocumentoAdmision(activoAdmisionDocumento, dtoAdmisionDocumento);

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdActivo());
			activoAdmisionDocumento.setActivo(genericDao.get(Activo.class, filtro));
			filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdConfiguracionDoc());
			activoAdmisionDocumento.setConfigDocumento(genericDao.get(ActivoConfigDocumento.class, filtro));

			rellenaCheckingDocumentoAdmision(activoAdmisionDocumento, dtoAdmisionDocumento);
			genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDocumento);

		}

		return true;

	}

	private void rellenaCheckingDocumentoAdmision(ActivoAdmisionDocumento activoAdmisionDocumento,
			DtoAdmisionDocumento dtoAdmisionDocumento) {

		try {

			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaObtencion",
					dtoAdmisionDocumento.getFechaObtencion());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaSolicitud",
					dtoAdmisionDocumento.getFechaSolicitud());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaVerificado",
					dtoAdmisionDocumento.getFechaVerificado());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "aplica",
					BooleanUtils.toBoolean(dtoAdmisionDocumento.getAplica()));

			if (dtoAdmisionDocumento.getEstadoDocumento() != null) {
				DDEstadoDocumento estadoDocumento = (DDEstadoDocumento) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDEstadoDocumento.class, dtoAdmisionDocumento.getEstadoDocumento());
				activoAdmisionDocumento.setEstadoDocumento(estadoDocumento);
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

	}

	public List<DtoAdjunto> getAdjuntosActivo(Long id)
			throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();

		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Activo activo = activoApi.get(id);
			listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosActivo(activo);

			for (DtoAdjunto adj : listaAdjuntos) {
				ActivoAdjuntoActivo adjuntoActivo = activo.getAdjuntoGD(adj.getId());
				if (!Checks.esNulo(adjuntoActivo)) {
					if (!Checks.esNulo(adjuntoActivo.getTipoDocumentoActivo())) {
						adj.setDescripcionTipo(adjuntoActivo.getTipoDocumentoActivo().getDescripcion());
					}
					adj.setContentType(adjuntoActivo.getContentType());
					if (!Checks.esNulo(adjuntoActivo.getAuditoria())) {
						adj.setGestor(adjuntoActivo.getAuditoria().getUsuarioCrear());
					}
					adj.setTamanyo(adjuntoActivo.getTamanyo());
				}
			}

		} else {
			listaAdjuntos = getAdjuntosActivo(id, listaAdjuntos);
		}
		return listaAdjuntos;
	}

	private List<DtoAdjunto> getAdjuntosActivo(Long id, List<DtoAdjunto> listaAdjuntos)
			throws IllegalAccessException, InvocationTargetException {
		Activo activo = activoApi.get(id);

		for (ActivoAdjuntoActivo adjunto : activo.getAdjuntos()) {
			DtoAdjunto dto = new DtoAdjunto();

			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(activo.getId());
			dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
			dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

			listaAdjuntos.add(dto);
		}
		return listaAdjuntos;
	}

	public String uploadDocumento(WebFileItem webFileItem, Activo activoEntrada, String matricula) throws Exception {

		if (Checks.esNulo(activoEntrada)) {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Activo activo = activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao
						.get(DDTipoDocumentoActivo.class, filtro);
				Long idDocRestClient = gestorDocumentalAdapterApi.upload(activo, webFileItem,
						usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				activoApi.upload2(webFileItem, idDocRestClient);
			} else {
				activoApi.upload(webFileItem);
			}
		} else {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao
						.get(DDTipoDocumentoActivo.class, filtro);

				if (!Checks.esNulo(tipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.upload(activoEntrada, webFileItem,
							usuarioLogado.getUsername(), tipoDocumento.getMatricula());
					activoApi.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
				}
			} else {
				activoApi.uploadDocumento(webFileItem, null, activoEntrada, matricula);
			}
		}
		return null;
	}

	public String upload(WebFileItem webFileItem) throws Exception {
		return uploadDocumento(webFileItem, null, null);
		// if(modoRestClient()) {
		// Activo activo =
		// activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));
		// Usuario usuarioLogado =
		// genericAdapter.getUsuarioLogado();
		//
		// Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
		// webFileItem.getParameter("tipo"));
		// DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo)
		// genericDao.get(DDTipoDocumentoActivo.class, filtro);
		// Long idDocRestClient = gestorDocumentalAdapterApi.upload(activo,
		// webFileItem, usuarioLogado.getUsername(),
		// tipoDocumento.getMatricula());
		// activoApi.upload2(webFileItem, idDocRestClient);
		// }else{
		// activoApi.upload(webFileItem);
		// }
		// return null;
	}

	public FileItem download(Long id) throws Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		return dl.getFileItem(id);
	}

	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			borrado = activoApi.deleteAdjunto(dtoAdjunto);
		}
		return borrado;
	}

	// MOVIDO A GENERIC MANAGER
	/*
	 * private boolean modoRestClient() { Boolean activar =
	 * Boolean.valueOf(appProperties.getProperty(PROPIEDAD_ACTIVAR_REST_CLIENT))
	 * ; if (activar == null) { activar = false; } return activar; }
	 */

	// public List<DtoActivoAviso> getAvisosActivoById(Long id) {
	// FIXME: Formatear aquí o en vista cuando se sepa el diseño.
	public DtoAviso getAvisosActivoById(Long id) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		List<DtoAviso> avisos = activoAvisadorApi.getListActivoAvisador(id, usuarioLogado);

		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		for (int i = 0; i < avisos.size(); i++) {
			avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso'>"
					+ avisos.get(i).getDescripcion() + "</div>");
		}

		return avisosFormateados;

	}

	@Transactional(readOnly = false)
	public boolean deleteFotosActivoById(Long[] id) {
		boolean resultado = true;
		try {

			for (int i = 0; i < id.length; i++) {
				ActivoFoto actvFoto = this.getFotoActivoById(id[i]);
				if (actvFoto.getRemoteId() != null) {
					OperationResultResponse reponseDelete = gestorDocumentalFotos.delete(actvFoto.getRemoteId());
					if (reponseDelete.getError() != null && !reponseDelete.getError().isEmpty()) {
						throw new Exception(reponseDelete.getError());
					}
				}
				genericDao.deleteById(ActivoFoto.class, actvFoto.getId());
			}

		} catch (Exception e) {
			logger.error(e);
			resultado = false;
		}

		return resultado;

	}

	@Transactional(readOnly = false)
	public void deleteFotoByRemoteId(Long remoteId) throws Exception {
		try {
			ActivoFoto actvFoto = this.getFotoActivoByRemoteId(remoteId);
			if (actvFoto != null) {
				genericDao.deleteById(ActivoFoto.class, actvFoto.getId());
			} else {
				throw new Exception("La foto con id remoto ".concat(remoteId.toString()).concat(" no existe"));
			}
		} catch (Exception e) {
			logger.error("Error borrando la foto", e);
			throw new Exception(e.getMessage());
		}

	}

	/*
	 * public Page findAllHistoricoPresupuestos(DtoHistoricoPresupuestosFilter
	 * dtoPresupuestoFiltro) {
	 * 
	 * Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
	 * 
	 * return (Page)
	 * activoApi.getListHistoricoPresupuestos(dtoPresupuestoFiltro,
	 * usuarioLogado); }
	 */

	@SuppressWarnings("unchecked")
	public DtoPage findAllHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dtoPresupuestoFiltro) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		Page pagePresupuestosActivo = activoApi.getListHistoricoPresupuestos(dtoPresupuestoFiltro, usuarioLogado);

		List<VBusquedaPresupuestosActivo> presupuestosActivo = (List<VBusquedaPresupuestosActivo>) pagePresupuestosActivo
				.getResults();

		for (VBusquedaPresupuestosActivo presupuesto : presupuestosActivo) {

			// Gastado + Pendiente de pago
			DtoActivosTrabajoFilter dtoFilter = new DtoActivosTrabajoFilter();

			dtoFilter.setIdActivo(presupuesto.getIdActivo());
			dtoFilter.setLimit(50000);
			dtoFilter.setStart(0);
			dtoFilter.setEstadoContable("1");

			Page vista = trabajoApi.getListActivosPresupuesto(dtoFilter);
			if (vista.getTotalCount() > 0) {

				List<VBusquedaActivosTrabajoPresupuesto> listaTemp = (List<VBusquedaActivosTrabajoPresupuesto>) vista
						.getResults();
				presupuesto.setDispuesto(new Double(0));
				for (VBusquedaActivosTrabajoPresupuesto activoTrabajoTemp : listaTemp) {
					if(activoTrabajoTemp.getEjercicio().equals(presupuesto.getEjercicioAnyo())) {
						presupuesto.setDispuesto(
								presupuesto.getDispuesto() + new Double(activoTrabajoTemp.getImporteParticipa()));
					}
				}

			} else {
				presupuesto.setDispuesto(new Double(0));
			}

			if (Checks.esNulo(presupuesto.getSumaIncrementos())) {
				presupuesto.setSumaIncrementos(new Double(0));
			}

		}

		return new DtoPage(presupuestosActivo, pagePresupuestosActivo.getTotalCount());

	}

	// public List<DtoPresupuestoGraficoActivo>
	// findLastPresupuesto(DtoActivosTrabajoFilter dtoFilter) {
	@SuppressWarnings("unchecked")
	public DtoPresupuestoGraficoActivo findLastPresupuesto(DtoActivosTrabajoFilter dtoFilter) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		DtoPresupuestoGraficoActivo presupuestoGrafico = new DtoPresupuestoGraficoActivo();

		SimpleDateFormat dfAnyo = new SimpleDateFormat("yyyy");
		String ejercicioActual = dfAnyo.format(new Date());

		Long idPresupuesto = activoApi.getUltimoHistoricoPresupuesto(Long.parseLong(dtoFilter.getIdActivo()));
		DtoHistoricoPresupuestosFilter dtoFiltroHistorico = new DtoHistoricoPresupuestosFilter();
		dtoFiltroHistorico.setIdActivo(dtoFilter.getIdActivo());
		dtoFiltroHistorico.setIdPresupuesto(String.valueOf(idPresupuesto));
		dtoFiltroHistorico.setLimit(1);
		dtoFiltroHistorico.setStart(0);

		// Esta consulta solo deberia obtener 1 registro: el presupuesto para el
		// ultimo ejercicio registrado (y no borrado)
		// NO hay que coger el primer registro que salga en el historico de
		// presupuestos porque si no sale ordenado, no coge el bueno
		// esto se hace gracias a calcular el id de presupuesto con el metodo
		// "getUltimoHistoricoPresupuesto"
		VBusquedaPresupuestosActivo presupuestoActivo = (VBusquedaPresupuestosActivo) activoApi
				.getListHistoricoPresupuestos(dtoFiltroHistorico, usuarioLogado).getResults().get(0);

		// Disponible para ejercicio actual
		dtoFilter.setEjercicioPresupuestario(ejercicioActual);
		Page vista = trabajoApi.getListActivosPresupuesto(dtoFilter);
		if (vista.getTotalCount() > 0) {
			VBusquedaActivosTrabajoPresupuesto activoTrabajo = (VBusquedaActivosTrabajoPresupuesto) vista.getResults()
					.get(0);
			presupuestoGrafico.setDisponible(new Double(activoTrabajo.getSaldoDisponible()));

			dtoFilter.setEstadoContable("1");

			// Gastado + Pendiente de pago, para el ejercicio actual
			dtoFilter.setEjercicioPresupuestario(ejercicioActual);
			vista = trabajoApi.getListActivosPresupuesto(dtoFilter);
			if (vista.getTotalCount() > 0) {

				List<VBusquedaActivosTrabajoPresupuesto> listaTemp = (List<VBusquedaActivosTrabajoPresupuesto>) vista
						.getResults();
				presupuestoGrafico.setGastado(new Double(0));
				for (VBusquedaActivosTrabajoPresupuesto activoTrabajoTemp : listaTemp) {

					presupuestoGrafico.setGastado(
							presupuestoGrafico.getGastado() + new Double(activoTrabajoTemp.getImporteParticipa()));

				}

			} else {
				presupuestoGrafico.setGastado(new Double(0));
			}

			// Pendiente de pago, para el ejercicio actual
			dtoFilter.setEstadoCodigo(DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
			dtoFilter.setEjercicioPresupuestario(ejercicioActual);
			vista = trabajoApi.getListActivosPresupuesto(dtoFilter);
			if (vista.getTotalCount() > 0) {

				List<VBusquedaActivosTrabajoPresupuesto> listaTemp = (List<VBusquedaActivosTrabajoPresupuesto>) vista
						.getResults();
				presupuestoGrafico.setDispuesto(new Double(0));
				for (VBusquedaActivosTrabajoPresupuesto activoTrabajoTemp : listaTemp) {

					presupuestoGrafico.setDispuesto(
							presupuestoGrafico.getDispuesto() + new Double(activoTrabajoTemp.getImporteParticipa()));

				}

			} else {
				presupuestoGrafico.setDispuesto(new Double(0));
			}

			presupuestoGrafico.setGastado(presupuestoGrafico.getGastado() - presupuestoGrafico.getDispuesto());
			presupuestoGrafico.setPresupuesto(presupuestoGrafico.getDisponible() + presupuestoGrafico.getDispuesto()
					+ presupuestoGrafico.getGastado());
			presupuestoGrafico.setDisponiblePorcentaje(
					Double.valueOf(((presupuestoGrafico.getDisponible() / presupuestoGrafico.getPresupuesto()) * 100)));
			presupuestoGrafico.setDispuestoPorcentaje(
					Double.valueOf(((presupuestoGrafico.getDispuesto() / presupuestoGrafico.getPresupuesto()) * 100)));
			presupuestoGrafico.setGastadoPorcentaje(
					Double.valueOf(((presupuestoGrafico.getGastado() / presupuestoGrafico.getPresupuesto()) * 100)));

			presupuestoGrafico.setEjercicio(presupuestoActivo.getEjercicioAnyo());

		} else {

			if (presupuestoActivo.getSumaIncrementos() != null) {
				presupuestoGrafico.setDisponible(
						presupuestoActivo.getImporteInicial() + Double.valueOf(presupuestoActivo.getSumaIncrementos()));
			} else {
				presupuestoGrafico.setDisponible(presupuestoActivo.getImporteInicial());
			}
			presupuestoGrafico.setDisponiblePorcentaje(new Double(100));
			presupuestoGrafico.setEjercicio(presupuestoActivo.getEjercicioAnyo());
			presupuestoGrafico.setDispuesto(new Double(0));
			presupuestoGrafico.setGastado(new Double(0));
			presupuestoGrafico.setDispuestoPorcentaje(new Double(0));
			presupuestoGrafico.setGastadoPorcentaje(new Double(0));
			presupuestoGrafico.setPresupuesto(presupuestoGrafico.getDisponible());

		}

		return presupuestoGrafico;

	}

	public List<DtoIncrementoPresupuestoActivo> findAllIncrementosPresupuestoById(Long idPresupuesto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "presupuestoActivo.id", idPresupuesto);
		Order order = new Order(OrderType.DESC, "fechaAprobacion");

		List<IncrementoPresupuesto> listaPresupuestos = genericDao.getListOrdered(IncrementoPresupuesto.class, order,
				filtro);
		List<DtoIncrementoPresupuestoActivo> listaDto = new ArrayList<DtoIncrementoPresupuestoActivo>();

		for (int i = 0; i < listaPresupuestos.size(); i++) {
			DtoIncrementoPresupuestoActivo dtoPresupuesto = new DtoIncrementoPresupuestoActivo();

			try {

				IncrementoPresupuesto incrementoPresupuesto = listaPresupuestos.get(i);
				BeanUtils.copyProperties(dtoPresupuesto, incrementoPresupuesto);

				beanUtilNotNull.copyProperty(dtoPresupuesto, "presupuestoActivoImporte",
						incrementoPresupuesto.getPresupuestoActivo().getImporteInicial());
				if (incrementoPresupuesto.getTrabajo() != null) {
					beanUtilNotNull.copyProperty(dtoPresupuesto, "codigoTrabajo",
							incrementoPresupuesto.getTrabajo().getNumTrabajo());
				}

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}

			listaDto.add(dtoPresupuesto);
		}

		return listaDto;
	}

	public WebDto getTabActivo(Long id, String tab) throws IllegalAccessException, InvocationTargetException {

		TabActivoService tabActivoService = tabActivoFactory.getService(tab);
		Activo activo = activoApi.get(id);

		WebDto dto = tabActivoService.getTabData(activo);

		return dto;

	}

	@Transactional(readOnly = false)
	public boolean saveTabActivo(WebDto dto, Long id, String tab) {
		
		if (this.saveTabActivoTransactional(dto, id, tab)){
			//this.updatePortalPublicacion(dto, id);
		}
		return true;
	}
	
	@Transactional(readOnly = false)
	public boolean updatePublicarActivo(Long id) {
		Activo activo = activoApi.get(id);
		if(Checks.esNulo(activo)&&!Checks.esNulo(activo.getFechaPublicable())&&(!activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO)
				|| !activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO)
				|| !activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO)
				|| !activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_DESPUBLICADO))) {
			Usuario usuario = genericAdapter.getUsuarioLogado();
			activoDao.publicarActivo(activo.getId(), usuario.getUsername());
		}
		
		return true;
	}
	
	@Transactional(readOnly = false)
	public boolean updatePortalPublicacion(Long id) {
		Activo activo = activoApi.get(id);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		activoDao.publicarActivoPortal(activo.getId(), usuarioLogado.getUsername());
		return true;
	}
	
	@Transactional(readOnly = false)
	public boolean saveTabActivoTransactional(WebDto dto, Long id, String tab) {

		TabActivoService tabActivoService = tabActivoFactory.getService(tab);
		Activo activo = activoApi.get(id);

		activo = tabActivoService.saveTabActivo(activo, dto);

		activoApi.saveOrUpdate(activo);

		// Metodo que recoge funciones que requieren el guardado previo de los
		// datos
		afterSaveTabActivo(dto, activo, tabActivoService);

		return true;
	}

	private void afterSaveTabActivo(WebDto dto, Activo activo, TabActivoService tabActivoService) {
		
		if (tabActivoService instanceof TabActivoDatosBasicos) {			

			((TabActivoDatosBasicos) tabActivoService).afterSaveTabActivo(activo, dto);

		} else if (tabActivoService instanceof TabActivoSitPosesoriaLlaves) {
			
			((TabActivoSitPosesoriaLlaves) tabActivoService).afterSaveTabActivo(activo, dto);
			
		}
		
		else if (tabActivoService instanceof TabActivoDatosRegistrales) {
			
			((TabActivoDatosRegistrales) tabActivoService).afterSaveTabActivo(activo, dto);

		}

		// Actualizacion Tipo comercializacion y Estado de disponibilidad
		// comercial del activo
		// Vinculado a varias pestanyas del activo
		updaterState.updaterStateDisponibilidadComercial(activo);
		

	}

	@Transactional(readOnly = false)
	public boolean createOfertaActivo(DtoOfertasFilter dto) throws Exception {
		List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();

		Activo activo = activoApi.get(dto.getIdActivo());

		// Comprobar el tipo de destino comercial que tiene actualmente el
		// activo y contrastar con la oferta.
		if (!Checks.esNulo(activo.getTipoComercializacion())) {
			String comercializacion = activo.getTipoComercializacion().getCodigo();

			if (DDTipoOferta.CODIGO_VENTA.equals(dto.getTipoOferta())
					&& (!DDTipoComercializacion.CODIGO_VENTA.equals(comercializacion)
							&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion))) {
				throw new Exception(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
			}

			if (DDTipoOferta.CODIGO_ALQUILER.equals(dto.getTipoOferta())
					&& (!DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(comercializacion)
							&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion))) {
				throw new Exception(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
			}
		}

		try {
			Oferta oferta = new Oferta();
			ClienteComercial clienteComercial = new ClienteComercial();

			/*
			 * if(!Checks.esNulo(activo.getAgrupaciones()) &&
			 * activo.getAgrupaciones().size()!=0){ for(ActivoAgrupacionActivo
			 * agrupaciones: activo.getAgrupaciones()){ ActivoAgrupacion
			 * agrupacion = agrupaciones.getAgrupacion();
			 * if(agrupacion.getActivoPrincipal().getId().equals(activo.getId())
			 * ){ oferta.setAgrupacion(agrupacion); } } }
			 */

			String codigoEstado = this.getEstadoNuevaOferta(activo);

			DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadoOferta.class, codigoEstado);
			DDTipoOferta tipoOferta = (DDTipoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoOferta.class,
					dto.getTipoOferta());
			DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getTipoDocumento());
			Long numOferta = activoDao.getNextNumOferta();

			Long clcremid = activoDao.getNextClienteRemId();
			clienteComercial.setNombre(dto.getNombreCliente());
			clienteComercial.setApellidos(dto.getApellidosCliente());
			clienteComercial.setDocumento(dto.getNumDocumentoCliente());
			clienteComercial.setTipoDocumento(tipoDocumento);
			clienteComercial.setRazonSocial(dto.getRazonSocialCliente());
			clienteComercial.setIdClienteRem(clcremid);

			genericDao.save(ClienteComercial.class, clienteComercial);

			oferta.setNumOferta(numOferta);
			oferta.setImporteOferta(Double.valueOf(dto.getImporteOferta()));
			oferta.setEstadoOferta(estadoOferta);
			oferta.setTipoOferta(tipoOferta);
			oferta.setFechaAlta(new Date());
			oferta.setDesdeTanteo(dto.getDeDerechoTanteo());

			listaActOfr = ofertaApi.buildListaActivoOferta(activo, null, oferta);
			oferta.setActivosOferta(listaActOfr);

			oferta.setCliente(clienteComercial);

			oferta.setPrescriptor((ActivoProveedor) proveedoresApi.searchProveedorCodigo(dto.getCodigoPrescriptor()));
			
			if(!Checks.esNulo(dto.getIntencionFinanciar()))
				oferta.setIntencionFinanciar(dto.getIntencionFinanciar()? 1 : 0);
			if(!Checks.esNulo(dto.getCodigoSucursal())) {
				String codigoOficina = activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)? "2038" : 
					activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)? "3058" : "";
				if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA) || activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR))
					oferta.setSucursal((ActivoProveedor) proveedoresApi.searchProveedorCodigoUvem(codigoOficina+dto.getCodigoSucursal()));
			}
			genericDao.save(Oferta.class, oferta);
			// Actualizamos la situacion comercial del activo
			updaterState.updaterStateDisponibilidadComercialAndSave(activo);

			notificationOfertaManager.sendNotification(oferta);
		} catch (Exception ex) {
			logger.error("error en activoAdapter", ex);
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveLlave(DtoLlaves dto) {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter llaveIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, llaveIDFilter);

		if (!Checks.esNulo(llave)) {
			try {
				beanUtilNotNull.copyProperty(llave, "numLlave", dto.getNumLlave());
				beanUtilNotNull.copyProperty(llave, "codCentroLlave", dto.getCodCentroLlave());
				beanUtilNotNull.copyProperty(llave, "nomCentroLlave", dto.getNomCentroLlave());
				beanUtilNotNull.copyProperty(llave, "archivo1", dto.getArchivo1());
				beanUtilNotNull.copyProperty(llave, "archivo2", dto.getArchivo2());
				beanUtilNotNull.copyProperty(llave, "archivo3", dto.getArchivo3());
				beanUtilNotNull.copyProperty(llave, "juegoCompleto", dto.getJuegoCompleto());
				if (!Checks.esNulo(llave.getJuegoCompleto()) && llave.getJuegoCompleto() == 1)
					dto.setMotivoIncompleto("");
				beanUtilNotNull.copyProperty(llave, "motivoIncompleto", dto.getMotivoIncompleto());

			} catch (IllegalAccessException e) {
				e.printStackTrace();
				return false;
			} catch (InvocationTargetException e) {
				e.printStackTrace();
				return false;
			}
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteLlave(DtoLlaves dto) {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter llaveIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, llaveIDFilter);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		if (!Checks.esNulo(llave) && !Checks.esNulo(usuarioLogado)) {
			llave.getAuditoria().setBorrado(true);
			llave.getAuditoria().setFechaBorrar(new Date());
			llave.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
		} else {
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createLlave(DtoLlaves dto) {

		ActivoLlave llave = new ActivoLlave();

		Filter activoIdFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdActivo()));
		Activo activo = genericDao.get(Activo.class, activoIdFilter);
		if (Checks.esNulo(activo)) {
			return false;
		}

		try {
			beanUtilNotNull.copyProperty(llave, "activo", activo);
			beanUtilNotNull.copyProperty(llave, "codCentroLlave", dto.getCodCentroLlave());
			beanUtilNotNull.copyProperty(llave, "nomCentroLlave", dto.getNomCentroLlave());
			beanUtilNotNull.copyProperty(llave, "archivo1", dto.getArchivo1());
			beanUtilNotNull.copyProperty(llave, "archivo2", dto.getArchivo2());
			beanUtilNotNull.copyProperty(llave, "archivo3", dto.getArchivo3());
			beanUtilNotNull.copyProperty(llave, "juegoCompleto", dto.getJuegoCompleto());
			if (!Checks.esNulo(dto.getJuegoCompleto()) && dto.getJuegoCompleto() == 0)
				beanUtilNotNull.copyProperty(llave, "motivoIncompleto", dto.getMotivoIncompleto());
			beanUtilNotNull.copyProperty(llave, "numLlave", dto.getNumLlave());

			llave = genericDao.save(ActivoLlave.class, llave);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createMovimientoLlave(DtoMovimientoLlave dto) {

		ActivoMovimientoLlave movimiento = new ActivoMovimientoLlave();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdLlave()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, filtro);

		if (Checks.esNulo(llave)) {
			return false;
		}

		DDTipoTenedor tipoTenedor = (DDTipoTenedor) proxyFactory.proxy(UtilDiccionarioApi.class)
				.dameValorDiccionarioByCod(DDTipoTenedor.class, dto.getCodigoTipoTenedor());

		try {
			beanUtilNotNull.copyProperties(movimiento, dto);
			beanUtilNotNull.copyProperty(movimiento, "activoLlave", llave);
			beanUtilNotNull.copyProperty(movimiento, "tipoTenedor", tipoTenedor);

			genericDao.save(ActivoMovimientoLlave.class, movimiento);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveMovimientoLlave(DtoMovimientoLlave dto) {

		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoMovimientoLlave movimiento = genericDao.get(ActivoMovimientoLlave.class, filtro);

		if (!Checks.esNulo(movimiento)) {
			try {

				beanUtilNotNull.copyProperties(movimiento, dto);

				if (!Checks.esNulo(dto.getCodigoTipoTenedor())) {
					DDTipoTenedor tipoTenedor = (DDTipoTenedor) proxyFactory.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByCod(DDTipoTenedor.class, dto.getCodigoTipoTenedor());
					movimiento.setTipoTenedor(tipoTenedor);
				}

				// Datos auditoria
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				if (!Checks.esNulo(usuarioLogado)) {
					movimiento.getAuditoria().setFechaModificar(new Date());
					movimiento.getAuditoria().setUsuarioModificar(usuarioLogado.getUsername());
				} else {
					return false;
				}

			} catch (IllegalAccessException e) {
				e.printStackTrace();
				return false;
			} catch (InvocationTargetException e) {
				e.printStackTrace();
				return false;
			}
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteMovimientoLlave(DtoMovimientoLlave dto) {

		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoMovimientoLlave movimiento = genericDao.get(ActivoMovimientoLlave.class, filtro);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		// Datos auditoria
		if (!Checks.esNulo(movimiento) && !Checks.esNulo(usuarioLogado)) {
			movimiento.getAuditoria().setBorrado(true);
			movimiento.getAuditoria().setFechaBorrar(new Date());
			movimiento.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
		} else {
			return false;
		}

		return true;
	}

	/**
	 * Realiza comprobaciones y acciones a realizar por los datos modificados en
	 * la Ficha Cabecera
	 * 
	 * @param activo
	 * @param dtoFicha
	 */
	

	private String getEstadoNuevaOferta(Activo activo) {
		String codigoEstado = DDEstadoOferta.CODIGO_PENDIENTE;

		// Comprobar si el activo se encuentra en una agrupación de tipo 'lote
		// comercial'.
		// Y que tenga oferta aceptada de expediente con estasdo (aprobado,
		// reservado, en devolución)
		if (activoAgrupacionActivoDao.activoEnAgrupacionLoteComercial(activo.getId())
				|| ofertaApi.isActivoConOfertaYExpedienteBlocked(activo)) {
			codigoEstado = DDEstadoOferta.CODIGO_CONGELADA;
		}

		return codigoEstado;
	}

	public List<DtoUsuario> getComboUsuariosPorTipoGestorYCarteraDelLoteComercial(ActivoAgrupacion activoAgrupacion, Long tipoGestor) {
		// Obtener una lista de usuarios filtrados por tipo gestor.
		List<DtoUsuario> usuariosPorTipoGestorList = this.getComboUsuarios(tipoGestor);
		if(usuariosPorTipoGestorList == null) {
			return null;
		}

		// Obtener el id de cartera por la agrupación.
		Long idCartera;
		if (activoAgrupacion.getActivoPrincipal() != null && activoAgrupacion.getActivoPrincipal().getCartera() != null) {
			idCartera = activoAgrupacion.getActivoPrincipal().getCartera().getId();
		} else if (activoAgrupacion.getActivos() != null && !activoAgrupacion.getActivos().isEmpty()
				&& activoAgrupacion.getActivos().get(0).getActivo().getCartera() != null) {
			idCartera = activoAgrupacion.getActivos().get(0).getActivo().getCartera().getId();
		} else {
			// Si la agrupación no contiene activos, por lo que no pertenece a una cartera, devolver la lista de usuarios por tipo gestor sólo.
			return usuariosPorTipoGestorList;
		}

		// Contrastar el tipo de cartera de cada usuario contra la cartera de la agrupación.
		List<Long> usuarioIdList = new ArrayList<Long>();
		for(DtoUsuario usuario: usuariosPorTipoGestorList) {
			usuarioIdList.add(usuario.getId());
		}

		List<DtoUsuario> usuariosPorTipoGestorYCarteraList = new ArrayList<DtoUsuario>();

		List<ActivoProveedorContacto> activoProveedorContactoList = proveedoresApi.getActivoProveedorContactoPorIdsUsuarioYCartera(usuarioIdList, idCartera);
		for(ActivoProveedorContacto  activoProveedorContacto: activoProveedorContactoList) {
			DtoUsuario dto = new DtoUsuario();

			dto.setId(activoProveedorContacto.getUsuario().getId());
			dto.setApellidoNombre(activoProveedorContacto.getUsuario().getApellidoNombre());

			usuariosPorTipoGestorYCarteraList.add(dto);
		}

		return usuariosPorTipoGestorYCarteraList;
	}
	
	public void enviarAvisosCambioSituacionLegalActivo(Activo activo, ExpedienteComercial expediente) {
		
		Notificacion notificacion = new Notificacion();
		Usuario destinatario = null;
		
		notificacion.setIdActivo(activo.getId());	
		
		String[] numActivo = {String.valueOf(activo.getNumActivo())};
		notificacion.setDescripcion(messageServices.getMessage(AVISO_DESCRIPCION_MODIFICADAS_CONDICIONES_JURIDICAS, numActivo));
		
		notificacion.setTitulo(messageServices.getMessage(AVISO_TITULO_MODIFICADAS_CONDICIONES_JURIDICAS));	
		if(!Checks.esNulo(expediente.getTrabajo())) {
		// Buscamos el gestor responsable de Haya
			List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());						
			
			for(TareaActivo tarea: tramites.get(0).getTareas()) {
				
				if(!tarea.getAuditoria().isBorrado() && Checks.esNulo(tarea.getFechaFin())
						&& genericAdapter.isGestorHaya(tarea.getUsuario())) {
	
					if(Checks.esNulo(destinatario)) {
						destinatario = tarea.getUsuario();
					}
												
				}
			}
		}
		if (!Checks.esNulo(destinatario)) {														
			
			notificacion.setDestinatario(destinatario.getId());									
			
			try {
				
				notificacionAdapter.saveNotificacion(notificacion);
				logger.debug("ENVIO NOTIFICACION: [TITULO " + notificacion.getTitulo() + " | ACTIVO " + activo.getNumActivo() + "| DESTINATARIO " + destinatario.getUsername() + " ]");
				
			} catch (ParseException e) {
					logger.error(e.getMessage());
			}
		}
									
		// Si expediente ya ha sido aprobado avisamos al gestor de formalización
		if (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.ALQUILADO.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo())) {
			
			Usuario gestorFormalizacion = gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GFORM");
			
			if(!Checks.esNulo(gestorFormalizacion) && !gestorFormalizacion.equals(destinatario)) {
		
				notificacion.setDestinatario(gestorFormalizacion.getId());								
				
				try {
					
					notificacionAdapter.saveNotificacion(notificacion);
					logger.debug("ENVIO NOTIFICACION: [TITULO " + notificacion.getTitulo() + " | ACTIVO " + activo.getNumActivo() + "| DESTINATARIO " + gestorFormalizacion.getUsername() + " ]");
					
				} catch (ParseException e) {
						logger.error(e.getMessage());
				}
			}
		}
	}
	
}
