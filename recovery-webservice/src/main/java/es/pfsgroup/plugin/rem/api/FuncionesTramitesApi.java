package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

public interface FuncionesTramitesApi {

	boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna);

	boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco);
	
	boolean isTramiteAprobado(ExpedienteComercial eco);
	
}

