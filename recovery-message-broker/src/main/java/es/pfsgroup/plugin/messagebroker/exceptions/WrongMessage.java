package es.pfsgroup.plugin.messagebroker.exceptions;

import org.springframework.integration.core.Message;

public class WrongMessage extends RuntimeException {

	private static final long serialVersionUID = -7507775094768479387L;

	
	public WrongMessage(@SuppressWarnings("rawtypes") Message message, String errMsg, Throwable e) {
		super(createErrorMessage(message, errMsg), e);
	}
	
	public WrongMessage(Message<Object> message, String errMsg) {
		super(createErrorMessage(message, errMsg));
	}


	private static String createErrorMessage(@SuppressWarnings("rawtypes") Message message, String errMsg) {
		return "Error occurred processing message [" + message.getHeaders().getId() + "]. " + errMsg;
	}
}
