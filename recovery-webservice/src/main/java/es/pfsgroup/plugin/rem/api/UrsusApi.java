package es.pfsgroup.plugin.rem.api;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.rest.dto.UrsusDto;
import net.sf.json.JSONObject;

public interface UrsusApi {
	public ArrayList<Map<String, Object>> saveOrUpdateNumerosUrsus(List<UrsusDto> informes,JSONObject jsonFields) throws Exception;
}
