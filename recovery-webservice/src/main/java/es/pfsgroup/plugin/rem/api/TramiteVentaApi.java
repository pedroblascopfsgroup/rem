package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface TramiteVentaApi {

	boolean checkAprobadoRechazadoBCPosicionamiento(TareaExterna tareaExterna);

	boolean checkAprobadoRechazadoBC(TareaExterna tareaExterna);

	boolean userHasPermisoParaAvanzarTareas(TareaExterna tareaExterna);

	boolean isTramiteT017Aprobado(List<String> tareasActivas);

	boolean tieneFechaVencimientoReserva(TareaExterna tareaExterna);


	
	
}

