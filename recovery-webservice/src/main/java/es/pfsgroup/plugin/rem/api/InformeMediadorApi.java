package es.pfsgroup.plugin.rem.api;

import java.beans.IntrospectionException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;

public interface InformeMediadorApi {

	public boolean existeInformemediadorActivo(Long numActivo);

	public void validateInformeField(HashMap<String, String> errorsList, String fiedlName, Object fieldValor,
			String codigoTipoBien);

	public void validateInformeMediadorDto(InformeMediadorDto informe, String codigoTipoBien, HashMap<String, String> errorsList)
			throws IntrospectionException, IllegalAccessException, IllegalArgumentException, InvocationTargetException;

	public ArrayList<Map<String, Object>> saveOrUpdateInformeMediador(List<InformeMediadorDto> informes)
			throws Exception;
}
