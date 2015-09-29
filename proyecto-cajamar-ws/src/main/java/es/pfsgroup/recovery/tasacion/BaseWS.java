package es.pfsgroup.recovery.tasacion;

import java.util.Properties;

import javax.annotation.Resource;

public abstract class BaseWS {

	@Resource
	private Properties appProperties;
	
	public abstract String getWSName();
	
	public String getWSNamespace() {
		return appProperties.getProperty(String.format("ws.namespace"));
	}

	public String getWSURL() {
		return appProperties.getProperty(String.format("ws.%s.location", getWSName()));
	}

}
