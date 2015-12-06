package es.pfsgroup.recovery.haya.integration.bpm;

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

    @Autowired
	private ConvenioManager convenioManager;
    
    @Autowired
	private ContratoManager contratoManager;
	
	public EntityToPayloadTransformer(DiccionarioDeCodigos diccionarioCodigos) {
		super(diccionarioCodigos);
	}

	public Message<DataContainerPayload> transformCOV(Message<Convenio> message) {
		
		Convenio convenio = message.getPayload();
		convenioManager.prepareGuid(convenio);
		extProcedimientoManager.prepareGuid(convenio.getProcedimiento());
		
		DataContainerPayload data = getNewPayload(message);
		ConvenioPayload convenioPayload = new ConvenioPayload(data, convenio);

		String grpId = convenioPayload.getAsunto().getGuid();
		Message<DataContainerPayload> newMessage = createMessage(message,  data, grpId);

		return newMessage;
	}
	
	public Message<DataContainerPayload> transformRIO(Message<ActualizarRiesgoOperacionalDto> message) {
		
		ActualizarRiesgoOperacionalDto riesgoOperacionalDto = message.getPayload();
		Contrato contrato = contratoManager.get(riesgoOperacionalDto.getIdContrato());
		
		if(contrato != null) {
			DataContainerPayload data = getNewPayload(message);
			RiesgoOperacionalPayload riesgoOperacionalPayload = new RiesgoOperacionalPayload(data);
			riesgoOperacionalPayload.build(riesgoOperacionalDto, contrato.getNroContrato());
			
			Message<DataContainerPayload> newMessage = createMessage(message,  data, "CNT-" + contrato.getNroContrato());
	
			return newMessage;
		}
		else {
			throw new FrameworkException("Error en el método transformRIO: no se ha encontrado el contrato con ID " + riesgoOperacionalDto.getIdContrato());
		}
	}
}
