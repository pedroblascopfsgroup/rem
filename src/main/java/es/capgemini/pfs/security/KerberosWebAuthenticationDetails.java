package es.capgemini.pfs.security;

import javax.servlet.http.HttpServletRequest;

public class KerberosWebAuthenticationDetails extends
		RSIWebAuthenticationDetails {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5946015184604194050L;

	private HttpServletRequest request;
	
	public KerberosWebAuthenticationDetails(HttpServletRequest request) {
		
		super(request);
		this.request = request;
		
	}

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	@Override
	protected void doPopulateAdditionalInformation(HttpServletRequest request) {
		this.setRequest(request);
		super.doPopulateAdditionalInformation(request);
	}

}
