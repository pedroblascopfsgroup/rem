package es.pfsgroup.plugin.log.advanced.api;

import java.util.HashMap;

public class LogAdvancedRemImpl implements LogAdvancedRem{
	
	private HashMap<String, HashMap<String, String>> registerBrowserLog;

	public HashMap<String, HashMap<String, String>> getRegisterBrowserLog() {
		return registerBrowserLog;
	}

	public void setRegisterBrowserLog(HashMap<String, HashMap<String, String>> registerBrowserLog) {
		this.registerBrowserLog = registerBrowserLog;
	}
	

}
