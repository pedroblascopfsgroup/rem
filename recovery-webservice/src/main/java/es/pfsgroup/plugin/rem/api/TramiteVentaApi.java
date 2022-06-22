package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.DtoDocPostVenta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

import java.util.List;

public interface TramiteVentaApi {

	boolean checkAprobadoRechazadoBCPosicionamiento(TareaExterna tareaExterna);

	boolean checkAprobadoRechazadoBC(TareaExterna tareaExterna);

	boolean userHasPermisoParaAvanzarTareas(TareaExterna tareaExterna);

	boolean tieneFechaVencimientoReserva(TareaExterna tareaExterna);

	boolean checkArrasEstadoBCIngreso(TareaExterna tareaExterna);

	void guardarEstadoAnulacionExpedienteBK(Long ecoId);

	boolean tieneReservaPrevia(TareaExterna tareaExterna);

	boolean checkFechaContabilizacionArras(TareaExterna tareaExterna);

	DtoDocPostVenta getDatosDocPostventa(Long idExpediente);

	boolean isTramiteT017Aprobado(ExpedienteComercial eco);
	
	boolean isExpedienteAntesAprobadoT013(DDEstadosExpedienteComercial estado);

}

