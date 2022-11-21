package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

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

	boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna);
	
	void irClRod(ExpedienteComercial eco);

	String checkGarantiasNinguna(TareaExterna tareaExterna, String valor);

	boolean expedienteTieneRiesgo(Long idExpediente);

	boolean siUsuarioTieneFuncionAvanzarPBC();
	
	boolean getRespuestaHistReagendacionMayor(TareaExterna tareaExterna);

	void actualizarSituacionComercial(List<ActivoOferta> activosOferta, Activo activo, Long ecoId);

	void actualizarSituacionComercialUAs(Activo activo);

	void actualizarEstadoPublicacionUAs(Activo activo);

	boolean modificarFianza(ExpedienteComercial eco);

	boolean estanCamposRellenosParaFormalizacion(ExpedienteComercial eco);	
}

