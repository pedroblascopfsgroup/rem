package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.DtoTiposAlquilerNoComercial;

public interface TramiteAlquilerNoComercialApi {

	String aprobarPbcAlquiler(Long idTramite);

	String aprobarScoringBc(Long idTramite);
	
	String aprobarRevisionBcYCondiciones(TareaExterna tareaExterna);

	String avanzaAprobarPbcAlquiler(TareaExterna tareaExterna);

	String getCodigoSubtipoOfertaByIdExpediente(Long idExpediente);

	DtoTiposAlquilerNoComercial getInfoCaminosAlquilerNoComercial(Long idExpediente);
	
}

