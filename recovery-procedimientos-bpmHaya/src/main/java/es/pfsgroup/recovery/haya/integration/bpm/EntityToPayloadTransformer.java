package es.pfsgroup.recovery.haya.integration.bpm;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageBuilder;

import es.pfsgroup.concursal.convenio.ConvenioManager;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.TypePayload;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;

public class EntityToPayloadTransformer extends es.pfsgroup.recovery.integration.bpm.EntityToPayloadTransformer {

    @Autowired
	private ConvenioManager convenioManager;
	
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
/*		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(data)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_DESC, convenioPayload.getAsunto().getGuid())
				.build();
		*/
		return newMessage;
	}
}
