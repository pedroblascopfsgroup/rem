package es.pfsgroup.recovery.geninformes.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.geninformes.model.GENINFInformeTPO;

public interface GENINFGenerarEscritosApi {

	public static final String PLUGIN_GENINFORMES_BO_GET_ESCRITOS_BY_TPO = "plugin.geninformes.getEscritosByTPO";

	@BusinessOperationDefinition(PLUGIN_GENINFORMES_BO_GET_ESCRITOS_BY_TPO)
	public List<GENINFInformeTPO> getEscritosByTPO(Long idTipoProc); 
	
}
