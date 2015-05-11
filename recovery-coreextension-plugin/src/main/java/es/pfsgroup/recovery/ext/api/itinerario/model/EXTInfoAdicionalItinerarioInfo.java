package es.pfsgroup.recovery.ext.api.itinerario.model;

import es.capgemini.pfs.itinerario.model.Itinerario;

public interface EXTInfoAdicionalItinerarioInfo {
	
	Itinerario getItinerario();
	
	EXTDDTipoInfoAdicionalItinerarioInfo getTipoInfoAdicional();
	
	String getValue();

}
