package es.pfsgroup.plugin.messagebroker.exceptions;

public class RetriesRequiredException extends MessageBrokerControlledException {

	private static final long serialVersionUID = 5787977751844223292L;
	
	private int retries = 0;
	private long miliseconds = 0;

	public RetriesRequiredException(Throwable exception, int retries) {
		super(exception);
		this.retries = retries;
	}
	
	public RetriesRequiredException(Throwable exception, int retries, long miliseconds) {
		super(exception);
		this.retries = retries;
		this.miliseconds = miliseconds;
	}

	public long getMiliseconds() {
		return miliseconds;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public int getRetries() {
		return retries;
	}
	
}
