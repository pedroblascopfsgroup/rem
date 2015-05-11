package es.pfsgroup.recovery.ext.impl.security.tripledes;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.pfs.security.RSIWebAuthenticationDetails;

public class TripleDesWebAuthenticationDetails extends RSIWebAuthenticationDetails {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3759388434374543571L;
	public static final String RSA_SECURITY_FORM_CODE_KEY = "workingcode";
	public static final String RSA_SECURITY_FORM_TIME_STAMP = "timestamp";
	
	private String loginCode;
	private String timeStamp;


	//private final Log logger = LogFactory.getLog(getClass());

	
	
	@Override
	protected void doPopulateAdditionalInformation(HttpServletRequest request) {
		this.setLoginCode(request.getParameter(RSA_SECURITY_FORM_CODE_KEY));
		this.setTimeStamp(request.getParameter(RSA_SECURITY_FORM_TIME_STAMP));
		
		
		super.doPopulateAdditionalInformation(request);
	}

	public TripleDesWebAuthenticationDetails(HttpServletRequest request) {
		super(request);
	}

	public void setLoginCode(String loginCode) {
		this.loginCode = loginCode;
	}

	public String getLoginCode() {
		return loginCode;
	}

	public void setTimeStamp(String timeStamp) {
		this.timeStamp = timeStamp;
	}

	public String getTimeStamp() {
		return timeStamp;
	}
}
