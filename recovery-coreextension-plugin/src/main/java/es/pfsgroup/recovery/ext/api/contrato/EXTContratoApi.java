package es.pfsgroup.recovery.ext.api.contrato;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.api.contrato.model.EXTInfoAdicionalContratoInfo;
import es.pfsgroup.recovery.ext.api.contrato.dto.EXTBusquedaContratosDto;

public interface EXTContratoApi {
	
	public static final String EXT_BO_CNT_GETINFO_BY_TIPO = "es.pfsgroup.recovery.ext.api.contrato.getInfoAdicionalContratoByTipo";
	public static final String EXT_BO_CNT_GETCNT_CON_INFO = "es.pfsgroup.recovery.ext.api.contrato.findContratosConInfoAdicional";
	
	
	@BusinessOperationDefinition(EXT_BO_CNT_GETINFO_BY_TIPO)
	EXTInfoAdicionalContratoInfo getInfoAdicionalContratoByTipo(long idContrato, String codigoTipo );


	@BusinessOperationDefinition(EXT_BO_CNT_GETCNT_CON_INFO)
	List<Long> findIdContratosConInfoAdicional(EXTInfoAdicionalContratoInfo iac);
	
	/**
     * Hace la b�squeda de contratos de acuerdo a los filtros que vienen en el DTO.
     * Esta operaci�n sobreescribe la anterior con el control de contratos para la b�squeda de los 
     * Gestores Externos
     * @param dto contiene los filtros de la b�squeda.
     * @return la lista de contratos que cumplen con los filtros.
     * 
     */
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CONTRATOS)
	Page buscarContratos(BusquedaContratosDto dto);

	/**
	 * PBO: 28/11/12
	 * Se usaba acoplado desde el plugin de UNNIM.
	 * Se copia desde el plugin de UNNIM y se adapta para poder desenchufarlo
	 */
	public static final String EXT_BO_CNT_BUSCAR_CONTRATO_AVANZADO = "es.pfsgroup.recovery.ext.api.contrato.buscarContratos";
	@BusinessOperationDefinition(EXT_BO_CNT_BUSCAR_CONTRATO_AVANZADO)
	Page buscarContratosAvanzado(EXTBusquedaContratosDto dto);

	public Page getEfectosContrato(Long idContrato, Integer start, Integer limit);
}
