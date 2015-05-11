package es.capgemini.pfs.security;

import javax.servlet.http.HttpServletRequest;

public class RSAWebAuthenticationDetails extends RSIWebAuthenticationDetails {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3759388434374543571L;
	public static final String RSA_SECURITY_FORM_CODE_KEY = "workingcode";
	public static final String RSA_SECURITY_FORM_TIME_STAMP = "timestamp";
    public static final String RSI_SECURITY_FORM_VIEW_KEY = "view";
    public static final String RSI_SECURITY_FORM_ID_KEY = "id";
	
	private String loginCode;
	private String timeStamp;


	//private final Log logger = LogFactory.getLog(getClass());

	
	
	@Override
	protected void doPopulateAdditionalInformation(HttpServletRequest request) {
		this.setLoginCode(request.getParameter(RSA_SECURITY_FORM_CODE_KEY));
		this.setTimeStamp(request.getParameter(RSA_SECURITY_FORM_TIME_STAMP));
		String view = request.getParameter(RSI_SECURITY_FORM_VIEW_KEY);
		String id = request.getParameter(RSI_SECURITY_FORM_ID_KEY);
		
		request.getSession().setAttribute(RSI_SECURITY_FORM_WORKING_CODE_KEY, this.getWorkingCode());
		request.getSession().setAttribute(RSI_SECURITY_FORM_VIEW_KEY, view);
		request.getSession().setAttribute(RSI_SECURITY_FORM_ID_KEY, id);
		
		super.doPopulateAdditionalInformation(request);
	}

	public RSAWebAuthenticationDetails(HttpServletRequest request) {
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
