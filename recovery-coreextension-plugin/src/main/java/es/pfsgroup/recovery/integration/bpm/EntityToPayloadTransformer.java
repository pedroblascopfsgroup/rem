package es.pfsgroup.recovery.integration.bpm;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.integration.core.MessageHeaders;
import org.springframework.integration.message.MessageBuilder;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.acuerdo.AcuerdoManager;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.persona.EXTPersonaManager;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.manager.EXTSubastaManager;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.MEJRecursoManager;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.TypePayload;
import es.pfsgroup.recovery.integration.bpm.payload.ActuacionesAExplorarPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ActuacionesRealizadasPayload;
import es.pfsgroup.recovery.integration.bpm.payload.AcuerdoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.DecisionProcedimientoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.FinAsuntoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoDerivadoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.RecursoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.SubastaPayload;
import es.pfsgroup.recovery.integration.bpm.payload.TareaExternaPayload;
import es.pfsgroup.recovery.integration.bpm.payload.TareaNotificacionPayload;
import es.pfsgroup.recovery.integration.bpm.payload.TerminoAcuerdoPayload;

public class EntityToPayloadTransformer {

    private final Log logger = LogFactory.getLog(getClass());

    private static Map<String, String> mapaPersonas = new HashMap<String, String>();
    
	@Autowired
	protected EXTProcedimientoManager extProcedimientoManager;

	@Autowired
	private EXTTareaNotificacionManager extTareaNotificacionManager;

	@Autowired
	private AcuerdoManager acuerdoManager;
	
	@Autowired
	private MEJAcuerdoManager mejAcuerdoManager;

	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
	@Autowired
	private MEJRecursoManager mejRecursoManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private VTARBusquedaOptimizadaTareasDao busquedaTareasOptimizadaDao;
	
	@Autowired
	private EXTSubastaManager extSubastaManager;
	
	@Autowired
	private MEJDecisionProcedimientoManager mejDecisionProcedimientoManager;
	
	@Autowired
	private ProcedimientoManager procedimientoManager;
	
	@Autowired
	private EXTPersonaManager extPersonaManager;	
	
	private final DiccionarioDeCodigos diccionarioCodigos;
	
	private TransformerHelper helper;
	
	public TransformerHelper getHelper() {
		return helper;
	}

	public void setHelper(TransformerHelper helper) {
		this.helper = helper;
	}

	public EntityToPayloadTransformer(DiccionarioDeCodigos diccionarioCodigos) {
		this.diccionarioCodigos = diccionarioCodigos;
	}

	/**
	 * Procesa la información recopilada a través del helper
	 * @param dataPayload
	 */
	private void postProcessDataContainer(DataContainerPayload dataPayload) {
		if (helper!=null) {
			helper.ampliar(dataPayload);
		}
	}
	
	protected TareaExterna setup4sync(TareaExterna tareaExterna) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", tareaExterna.getId());
		tareaExterna = genericDao.get(TareaExterna.class, filter);
		setup4sync(tareaExterna.getTareaPadre()); 
		return tareaExterna;
	}
	
	protected EXTTareaNotificacion setup4sync(TareaNotificacion tareaNotif) {
		logger.debug(String.format("[INTEGRACION] Comprobando GUID para tareaNotificacion %d", tareaNotif.getId()));
		EXTTareaNotificacion extTareaNotif = extTareaNotificacionManager.prepareGuid(tareaNotif);
		if (extTareaNotif == null) {
			throw new IntegrationDataException(String.format("La tarea %d es de tipo EXTTAreaNotificación,  no tiene GUID", tareaNotif.getId()));
		}
		return extTareaNotif;
	}

	protected Message<DataContainerPayload> createMessage(Message<?> originalMsg, 
			DataContainerPayload payload,
			String group) {
		// Construye el nuevo mensaje
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HHmmss-SSSSSS");
		//String id = String.format("%s.%s.%s", sdf.format(new java.util.Date()), payload.getTipo(), group);
		String id = String.format("%s.%s", sdf.format(new java.util.Date()), payload.getTipo());
		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(payload)
				.copyHeaders(originalMsg.getHeaders())
				.setHeader(MessageHeaders.ID, id)
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, group)
				.build();
		return newMessage;
	}
	
	protected DataContainerPayload getNewPayload(Message<?> message) {
		if (!message.getHeaders().containsKey(TypePayload.HEADER_MSG_TYPE)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El mensaje no tiene asignado tipo de mensaje en la cabecera, por favor asigne el valor %s a la cabecera.", TypePayload.HEADER_MSG_TYPE));
		}
		String tipoMensaje = (String)message.getHeaders().get(TypePayload.HEADER_MSG_TYPE);
		String entidad = (String)message.getHeaders().get(TypePayload.HEADER_MSG_ENTIDAD);
		DataContainerPayload payload = new DataContainerPayload(tipoMensaje, entidad);
		if (message.getHeaders().containsKey(ProcedimientoPayload.JBPM_TRANSICION)) {
			payload.addExtraInfo(ProcedimientoPayload.JBPM_TRANSICION, (String)message.getHeaders().get(ProcedimientoPayload.JBPM_TRANSICION));
		}
		if (message.getHeaders().containsKey(ProcedimientoPayload.JBPM_TAR_GUID_ORIGEN)) {
			payload.addExtraInfo(ProcedimientoPayload.JBPM_TAR_GUID_ORIGEN, (String)message.getHeaders().get(ProcedimientoPayload.JBPM_TAR_GUID_ORIGEN));
		}
		return payload;
	}
	
	private void addValorDD(TareaExternaPayload tareaPayload, List<GenericFormItem> items, TareaExternaValor tareaExternaValor) {
		String key = tareaExternaValor.getNombre();
		String valorStr = tareaExternaValor.getValor();
		GenericFormItem itemEncontado = null;
		for (GenericFormItem item : items) {
			if (item.getNombre().equals(tareaExternaValor.getNombre())) {
				itemEncontado = item;
				break;
			}
		}
		if (itemEncontado != null) {
			String bo = itemEncontado.getValuesBusinessOperation();
			valorStr = diccionarioCodigos.getCodigoDDFinal(bo, valorStr);
		}
		tareaPayload.setValorCampoFormulario(key, valorStr);
	}
	
	protected void loadTareaFormItems(TareaExternaPayload tareaPayload, TareaExterna tareaExterna) {
		String transicion = tareaPayload.getProcedimiento().getTransicionBPM();
		if (!Checks.esNulo(transicion) && transicion.equals(BPMContants.TRANSICION_AVANZA_BPM)) {
		
			// Listado de tareas
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tareaExterna.getTareaProcedimiento().getId()); 
			List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtro);
			
			// Cargamos los Valores de la tarea.
			for (TareaExternaValor valor : tareaExterna.getValores()) {
				addValorDD(tareaPayload, items, valor);
			}
		}
	}

	public Message<DataContainerPayload> transformTAR(Message<TareaNotificacion> message) {
		logger.info("[INTEGRACION] Transformando TareaNotificación...");
		TareaNotificacion tar = message.getPayload();

		// Persistencia de IDs de sincronización
		setup4sync(tar);
		
		// Carga los valores
		DataContainerPayload data = getNewPayload(message);
		TareaNotificacionPayload tareaPayload = new TareaNotificacionPayload(data, tar);
		postProcessDataContainer(data);

		logger.debug(String.format("[INTEGRACION] TareaNotificación Transformado %s!", tareaPayload.getGuid()));
		
		//translateValues(message);
		String grpId = tareaPayload.getAsunto().getGuid();
		Message<DataContainerPayload> newMessage = createMessage(message,  data, grpId);
/*		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, tareaPayload.getAsunto().getGuid())
				.build();*/
		return newMessage;
	}	
	
	public Message<DataContainerPayload> transformTEX(Message<TareaExterna> message) {
		logger.info("[INTEGRACION] Transformando TareaExterna...");
		TareaExterna tex = message.getPayload();

		// Persistencia de IDs de sincronización
		setup4sync(tex);
		//MEJProcedimiento procedimientoFinal = MEJProcedimiento.instanceOf(tex.getTareaPadre().getProcedimiento());
		extProcedimientoManager.prepareGuid(tex.getTareaPadre().getProcedimiento());

		// Carga los valores
		DataContainerPayload data = getNewPayload(message);
		TareaExternaPayload tareaPayload = new TareaExternaPayload(data, tex);

		// POne el usuario al que se le asigna la tarea cuando estÃ¡ pendiente (tarea nueva)
		if (data.getTipo().equals(IntegracionBpmService.TIPO_INICIO_TAREA)) {
			Usuario responsable = busquedaTareasOptimizadaDao.obtenerResponsableTarea(tex.getTareaPadre().getId());
			if (responsable!=null) {
				Auditoria auditoria = Auditoria.getNewInstance();
				auditoria.setUsuarioCrear(responsable.getUsername());
			}
		}
		
		loadTareaFormItems(tareaPayload, tex);
		tareaPayload.translate(diccionarioCodigos);
		postProcessDataContainer(data);
		
		logger.debug(String.format("[INTEGRACION] TareaExterna Transformado %s!", tareaPayload.getGuidTARTarea()));
		
		//translateValues(message);
		String grpId = tareaPayload.getProcedimiento().getAsunto().getGuid();
		Message<DataContainerPayload> newMessage = createMessage(message,  data, grpId);
/*		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, tareaPayload.getProcedimiento().getAsunto().getGuid())
				.build();*/
		return newMessage;
	}	

	public Message<DataContainerPayload> transformFINASU(Message<MEJFinalizarAsuntoDto> message) {
		logger.info("[INTEGRACION] Finalizando asunto...");
		MEJFinalizarAsuntoDto dto = message.getPayload();

		// Persistencia de IDs de sincronización
		Long idAsunto = dto.getIdAsunto();
		Asunto asu = extAsuntoManager.get(idAsunto);
		 
		// Carga los valores
		DataContainerPayload data = getNewPayload(message);
		FinAsuntoPayload finAsuPayload = new FinAsuntoPayload(data, asu, dto);

		postProcessDataContainer(data);
		
		logger.debug(String.format("[INTEGRACION] Finalizando asunto %s!", finAsuPayload.getAsunto().getGuid()));
		
		//translateValues(message);
		String grpId = finAsuPayload.getAsunto().getGuid();
		Message<DataContainerPayload> newMessage = createMessage(message,  data, grpId);

		return newMessage;
	}	
	
	private ProcedimientoPayload prepararProcedimiento(Message<?> mensaje, Procedimiento procedimiento) {
		// Persistencia de IDs de sincronización
		extProcedimientoManager.prepareGuid(procedimiento);
		DataContainerPayload data = getNewPayload(mensaje);
		ProcedimientoPayload procPayload = new ProcedimientoPayload(data, procedimiento);
		procPayload.translate(diccionarioCodigos);
		postProcessDataContainer(data);
		return procPayload;
	}
	
	public Message<DataContainerPayload> transformPRC(Message<Procedimiento> message) {
		logger.info("[INTEGRACION] Transformando Procedimiento...");
		Procedimiento procedimiento = message.getPayload();

		ProcedimientoPayload procPayload = prepararProcedimiento(message, procedimiento);
		DataContainerPayload data = procPayload.getData();
		logger.debug(String.format("[INTEGRACION] Procedimiento Transformado %s!", procPayload.getGuid()));
		
		//translateValues(message);
		String grpId = procPayload.getAsunto().getGuid();
		Message<DataContainerPayload> newMessage = createMessage(message,  data, grpId);
		return newMessage;
	}	

	
	public Message<DataContainerPayload> transformRecurso(Message<MEJRecurso> message) {
		logger.info("[INTEGRACION] Transformando Recurso...");
		MEJRecurso recurso = message.getPayload();

		// Persistencia de IDs de sincronización
		extProcedimientoManager.prepareGuid(recurso.getProcedimiento());
		
		// Prepara para el envío el recurso (Si no lo está ya...)
		mejRecursoManager.prepareGuid(recurso);
		
		// Carga los valores
		DataContainerPayload data = getNewPayload(message);
		RecursoPayload recursoPayload = new RecursoPayload(data, recurso);
		
		// Información de usuario registrado:
		if (SecurityUtils.getCurrentUser() != null) {
			Asunto asunto = recurso.getProcedimiento().getAsunto();
			boolean esGestor = proxyFactory.proxy(AsuntoApi.class).esGestor(asunto.getId()); 
			boolean esSupervisor = proxyFactory.proxy(AsuntoApi.class).esSupervisor(asunto.getId()); 
			recursoPayload.setEsGestor(esGestor);
			recursoPayload.setEsSupervisor(esSupervisor);
		}
		
		recursoPayload.getProcedimiento().translate(diccionarioCodigos);
		
		logger.debug(String.format("[INTEGRACION] Recurso Transformado %s!", recursoPayload.getGuid()));
		
		//translateValues(message);
		String grpId = recursoPayload.getProcedimiento().getAsunto().getGuid();
		Message<DataContainerPayload> newMessage = createMessage(message,  data, grpId);
/*		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, recursoPayload.getProcedimiento().getAsunto().getGuid())
				.build();*/

		return newMessage;
	}
	
	public Message<DataContainerPayload> transformSUB(Message<Subasta> message) {
		logger.info("[INTEGRACION] Transformando Subasta...");
		Subasta subasta = message.getPayload();
		extSubastaManager.prepareGuid(subasta);
		
		DataContainerPayload data = getNewPayload(message);
		SubastaPayload subastaPayload = new SubastaPayload(data, subasta);
		postProcessDataContainer(data);

		logger.debug(String.format("[INTEGRACION] Subasta Transformada %s!", subastaPayload.getGuid()));
		
		String grpId = subastaPayload.getProcedimiento().getAsunto().getGuid();
		Message<DataContainerPayload> newMessage = createMessage(message,  data, grpId);
/*		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, subastaPayload.getProcedimiento().getAsunto().getGuid())
				.build();
*/		
		return newMessage;
	}
	
	public Message<DataContainerPayload> transformACU(Message<Acuerdo> message) {
		logger.info("[INTEGRACION] Transformando Acuerdo...");
		Acuerdo acuerdo = message.getPayload();
		//mejAcuerdoManager.prepareGuid(acuerdo);
		
		List<TerminoAcuerdo> listadoTerminos = mejAcuerdoManager.getTerminosAcuerdo(acuerdo.getId());
		for (TerminoAcuerdo terminoAcuerdo : listadoTerminos) {
			//mejAcuerdoManager.prepareGuid(terminoAcuerdo);
		}
			
		DataContainerPayload data = getNewPayload(message);
		AcuerdoPayload acuerdoPayload = new AcuerdoPayload(data, acuerdo);
		postProcessDataContainer(data);
		
		// Información de usuario registrado:
		if (SecurityUtils.getCurrentUser() != null) {
			Asunto asunto = acuerdo.getAsunto();
			boolean esGestor = proxyFactory.proxy(AsuntoApi.class).esGestor(asunto.getId()); 
			boolean esSupervisor = proxyFactory.proxy(AsuntoApi.class).esSupervisor(asunto.getId()); 
			acuerdoPayload.setEsGestor(esGestor);
			acuerdoPayload.setEsSupervisor(esSupervisor);
		}
		logger.debug(String.format("[INTEGRACION] Acuerdo Transformado %s!", acuerdoPayload.getGuid()));

		Message<DataContainerPayload> newMessage = createMessage(message,  data, acuerdoPayload.getAsunto().getGuid());
/*		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, acuerdoPayload.getAsunto().getGuid())
				.build();
	*/	
		
		return newMessage;
	}

	public Message<DataContainerPayload> transformActuacionesRealizadas(Message<ActuacionesRealizadasAcuerdo> message) {
		logger.info("[INTEGRACION] Transformando ActuacionesRealizadasAcuerdo...");
		ActuacionesRealizadasAcuerdo actRealizada = message.getPayload();
		acuerdoManager.prepareGuid(actRealizada);
		
		DataContainerPayload data = getNewPayload(message);
		ActuacionesRealizadasPayload acuerdoPayload = new ActuacionesRealizadasPayload(data, actRealizada);
		postProcessDataContainer(data);

		logger.debug(String.format("[INTEGRACION] ActuacionesRealizadasAcuerdo Transformado %s!", acuerdoPayload.getGuid()));

		Message<DataContainerPayload> newMessage = createMessage(message,  data, acuerdoPayload.getAcuerdo().getAsunto().getGuid());
/*		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, acuerdoPayload.getAcuerdo().getAsunto().getGuid())
				.build();
	*/	
		return newMessage;
	}
	
	public Message<DataContainerPayload> transformActuacionesAExplorar(Message<ActuacionesAExplorarAcuerdo> message) {
		logger.info("[INTEGRACION] Transformando ActuacionesAExplorarAcuerdo...");
		ActuacionesAExplorarAcuerdo actAExplorar = message.getPayload();
		acuerdoManager.prepareGuid(actAExplorar);
		
		DataContainerPayload data = getNewPayload(message);
		ActuacionesAExplorarPayload acuerdoPayload = new ActuacionesAExplorarPayload(data, actAExplorar);
		postProcessDataContainer(data);

		logger.debug(String.format("[INTEGRACION] ActuacionesAExplorarAcuerdo Transformado %s!", acuerdoPayload.getGuid()));

		Message<DataContainerPayload> newMessage = createMessage(message,  data, acuerdoPayload.getAcuerdo().getAsunto().getGuid());
/*		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, acuerdoPayload.getAcuerdo().getAsunto().getGuid())
				.build();
	*/	
		return newMessage;
	}
	
	public Message<DataContainerPayload> transformAcuerdoTermino(Message<TerminoAcuerdo> message) {
		logger.info("[INTEGRACION] Transformando Término Acuerdo...");
		TerminoAcuerdo termino = message.getPayload();
		//mejAcuerdoManager.prepareGuid(termino);
		
		DataContainerPayload data = getNewPayload(message);
		TerminoAcuerdoPayload payload = new TerminoAcuerdoPayload(data, termino);

		Long idTermino = termino.getId();
		List<TerminoContrato> listadoTerminoContratos = mejAcuerdoManager.getTerminoAcuerdoContratos(idTermino);
		List<TerminoBien> listadoTerminoBienes = mejAcuerdoManager.getTerminoAcuerdoBienes(idTermino);
		
		payload
			.buildTerminoContrato(listadoTerminoContratos)
			.buildTerminoBien(listadoTerminoBienes);
		postProcessDataContainer(data);

		logger.debug(String.format("[INTEGRACION] TerminoAcuerdo Transformado %s!", payload.getGuid()));

		Message<DataContainerPayload> newMessage = createMessage(message,  data, payload.getAcuerdo().getAsunto().getGuid());
		/*Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, payload.getAcuerdo().getAsunto().getGuid())
				.build();*/
		
		return newMessage;
	}
	
	public Message<DataContainerPayload> transformDecisionProcedimiento(Message<MEJDtoDecisionProcedimiento> message) {
		logger.info("[INTEGRACION] Transformando DecisionProcedimiento...");
		MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = message.getPayload();
		mejDecisionProcedimientoManager.prepareGuid(dtoDecisionProcedimiento);
		
		DataContainerPayload data = getNewPayload(message);
		
		Procedimiento procedimiento = procedimientoManager.getProcedimiento(dtoDecisionProcedimiento.getIdProcedimiento());
		DecisionProcedimientoPayload payload = new DecisionProcedimientoPayload(data, procedimiento);
		payload.build(dtoDecisionProcedimiento);
		
		if(payload.getProcedimientoDerivado() != null) {
			for(ProcedimientoDerivadoPayload procedimientoDerivadoPayload : payload.getProcedimientoDerivado()) {
				
				if(procedimientoDerivadoPayload.getGuidProcedimientoHijo() != null) {
					
					procedimiento = procedimientoManager.getProcedimiento(Long.valueOf(procedimientoDerivadoPayload.getGuidProcedimientoHijo()));
					MEJProcedimiento mejProcedimiento = extProcedimientoManager.getInstanceOf(procedimiento);
					procedimientoDerivadoPayload.setGuidProcedimientoHijo(mejProcedimiento.getGuid());
				}				
				
				if(procedimientoDerivadoPayload.getPersonas() != null) {
					List<String> lPersonas = new ArrayList<String>(procedimientoDerivadoPayload.getPersonas());
					List<String> lCodigos = new ArrayList<String>();
					
					for(String idPersona : lPersonas) {
						
						if(mapaPersonas.get(idPersona) != null) {
							lCodigos.add(mapaPersonas.get(idPersona));
						}
						else {
							Persona persona = extPersonaManager.get(Long.valueOf(idPersona));
							lCodigos.add(persona.getCodClienteEntidad().toString());
							mapaPersonas.put(idPersona, persona.getCodClienteEntidad().toString());
						}
					}
					
					procedimientoDerivadoPayload.getPersonas().clear();
					procedimientoDerivadoPayload.getPersonas().addAll(lCodigos);
				}
			}
		}
		
		postProcessDataContainer(data);

		logger.debug(String.format("[INTEGRACION] DecisionProcedimiento Transformado %s!", payload.getGuid()));

		Message<DataContainerPayload> newMessage = createMessage(message,  data, payload.getProcedimiento().getAsunto().getGuid());
		
		return newMessage;
	}	
}
