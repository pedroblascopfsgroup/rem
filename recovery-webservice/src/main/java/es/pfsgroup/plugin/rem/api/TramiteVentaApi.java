package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface TramiteVentaApi {

	boolean checkAprobadoRechazadoBCPosicionamiento(TareaExterna tareaExterna);

	boolean checkAprobadoRechazadoBC(TareaExterna tareaExterna);

	boolean userHasPermisoParaAvanzarTareas(TareaExterna tareaExterna);


	
	
}

