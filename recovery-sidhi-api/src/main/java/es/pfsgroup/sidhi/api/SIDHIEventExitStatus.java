package es.pfsgroup.sidhi.api;

public class SIDHIEventExitStatus {
	
	public enum Status {OK, FAIL};
	
	private Status status;
	
	private boolean markAsProcessed = false;

	private Exception exception;
	
	public SIDHIEventExitStatus(Status status, boolean markAsProcessed,
			Exception exception) {
		super();
		this.status = status;
		this.markAsProcessed = markAsProcessed;
		this.exception = exception;
	}

	public Status getStatus() {
		return status;
	}

	public boolean isMarkAsProcessed() {
		return markAsProcessed;
	}

	public Exception getException() {
		return exception;
	}

}
