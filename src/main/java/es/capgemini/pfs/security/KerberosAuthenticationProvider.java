package es.capgemini.pfs.security;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationServiceException;
import org.springframework.security.BadCredentialsException;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.devon.security.DevonAuthenticationProvider;

public class KerberosAuthenticationProvider extends DevonAuthenticationProvider {

	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Resource
	private KerberosAuthenticationFacade facadeKerberos;
	 
	@Override
    protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication)
            throws AuthenticationException {

//		logger.info("additionalAuthenticationChecks");

//       	System.out.println("additionalAuthenticationChecks 1 authentication: " + authentication.getAuthorities());
//       	System.out.println("additionalAuthenticationChecks 1 userDetails: " + userDetails.getAuthorities());

       	doPreAuthenticationChecks(userDetails, authentication);

        // Debemos empaquetar el objeto HttpServlet en los webdetails (authentication) para pasarlo a la Facade de Kerberos
        KerberosWebAuthenticationDetails ad = (KerberosWebAuthenticationDetails) authentication.getDetails();
        HttpServletRequest request = ad.getRequest();

//        System.out.println("additionalAuthenticationChecks 2 authentication: " + authentication.getAuthorities());
//       	System.out.println("additionalAuthenticationChecks 2 userDetails: " + userDetails.getAuthorities());

		if (request == null){
			logger.error("No se puede recuperar la petición Http");
			throw new AuthenticationServiceException("No se puede recuperar la petición Http");
		}
       	facadeKerberos.checkAuthentication(userDetails, request);
        
//       	System.out.println("additionalAuthenticationChecks 3 authentication: " + authentication.getAuthorities());
//       	System.out.println("additionalAuthenticationChecks 3 userDetails: " + userDetails.getAuthorities());
       	
       	doPostAuthenticationChecks(userDetails, authentication);

	}


    /**
     * Sobreescrito para obtener el usuario según los requerimientos de Kerberos
     * 
     * @param username
     * @param authentication
     * @return
     * @throws AuthenticationException
     * @see {@link RSIWebAuthenticationDetails}
     */
    @Override
    protected UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        
		//logger.info("retrieveUser");

    	UserDetails loadedUser = null;
    	
        KerberosWebAuthenticationDetails ad = (KerberosWebAuthenticationDetails) authentication.getDetails();
        HttpServletRequest request = ad.getRequest();

		if (request == null){
			logger.error("No se puede recuperar la petición Http");
			throw new AuthenticationServiceException("No se puede recuperar la petición Http");
		}

    	//Obtener los detalles de autenticacion, de la manera particular de Kerberos
    	KerberosUserDetailsService service = (KerberosUserDetailsService) this.getUserDetailsService();
    	if (service == null) {
    		service = new KerberosUserDetailsService();
    	}
    	facadeKerberos.setRequest(request);
   		service.setFacadeKerberos(facadeKerberos);
    	String workingCode = ad.getWorkingCode();
    	
    	//logger.info("retrieveUser " + username);
    	String kUsername = facadeKerberos.getUsername(username, request);
		//logger.info("retrieveUser " + kUsername);
    	
		KerberosUserDetails authDetails;
		if (workingCode != null && !workingCode.equals("")) {
			authDetails = service.loadUserByUsernameAndEntity(kUsername, workingCode);
		} else {
			authDetails = service.loadUserByUsername(kUsername);
		}
        if (authDetails == null) {
            throw new AuthenticationServiceException("KerberosDetailsService retorna null, lo cual es una violacion del contrato de interface");
        }
        loadedUser = authDetails.getUserDetails();
        
        return loadedUser;
 
    }
}
