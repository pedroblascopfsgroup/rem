package es.capgemini.pfs.security.manager;

public class RSADecripterStatus {
	
	private String username;
	
	private String timestamp;
	
	private boolean ok;


	public RSADecripterStatus(String username, String timestamp, boolean ok) {
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
