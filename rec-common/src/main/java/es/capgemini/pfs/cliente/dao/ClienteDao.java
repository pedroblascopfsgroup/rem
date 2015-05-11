package es.capgemini.pfs.cliente.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Cliente DAO.
 * @author jbosnjak
 *
 */
public interface ClienteDao extends AbstractDao<Cliente, Long> {

    /**
     * Retorna paginado los clientes que cumplan con los parámetros pasados.
     * @param clientes DtoBuscarClientes Campos con los que tiene que coincidir la búsqueda
     * @return Page página con los clientes
     */
    Page findClientesPaginated(DtoBuscarClientes clientes);

    /**
     * Retorna paginado los clientes que cumplan con los parámetros pasados.
     * @param clientToFind String
     * @param tableParams PaginationParams
     * @return Page página con los clientes
    */
    Page findByName(String clientToFind, PaginationParams tableParams);

    /**
     * busca clientes por un id de contrato.
     * @param idContrato id de contrato
     * @return clientes
     */
    List<Cliente> findClientesByContrato(Long idContrato);

    /**
     * Método encargado de buscar los clientes titulares para un contrato determinado.
     * @param idContrato id de contrato
     * @return clientes
     */
    List<Cliente> findClientesTitularesByContrato(Long idContrato);

    /**
     * Buscar clientes.
     * @param clientes dto
     * @return Lista de clientes
     */
    List<Cliente> findClientes(DtoBuscarClientes clientes);

    /**
     * @param idContrato Long: id del contrato
     * @return Cliente: cliente generado por el contrato, <code>null</code> si el
     * contrato no genero clientes actualmente no borrados
     */
    Cliente findClienteByContratoPaseId(Long idContrato);
}
