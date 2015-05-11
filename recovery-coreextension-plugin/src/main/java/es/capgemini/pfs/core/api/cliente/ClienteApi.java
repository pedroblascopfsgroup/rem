package es.capgemini.pfs.core.api.cliente;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ClienteApi {

	 /**
     * Obtiene un cliente.
     * @param id id del cliente
     * @return entidad cliente
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CLI_MGR_GET_WITH_ESTADOS)
    @Transactional
    public Cliente getWithEstado(Long id);
    
    /**
     * Graba o updatea un cliente.
     * @param cliente cliente.
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CLI_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(Cliente cliente);
}
