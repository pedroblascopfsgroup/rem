package es.pfsgroup.plugin.log.advanced.manager;

import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.log.advanced.dto.LogAdvancedDto;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;

@Component
public class LogAdvancedManager {

	@Autowired
	CoreProjectContext coreProjectContext;

	@Resource
	private Properties appProperties;

	protected final Log logger = LogFactory.getLog(LogAdvancedManager.class);

	static final String MAP_KEY_PRIORITY = "PRIORITY";
	static final String MAP_KEY_ENTIDADCODE = "ENTIDAD_CODE";
	static final String MAP_KEY_TYPE = "TYPE";
	static final String MAP_KEY_NAMEID = "NAME_ID_PARAMETER";
	static final String MAP_KEY_DESCRIPTION = "DESCRIPTION";
	static final String LOGIN_DESCRIPTION = "Acceso a REM";
	static final String MESSENGER_DESCRIPTION = "Sincronización por mensajería";
	static final String TYPE_LOGIN = "LOGIN";
	static final String ACCES_LOGIN_OK = "OK";
	static final String ACCES_LOGIN_KO = "KO";
	static final String WEB_SERVICE_OK = "OK";
	static final String WEB_SERVICE_KO = "KO";
	static final String ACCES_OK = "OK";
	static final String ACCES_KO = "KO";
	static final String TYPE_WEB_SERVICE = "WEB_SERVICE";
	static final String WEB_SERVICE_DESCRIPTION = "Llamada Web Service";
	static final String PREFIX_RSYSLOG = "[REM_WEB_LOG]";

	public void writeLog(LogAdvancedDto logDto) {
		String rsyslogActive = appProperties.getProperty("rsyslog.rem.active");

		if (!Checks.esNulo(rsyslogActive) && rsyslogActive.equals("true") && !Checks.esNulo(logDto)
				&& !Checks.esNulo(logDto.getMessageRsyslog())) {
			logger.error(PREFIX_RSYSLOG + ":" + logDto.getMessageRsyslog());
		}

	}

}
