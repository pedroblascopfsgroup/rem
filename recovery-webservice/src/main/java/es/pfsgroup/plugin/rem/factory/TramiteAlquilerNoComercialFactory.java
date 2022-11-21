package es.pfsgroup.plugin.rem.factory;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercial;

public interface TramiteAlquilerNoComercialFactory {
	
	TramiteAlquilerNoComercial getTramiteAlquilerNoComercial(String codigo);

	TramiteAlquilerNoComercial getTramiteAlquilerNoComercialByTareaExterna(TareaExterna tareaExterna);
	
}
