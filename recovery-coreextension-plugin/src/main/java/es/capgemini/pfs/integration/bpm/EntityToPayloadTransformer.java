package es.capgemini.pfs.integration.bpm;

import java.util.List;
import java.util.UUID;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageBuilder;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.acuerdo.EXTAcuerdoManager;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.integration.AsuntoPayload;
import es.capgemini.pfs.integration.DataContainerPayload;
import es.capgemini.pfs.integration.TypePayload;
import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.capgemini.pfs.integration.IntegrationDataException;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.MEJRecursoManager;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;

public class EntityToPayloadTransformer {

    private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;

	@Autowired
	private MEJAcuerdoManager mejAcuerdoManager;

	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
	@Autowired
	private MEJRecursoManager mejRecursoManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private final DiccionarioDeCodigos diccionarioCodigos;
	
	public EntityToPayloadTransformer(DiccionarioDeCodigos diccionarioCodigos) {
		this.diccionarioCodigos = diccionarioCodigos;
	}
	
	@Transactional(readOnly=false)
	protected EXTAsunto setup4sync(Asunto asunto) {
		EXTAsunto extAsunto = extAsuntoManager.getAsuntoById(asunto.getId());
		if (extAsunto.getGuid() == null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El asunto ID: %d no tiene código externo, no se puede sincronizar", asunto.getId()));
		}
		return extAsunto;
	}
	
	@Transactional(readOnly=false)
	protected TareaExterna setup4sync(TareaExterna tareaExterna) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", tareaExterna.getId());
		tareaExterna = genericDao.get(TareaExterna.class, filter);
		setup4sync(tareaExterna.getTareaPadre()); 
		return tareaExterna;
	}
	
	@Transactional(readOnly=false)
	protected EXTTareaNotificacion setup4sync(TareaNotificacion tareaNotif) {
		if (!(tareaNotif instanceof EXTTareaNotificacion)) {
			throw new IntegrationClassCastException(EXTTareaNotificacion.class.getName(),tareaNotif.getClass().getName(), "No puede generarse UUID");
		}
		EXTTareaNotificacion extTareaNotif = (EXTTareaNotificacion)tareaNotif; 
		if (Checks.esNulo(extTareaNotif.getGuid())) {
			logger.debug(String.format("[INTEGRACION] Asignando nuevo GUID para tareaNotificacion %d", tareaNotif.getId()));
			extTareaNotif.setGuid(UUID.randomUUID().toString());
			genericDao.save(EXTTareaNotificacion.class, extTareaNotif);
		}
		return extTareaNotif;
	}

	private AsuntoPayload getNewPayload(Message<?> message, EXTAsunto asunto) {
		if (!message.getHeaders().containsKey(TypePayload.HEADER_MSG_TYPE)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El mensaje no tiene asignado tipo de mensaje en la cabecera, por favor asigne el valor %s a la cabecera.", TypePayload.HEADER_MSG_TYPE));
		}
		if (Checks.esNulo(asunto.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El asunto %d no está preparado para sincronización, no se puede enviar.", asunto.getId()));
		}
		String tipoMensaje = (String)message.getHeaders().get(TypePayload.HEADER_MSG_TYPE);
		AsuntoPayload msg = new AsuntoPayload(tipoMensaje, asunto); 
		return msg;
	}
	
	private void copyHeadersToPayload(Message<?> message, DataContainerPayload payload) {
		if (message.getHeaders().containsKey(AsuntoPayload.JBPM_TRANSICION)) {
			payload.addExtraInfo(AsuntoPayload.JBPM_TRANSICION, (String)message.getHeaders().get(AsuntoPayload.JBPM_TRANSICION));
		}
		if (message.getHeaders().containsKey(AsuntoPayload.JBPM_TAR_GUID_ORIGEN)) {
			payload.addExtraInfo(AsuntoPayload.JBPM_TAR_GUID_ORIGEN, (String)message.getHeaders().get(AsuntoPayload.JBPM_TAR_GUID_ORIGEN));
		}
	}

	private void addValorDD(DataContainerPayload message, List<GenericFormItem> items, TareaExternaValor tareaExternaValor) {
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
		message.addExtraInfo(String.format("%s.%s", AsuntoPayload.KEY_TFI_FORM_ITEM, key), valorStr);
	}
	
	protected void loadTareaFormItems(AsuntoPayload payload, TareaExterna tareaExterna) {
		String transicion = payload.getExtraInfo().get(AsuntoPayload.JBPM_TRANSICION);
		if (!Checks.esNulo(transicion) && transicion.equals(BPMContants.TRANSICION_AVANZA_BPM)) {
		
			// Listado de tareas
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tareaExterna.getTareaProcedimiento().getId()); 
			List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtro);
			
			// Cargamos los Valores de la tarea.
			for (TareaExternaValor valor : tareaExterna.getValores()) {
				addValorDD(payload, items, valor);
			}
		}
	}
	
	private void translate(AsuntoPayload payload) {
		String valor;
		
		//
		valor = payload.getCodigoProcedimiento();
		valor = diccionarioCodigos.getCodigoProcedimientoFinal(valor);
		payload.addCodigo(AsuntoPayload.KEY_PROCEDIMIENTO, valor);
	
		//
		valor = payload.getCodigoProcedimientoPadre();
		valor = diccionarioCodigos.getCodigoProcedimientoFinal(valor);
		payload.addCodigo(AsuntoPayload.KEY_PROCEDIMIENTO_PADRE, valor);
	
		//
		valor = payload.getCodigoTAPTarea();
		valor = diccionarioCodigos.getCodigoTareaFinal(valor);
		payload.addCodigo(AsuntoPayload.KEY_TAP_TAREA, valor);
		
	}
	
	public Message<AsuntoPayload> transformTEX(Message<TareaExterna> message) {
		TareaExterna tex = message.getPayload();

		// Persistencia de IDs de sincronización
		TareaExterna tareaExterna = setup4sync(tex);
		MEJProcedimiento procedimientoFinal = extProcedimientoManager.getProcedimientoById(tex.getTareaPadre().getProcedimiento().getId());
		MEJProcedimiento procedimientoPadreFinal = null;
		EXTAsunto asunto = setup4sync(procedimientoFinal.getAsunto());

		procedimientoFinal = extProcedimientoManager.prepareGuid(procedimientoFinal);
		if (procedimientoFinal.getGuid() == null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento ID: %d no tiene referencia de sincronización", procedimientoFinal.getId()));
		}
		
		// Debe existir un padre y debe tener GUID.
		if (procedimientoFinal.getProcedimientoPadre()!=null) {
			procedimientoPadreFinal = extProcedimientoManager.getProcedimientoById(procedimientoFinal.getProcedimientoPadre().getId());
			if (procedimientoPadreFinal.getGuid() == null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento padre no tiene referencia de sincronización %d", procedimientoPadreFinal.getId()));
			}
			
		}
		
		// Carga los valores
		AsuntoPayload newPayload = getNewPayload(message, asunto);
		newPayload.build(procedimientoFinal, procedimientoPadreFinal);
		newPayload.build(tareaExterna);
		copyHeadersToPayload(message, newPayload);
		loadTareaFormItems(newPayload, tareaExterna);
		
		translate(newPayload);
		
		//translateValues(message);
		Message<AsuntoPayload> newMessage = MessageBuilder
				.withPayload(newPayload)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, asunto.getGuid())
				.build();
		return newMessage;
	}	

	
	public Message<AsuntoPayload> transformPRC(Message<Procedimiento> message) {
		Procedimiento prc = message.getPayload();

		// Persistencia de IDs de sincronización
		MEJProcedimiento procedimientoFinal = extProcedimientoManager.getProcedimientoById(prc.getId());
		MEJProcedimiento procedimientoPadreFinal = null;
		EXTAsunto asunto = setup4sync(procedimientoFinal.getAsunto());
		
		procedimientoFinal = extProcedimientoManager.prepareGuid(procedimientoFinal);
		if (Checks.esNulo(procedimientoFinal.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento ID: %d no tiene referencia de sincronización", procedimientoFinal.getId()));
		}
		
		// Información proceidmiento padre
		if (prc.getProcedimientoPadre()!=null) {
			procedimientoPadreFinal = extProcedimientoManager.getProcedimientoById(prc.getProcedimientoPadre().getId());
			if (procedimientoPadreFinal.getGuid() == null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento padre no tiene referencia de sincronización %d", procedimientoPadreFinal.getId()));
			}
		}

		AsuntoPayload newPayload = getNewPayload(message, asunto);

		// Carga los valores
		newPayload.build(asunto);
		newPayload.build(procedimientoFinal, procedimientoPadreFinal);
		
		copyHeadersToPayload(message, newPayload);
		translate(newPayload);
		
		//translateValues(message);
		Message<AsuntoPayload> newMessage = MessageBuilder
				.withPayload(newPayload)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, asunto.getGuid())
				.build();
		return newMessage;
	}	

	
	public Message<AsuntoPayload> transformRecurso(Message<MEJRecurso> message) {
		MEJRecurso recurso = message.getPayload();
		EXTAsunto extAsunto = setup4sync(recurso.getProcedimiento().getAsunto());

		AsuntoPayload payload = loadFromRecurso((Message<MEJRecurso>) message);
		Message<AsuntoPayload> m = MessageBuilder
				.withPayload(payload)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(DataContainerPayload.HEADER_MSG_DESC, extAsunto.getGuid())
				.build();
		return m;
	}
	
	private AsuntoPayload loadFromRecurso(Message<MEJRecurso> message) {
		String msgType = (String)message.getHeaders().get(TypePayload.HEADER_MSG_TYPE);
		MEJRecurso recurso = message.getPayload();

		MEJProcedimiento mejPrc = (MEJProcedimiento)recurso.getProcedimiento(); 
		EXTAsunto extAsunto = setup4sync(mejPrc.getAsunto());

		if (Checks.esNulo(mejPrc.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento ID: %d no tiene referencia de sincronización", mejPrc.getId()));
		}
		
		AsuntoPayload payload = new AsuntoPayload(msgType, extAsunto);
		payload.build(mejPrc, null);

		// Prepara para el envío el recurso (Si no lo está ya...)
		mejRecursoManager.prepareGuid(recurso);
		payload.addSourceId("rec", recurso.getId());
		payload.addGuid("rec", recurso.getGuid());
		
		// Información de usuario registrado:
		if (SecurityUtils.getCurrentUser() != null) {
			boolean esGestor = proxyFactory.proxy(AsuntoApi.class).esGestor(mejPrc.getAsunto().getId()); 
			boolean esSupervisor = proxyFactory.proxy(AsuntoApi.class).esSupervisor(mejPrc.getAsunto().getId()); 
			payload.addFlag("esGestor", esGestor);
			payload.addFlag("esSupervisor", esSupervisor);
		}
			
		/*
		if (recurso.getTareaNotificacion()!=null) {
			EXTTareaNotificacion tareaNotificacion = setup4sync(recurso.getTareaNotificacion());
			payload.addGuid(Payload.KEY_TAR_TAREA, tareaNotificacion.getGuid());
			payload.addSourceId(Payload.KEY_TAR_TAREA, tareaNotificacion.getId());
		}*/
		
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
		/*if (extAcuerdo.getDespacho()!=null) {
			newPayload.addCodigo("despacho", extAcuerdo.getDespacho().getCodigo());
		}*/
		
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
	
}
