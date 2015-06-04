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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;

/**
 * Transiciona un BPM según la transición desde el token que llega. 
 *  
 * @author gonzalo
 *
 */
public class FinalizarBPM extends ConsumerAction<AsuntoPayload> {

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private GenericABMDao genericDao;
	
    @Autowired
    private JBPMProcessManager jbpmUtil;

    @Autowired
    private EXTProcedimientoManager extProcedimientoManager;

	public FinalizarBPM(Rule<AsuntoPayload> rule) {
		super(rule);
	}
	
	public FinalizarBPM(List<Rule<AsuntoPayload>> rules) {
		super(rules);
	}

	private String getGuidProcedimiento(AsuntoPayload message) {
		return String.format("%d-EXT", message.getIdProcedimiento()); //message.getGuidProcedimiento();
	}
	
	@Override
	protected void doAction(AsuntoPayload message) {
		String guidPRC = getGuidProcedimiento(message); 
		logger.debug(String.format("[INTEGRACION] PRC [%s] Finalizando procedimiento...", guidPRC));
		// OJO! El procediento padre del nuevo BPM será el procedimiento desde el que se genera (no el padre de este!).
		MEJProcedimiento procedimiento = extProcedimientoManager.getProcedimientoByGuid(guidPRC);
		if (procedimiento==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%s] El procedimiento no existe, NO SE PUEDE FINALIZAR", guidPRC));
		}
		try {
			jbpmUtil.finalizarProcedimiento(procedimiento.getId());
			logger.debug(String.format("[INTEGRACION] PRC [%s] Transición realizada!", guidPRC));
		} catch (Exception e) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%s] El procedimiento no se ha podido finalizar", guidPRC), e);
		}
	}
	
}
