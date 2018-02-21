package es.pfsgroup.plugin.rem.security;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.ui.WebAuthenticationDetails;

import es.capgemini.pfs.security.RSAWebAuthenticationDetails;

public class HayaWebAuthenticationDetails extends RSAWebAuthenticationDetails {

	private static final long serialVersionUID = 1L;
	private static final String ID_TOKEN_KEY = "id_token";
	private static final String ID_USER_KEY = "user_id";
	private static final String SIGNATURE_KEY = "signature";
	private static final String CODE_KEY = "code";

	private String userId;
	private String signature;
	private String idToken;
	private String code;

	/**
	 * @param request
	 */
	public HayaWebAuthenticationDetails(HttpServletRequest request) {
		super(request);
	}

	/**
	 * @see org.springframework.security.ui.WebAuthenticationDetails#doPopulateAdditionalInformation(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	protected void doPopulateAdditionalInformation(HttpServletRequest request) {
		userId = request.getParameter(ID_USER_KEY);
		signature = request.getParameter(SIGNATURE_KEY);
		idToken = request.getParameter(ID_TOKEN_KEY);
		code = request.getParameter(CODE_KEY);
	}
	
	public String getUserId() {
		return userId;
	}

	public String getSignature() {
		return signature;
	}

	public String getIdToken() {
		return idToken;
	}
	
	public String getCode() {
		return code;
	}

	public void setIdToken(String idToken) {
		this.idToken = idToken;
	}
	
}