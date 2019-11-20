package es.pfsgroup.plugin.log.advanced.api;

import java.util.HashMap;

public interface LogAdvancedRem {
	
	public HashMap<String, HashMap<String, String>> getRegisterBrowserLog();
	public void setRegisterBrowserLog(HashMap<String, HashMap<String, String>> registerBrowserLog);

}
