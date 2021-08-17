package es.pfsgroup.plugin.rem.security;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationCredentialsNotFoundException;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationServiceException;
import org.springframework.security.BadCredentialsException;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.providers.dao.AbstractUserDetailsAuthenticationProvider;
import org.springframework.security.ui.WebAuthenticationDetails;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UserDetailsService;
import org.springframework.security.userdetails.UsernameNotFoundException;
import org.springframework.util.Assert;

import com.nimbusds.jwt.JWT;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.JWTParser;

import es.capgemini.devon.security.AuthenticationFilter;
import es.capgemini.devon.security.SecurityUserInfo;
import es.pfsgroup.plugin.rem.security.jupiter.IntegracionJupiterApi;
import net.sf.json.JSONObject;

public class HayaAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {

	private UserDetailsService userDetailsService;
	private boolean includeDetailsObject = true;

	private List<AuthenticationFilter> preAuthenticationFilters = new ArrayList<AuthenticationFilter>();
	private List<AuthenticationFilter> postAuthenticationFilters = new ArrayList<AuthenticationFilter>();
	
	private static final String AUTH_USERNAME_REGEX = "haya.auth.username.regex";
	private static final String AUTH_KEY_SIGNATURE = "haya.auth.key.signature";
	
	private static final String AUTH2_SERVER_URL = "haya.auth2.server.url";
	private static final String AUTH2_SERVER_CLIENT_ID = "haya.auth2.server.param.client_id";
	private static final String AUTH2_SERVER_REDIRECT_URI = "haya.auth2.server.param.redirect_uri";
	private static final String AUTH2_SERVER_RESOURCE = "haya.auth2.server.param.resource";
	private static final String AUTH2_SERVER_GRANT_TYPE = "haya.auth2.server.param.grant_type";
	private static final String AUTH2_SERVER_CLIENT_SECRET = "haya.auth2.server.param.client_secret";
	private static final String AUTH2_SERVER_SCOPE = "haya.auth2.server.param.scope";

	private static final String AUTH2_ERROR_BAD_CREDENTIALS = "AbstractUserDetailsAuthenticationProvider.badCredentials";
	private static final String AUTH2_ERROR_INVALID_TOKEN = "AbstractUserDetailsAuthenticationProvider.invalidToken";
	// private static final String AUTH2_ERROR_MALFORMED_URL = "AbstractUserDetailsAuthenticationProvider.malformedURL";
	
	private static final Log logger = LogFactory.getLog(HayaAuthenticationProvider.class);
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private IntegracionJupiterApi integracionJupiterManager;

	public static void main(String[] args) throws NoSuchAlgorithmException, UnsupportedEncodingException {
		
		if ((args == null) || (args.length <= 0)){
			System.err.println("Por favor, indica el user_id como primer parámetro.");
			System.exit(1);
		}
		
		String stringToHash = String.format("%s|%s|%3$tY%3$tm%3$td", "Hams18127!???18273gasfgkdagi1yula", args[0], new Date());
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		String hash = new String(Hex.encodeHex(md.digest(stringToHash.getBytes("UTF-8"))));
		System.out.println(hash);
	}
	

	public Authentication authenticate(Authentication authentication) throws AuthenticationException {

		Assert.isInstanceOf(HayaWebAuthenticationDetails.class, authentication.getDetails(), "HayaAuthenticationProvider Only HayaWebAuthenticationDetails is supported");

		HayaWebAuthenticationDetails authDetails = (HayaWebAuthenticationDetails) authentication.getDetails();
	    
		logger.info("OAuth2: code >" + authDetails.getCode() + "<");
		
		String baseUrl = authDetails.getBaseUrl();
		
		// Determine username 
		String username = "NONE_PROVIDED";
		String idToken = null;
		String accessToken = null;
				
		if (authDetails.getCode() != null) {
			
		    HttpClient httpClient = new HttpClient();
		    PostMethod postMethod = new PostMethod(appProperties.getProperty(AUTH2_SERVER_URL));
		    postMethod.addParameter("client_id", appProperties.getProperty(AUTH2_SERVER_CLIENT_ID));
		    if (baseUrl == null || "".equals(baseUrl)) {
		    	postMethod.addParameter("redirect_uri", appProperties.getProperty(AUTH2_SERVER_REDIRECT_URI));
		    } else {
		    	baseUrl = baseUrl.replaceFirst("http://", "https://");
		    	postMethod.addParameter("redirect_uri", baseUrl);
		    }
		    postMethod.addParameter("resource", appProperties.getProperty(AUTH2_SERVER_RESOURCE));
		    postMethod.addParameter("grant_type", appProperties.getProperty(AUTH2_SERVER_GRANT_TYPE));
			postMethod.addParameter("client_secret", appProperties.getProperty(AUTH2_SERVER_CLIENT_SECRET));
			postMethod.addParameter("scope", appProperties.getProperty(AUTH2_SERVER_SCOPE));
			postMethod.addParameter("code", authDetails.getCode());

			//Seteamos el máximo de reintentos a tres
			postMethod.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler(3, false));

			try {
		    	int statusCode = httpClient.executeMethod(postMethod);
		    	logger.info("OAuth2: statusCode >" + statusCode + "<");
		    	
		        if (statusCode != HttpStatus.SC_OK) {
		        	throw new ParseException(messages.getMessage(AUTH2_ERROR_BAD_CREDENTIALS),0);
		        }

		        byte[] responseBody = postMethod.getResponseBody();
		        String stringBody = new String(responseBody);
		        JSONObject response = JSONObject.fromObject(stringBody);
		    	
				idToken = (String) response.get("id_token");
				logger.info("OAuth2: idToken >" + idToken + "<");
				
				authDetails.setIdToken(idToken);
				JWT jwt = JWTParser.parse(idToken);
	            Map<String, Object> claims = jwt.getJWTClaimsSet().getClaims();
				String upn = (String) claims.get("upn");
				
	            logger.info("OAuth2: upn >" + upn + "<");
	            username = upn.split("@")[0];
	            logger.debug("OAuth2: username >" + username + "<");
	            
	            //Obtener el resto de los datos a partir del access_token
	            accessToken = (String) response.get("access_token");
	            JWTClaimsSet claimSetAccess = JWTParser.parse(accessToken).getJWTClaimsSet();
	            
	            String nombre = claimSetAccess.getStringClaim("given_name"); 
	            String apellidos = claimSetAccess.getStringClaim("family_name"); 
	            String email = claimSetAccess.getStringClaim("email"); 
	            
	            logger.debug("OAuth2: nombre >" + nombre + "<");
	            logger.debug("OAuth2: apellidos >" + apellidos + "<");
	            logger.debug("OAuth2: email >" + email + "<");

	            integracionJupiterManager.setDBContext();
	            integracionJupiterManager.actualizarInfoPersonal(username, nombre, apellidos, email);

	            String perfilesrem = claimSetAccess.getStringClaim("perfilrem");
	            if (perfilesrem == null || "".contentEquals(perfilesrem)) {
	            	perfilesrem = claimSetAccess.getStringClaim("perfilprerem"); // Los perfiles en pre vienen en otra clave del mapa
	            }
	            logger.debug("OAuth2: perfilesrem >" + perfilesrem + "<");
	            
	            integracionJupiterManager.actualizarRolesDesdeJupiter(username, perfilesrem);
				
			} catch (ParseException e) {
				throw new AuthenticationCredentialsNotFoundException(messages.getMessage(AUTH2_ERROR_INVALID_TOKEN));
			} catch (IOException e) {
				throw new AuthenticationCredentialsNotFoundException(messages.getMessage(AUTH2_ERROR_BAD_CREDENTIALS));
			} catch (Exception e) {
				logger.debug("OAuth2: " + e.getMessage());
				e.printStackTrace();
			}
		}

		
		if (authDetails.getUserId() != null) {
			username = authDetails.getUserId().replace(appProperties.getProperty(AUTH_USERNAME_REGEX), "");			
		}

		boolean cacheWasUsed = true;
		UserDetails user = getUserCache().getUserFromCache(username);	

		if (user == null) {
			cacheWasUsed = false;

			try {
				
				user = retrieveUser(username, (UsernamePasswordAuthenticationToken) authentication);
				
			} catch (UsernameNotFoundException notFound) {
				if (hideUserNotFoundExceptions) {
					throw new BadCredentialsException(messages.getMessage(AUTH2_ERROR_BAD_CREDENTIALS, "Bad credentials"));
				} else {
					throw notFound;
				}
			}

			Assert.notNull(user, "retrieveUser returned null - a violation of the interface contract");
		}

		try {
			getPreAuthenticationChecks().check(user);
			additionalAuthenticationChecks(user, (UsernamePasswordAuthenticationToken) authentication);
		} catch (AuthenticationException exception) {
			if (cacheWasUsed) {
				// There was a problem, so try again after checking
				// we're using latest data (i.e. not from the cache)
				cacheWasUsed = false;
				user = retrieveUser(username, (UsernamePasswordAuthenticationToken) authentication);
				getPreAuthenticationChecks().check(user);
				additionalAuthenticationChecks(user, (UsernamePasswordAuthenticationToken) authentication);
			} else {
				throw exception;
			}
		}

		getPostAuthenticationChecks().check(user);

		if (!cacheWasUsed) {
			getUserCache().putUserInCache(user);
		}

		Object principalToReturn = user;

		if (isForcePrincipalAsString()) {
			principalToReturn = user.getUsername();
		}

		return createSuccessAuthentication(principalToReturn, authentication, user);
	}

	@Override
	protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
		doPreAuthenticationChecks(userDetails, authentication);
		doPostAuthenticationChecks(userDetails, authentication);
	}

	protected void doPreAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
		for (AuthenticationFilter filter : preAuthenticationFilters) {
			filter.check(userDetails, authentication);
		}
	}

	protected void doAuthenticationCheck(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
		HayaWebAuthenticationDetails authDetails = (HayaWebAuthenticationDetails) authentication.getDetails();

		
		if (authDetails.getSignature() == null || authDetails.getIdToken() == null || authDetails.getCode() == null) {
			throw new AuthenticationCredentialsNotFoundException(messages.getMessage(AUTH2_ERROR_BAD_CREDENTIALS));
		}

		String claveHashREM = appProperties.getProperty(AUTH_KEY_SIGNATURE);
		
		String stringToHash = String.format("%s|%s|%3$tY%3$tm%3$td", claveHashREM, authDetails.getUserId(), new Date());

		String hash = null;
		try {

			MessageDigest md = MessageDigest.getInstance("SHA-256");
			hash = new String(Hex.encodeHex(md.digest(stringToHash.getBytes("UTF-8"))));

		} catch (NoSuchAlgorithmException e) {
			throw new AuthenticationCredentialsNotFoundException(messages.getMessage(AUTH2_ERROR_BAD_CREDENTIALS));
		} catch (UnsupportedEncodingException e) {
			throw new AuthenticationCredentialsNotFoundException(messages.getMessage(AUTH2_ERROR_BAD_CREDENTIALS));
		}

		if (!authDetails.getSignature().equals(hash)) {
			throw new AuthenticationCredentialsNotFoundException(messages.getMessage(AUTH2_ERROR_BAD_CREDENTIALS));
		}
	}

	protected void doPostAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
		for (AuthenticationFilter filter : postAuthenticationFilters) {
			filter.check(userDetails, authentication);
		}
	}

	@Override
	protected UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
		UserDetails loadedUser;

		try {
			loadedUser = this.getUserDetailsService().loadUserByUsername(username);

			if (loadedUser == null) {
				throw new AuthenticationServiceException("UserDetailsService returned null, which is an interface contract violation");
			}

			WebAuthenticationDetails ad = (WebAuthenticationDetails) authentication.getDetails();
			((SecurityUserInfo) loadedUser).setLoginTime(System.currentTimeMillis());

			if (ad != null) {
				((SecurityUserInfo) loadedUser).setRemoteAddress(ad.getRemoteAddress());
			}

		} catch (DataAccessException repositoryProblem) {
			throw new AuthenticationServiceException(repositoryProblem.getMessage(), repositoryProblem);
		}

		return loadedUser;
	}

	/**
	 * @param preAuthenticationFilters
	 *            the preAuthenticationFilters to set
	 */
	public void setPreAuthenticationFilters(List<AuthenticationFilter> preAuthenticationFilters) {
		this.preAuthenticationFilters = preAuthenticationFilters;
	}

	
	@Override
	protected void doAfterPropertiesSet() throws Exception {
		Assert.notNull(this.userDetailsService, "A UserDetailsService must be set");
	}

	public void setPostAuthenticationFilters(List<AuthenticationFilter> postAuthenticationFilters) {
		this.postAuthenticationFilters = postAuthenticationFilters;
	}

	public void setUserDetailsService(UserDetailsService userDetailsService) {
		this.userDetailsService = userDetailsService;
	}

	protected UserDetailsService getUserDetailsService() {
		return userDetailsService;
	}

	protected boolean isIncludeDetailsObject() {
		return includeDetailsObject;
	}

	private String toHexString(byte[] bytes) {
	    StringBuilder hexString = new StringBuilder();

	    for (int i = 0; i < bytes.length; i++) {
	        String hex = Integer.toHexString(0xFF & bytes[i]);
	        if (hex.length() == 1) {
	            hexString.append('0');
	        }
	        hexString.append(hex);
	    }

	    return hexString.toString();
	}
}
