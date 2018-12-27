package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandler;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandlerFactory;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.formulario.ActivoGenericFormManager;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoCampo;
import es.pfsgroup.plugin.rem.model.DtoNombreTarea;
import es.pfsgroup.plugin.rem.model.DtoReasignarTarea;
import es.pfsgroup.plugin.rem.model.DtoSaltoTarea;
import es.pfsgroup.plugin.rem.model.DtoSolicitarProrrogaTarea;
import es.pfsgroup.plugin.rem.model.DtoTarea;
import es.pfsgroup.plugin.rem.model.DtoTareaFilter;
import es.pfsgroup.plugin.rem.model.DtoTareaGestorSustitutoFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoExpediente;
import es.pfsgroup.plugin.rem.service.UpdaterTransitionService;
import es.pfsgroup.plugin.rem.tareasactivo.dao.VTareasGestorSustitutoDao;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;

@Service
public class AgendaAdapter {

	private static final String CODIGO_DEFINICION_OFERTA = "T013_DefinicionOferta";
	private static final String TEXTO_ADVERTENCIA_T013_DO = "ATENCIÓN: Va a aprobar un expediente con importe inferior al precio mínimo. Confirme que tiene la autorización de su supervisor.";
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	private SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
	protected static final Log logger = LogFactory.getLog(AgendaAdapter.class);

	@Resource
	private MessageService messageServices;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private BuzonTareasViewHandlerFactory viewHandlerFactory;

	@Autowired
	private ActivoGenericFormManager actGenericFormManager;

	@Autowired
	private TareaActivoApi tareaActivoApi;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;

	@Autowired
	private TrabajoAdapter trabajoAdapter;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private PreciosApi preciosApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private UpdaterTransitionService updaterTransitionService;

	@Autowired
	private VTareasGestorSustitutoDao tareasGSDao;


	public Page getListTareas(DtoTareaFilter dtoTareaFiltro){
		DtoTarea dto = new DtoTarea();
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		List<Perfil> perfiles = usuarioLogado.getPerfiles();
		List<DDZona> zonas = usuarioLogado.getZonas();
		dto.setPerfiles(perfiles);
		dto.setZonas(zonas);
		dto.setUsuarioLogado(usuarioLogado);
		dto.setSort(dtoTareaFiltro.getSort());
		dto.setLimit(dtoTareaFiltro.getLimit());
		dto.setStart(dtoTareaFiltro.getStart());
		dto.setDir(dtoTareaFiltro.getDir());
		dto.setBusqueda(true);

		// Anotaciones buscan por el nombre de tarea, el resto buscan por la descripción
		if("Notificación".equals(dtoTareaFiltro.getDescripcionTarea())){
			dto.setNombreTarea(dtoTareaFiltro.getDescripcionTarea());
			dto.setDescripcionTarea(null);
		}else{
			if (!Checks.esNulo(dtoTareaFiltro.getNombreTarea())) {
				Filter filterNombre = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTareaFiltro.getNombreTarea());
				TareaProcedimiento tarea = genericDao.get(TareaProcedimiento.class, filterNombre);
				dto.setNombreTarea(tarea.getDescripcion());
			} else {
				dto.setNombreTarea(null);
			}
			if (!Checks.esNulo(dtoTareaFiltro.getDescripcionTarea())){
				Filter filterDescripcion = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTareaFiltro.getDescripcionTarea());
				TipoProcedimiento procedimiento = genericDao.get(TipoProcedimiento.class, filterDescripcion);
				dto.setDescripcionTarea(procedimiento.getDescripcion());
			} else {
				dto.setDescripcionTarea(null);
			}
		}

		// Adaptamos las fechas por si introducimos sólo unas de las dos.
		String fechaInicioDesde = (Checks.esNulo(dtoTareaFiltro.getFechaInicioDesde()) && !Checks.esNulo(dtoTareaFiltro.getFechaInicioHasta())) ? "01/01/2000" : dtoTareaFiltro.getFechaInicioDesde();
		String fechaInicioHasta = (Checks.esNulo(dtoTareaFiltro.getFechaInicioHasta()) && !Checks.esNulo(dtoTareaFiltro.getFechaInicioDesde())) ? "31/12/2099" : dtoTareaFiltro.getFechaInicioHasta();
		String fechaVencimientoDesde = (Checks.esNulo(dtoTareaFiltro.getFechaVencimientoDesde()) && !Checks.esNulo(dtoTareaFiltro.getFechaVencimientoHasta())) ? "01/01/2000" : dtoTareaFiltro.getFechaVencimientoDesde();
		String fechaVencimientoHasta = (Checks.esNulo(dtoTareaFiltro.getFechaVencimientoHasta()) && !Checks.esNulo(dtoTareaFiltro.getFechaVencimientoDesde())) ? "31/12/2099" : dtoTareaFiltro.getFechaVencimientoHasta();

		dto.setFechaInicioDesde(fechaInicioDesde);
		dto.setFechaInicioHasta(fechaInicioHasta);
		dto.setFechaVencimientoDesde(fechaVencimientoDesde);
		dto.setFechaVencDesdeOperador(">=");
		dto.setFechaVencimientoHasta(fechaVencimientoHasta);
		dto.setFechaVencimientoHastaOperador("<=");
		dto.setCodigoTipoTarea(dtoTareaFiltro.getCodigoTipoTarea());
		dto.setEsAlerta(dtoTareaFiltro.getEsAlerta());

		return proxyFactory.proxy(EXTTareasApi.class).buscarTareasPendientesDelegator(dto);
	}

	public String getValidacionPrevia(Long id){
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(id);
		GenericForm formulario = actGenericFormManager.get(tar.getTareaExterna().getId());

		return formulario.getErrorValidacion();
	}

	public String getIdActivoTarea(Long id){
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(id);
		TareaActivo tareaActivo = tareaActivoApi.getByIdTareaExterna(tar.getTareaExterna().getId());

		return tareaActivo.getActivo().getId().toString();
	}
	
	public String getTipoTituloActivoByIdTarea(Long id){
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(id);
		TareaActivo tareaActivo = tareaActivoApi.getByIdTareaExterna(tar.getTareaExterna().getId());

		return tareaActivo.getActivo().getTipoTitulo().getCodigo().toString();
	}

	public String getIdTrabajoTarea(Long id){
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(id);
		TareaActivo tareaActivo = tareaActivoApi.getByIdTareaExterna(tar.getTareaExterna().getId());

		return tareaActivo.getTramite().getTrabajo().getId().toString();
	}

	public String getIdExpediente(Long id){
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(id);
		TareaActivo tareaActivo = tareaActivoApi.getByIdTareaExterna(tar.getTareaExterna().getId());

		Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", tareaActivo.getTramite().getTrabajo().getId());
		ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filtroTrabajo);

		if(!Checks.esNulo(expedienteComercial)){
			return expedienteComercial.getId().toString();
		} else {
			return null;
		}
	}

	public String getNumExpediente(Long id){
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(id);
		TareaActivo tareaActivo = tareaActivoApi.getByIdTareaExterna(tar.getTareaExterna().getId());

		Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", tareaActivo.getTramite().getTrabajo().getId());
		ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filtroTrabajo);

		if(!Checks.esNulo(expedienteComercial)){
			return expedienteComercial.getNumExpediente().toString();
		} else {
			return null;
		}
	}

	public List<DtoCampo>  getFormularioTarea(Long id){
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(id);
		GenericForm formulario = actGenericFormManager.get(tar.getTareaExterna().getId());
		List<GenericFormItem> campos = formulario.getItems();

		actGenericFormManager.get(tar.getTareaExterna().getId());
		List<DtoCampo> camposDto = new ArrayList<DtoCampo>();

		for(GenericFormItem campo : campos){
			DtoCampo campoDto = new DtoCampo();

			try{
				beanUtilNotNull.copyProperty(campoDto, "xtype", campo.getType());
				beanUtilNotNull.copyProperty(campoDto, "fieldLabel", campo.getLabel());
				beanUtilNotNull.copyProperty(campoDto, "store", campo.getValuesBusinessOperation());
				beanUtilNotNull.copyProperty(campoDto, "name", campo.getNombre());
				beanUtilNotNull.copyProperty(campoDto, "values", campo.getValues());
				beanUtilNotNull.copyProperty(campoDto, "value", campo.getValue());
				beanUtilNotNull.copyProperty(campoDto, "allowBlank", (campo.getValidation() == null) ? true : campo.getValidation());
				beanUtilNotNull.copyProperty(campoDto, "blankText", campo.getValidationError());

			} catch (IllegalAccessException e) {
				logger.error("Error al obtener el formulario de la tarea", e);
			} catch (InvocationTargetException e) {
				logger.error("Error al obtener el formulario de la tarea", e);
			}

			camposDto.add(campoDto);
		}

		return camposDto;
	}

	public Object abreTarea(Long idTarea, String subtipoTarea) {
		BuzonTareasViewHandler handler = viewHandlerFactory.getHandlerForSubtipoTarea(subtipoTarea);

		return handler.getModel(idTarea);
	}

	public Boolean save(Map<String,String[]> valores) throws Exception{
		DtoGenericForm dto = new DtoGenericForm();
		Long idTarea = 0L;

		Map<String, String> camposFormulario = new HashMap<String,String>();
		for (Map.Entry<String, String[]> entry : valores.entrySet()) {
			String key = entry.getKey();
			if (!key.equals("idTarea")){
				camposFormulario.put(key, (String)entry.getValue()[0]);
			}else{
				idTarea = Long.parseLong((String)entry.getValue()[0]);
			}
		}

		dto = this.rellenaDTO(idTarea,camposFormulario);

		actGenericFormManager.saveValues(dto);

		return true;
	}

	@SuppressWarnings("rawtypes")
	private DtoGenericForm rellenaDTO(Long idTarea, Map<String,String> camposFormulario) {
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);
		GenericForm genericForm = actGenericFormManager.get(tar.getTareaExterna().getId());

		DtoGenericForm dto = new DtoGenericForm();
		dto.setForm(genericForm);
		String[] valores = new String[genericForm.getItems().size()];

		for (int i = 0; i < genericForm.getItems().size(); i++) {
			GenericFormItem gfi = genericForm.getItems().get(i);
			String nombreCampo = gfi.getNombre();
			for (Map.Entry<String, String> stringStringEntry : camposFormulario.entrySet()) {
				if (nombreCampo.equals(((Map.Entry) stringStringEntry).getKey())) {
					String valorCampo = (String) ((Map.Entry) stringStringEntry).getValue();
					if (valorCampo != null && !valorCampo.isEmpty() && nombreCampo.toUpperCase().contains("FECHA")) {
						valorCampo = valorCampo.substring(6, 10) + "-" + valorCampo.substring(3, 5) + "-" + valorCampo.substring(0, 2);
					}
					valores[i] = valorCampo;
					break;
				}
			}
		}

		dto.setValues(valores);
		return dto;
	}

	public Long tareasPendientes(){
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return tareaActivoApi.getTareasPendientes(usuarioLogado);
	}

	public Long alertasPendientes(){
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return tareaActivoApi.getAlertasPendientes(usuarioLogado);
	}

	public Long avisosPendientes(){
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return tareaActivoApi.getAvisosPendientes(usuarioLogado);
	}


	public List<DtoNombreTarea> getComboNombreTarea(Long idTipoTramite) {
		Filter filtroTipoTramite = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.id", idTipoTramite);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<TareaProcedimiento> tareasProcedimiento = genericDao.getList(TareaProcedimiento.class, filtroTipoTramite, filtroBorrado);
		List<DtoNombreTarea> listaNombreTarea = new ArrayList<DtoNombreTarea>();

		try {
			for (TareaProcedimiento tareaProcedimiento : tareasProcedimiento){
				DtoNombreTarea dtoNombreTarea = new DtoNombreTarea();
				BeanUtils.copyProperties(dtoNombreTarea, tareaProcedimiento);
				listaNombreTarea.add(dtoNombreTarea);
			}
		} catch (IllegalAccessException e) {
			logger.error("Error al obtener el combo del nombre de la tarea", e);
		} catch (InvocationTargetException e) {
			logger.error("Error al obtener el combo del nombre de la tarea", e);
		}

		return listaNombreTarea;
	}

	public String getAdvertenciaTarea(Long idTarea){
		//Advertencias para avisar al usuario desde la ventana de tareas
		//Advertencia 1: Avisa al usuario de algún trabajo existente del mismo tipo/subtipo
		String mensaje = "";
		TareaActivo tarea = tareaActivoApi.get(idTarea);
		Long idActivo = tarea.getActivo().getId();

		if(!Checks.esNulo(tarea.getTramite().getTrabajo()) && !Checks.esNulo(idActivo)){
			String codigoSubtipoTrabajo = tarea.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo();

			List<ActivoTrabajo> listaActivoTrabajo = trabajoAdapter.getListadoActivoTrabajos(idActivo, codigoSubtipoTrabajo);

			//Para advertencia en Tarea, solo deben contabilizarse trabajos del mismo tipo anteriores
			// al q está tramitando el usuario, por esto eliminamos de la lista el ActivoTrabajo de la tarea.
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", tarea.getTramite().getTrabajo().getId());

			ActivoTrabajo activoTrabajoTarea = genericDao.get(ActivoTrabajo.class, filtroActivo, filtroTrabajo);

			listaActivoTrabajo.remove(activoTrabajoTarea);

			if(!Checks.estaVacio(listaActivoTrabajo)){
				mensaje = trabajoAdapter.getAdvertenciaCrearTrabajo(null, null, listaActivoTrabajo);
			}
		}

		return mensaje;
	}

	public String getAdvertenciaTareaComercial(Long idTarea){
		//Advertencias para avisar al usuario desde la ventana de tareas
		TareaActivo tarea = tareaActivoApi.get(idTarea);

		if(!Checks.esNulo(tarea.getTramite()) &&CODIGO_DEFINICION_OFERTA.equals(tarea.getTareaExterna().getTareaProcedimiento().getCodigo()) &&
				expedienteComercialApi.importeExpedienteMenorPreciosMinimosActivos(tarea.getTramite().getId())){
			return TEXTO_ADVERTENCIA_T013_DO;
		}

		return "";
	}

	public String getCodigoTramiteTarea(Long idTarea){
		if (!Checks.esNulo(idTarea) && !Checks.esNulo(tareaActivoApi.get(idTarea))  && !Checks.esNulo(tareaActivoApi.get(idTarea).getTramite())) {
			return tareaActivoApi.get(idTarea).getTramite().getTipoTramite().getCodigo();
		}

		return null;
	}

	public String getCodigoTareaProcedimiento(Long idTarea){
		if (!Checks.esNulo(idTarea) && !Checks.esNulo(tareaActivoApi.get(idTarea))  && !Checks.esNulo(tareaActivoApi.get(idTarea).getTareaExterna())) {
			return tareaActivoApi.get(idTarea).getTareaExterna().getTareaProcedimiento().getCodigo();
		}

		return null;
	}

	public List<TipoProcedimiento> getTiposProcedimientoAgenda(){
		List<TipoProcedimiento> tiposProcedimiento = new ArrayList<TipoProcedimiento>();
		TipoProcedimiento tipoNotificacion = new TipoProcedimiento();

		tipoNotificacion.setId(0L);
		tipoNotificacion.setCodigo("NOTIFICACION");
		tipoNotificacion.setDescripcion("Notificación");
		tipoNotificacion.setDescripcionLarga("Notificación");
		tiposProcedimiento.add(tipoNotificacion);

		Filter filtroTipoTramiteVigente = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		tiposProcedimiento.addAll(genericDao.getList(TipoProcedimiento.class, filtroTipoTramiteVigente));

		return tiposProcedimiento;
	}

	public Boolean generarAutoprorroga(DtoSolicitarProrrogaTarea dtoSolicitarProrrogaTarea){
		TareaExterna tex = activoTareaExternaApi.get(dtoSolicitarProrrogaTarea.getIdTareaExterna());
		TareaActivo tac = (TareaActivo) tex.getTareaPadre();

		// Creamos y rellenamos DtoSolicitarProrroga:
		DtoSolicitarProrroga dto = new DtoSolicitarProrroga();

		dto.setCodigoCausa("10"); //Otras causas
		dto.setCodigoRespuesta("10"); //Otras causas

		try {
			dto.setFechaPropuesta(ft.parse(dtoSolicitarProrrogaTarea.getNuevaFechaProrroga()));
		} catch (ParseException e) {
			logger.error("Error al convertir la nueva fecha de prorroga al generar autoprorroga", e);
		}
		dto.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_ACTIVO);
		dto.setIdEntidadInformacion(tac.getActivo().getId());
		dto.setDescripcionCausa(dtoSolicitarProrrogaTarea.getMotivoAutoprorroga());
		dto.setSolicitud(true);
		dto.setIdTareaAsociada(tex.getId());

		try {
			tareaActivoApi.generarAutoprorroga(dto);
		}catch(BusinessOperationException ex){
			logger.error("Error al generar autoprorroga", ex);
			return false;
		}

		return true;
	}

	public Boolean saltoTareaByCodigo(Long idTareaExterna, String codigoTarea){
		try{
			tareaActivoApi.saltoDesdeTareaExterna(idTareaExterna, codigoTarea);
		}catch(Exception e){
			logger.error("Error al realizar un salto en la tarea por codigo", e);
			return false;
		}

		return true;
	}

	public Boolean saltoCierreEconomico(Long idTareaExterna){
		try{
			tareaActivoApi.saltoCierreEconomico(idTareaExterna);
		}catch(Exception ex){
			return false;
		}

		return true;
	}

	public Boolean saltoResolucionExpediente(Long idTareaExterna){
		try{
			tareaActivoApi.saltoResolucionExpediente(idTareaExterna);
		}catch(Exception ex){
			return false;
		}

		return true;
	}

	public Boolean saltoRespuestaBankiaAnulacionDevolucion(Long idTareaExterna){
		try{
			tareaActivoApi.saltoRespuestaBankiaAnulacionDevolucion(idTareaExterna);
		}catch(Exception ex){
			return false;
		}

		return true;
	}

	public Boolean saltoPendienteDevolucion(Long idTareaExterna){
		try{
			tareaActivoApi.saltoPendienteDevolucion(idTareaExterna);
		}catch(Exception ex){
			return false;
		}

		return true;
	}

	public void saltoInstruccionesReserva(Long idProcesBpm){
		tareaActivoApi.saltoInstruccionesReserva(idProcesBpm);

	}

	@Transactional
	public Boolean reasignarTarea(DtoReasignarTarea dto){
		TareaActivo tareaActivo = tareaActivoApi.get(dto.getIdTarea());

		if(!Checks.esNulo(dto.getUsuarioGestor()) || !Checks.esNulo(dto.getUsuarioSupervisor())){
			if(!Checks.esNulo(dto.getUsuarioGestor())){
				Filter filtroGestor = genericDao.createFilter(FilterType.EQUALS, "id", dto.getUsuarioGestor());
				Usuario usuarioGestor = genericDao.get(Usuario.class, filtroGestor);
				tareaActivo.setUsuario(usuarioGestor);
			}

			if(!Checks.esNulo(dto.getUsuarioSupervisor())){
				Filter filtroSupervisor = genericDao.createFilter(FilterType.EQUALS, "id", dto.getUsuarioSupervisor());
				Usuario usuarioSupervisor = genericDao.get(Usuario.class, filtroSupervisor);
				tareaActivo.setSupervisorActivo(usuarioSupervisor);
			}
			genericDao.update(TareaActivo.class, tareaActivo);

			return true;
		}

		return false;
	}

	@Transactional
	public Boolean anularTramite(Long idTramite) {
		if (idTramite != null) {
			ActivoTramite tramite = activoTramiteApi.get(idTramite);
			finalizarTramiteYTareas(tramite);

			DDEstadoTrabajo anulado = genericDao.get(DDEstadoTrabajo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_ANULADO));
			if ((anulado != null) && (tramite != null)  && (tramite.getTrabajo() != null)) {
				Trabajo trabajo = tramite.getTrabajo();
				trabajo.setEstado(anulado);
				genericDao.save(Trabajo.class, trabajo);
			}

			if ((tramite != null)  && (tramite.getTipoTramite() != null)) {
				String codigoTipotramite = tramite.getTipoTramite().getCodigo();
				if (ActivoTramiteApi.CODIGO_TRAMITE_PROPUESTA_PRECIOS.equals(codigoTipotramite)) {
					anularPropuestaPrecios(tramite);
				}
			}

			return true;
		}

		return false;
	}
	@Transactional
	public Boolean anularTramiteAlquiler(Long idTramite, String motivo) {
		
		if (idTramite != null) {
			ActivoTramite tramite = activoTramiteApi.get(idTramite);
			finalizarTramiteYTareas(tramite);

			DDEstadoTrabajo anulado = genericDao.get(DDEstadoTrabajo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_ANULADO));
			DDEstadosExpedienteComercial anuladoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO));
			DDMotivoRechazoExpediente motivoRechazoAlquiler = genericDao.get(DDMotivoRechazoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", motivo));
			if ((anulado != null) && (tramite != null)  && (tramite.getTrabajo() != null)) {
				Trabajo trabajo = tramite.getTrabajo();
				trabajo.setEstado(anulado);
				genericDao.save(Trabajo.class, trabajo);
				ExpedienteComercial eco = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId()));
				if(! Checks.esNulo(eco)) {
					eco.setEstado(anuladoExpedienteComercial);
					Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();					
					eco.setPeticionarioAnulacion(usuarioLogado.getUsername());
					eco.setFechaAnulacion(new Date());
					//eco.setMo
					eco.setMotivoRechazo(motivoRechazoAlquiler);
					genericDao.update(ExpedienteComercial.class, eco);
				}
			}

			return true;
		}

		return false;
	}
	
	private void finalizarTramiteYTareas(ActivoTramite tramite) {
		if (tramite != null) {
			List<TareaExterna> tareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
			if (!Checks.estaVacio(tareas)) {
				for (TareaExterna t : tareas) {
					if (t != null) {
						tareaActivoApi.saltoFin(t.getId());
					}
				}
			}

			DDEstadoProcedimiento cerrado = genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO));
			if ((cerrado != null)) {
				tramite.setEstadoTramite(cerrado);
				activoTramiteApi.saveOrUpdateActivoTramite(tramite);
			}
		}
	}

	private void anularPropuestaPrecios(ActivoTramite tramite) {
		DDEstadoPropuestaPrecio anulada = genericDao.get(DDEstadoPropuestaPrecio.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPropuestaPrecio.ESTADO_ANULADA));
		if (anulada != null) {
			PropuestaPrecio propuesta = preciosApi.getPropuestaByTrabajo(tramite.getTrabajo().getId());
			if (propuesta != null) {
				propuesta.setEstado(anulada);
				genericDao.save(PropuestaPrecio.class, propuesta);
			}
		}
	}

	@Transactional
	public boolean lanzarTareaAdministrativa(DtoSaltoTarea dto) throws Exception {
		//Validacion de documentos de reserva si salta con reserva a ResultadoPBC o Posicionamiento y firma
		updaterTransitionService.validarContratoYJustificanteReserva(dto);

		List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(dto.getIdTramite());
		for (int i = 0; i < listaTareas.size(); i++) {
			if(listaTareas.size()>1) {
				for (int j = 1; j < listaTareas.size(); j++) {
					TareaExterna tareaExterna = listaTareas.get(j);
					proxyFactory.proxy(TareaExternaApi.class).borrar(tareaExterna);
				}
			}

			TareaExterna tarea = listaTareas.get(i);
			if (!Checks.esNulo(tarea)) {
				tareaActivoApi.saltoDesdeTareaExterna(tarea.getId(),dto.getCodigoTareaDestino());
				break;
			}
		}

		// Guardamos campos en expediente, oferta, y reserva, y actualizamos estado de expediente
		// TODO Pendientes de definir muchos campos.
		updaterTransitionService.updateFrom(dto);

		return true;
	}

	public Page getListTareasGS(DtoTareaGestorSustitutoFilter dto){
		return tareasGSDao.getListTareasGS(dto);
	}
}
