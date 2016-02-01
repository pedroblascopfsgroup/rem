package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
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
public class ActivarBPMConsumer extends ConsumerAction<DataContainerPayload>  {

	protected final Log logger = LogFactory.getLog(getClass());
	
    @Autowired
    private EXTProcedimientoManager extProcedimientoManager;

	public ActivarBPMConsumer(Rule<DataContainerPayload> rule) {
		super(rule);
	}
	
	public ActivarBPMConsumer(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	protected String getGuidProcedimiento(ProcedimientoPayload procedimiento) {
		return procedimiento.getGuid(); 
	}

	@Override
	protected void doAction(DataContainerPayload payload) {
		ProcedimientoPayload procedimiento = new ProcedimientoPayload(payload);
		String prcUUID = getGuidProcedimiento(procedimiento);

		logger.info(String.format("[INTEGRACION] PRC[%s] Activando procedimiento...", prcUUID));
		Procedimiento prc = extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		if (prc==null || !(prc instanceof MEJProcedimiento)) {
			String logMsg = String.format("[INTEGRACION] PRC[%s] Procedimiento no encontrado!!!!, no se puede desparalizar!!", prcUUID);
			logger.error(logMsg);
			throw new IntegrationDataException(logMsg);
			
		}
		MEJProcedimiento mejPrc = MEJProcedimiento.instanceOf(prc);  
		if (!extProcedimientoManager.isDespararizable(prc.getId())) {
			String logMsg = String.format("[INTEGRACION] PRC[%s] Procedimiento no es desparalizable!!!!, no se puede desparalizar!!", prcUUID);
			logger.error(logMsg);
			throw new IntegrationDataException(logMsg);
		}
		extProcedimientoManager.desparalizarProcedimiento(prc.getId(), false);
		logger.debug(String.format("[INTEGRACION] PRC[%s] Procedimiento activado!!", prcUUID));
	}
	
}
