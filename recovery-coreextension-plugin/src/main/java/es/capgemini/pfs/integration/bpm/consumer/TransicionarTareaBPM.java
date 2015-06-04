package es.capgemini.pfs.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.integration.AsuntoPayload;
import es.capgemini.pfs.integration.ConsumerAction;
import es.capgemini.pfs.integration.IntegrationDataException;
import es.capgemini.pfs.integration.Rule;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;

/**
 * Transiciona un BPM según la transición desde el token que llega. 
 *  
 * @author gonzalo
 *
 */
public class TransicionarTareaBPM extends ConsumerAction<AsuntoPayload> {

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private EXTTareaNotificacionManager extTareaNotificacionManager;
	
    @Autowired
    private JBPMProcessManager jbpmUtil;
	
    private String forzarTransicion;
    
	public TransicionarTareaBPM(Rule<AsuntoPayload> rule) {
		super(rule);
	}
	
	public TransicionarTareaBPM(List<Rule<AsuntoPayload>> rules) {
		super(rules);
	}

	public String getForzarTransicion() {
		return forzarTransicion;
	}

	public void setForzarTransicion(String forzarTransicion) {
		this.forzarTransicion = forzarTransicion;
	}
	
	private String getGuidTareaATransicionar(AsuntoPayload message) {
		if (!message.getExtraInfo().containsKey(AsuntoPayload.JBPM_TAR_GUID_ORIGEN)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El mensaje no contiene la Info. extra '%s', indica el guid de la tarea sobre la que se va a generar la transición.", AsuntoPayload.JBPM_TAR_GUID_ORIGEN));
		}
		String tarGUID =  message.getExtraInfo().get(AsuntoPayload.JBPM_TAR_GUID_ORIGEN);
		if (!message.getExtraInfo().containsKey(AsuntoPayload.JBPM_TAR_GUID_ORIGEN)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] No se ha indicado GUID de la tarea a transicionar.", tarGUID));
		}
		return tarGUID; 
	}

	private String getTransicionPropuesta(AsuntoPayload message) {
		return message.getExtraInfo().containsKey(AsuntoPayload.JBPM_TRANSICION) 
				? message.getExtraInfo().get(AsuntoPayload.JBPM_TRANSICION) 
				: null;
	}
	
	protected void doTransicion(AsuntoPayload message, TareaExterna tex) {
		String transicionPropuesta = (!Checks.esNulo(forzarTransicion)) ? forzarTransicion : getTransicionPropuesta(message);
		if (Checks.esNulo(transicionPropuesta)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] TEX [%d] La tansición no se ha enviado, no se puede transicionar", tex.getId()));
		}
		logger.debug(String.format("[INTEGRACION] TEX [%d] transición candidata: %s", tex.getId(), transicionPropuesta));
		Long tokenId = tex.getTokenIdBpm();
		if (Checks.esNulo(tokenId)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] TEX [%d] La tarea asignada no tiene token BPM, no se puede transicionar", tex.getId()));
		}
		if (!jbpmUtil.hasTransitionToken(tokenId, transicionPropuesta)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] TEX [%d] La transicion %s no existe para esta tarea, Token %d no se puede transicionar", tex.getId(), transicionPropuesta, tokenId));
		}
		logger.info(String.format("[INTEGRACION] TEX [%d] transicionando a través de %s", tex.getId(), transicionPropuesta));
		jbpmUtil.signalToken(tex.getTokenIdBpm(), transicionPropuesta);
	}
	
	
	@Override
	protected void doAction(AsuntoPayload message) {
		String tarGUID = getGuidTareaATransicionar(message);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Inciando transición en tarea...", tarGUID));
		// OJO! El procediento padre del nuevo BPM será el procedimiento desde el que se genera (no el padre de este!).
		EXTTareaNotificacion tarNotif = extTareaNotificacionManager.getTareaNoficiacionByGuid(tarGUID);
		if (tarNotif==null || tarNotif.getTareaExterna()==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] TAR [%s] La tarea externa a transicionar no existe.", tarGUID));
		}
		doTransicion(message, tarNotif.getTareaExterna());
		logger.debug(String.format("[INTEGRACION] TAR [%s] Transición completada!", tarGUID));
	}

	
}
