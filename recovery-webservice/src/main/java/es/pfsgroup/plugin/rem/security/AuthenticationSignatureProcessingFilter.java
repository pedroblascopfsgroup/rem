package es.pfsgroup.plugin.rem.security;


import java.io.IOException;
import java.io.Writer;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.concurrent.SessionRegistry;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.event.authentication.InteractiveAuthenticationSuccessEvent;
import org.springframework.security.ui.webapp.AuthenticationProcessingFilter;
import org.springframework.security.util.SessionUtils;

import es.pfsgroup.commons.utils.Checks;


public class AuthenticationSignatureProcessingFilter extends AuthenticationProcessingFilter {
	
	private boolean invalidateSessionOnSuccessfulAuthentication;
	
    private boolean migrateInvalidatedSessionAttributes = true;
    
    private boolean serverSideRedirect = false;
    
    private SessionRegistry sessionRegistry;
    
    @Resource
	private Properties appProperties;
    

	@Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response,
            Authentication authResult) throws IOException, ServletException {
        if (logger.isDebugEnabled()) {
            logger.debug("Authentication success: " + authResult.toString());
        }

        SecurityContextHolder.getContext().setAuthentication(authResult);

        if (logger.isDebugEnabled()) {
            logger.debug("Updated SecurityContextHolder to contain the following Authentication: '" + authResult + "'");
        }
        
        if (this.invalidateSessionOnSuccessfulAuthentication) {
			SessionUtils.startNewSessionIfRequired(request, migrateInvalidatedSessionAttributes, sessionRegistry);
        }

        String targetUrl = determineTargetUrl(request);

        if (logger.isDebugEnabled()) {
            logger.debug("Redirecting to target URL from HTTP Session (or default): " + targetUrl);
        }

        onSuccessfulAuthentication(request, response, authResult);

        getRememberMeServices().loginSuccess(request, response, authResult);

        // Fire event
        if (this.eventPublisher != null) {
            eventPublisher.publishEvent(new InteractiveAuthenticationSuccessEvent(authResult, this.getClass()));
        }

    	if(authHasToken(authResult)) {
    		
    		sendRedirect(request, response, getDefaultTargetUrl());
    		
    	} else {
    		Writer out = response.getWriter();
    		
            try {
                
        		out.write("{success:true}");
    		
            } catch (IOException e) {
            	logger.error("failed to write to response", e);
            	response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "processing failed");
            } finally {
              out.close();
            }
    	}
        
    }
    
	@Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException failed) throws IOException, ServletException {
        SecurityContextHolder.getContext().setAuthentication(null);

        if (logger.isDebugEnabled()) {
            logger.debug("Updated SecurityContextHolder to contain null Authentication");
        }

        String failureUrl = determineFailureUrl(request, failed);

        if (logger.isDebugEnabled()) {
            logger.debug("Authentication request failed: " + failed.toString());
        }

        try {
            HttpSession session = request.getSession(false);

            if (session != null || getAllowSessionCreation()) {
                request.getSession().setAttribute(SPRING_SECURITY_LAST_EXCEPTION_KEY, failed);
            }
        }
        catch (Exception ignored) {
        }

        onUnsuccessfulAuthentication(request, response, failed);

        getRememberMeServices().loginFail(request, response);
        
        Writer out = response.getWriter();


        if (failureUrl == null) {
            try
            {
              out.write("{success:false, msg: '"+failed.getLocalizedMessage()+"' }");
            }
            catch (IOException e)
            {
              logger.error("failed to write to response", e);
              response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "processing failed");
            }
            finally
            {
              out.close();
            }
        } else if (serverSideRedirect){
            request.getRequestDispatcher(failureUrl).forward(request, response);
        } else {
            sendRedirect(request, response, failureUrl);
        }
    }
	
	private boolean authHasSignature (Authentication auth) {
		
        Boolean authHasSignature = false;
        
        if(auth.getDetails() instanceof HayaWebAuthenticationDetails) {
        	
        	String signature = ((HayaWebAuthenticationDetails) auth.getDetails()).getSignature();
        	
        	if(!Checks.esNulo(signature)) {
        		authHasSignature = true;
        	}
        }
        
        return authHasSignature;	
		
	}
	
	private boolean authHasToken (Authentication auth) {
		
        Boolean authHasToken = false;
        
        if(auth.getDetails() instanceof HayaWebAuthenticationDetails) {
        	
        	String token = ((HayaWebAuthenticationDetails) auth.getDetails()).getIdToken();
        	
        	if(!Checks.esNulo(token)) {
        		authHasToken = true;
        	}
        }
        
        return authHasToken;	
		
	}
    
    /**
     * The session registry needs to be set if session fixation attack protection is in use (and concurrent
     * session control is enabled).
     */

    public void setSessionRegistry(SessionRegistry sessionRegistry) {
        this.sessionRegistry = sessionRegistry;
    }
    
    public void setMigrateInvalidatedSessionAttributes(boolean migrateInvalidatedSessionAttributes) {
        this.migrateInvalidatedSessionAttributes = migrateInvalidatedSessionAttributes;
    }
    
    public void setInvalidateSessionOnSuccessfulAuthentication(boolean invalidateSessionOnSuccessfulAuthentication) {
        this.invalidateSessionOnSuccessfulAuthentication = invalidateSessionOnSuccessfulAuthentication;
    }

    /**
     * Tells if we are to do a server side include of the error URL instead of a 302 redirect.
     *
     * @param serverSideRedirect
     */
    public void setServerSideRedirect(boolean serverSideRedirect) {
        this.serverSideRedirect = serverSideRedirect;
    }
    
    

	

}
