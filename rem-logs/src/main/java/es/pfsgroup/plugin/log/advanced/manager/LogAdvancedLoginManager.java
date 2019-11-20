package es.pfsgroup.plugin.log.advanced.manager;

import org.springframework.security.Authentication;
import org.springframework.security.ui.WebAuthenticationDetails;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.log.advanced.api.LogAdvancedLoginApi;
import es.pfsgroup.plugin.log.advanced.dto.LogAdvancedDto;

@Component
public class LogAdvancedLoginManager extends LogAdvancedManager implements LogAdvancedLoginApi {

	@Override
	public void registerLog(Authentication authentication) {
		final WebAuthenticationDetails details = (WebAuthenticationDetails) authentication.getDetails();
		String msg = TYPE_LOGIN + "|0|0|" + authentication.getName() + "|" + LOGIN_DESCRIPTION + "|"
				+ details.getRemoteAddress().toString() + "|" + details.getSessionId() + "|"
				+ ((authentication.isAuthenticated()) ? ACCES_LOGIN_OK : ACCES_LOGIN_KO);
		// String msgSyslog = "["+TYPE_LOGIN+"]"+" "+LOGIN_DESCRIPTION+"
		// "+((authentication.isAuthenticated())?ACCES_LOGIN_OK:ACCES_LOGIN_KO)+" por el
		// usuario "+authentication.getName()+" con IP:
		// "+details.getRemoteAddress().toString()
		// +", identificador de sesión "+details.getSessionId();
		String msgSyslog = "[" + TYPE_LOGIN + "] |" + authentication.getName() + "|" + LOGIN_DESCRIPTION + "|"
				+ details.getRemoteAddress().toString() + "|" + details.getSessionId() + "|"
				+ ((authentication.isAuthenticated()) ? ACCES_LOGIN_OK : ACCES_LOGIN_KO);
		writeLog(new LogAdvancedDto(msg, 1, msgSyslog));
	}

}
