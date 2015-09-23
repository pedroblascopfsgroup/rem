package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
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
public class ParalizarBPM extends ConsumerAction<DataContainerPayload> {

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private GenericABMDao genericDao;
	
    @Autowired
    private JBPMProcessManager jbpmUtil;

    @Autowired
    private EXTProcedimientoManager extProcedimientoManager;

	public ParalizarBPM(Rule<DataContainerPayload> rule) {
		super(rule);
	}
	
	public ParalizarBPM(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	private String getGuidProcedimiento(ProcedimientoPayload procedimiento) {
		return procedimiento.getGuid(); //String.format("%d-EXT", procedimiento.getIdOrigen()); //message.getGuidProcedimiento();
	}
	
	@Override
	protected void doAction(DataContainerPayload payload) {
		ProcedimientoPayload procedimientoPayload = new ProcedimientoPayload(payload);
		String guidPRC = getGuidProcedimiento(procedimientoPayload); 
		logger.info(String.format("[INTEGRACION] PRC [%s] Paralizando procedimiento...", guidPRC));
		
		MEJProcedimiento procedimiento = extProcedimientoManager.getProcedimientoByGuid(guidPRC);
		if (procedimiento==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%s] El procedimiento no existe, NO SE PUEDE PARALIZAR", guidPRC));
		}
		
		try {
			
			if (!payload.getFecha().containsKey(BPMContants.FECHA_APLAZAMIENTO_TAREAS)) {
				throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%d] No existe fecha de aplazamiento del procedimiento", procedimiento.getId()));
			}
			Date fecha = payload.getFecha(BPMContants.FECHA_APLAZAMIENTO_TAREAS);
			Long idProcessBPM = procedimiento.getProcessBPM();

			jbpmUtil.aplazarProcesosBPM(idProcessBPM, fecha);
			procedimiento.setEstaParalizado(true);
			procedimiento.setFechaUltimaParalizacion(new Date());
			genericDao.save(MEJProcedimiento.class, procedimiento);
			
			logger.info(String.format("[INTEGRACION] PRC [%s] Procedimiento paralizado!!", guidPRC));
		} catch (Exception e) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%s] El procedimiento no se ha podido finalizar", guidPRC), e);
		}
		
	}
	
}
