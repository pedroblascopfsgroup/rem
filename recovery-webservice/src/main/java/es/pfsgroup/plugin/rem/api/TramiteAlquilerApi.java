package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface TramiteAlquilerApi {

	boolean haPasadoScoring(Long idTramite);

	boolean esDespuesElevar(Long idTramite);

	boolean haPasadoScoringBC(Long idTramite);
	
	String tipoTratamientoAlquiler(Long idTramite);

	boolean haPasadoSeguroDeRentas(Long idTramite);

	boolean isOfertaContraOfertaMayor10K(TareaExterna tareaExterna);

	boolean isMetodoActualizacionRelleno(TareaExterna tareaExterna);
	
	
}

