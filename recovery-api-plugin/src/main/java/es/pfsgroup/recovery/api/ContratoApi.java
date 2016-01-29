package es.pfsgroup.recovery.api;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ContratoApi {

	/**
     * Devuelve una lista con el contrato de pase del expediente.
     * @param dto dto de busqueda
     * @return una lista con el contrato de pase.
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CONTRATOS_EXPEDIENTE)
    public Page buscarContratosExpediente(DtoBuscarContrato dto);
    
    /**
     * Busca expedientes para un contrato determinado.
     *
     * @param idContrato idContrato
     * @return List
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_GET)
    public Contrato get(Long idContrato);
    
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_GET_RECIBOS_DE_CONTRATO)
    public Page getRecibosContrato(Long idContrato);

    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_GET_DISPOSICIONES_DE_CONTRATO)
    public Page getDisposicionesContrato(Long idContrato);

    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_GET_EFECTOS_DE_CONTRATO)
    public Page getEfectosContrato(Long idContrato);
}
