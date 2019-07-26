package es.pfsgroup.plugin.log.advanced.api;

import java.util.HashMap;

public interface LogAdvancedRem {
	
	public HashMap<String, HashMap<String, HashMap<String, String>>> getRegisterLogAccesDevo();
	public void setRegisterLogAccesDevo(HashMap<String, HashMap<String, HashMap<String, String>>> registerLogAccesDevo);
	
	public HashMap<String, String> getEntidadPadreCartera();
	public void setEntidadPadreCartera(HashMap<String, String> entidadPadreCartera);

}
