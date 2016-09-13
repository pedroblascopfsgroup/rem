package es.pfsgroup.plugin.messagebroker.exceptions;

public abstract class MessageBrokerControlledException extends RuntimeException {

	public MessageBrokerControlledException() {
		super();
	}

	public MessageBrokerControlledException(String message, Throwable cause) {
		super(message, cause);
	}

	public MessageBrokerControlledException(String message) {
		super(message);
	}

	public MessageBrokerControlledException(Throwable cause) {
		super(cause);
	}

}
