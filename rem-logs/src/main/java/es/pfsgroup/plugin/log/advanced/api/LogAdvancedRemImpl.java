package es.pfsgroup.plugin.log.advanced.api;

import java.util.HashMap;

public class LogAdvancedRemImpl implements LogAdvancedRem{
	
	private HashMap<String, HashMap<String, HashMap<String, String>>> registerLogAccesDevo;
	private HashMap<String, String> entidadPadreCartera;
	
	public HashMap<String, HashMap<String, HashMap<String, String>>> getRegisterLogAccesDevo() {
		return registerLogAccesDevo;
	}

	public void setRegisterLogAccesDevo(HashMap<String, HashMap<String, HashMap<String, String>>> registerLogAccesDevo) {
		this.registerLogAccesDevo = registerLogAccesDevo;
	}
	
	public HashMap<String, String> getEntidadPadreCartera() {
		return entidadPadreCartera;
	}

	public void setEntidadPadreCartera(HashMap<String, String> entidadPadreCartera) {
		this.entidadPadreCartera = entidadPadreCartera;
	}


}
