package es.capgemini.pfs.batch.revisar.clientes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.revisar.clientes.dao.ClientesBatchDao;
import es.capgemini.pfs.favoritos.FavoritosManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Clase manager de la entidad Antecedente.
 *
 * @author mtorrado
 *
 */

public class ClientesBatchManager {

    @Autowired
    private ClientesBatchDao clientesDao;

    @Autowired
    private FavoritosManager favoritosManager;

    /**
     * Borra la relación entre el contrato indicado y el cliente.
     *
     * @param clienteId
     *            Long
     * @param contratoId
     *            Long
     */
    public void borrarContrato(Long clienteId, Long contratoId) {
        clientesDao.borrarContrato(clienteId, contratoId);
    }

    /**
     * Retorna el id del arquetipo actual del cliente.
     *
     * @param clienteId
     *            Long
     * @return arquetipo
     */
    public Long buscarArquetipo(Long clienteId) {
        return clientesDao.buscarArquetipo(clienteId);
    }

    /**
     * Busca el id del cliente para la persona en la tabla de clientes. De no
     * encontrar returna nulo
     *
     * @param personaId
     *            Long
     * @return cliente
     */
    public Long buscarCliente(Long personaId) {
        return clientesDao.buscarCliente(personaId);
    }

    /**
     * Retorna una lista con los id de los clientes activos.
     *
     * @return Clientes
     */
    public List<Long> buscarClientesActivos() {
        return clientesDao.buscarClientesActivos();
    }

    /**
     * Retorna el id del contrato principal del cliente indicado.
     *
     * @param clienteId
     *            Long
     * @return contratoPrincipal
     */
    public Long buscarContratoPrincipal(Long clienteId) {
        return clientesDao.buscarContratoPrincipal(clienteId);
    }

    /**
     * Retorna los id de los contratos relacionados con el cliente indicado.
     *
     * @param clienteId
     *            Long
     * @return contratos
     */
    public List<Long> buscarContratos(Long clienteId) {
        return clientesDao.buscarContratos(clienteId);
    }

    /**
     * Busca la persona que le corresponde al cliente indicado.
     *
     * @param clienteId
     *            id del cliente
     * @return id de la persona
     */
    public Long buscarPersona(Long clienteId) {
        return clientesDao.buscarPersona(clienteId);
    }

    /**
     * Borra logicamente un cliente de la tabla de cliente y liberar los
     * contratos.
     *
     * @param clienteId
     *            Long
     */
    public void cancelarCliente(Long clienteId) {
        clientesDao.cancelarCliente(clienteId);
        favoritosManager.eliminarFavoritosPorEntidadEliminada(clienteId, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
    }

    /**
     * Busca e inserta los nuevos contratos vencidos para el cliente.
     *
     * @param clienteId id
     */
    public void insertarNuevosContratosVencidos(Long clienteId) {
        clientesDao.insertarNuevosContratosVencidos(clienteId);
    }

    /**
     * Busca el contrato principal (el que tiene movimientos con menor posición
     * vencida) y lo marca como contrato principal. <br>
     * No valida si ya existe otro contrato principal
     *
     * @param clienteId
     *            Long
     */
    public void marcarContratoPrincipal(Long clienteId) {
        clientesDao.marcarContratoPrincipal(clienteId);
    }

    /**
     * Busca e inserta todos los nuevos contratos vencidos y no vencidos para el cliente.
     * @param clienteId long
     */
    public void insertarNuevosContratos(Long clienteId) {
        clientesDao.insertarNuevosContratos(clienteId);
    }
}
