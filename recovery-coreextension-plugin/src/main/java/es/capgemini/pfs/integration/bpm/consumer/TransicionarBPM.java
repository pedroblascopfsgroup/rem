package es.capgemini.pfs.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.integration.AsuntoPayload;
import es.capgemini.pfs.integration.ConsumerAction;
import es.capgemini.pfs.integration.IntegrationDataException;
import es.capgemini.pfs.integration.Rule;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;

/**
 * Transiciona un BPM según la transición desde el token que llega. 
 *  
 * @author gonzalo
 *
 */
public class TransicionarBPM extends ConsumerAction<AsuntoPayload> {

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
    @Autowired
    private JBPMProcessManager jbpmUtil;
	
    private String forzarTransicion;
    
	public TransicionarBPM(Rule<AsuntoPayload> rule) {
		super(rule);
	}
	
	public TransicionarBPM(List<Rule<AsuntoPayload>> rules) {
		super(rules);
	}

	private String getGuidProcedimiento(AsuntoPayload message) {
		return message.getGuidProcedimiento();
	}

	public String getForzarTransicion() {
		return forzarTransicion;
	}

	public void setForzarTransicion(String forzarTransicion) {
		this.forzarTransicion = forzarTransicion;
	}
	
	public String getTransicionPropuesta(AsuntoPayload message) {
		return (!Checks.esNulo(forzarTransicion)) 
				? forzarTransicion 
				: message.getExtraInfo().get(AsuntoPayload.JBPM_TRANSICION);
	}
	
	protected void doTransicion(AsuntoPayload message, MEJProcedimiento prcPadre) {
		String transicionPropuesta = getTransicionPropuesta(message);
		if (Checks.esNulo(transicionPropuesta)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%d] La tansición no se ha enviado, no se puede transicionar", prcPadre.getId()));
		}
		logger.debug(String.format("[INTEGRACION] PRC [%d] transicionando por: %s", prcPadre.getId(), transicionPropuesta));
		jbpmUtil.signalProcess(prcPadre.getProcessBPM(), transicionPropuesta);
	}
	
	@Override
	protected void doAction(AsuntoPayload message) {
		String guidPRC = getGuidProcedimiento(message); 
		logger.debug(String.format("[INTEGRACION] PRC [%s] Inciando transición...", guidPRC));
		// OJO! El procediento padre del nuevo BPM será el procedimiento desde el que se genera (no el padre de este!).
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(guidPRC);
		if (prc==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%s] El procedimiento no existe.", guidPRC));
		}
		doTransicion(message, prc);
		logger.debug(String.format("[INTEGRACION] PRC [%s] Transición realizada!", guidPRC));
	}
	
}
