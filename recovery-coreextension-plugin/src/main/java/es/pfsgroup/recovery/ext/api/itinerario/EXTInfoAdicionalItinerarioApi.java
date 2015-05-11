package es.pfsgroup.recovery.ext.api.itinerario;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.api.itinerario.model.EXTInfoAdicionalItinerarioInfo;

public interface EXTInfoAdicionalItinerarioApi {
	
	String EXT_BO_ITI_GET_INFO_ADD_BYTIPO = "es.pfsgroup.recovery.ext.api.itinerario.getByTipo";

	@BusinessOperationDefinition(EXT_BO_ITI_GET_INFO_ADD_BYTIPO)
	EXTInfoAdicionalItinerarioInfo getInfoAdicionalItinerarioByTipo(Long idItinerario, String codigo);

}
