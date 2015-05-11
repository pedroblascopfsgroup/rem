package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.controller;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;

public interface SubastaOnlineApi {

	public static final String BO_NMB_SUBASTA_BUSCAR_LOTES_GUARDAR_ESTADO = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.guardaEstadoLoteSubasta";
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_BUSCAR_LOTES_GUARDAR_ESTADO)
	void guardaEstadoLoteSubasta(Long[] idLotes, DDEstadoLoteSubasta estado, String codMotivoSuspSubasta, String observaciones);
	
}
