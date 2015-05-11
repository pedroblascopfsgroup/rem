package es.pfsgroup.recovery.ext.impl.security.tripledes.manager;

public class TripleDesDecripterStatus {
	
	private String username;
	
	private String timestamp;
	
	private boolean ok;


	public TripleDesDecripterStatus(String username, String timestamp, boolean ok) {
		super();
		this.username = username;
		this.timestamp = timestamp;
		this.ok = ok;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public boolean isOk() {
		return ok;
	}

	public void setOk(boolean ok) {
		this.ok = ok;
	}

}
