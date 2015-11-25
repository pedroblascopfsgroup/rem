package es.pfsgroup.plugin.recovery.mejoras.contrato;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.contrato.dto.MEJBusquedaContratosDto;
import es.pfsgroup.recovery.ext.impl.contrato.model.AtipicoContrato;

public interface MEJContratoApi {
	
	public static final String MEJ_MGR_CONTRATO_ADJUNTOSMAPEADOS = "plugin.mejoras.contrato.getAdjuntosContrato";
	public static final String BO_CNT_MGR_BUSCAR_CONTRATOS_EXPEDIENTE_SIN_ASIGNAR = "plugin.mejoras.contrato.buscarContratosExpedienteSinAsignar";
	public static final String MEJ_BUSCAR_ATIPICOS_CONTRATO = "plugin.mejoras.contrato.getAtipicosContrato";
	
	
	
	@BusinessOperationDefinition(MEJ_MGR_CONTRATO_ADJUNTOSMAPEADOS)
    public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id);
    
	/**
     * Hace la b�squeda de contratos de acuerdo a los filtros que vienen en el DTO.
     * Esta operaci�n sobreescribe la anterior con el control de contratos para la b�squeda de los 
     * Gestores Externos
     * @param dto contiene los filtros de la b�squeda.
     * @return la lista de contratos que cumplen con los filtros.
     * 
     */
	@BusinessOperationDefinition(BO_CNT_MGR_BUSCAR_CONTRATOS_EXPEDIENTE_SIN_ASIGNAR)
	Page buscarContratosExpedienteSinAsignar(DtoBuscarContrato dto);

	/**
	 * PBO: Incorporado al desenchufar referencias a UNNIM
	 */
	public static final String MEJ_CNT_BUSCAR_CONTRATO_SINASIGNAR = "plugin.mejoras.contrato.buscaContratosSinAsignar";
	
    @BusinessOperationDefinition(MEJ_CNT_BUSCAR_CONTRATO_SINASIGNAR)
	public Page buscaContratosSinAsignar(Long idAsunto, MEJBusquedaContratosDto dto);

    @BusinessOperationDefinition(MEJ_BUSCAR_ATIPICOS_CONTRATO)
	public List<AtipicoContrato> getAtipicosContrato(Long idContrato);
    
}
