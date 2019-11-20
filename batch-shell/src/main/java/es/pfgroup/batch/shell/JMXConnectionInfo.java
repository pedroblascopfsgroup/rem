package es.pfgroup.batch.shell;

/**
 * Clase que recoge los parámetros de entrada para el cliente JMX
 * @author bruno
 *
 */
public class JMXConnectionInfo implements Cloneable{

	public String getJmxAuth() {
		return jmxAuth;
	}

	public void setJmxAuth(String jmxAuth) {
		this.jmxAuth = jmxAuth;
	}

	public String getJmxUrl() {
		return jmxUrl;
	}

	public void setJmxUrl(String jmxUrl) {
		this.jmxUrl = jmxUrl;
	}

	public String getJmxMBean() {
		return jmxMBean;
	}

	public void setJmxMBean(String jmxMBean) {
		this.jmxMBean = jmxMBean;
	}

	public String getJmxCall() {
		return jmxCall;
	}

	public void setJmxCall(String jmxCall) {
		this.jmxCall = jmxCall;
	}

	private String jmxAuth;
	
	private String jmxUrl;
	
	private String jmxMBean;
	
	private String jmxCall;

	public String[] getArray() {
		return new String[] {this.jmxAuth, this.jmxUrl, this.jmxMBean, this.jmxCall };
	}

	public boolean hasData() {
		return ! "-".equals(jmxAuth);
	}
	
	public JMXConnectionInfo clone(){
		try {
			return (JMXConnectionInfo) super.clone();
		} catch (CloneNotSupportedException e) {
			// Si se produce esta excepción es porque se le ha quitado el implements Cloneable a la clase
			throw new IllegalStateException("Object not cloneable due an error.");
		}
	}
}
