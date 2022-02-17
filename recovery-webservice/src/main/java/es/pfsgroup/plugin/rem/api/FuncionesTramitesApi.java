package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoTareaPbc;

public interface FuncionesTramitesApi {

	boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna);
	
	boolean isTramiteAprobado(ExpedienteComercial eco);

	void desactivarHistoricoPbc(Long idOferta, String codigoTipoTarea);

	HistoricoTareaPbc createHistoricoPbc(Long idOferta, String codigoTipoTarea);
	
	boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco);
	
}

