package es.pfsgroup.recovery.integration.bpm;

import java.util.List;
import java.util.UUID;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageBuilder;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.manager.EXTSubastaManager;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.MEJRecursoManager;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.TypePayload;

public class EntityToPayloadTransformer {

    private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;

	@Autowired
	private EXTTareaNotificacionManager extTareaNotificacionManager;
	
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
	private EXTSubastaManager extSubastaManager;
	
	private final DiccionarioDeCodigos diccionarioCodigos;
	
	public EntityToPayloadTransformer(DiccionarioDeCodigos diccionarioCodigos) {
		this.diccionarioCodigos = diccionarioCodigos;
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

	private DataContainerPayload getNewPayload(Message<?> message) {
		if (!message.getHeaders().containsKey(TypePayload.HEADER_MSG_TYPE)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El mensaje no tiene asignado tipo de mensaje en la cabecera, por favor asigne el valor %s a la cabecera.", TypePayload.HEADER_MSG_TYPE));
		}
		String tipoMensaje = (String)message.getHeaders().get(TypePayload.HEADER_MSG_TYPE);

		DataContainerPayload payload = new DataContainerPayload(tipoMensaje);
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
	
	public Message<DataContainerPayload> transformTEX(Message<TareaExterna> message) {
		TareaExterna tex = message.getPayload();

		// Persistencia de IDs de sincronización
		setup4sync(tex);
		//MEJProcedimiento procedimientoFinal = MEJProcedimiento.instanceOf(tex.getTareaPadre().getProcedimiento());
		extProcedimientoManager.prepareGuid(tex.getTareaPadre().getProcedimiento());
		
		// Carga los valores
		DataContainerPayload data = getNewPayload(message);
		TareaExternaPayload tareaPayload = new TareaExternaPayload(data, tex);
 
		loadTareaFormItems(tareaPayload, tex);
		tareaPayload.translate(diccionarioCodigos);
		
		//translateValues(message);
		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, tareaPayload.getProcedimiento().getAsunto().getGuid())
				.build();
		return newMessage;
	}	

	
	public Message<DataContainerPayload> transformPRC(Message<Procedimiento> message) {
		Procedimiento procedimiento = message.getPayload();

		// Persistencia de IDs de sincronización
		extProcedimientoManager.prepareGuid(procedimiento);
		
		DataContainerPayload data = getNewPayload(message);
		ProcedimientoPayload procPayload = new ProcedimientoPayload(data, procedimiento);
		procPayload.translate(diccionarioCodigos);
		
		//translateValues(message);
		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, procPayload.getAsunto().getGuid())
				.build();
		return newMessage;
	}	

	
	public Message<DataContainerPayload> transformRecurso(Message<MEJRecurso> message) {
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
		
		//translateValues(message);
		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, recursoPayload.getProcedimiento().getAsunto().getGuid())
				.build();
		return newMessage;
	}
	
	/*		
	
	private RecursoPayload loadFromRecurso(Message<MEJRecurso> message) {
		String msgType = (String)message.getHeaders().get(TypePayload.HEADER_MSG_TYPE);
		MEJRecurso recurso = message.getPayload();

		MEJProcedimiento mejPrc = (MEJProcedimiento)recurso.getProcedimiento(); 

		
		AsuntoPayload payload = new AsuntoPayload(msgType, extAsunto);
		payload.build(mejPrc, null);


		
		
		
		
		
		
		payload.addSourceId("rec", recurso.getId());
		payload.addGuid("rec", recurso.getGuid());
		
		// Información de usuario registrado:
		if (SecurityUtils.getCurrentUser() != null) {
			boolean esGestor = proxyFactory.proxy(AsuntoApi.class).esGestor(mejPrc.getAsunto().getId()); 
			boolean esSupervisor = proxyFactory.proxy(AsuntoApi.class).esSupervisor(mejPrc.getAsunto().getId()); 
			payload.addFlag("esGestor", esGestor);
			payload.addFlag("esSupervisor", esSupervisor);
		}
		
		if (recurso.getActor()!=null) {
			payload.addCodigo("actor", recurso.getActor().getCodigo());
		}
		if (recurso.getTipoRecurso()!=null) {
			payload.addCodigo("tipoRecurso", recurso.getTipoRecurso().getCodigo());
		}
		if (recurso.getCausaRecurso()!=null) {
			payload.addCodigo("causaRecurso", recurso.getCausaRecurso().getCodigo());
		}
		if (recurso.getResultadoResolucion()!=null) {
			payload.addCodigo("resultadoResolucion", recurso.getResultadoResolucion().getCodigo());
		}
		if (recurso.getTareaNotificacion()!=null) {
			EXTTareaNotificacion tarNotif = (EXTTareaNotificacion)recurso.getTareaNotificacion();
			payload.addGuid(AsuntoPayload.KEY_TAR_TAREA, tarNotif.getGuid());
		}

		payload.addFecha("fechaRecurso", recurso.getFechaRecurso());
		payload.addFecha("fechaImpugnacion", recurso.getFechaImpugnacion());
		payload.addFecha("fechaVista", recurso.getFechaVista());
		payload.addFecha("fechaResolucion", recurso.getFechaResolucion());
		payload.addExtraInfo("observaciones", recurso.getObservaciones());
		
		payload.addFlag("confirmarImpugnacion", recurso.getConfirmarImpugnacion());
		payload.addFlag("confirmarVista", recurso.getConfirmarVista());
		payload.addFlag("suspensivo", recurso.getSuspensivo());

		return payload;
	}
*/			
	
	
/*	
	public Message<AsuntoPayload> transformACU(Message<EXTAcuerdo> message) {
		EXTAcuerdo acuerdo = message.getPayload();
		EXTAsunto asunto = setup4sync(acuerdo.getAsunto());

		AsuntoPayload newPayload = getNewPayload(message, asunto);
		EXTAcuerdo extAcuerdo = mejAcuerdoManager.prepareGuid(acuerdo);
		
		Message<AsuntoPayload> newMessage = MessageBuilder
				.withPayload(newPayload)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, asunto.getGuid())
				.build();
		
		newPayload.addGuid("acu", extAcuerdo.getGuid());
		newPayload.addSourceId("acu", extAcuerdo.getId());
		
		if (extAcuerdo.getTipoAcuerdo()!=null) {
			newPayload.addCodigo("tipoAcuerdo", extAcuerdo.getTipoAcuerdo().getCodigo());
		}
		if (extAcuerdo.getSolicitante()!=null) {
		newPayload.addCodigo("solicitante", extAcuerdo.getSolicitante().getCodigo());
		}
		if (extAcuerdo.getEstadoAcuerdo()!=null) {
		newPayload.addCodigo("estadoAcuerdo", extAcuerdo.getEstadoAcuerdo().getCodigo());
		}
		if (extAcuerdo.getTipoPagoAcuerdo()!=null) {
		newPayload.addCodigo("tipoPagoAcuerdo", extAcuerdo.getTipoPagoAcuerdo().getCodigo());
		}
		if (extAcuerdo.getPeriodicidadAcuerdo()!=null) {
			newPayload.addCodigo("periodicidadAcuerdo", extAcuerdo.getPeriodicidadAcuerdo().getCodigo());
		}
		if (extAcuerdo.getSubTipoPalanca()!=null) {
			newPayload.addCodigo("subTipoPalanca", extAcuerdo.getSubTipoPalanca().getCodigo());
		}
		if (extAcuerdo.getTipoPalanca()!=null) {
			newPayload.addCodigo("tipoPalanca", extAcuerdo.getTipoPalanca().getCodigo());
		}
		//if (extAcuerdo.getDespacho()!=null) {
		//	newPayload.addCodigo("despacho", extAcuerdo.getDespacho().getCodigo());
		//}
		
		newPayload.addExtraInfo("observaciones", extAcuerdo.getObservaciones());
		newPayload.addExtraInfo("motivo", extAcuerdo.getMotivo());

		newPayload.addFecha("fechaPropuesta", extAcuerdo.getFechaPropuesta());
		newPayload.addFecha("fechaEstado", extAcuerdo.getFechaEstado());
		newPayload.addFecha("fechaCierre", extAcuerdo.getFechaCierre());
		newPayload.addFecha("fechaResolucionPropuesta", extAcuerdo.getFechaResolucionPropuesta());
		newPayload.addFecha("fechaLimite", extAcuerdo.getFechaLimite());

		newPayload.addNumber("importePago", extAcuerdo.getImportePago());
		newPayload.addNumber("periodo", extAcuerdo.getPeriodo());
		newPayload.addNumber("porcentajeQuita", extAcuerdo.getPorcentajeQuita());
		
		return newMessage;
	}
*/
	
	public Message<DataContainerPayload> transformACU(Message<EXTAcuerdo> message) {
		
		EXTAcuerdo acuerdo = message.getPayload();
		mejAcuerdoManager.prepareGuid(acuerdo);
		
		DataContainerPayload data = getNewPayload(message);
		AcuerdoPayload recursoPayload = new AcuerdoPayload(data, acuerdo);
		
		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, recursoPayload.getAsunto().getGuid())
				.build();
		
		return newMessage;
	}

	public Message<DataContainerPayload> transformSUB(Message<Subasta> message) {
		
		Subasta subasta = message.getPayload();
		extSubastaManager.prepareGuid(subasta);
		
		DataContainerPayload data = getNewPayload(message);
		SubastaPayload subastaPayload = new SubastaPayload(data, subasta);
		
		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, subastaPayload.getProcedimiento().getAsunto().getGuid())
				.build();
		
		return newMessage;
	}
	
	
	
}
