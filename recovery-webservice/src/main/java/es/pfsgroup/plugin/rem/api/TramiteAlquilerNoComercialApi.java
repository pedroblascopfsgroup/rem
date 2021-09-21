package es.pfsgroup.plugin.rem.api;

public interface TramiteAlquilerNoComercialApi {

	String aprobarAnalisisBc(Long idTramite);

	String aprobarPbcAlquiler(Long idTramite);

	String aprobarScoringBc(Long idTramite);
	
	String aprobarRevisionBcYCondiciones(Long idTramite);
}

