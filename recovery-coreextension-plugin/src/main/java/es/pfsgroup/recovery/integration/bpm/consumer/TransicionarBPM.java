package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoPayload;

/**
 * Transiciona un BPM según la transición desde el token que llega. 
 *  
 * @author gonzalo
 *
 */
public class TransicionarBPM extends ConsumerAction<DataContainerPayload> {

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
    @Autowired
    private JBPMProcessManager jbpmUtil;
	
    private String forzarTransicion;
    
	public TransicionarBPM(Rule<DataContainerPayload> rule) {
		super(rule);
	}
	
	public TransicionarBPM(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	private String getGuidProcedimiento(ProcedimientoPayload procedimiento) {
		return procedimiento.getGuid();
	}

	public String getForzarTransicion() {
		return forzarTransicion;
	}

	public void setForzarTransicion(String forzarTransicion) {
		this.forzarTransicion = forzarTransicion;
	}
	
	public String getTransicionPropuesta(ProcedimientoPayload procedimiento) {
		return (!Checks.esNulo(forzarTransicion)) 
				? forzarTransicion 
				: procedimiento.getTransicionBPM();
	}
	
	protected void doTransicion(ProcedimientoPayload procedimiento, MEJProcedimiento prcPadre) {
		String transicionPropuesta = getTransicionPropuesta(procedimiento);
		if (Checks.esNulo(transicionPropuesta)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%d] La tansición no se ha enviado, no se puede transicionar", prcPadre.getId()));
		}
		logger.debug(String.format("[INTEGRACION] PRC [%d] transicionando por: %s", prcPadre.getId(), transicionPropuesta));
		jbpmUtil.signalProcess(prcPadre.getProcessBPM(), transicionPropuesta);
	}
	
	@Override
	protected void doAction(DataContainerPayload payload) {
		ProcedimientoPayload procedimiento = new ProcedimientoPayload(payload);
		String guidPRC = getGuidProcedimiento(procedimiento); 
		logger.debug(String.format("[INTEGRACION] PRC [%s] Inciando transición...", guidPRC));
		// OJO! El procediento padre del nuevo BPM será el procedimiento desde el que se genera (no el padre de este!).
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(guidPRC);
		if (prc==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%s] El procedimiento no existe.", guidPRC));
		}
		doTransicion(procedimiento, prc);
		logger.debug(String.format("[INTEGRACION] PRC [%s] Transición realizada!", guidPRC));
	}
	
}
