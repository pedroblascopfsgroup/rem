package es.capgemini.pfs.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.Authentication;
import org.springframework.security.providers.ProviderManager;
import org.springframework.security.AuthenticationException;

import es.pfsgroup.plugin.log.advanced.api.LogAdvancedLoginApi;

public class PFSProviderManager extends ProviderManager {

	@Autowired
	private LogAdvancedLoginApi logLoginDevoApi;

	@Override
	public Authentication doAuthentication(Authentication authentication) throws AuthenticationException {
		try {
			Authentication auth = super.doAuthentication(authentication);
			logLoginDevoApi.registerLog(auth);
			return auth;
		} catch (AuthenticationException ae) {
			logLoginDevoApi.registerLog(authentication);
			throw ae;
		}
	}

}
