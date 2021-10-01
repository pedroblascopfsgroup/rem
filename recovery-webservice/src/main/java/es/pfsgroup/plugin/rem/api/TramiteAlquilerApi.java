package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface TramiteAlquilerApi {

	boolean haPasadoScoring(Long idTramite);

	boolean esDespuesElevar(Long idTramite);

	boolean haPasadoScoringBC(Long idTramite);
	
	String tipoTratamientoAlquiler(Long idTramite);

	boolean haPasadoSeguroDeRentas(Long idTramite);

	boolean isOfertaContraOfertaMayor10K(TareaExterna tareaExterna);

	boolean isMetodoActualizacionRelleno(TareaExterna tareaExterna);

	boolean haPasadoAceptacionCliente(Long idTramite);
	
	boolean checkAvalCondiciones(TareaExterna tareaExterna);
	
	boolean checkSeguroRentasCondiciones(TareaExterna tareaExterna);

	boolean validarMesesImporteDeposito(TareaExterna tareaExterna);

	boolean isTramiteT015Aprobado(List<String> tareasActivas);
	
	
}

