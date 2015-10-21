package es.pfsgroup.recovery.integration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageBuilder;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.Translator;

public class JsonDataContainerPayloadTransformer {

	private final Translator translator;
	
	@Autowired
	private GenericABMDao genericDao;

	public JsonDataContainerPayloadTransformer(Translator translator) {
		this.translator = translator;
	}
	
	public Message<String> serialize(Message<DataContainerPayload> message) {
		String translated = translator.serialize(message.getPayload());
		Message<String> newMessage = MessageBuilder
				.withPayload(translated)
				.copyHeaders(message.getHeaders())
				.build();
		return newMessage;
	}	

	public Message<DataContainerPayload> deserialize(Message<String> message) {
		DataContainerPayload translated = (DataContainerPayload)translator.deserialize(message.getPayload(), DataContainerPayload.class);
		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(translated)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_TYPE, translated.getTipo())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_ENTIDAD, translated.getEntidad())
				.build();
		return newMessage;
	}	
	
}
