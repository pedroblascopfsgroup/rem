package es.pfsgroup.plugin.rem.api;

import java.util.List;

import org.springframework.ui.ModelMap;

import net.sf.json.JSONObject;

public interface AltaAsuntosLegalReoApi {
	
	public final static int TIMEOUT_1_MINUTO = 60;
	public final static int TIMEOUT_30_SEGUNDOS = 30;

	public JSONObject altaAsuntosLegalReo(List<Long> numActivosList, String userName, int segundosTimeout, ModelMap model);

}
