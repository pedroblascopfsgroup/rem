package es.pfsgroup.plugin.log.advanced.manager;

import java.util.HashMap;
import java.util.Map;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.ui.WebAuthenticationDetails;
import org.springframework.stereotype.Component;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.plugin.log.advanced.api.LogAdvancedRem;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.log.advanced.api.LogAdvancedBrowseApi;
import es.pfsgroup.plugin.log.advanced.dto.LogAdvancedDto;

@Component
public class LogAdvancedBrowseManager extends LogAdvancedManager implements LogAdvancedBrowseApi {

	@Autowired
	private UsuarioApi usuarioApi;

	@Autowired
	LogAdvancedRem logAdvanceRem;

	@Override
	public void registerLog(String uri, Map<String, Object> parameters) {

		HashMap<String, HashMap<String, String>> mapAccesRegistrer = logAdvanceRem.getRegisterBrowserLog();

		if (!Checks.esNulo(mapAccesRegistrer) && !mapAccesRegistrer.isEmpty()) {
			
			int index = uri.indexOf("/pfs/");
			if(index != -1){
				String uriFormat = uri.substring(index,uri.length());
				HashMap<String, String> mapDataLog = mapAccesRegistrer.get(uriFormat);
				if (!Checks.esNulo(mapDataLog)) {
					
					Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
					UsuarioSecurity userSec = (UsuarioSecurity) authentication.getPrincipal();
					DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					Date date = new Date();
					WebAuthenticationDetails details = (WebAuthenticationDetails) authentication.getDetails();
					//userSec.getEntidad();
					
					
					String msg = mapDataLog.get(MAP_KEY_TYPE) + "|" + mapDataLog.get(MAP_KEY_ENTIDADCODE) + "|"
							+ getIdEntidad(parameters, mapDataLog.get(MAP_KEY_NAMEID)) + "|"
							+ userSec.getUsername() + "|" + mapDataLog.get(MAP_KEY_DESCRIPTION) + "| " + "| "
							+ "| ";
	
					String msgSyslog = dateFormat.format(date)+" | " 
							+ mapDataLog.get(MAP_KEY_TYPE)+": "
							+ mapDataLog.get(MAP_KEY_DESCRIPTION) + " | " 
							+ userSec.getUsername() + " | "
							+ details.getRemoteAddress().toString()+" | "
							+ ACCES_OK+ "|" 
							+ mapDataLog.get(MAP_KEY_ENTIDADCODE) + "|"
							+ getIdEntidad(parameters, mapDataLog.get(MAP_KEY_NAMEID));
					
					writeLog(new LogAdvancedDto(msg, Integer.parseInt(mapDataLog.get(MAP_KEY_PRIORITY)),msgSyslog));
				}
			}
		}

	}

	private String getIdEntidad(Map<String, Object> parameters, String key) {
		if (!Checks.esNulo(key) && !Checks.esNulo(parameters.get(key))) {
			return ((String[]) parameters.get(key))[0];
		} else {
			return "";
		}
	}

}
