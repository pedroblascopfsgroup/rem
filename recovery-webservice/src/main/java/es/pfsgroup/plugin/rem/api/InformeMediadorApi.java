package es.pfsgroup.plugin.rem.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;
import net.sf.json.JSONObject;

public interface InformeMediadorApi {

	public boolean existeInformemediadorActivo(Long numActivo) throws Exception;

	public void validateInformeField(HashMap<String, String> errorsList, String fiedlName, Object fieldValor,
			String codigoTipoBien) throws Exception;

	public void validateInformeMediadorDto(InformeMediadorDto informe, String codigoTipoBien, HashMap<String, String> errorsList)
			throws Exception;

	public ArrayList<Map<String, Object>> saveOrUpdateInformeMediador(List<InformeMediadorDto> informes,JSONObject jsonFields)
			throws Exception;
}
