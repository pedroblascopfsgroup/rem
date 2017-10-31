package es.pfsgroup.plugin.rem.security;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.Hex;
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

import es.capgemini.devon.security.AuthenticationFilter;
import es.capgemini.devon.security.SecurityUserInfo;

public class HayaAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {

	private UserDetailsService userDetailsService;
	private boolean includeDetailsObject = true;

	private List<AuthenticationFilter> preAuthenticationFilters = new ArrayList<AuthenticationFilter>();
	private List<AuthenticationFilter> postAuthenticationFilters = new ArrayList<AuthenticationFilter>();

	@Resource
	private Properties appProperties;

	public Authentication authenticate(Authentication authentication) throws AuthenticationException {

		Assert.isInstanceOf(HayaWebAuthenticationDetails.class, authentication.getDetails(), "HayaAuthenticationProvider Only HayaWebAuthenticationDetails is supported");

		HayaWebAuthenticationDetails authDetails = (HayaWebAuthenticationDetails) authentication.getDetails();

		// Determine username -> CISA.0\\gc.flescano
		String username = "NONE_PROVIDED";
		if (authDetails.getUserId() != null) {
			String[] split = authDetails.getUserId().split(Pattern.quote("."));
			if (split.length > 2) {
				username = split[2];
			}
		}

		boolean cacheWasUsed = true;
		UserDetails user = getUserCache().getUserFromCache(username);

		if (user == null) {
			cacheWasUsed = false;

			try {
				user = retrieveUser(username, (UsernamePasswordAuthenticationToken) authentication);
			} catch (UsernameNotFoundException notFound) {
				if (hideUserNotFoundExceptions) {
					throw new BadCredentialsException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials", "Bad credentials"));
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

		doAuthenticationCheck(userDetails, authentication);

		doPostAuthenticationChecks(userDetails, authentication);
	}

	protected void doPreAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
		for (AuthenticationFilter filter : preAuthenticationFilters) {
			filter.check(userDetails, authentication);
		}
	}

	protected void doAuthenticationCheck(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
		HayaWebAuthenticationDetails authDetails = (HayaWebAuthenticationDetails) authentication.getDetails();

		if (authDetails.getSignature() == null || authDetails.getIdToken() == null) {
			throw new AuthenticationCredentialsNotFoundException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials"));
		}

		/*
		 * if (appProperties.getProperty("claveHashREM")) {
		 * 
		 * }
		 */

		// TODO
		String claveHashREM = "Hams18127!???18273gasfgkdagi1yula";
		
		String stringToHash = String.format("%s|%s|%3$tY%3$tm%3$td", claveHashREM, authDetails.getUserId(), new Date());

		String hash = null;
		try {

			MessageDigest md = MessageDigest.getInstance("SHA-256");
			hash = new String(Hex.encodeHex(md.digest(stringToHash.getBytes("UTF-8"))));

		} catch (NoSuchAlgorithmException e) {
			throw new AuthenticationCredentialsNotFoundException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials"));
		} catch (UnsupportedEncodingException e) {
			throw new AuthenticationCredentialsNotFoundException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials"));
		}

		if (!authDetails.getSignature().equals(hash)) {
			throw new AuthenticationCredentialsNotFoundException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials"));
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
