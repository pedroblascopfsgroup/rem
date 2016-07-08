package es.pfsgroup.plugin.rem.security;


import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.AuthenticationException;
import org.springframework.security.ui.webapp.AuthenticationProcessingFilterEntryPoint;

/**
 * returns 401 unauth header to be used with pure js ajax client
 */
public class Http401AuthenticationEntryPoint extends AuthenticationProcessingFilterEntryPoint {
	
    private static final Log logger = LogFactory.getLog(Http401AuthenticationEntryPoint.class);
    
    private boolean forceRedirect = false;

	@Override
	public void commence(ServletRequest request, ServletResponse response,
			AuthenticationException authException) throws IOException,
			ServletException {
	    
		 HttpServletRequest httpRequest = (HttpServletRequest) request; 
	        HttpServletResponse httpResponse = (HttpServletResponse) response;

	        String redirectUrl = null;
	        
	        boolean forceRedirect = ("/").equals(httpRequest.getServletPath());

	        if (isServerSideRedirect()) {

	            if (isForceHttps() && "http".equals(request.getScheme())) {
	                redirectUrl = buildHttpsRedirectUrlForRequest(httpRequest);
	            }

	            if (redirectUrl == null) {
	                String loginForm = determineUrlToUseForThisRequest(httpRequest, httpResponse, authException);
	                
	                if (logger.isDebugEnabled()) {
	                    logger.debug("Server side forward to: " + loginForm);
	                }

	                RequestDispatcher dispatcher = httpRequest.getRequestDispatcher(loginForm);

	                if(forceRedirect) {
	                	dispatcher.forward(request, response);

	                	return;
	                }
	            }
	        } else {
	            // redirect to login page. Use https if forceHttps true

	            redirectUrl = buildRedirectUrlToLoginPage(httpRequest, httpResponse, authException);

	        }
	        
	        if (logger.isDebugEnabled())
	        {
	        	logger.debug("url requires authentication " + httpRequest.getRequestURL().toString());
	        	System.out.println("url requires authentication " + httpRequest.getRequestURL().toString());
	        	
	        }
	        

	        if(forceRedirect) {
	        	httpResponse.sendRedirect(httpResponse.encodeRedirectURL(redirectUrl));
	        } else {
		        httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authentication required");
	        }        


	}

	public boolean isForceRedirect() {
		return forceRedirect;
	}

	public void setForceRedirect(boolean forceRedirect) {
		this.forceRedirect = forceRedirect;
	}
}
