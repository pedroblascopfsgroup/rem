package es.pfsgroup.recovery.haya.integration.bpm;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;

import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.concursal.convenio.ConvenioManager;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;

public class EntityToPayloadTransformer extends es.pfsgroup.recovery.integration.bpm.EntityToPayloadTransformer {

    private static final String LOG_MSG_TRANSFORM_START = "[INTEGRACION] Transformando %s...";
    private static final String LOG_MSG_TRANSFORM_END = "[INTEGRACION] %s transformado. Guid: %s!!!";

	private final Log logger = LogFactory.getLog(getClass());

    @Autowired
	private ConvenioManager convenioManager;
    
    @Autowired
	private ContratoManager contratoManager;
	
	public EntityToPayloadTransformer(DiccionarioDeCodigos diccionarioCodigos) {
		super(diccionarioCodigos);
	}

	public Message<DataContainerPayload> transformCOV(Message<Convenio> message) {
		
		Convenio convenio = message.getPayload();
		logger.debug(String.format(LOG_MSG_TRANSFORM_START, convenio.getClass().getName()));
		
		convenioManager.prepareGuid(convenio);
		extProcedimientoManager.prepareGuid(convenio.getProcedimiento());
		
		DataContainerPayload data = getNewPayload(message);
		ConvenioPayload convenioPayload = new ConvenioPayload(data, convenio);

		logger.info(String.format(LOG_MSG_TRANSFORM_END, convenio.getClass().getName(), convenioPayload.getGuid()));
		
		String grpId = convenioPayload.getAsunto().getGuid();
		Message<DataContainerPayload> newMessage = createMessage(message,  data, grpId);

		return newMessage;
	}
	
	public Message<DataContainerPayload> transformRIO(Message<ActualizarRiesgoOperacionalDto> message) {
		
		ActualizarRiesgoOperacionalDto riesgoOperacionalDto = message.getPayload();
		logger.debug(String.format(LOG_MSG_TRANSFORM_START, riesgoOperacionalDto.getClass().getName()));		
		
		Contrato contrato = contratoManager.get(riesgoOperacionalDto.getIdContrato());
		
		if(contrato != null) {
			DataContainerPayload data = getNewPayload(message);
			RiesgoOperacionalPayload riesgoOperacionalPayload = new RiesgoOperacionalPayload(data);
			riesgoOperacionalPayload.build(riesgoOperacionalDto, contrato.getNroContrato());
	
			logger.info(String.format(LOG_MSG_TRANSFORM_END, riesgoOperacionalDto.getClass().getName(), riesgoOperacionalPayload.getGuid()));
			
			Message<DataContainerPayload> newMessage = createMessage(message,  data, "CNT-" + contrato.getNroContrato());
	
			return newMessage;
		}
		else {
			throw new FrameworkException("Error en el método transformRIO: no se ha encontrado el contrato con ID " + riesgoOperacionalDto.getIdContrato());
		}
	}
}
