package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

public interface TramiteVentaApi {

	boolean checkAprobadoRechazadoBCPosicionamiento(TareaExterna tareaExterna);

	boolean checkAprobadoRechazadoBC(TareaExterna tareaExterna);

	boolean userHasPermisoParaAvanzarTareas(TareaExterna tareaExterna);

	boolean isTramiteT017Aprobado(List<String> tareasActivas);

	boolean tieneFechaVencimientoReserva(TareaExterna tareaExterna);

	boolean checkArrasEstadoBCIngreso(TareaExterna tareaExterna);

	void guardarEstadoAnulacionExpedienteBK(Long ecoId);

	boolean tieneReservaPrevia(TareaExterna tareaExterna);

	boolean checkFechaContabilizacionArras(TareaExterna tareaExterna);

	boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco);

}

