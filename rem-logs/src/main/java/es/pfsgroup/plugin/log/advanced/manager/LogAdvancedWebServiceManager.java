package es.pfsgroup.plugin.log.advanced.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.plugin.log.advanced.api.LogAdvancedWebServiceApi;
import es.pfsgroup.plugin.log.advanced.dto.LogAdvancedDto;
import es.pfsgroup.plugin.log.advanced.dto.LogDevoWebServiceDto;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;

@Component
public class LogAdvancedWebServiceManager extends LogAdvancedManager implements LogAdvancedWebServiceApi {

	@Autowired
	private UsuarioApi usuarioApi;

	@Autowired
	CoreProjectContext coreProjectContext;

	@Override
	public void registerLog(LogDevoWebServiceDto dto) {
		String user = usuarioApi.getUsuarioLogado().getUsername();
		String msg = TYPE_WEB_SERVICE + "|" + dto.getWebServiceName() + "| |" + user + "|" + WEB_SERVICE_DESCRIPTION
				+ "| | |" + ((dto.isResultOK()) ? WEB_SERVICE_OK : WEB_SERVICE_KO); 
		// String msgSyslog ="["+TYPE_WEB_SERVICE+"]"+" Llamada al webservice"+dto.getWebServiceName()+"realizada por el usuario "+user+" con resultado
							// "+((dto.isResultOK())?WEB_SERVICE_OK:WEB_SERVICE_KO);
		String msgSyslog = "[" + TYPE_WEB_SERVICE + "] |" + dto.getWebServiceName() + "|" + user + "|"
				+ WEB_SERVICE_DESCRIPTION + "|" + ((dto.isResultOK()) ? WEB_SERVICE_OK : WEB_SERVICE_KO);
		writeLog(new LogAdvancedDto(msg, 1, msgSyslog));
	}

}
