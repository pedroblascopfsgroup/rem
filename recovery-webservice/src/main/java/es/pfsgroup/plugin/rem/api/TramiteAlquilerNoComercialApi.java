package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface TramiteAlquilerNoComercialApi {

	String aprobarAnalisisBc(Long idTramite);

	String aprobarPbcAlquiler(Long idTramite);

	String aprobarScoringBc(Long idTramite);
	
	String aprobarRevisionBcYCondiciones(Long idTramite);	
	
}

