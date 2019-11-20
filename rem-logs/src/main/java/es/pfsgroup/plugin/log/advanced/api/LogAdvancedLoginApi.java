package es.pfsgroup.plugin.log.advanced.api;

import org.springframework.security.Authentication;


public interface LogAdvancedLoginApi {
	
	public void registerLog(Authentication authentication);

}