package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.payload.FinAsuntoPayload;

/**
 * Transiciona un BPM según la transición desde el token que llega. 
 *  
 * @author gonzalo
 *
 */
public class FinalizarAsuntoConsumer extends ConsumerAction<DataContainerPayload>  {

	protected final Log logger = LogFactory.getLog(getClass());
	
    @Autowired
    private EXTAsuntoManager extAsuntoManager;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;
    
	public FinalizarAsuntoConsumer(Rule<DataContainerPayload> rule) {
		super(rule);
	}
	
	public FinalizarAsuntoConsumer(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	protected String getGuidAsunto(FinAsuntoPayload payload) {
		return payload.getAsunto().getGuid(); 
	}

	@Override
	protected void doAction(DataContainerPayload payload) {
		FinAsuntoPayload asuPayload = new FinAsuntoPayload(payload);
		String asuUUID = getGuidAsunto(asuPayload);

		logger.info(String.format("[INTEGRACION] PRC[%s] Finalizando asunto...", asuUUID));
		Asunto asu = extAsuntoManager.getAsuntoByGuid(asuUUID);
		if (asu==null) {
			String logMsg = String.format("[INTEGRACION] ASU[%s] Asunto no encontrado!!!!, no se puede finalizar!!", asuUUID);
			logger.error(logMsg);
			throw new IntegrationDataException(logMsg);
			
		}
		
		MEJFinalizarAsuntoDto dto = new MEJFinalizarAsuntoDto();
		dto.setIdAsunto(asu.getId());
		dto.setObservaciones(asuPayload.getObservaciones());
		dto.setFechaFinalizacion(asuPayload.getFechaFin());
		dto.setMotivoFinalizacion(asuPayload.getMotivo());
		extAsuntoManager.finalizarAsunto(dto, false);
		
		logger.info(String.format("[INTEGRACION] ASU[%s] Asunto finalizado!!", asuUUID));
	}
	
}
