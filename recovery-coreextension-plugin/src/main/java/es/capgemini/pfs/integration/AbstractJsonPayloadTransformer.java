package es.capgemini.pfs.integration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageBuilder;

import es.capgemini.pfs.integration.DataContainerPayload;
import es.capgemini.pfs.integration.Translator;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

public abstract class AbstractJsonPayloadTransformer {

	private final Translator translator;
	
	@Autowired
	private GenericABMDao genericDao;

	public AbstractJsonPayloadTransformer(Translator translator) {
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

	public abstract Class<?> getDeserializedClass();
	
	public Message<DataContainerPayload> deserialize(Message<String> message) {
		DataContainerPayload translated = (DataContainerPayload)translator.deserialize(message.getPayload(), getDeserializedClass());
		Message<DataContainerPayload> newMessage = MessageBuilder
				.withPayload(translated)
				.copyHeaders(message.getHeaders())
				.setHeaderIfAbsent(TypePayload.HEADER_MSG_TYPE, translated.getTipo())
				.build();
		return newMessage;
	}	
	
}
