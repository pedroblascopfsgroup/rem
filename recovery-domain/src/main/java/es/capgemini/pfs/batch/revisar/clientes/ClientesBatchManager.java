package es.capgemini.pfs.batch.revisar.clientes;

import java.util.List;

/**
 * Clase manager de la entidad Antecedente.
 *
 * @author mtorrado
 *
 */

public class ClientesBatchManager {

   

    /**
     * Borra la relación entre el contrato indicado y el cliente.
     *
     * @param clienteId
     *            Long
     * @param contratoId
     *            Long
     */
    public void borrarContrato(Long clienteId, Long contratoId) {
    }

    /**
     * Retorna el id del arquetipo actual del cliente.
     *
     * @param clienteId
     *            Long
     * @return arquetipo
     */
    public Long buscarArquetipo(Long clienteId) {
    	return null;
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
    	return null;
    }

    /**
     * Retorna una lista con los id de los clientes activos.
     *
     * @return Clientes
     */
    public List<Long> buscarClientesActivos() {
    	return null;
    }

    /**
     * Retorna el id del contrato principal del cliente indicado.
     *
     * @param clienteId
     *            Long
     * @return contratoPrincipal
     */
    public Long buscarContratoPrincipal(Long clienteId) {
    	return null;
    }

    /**
     * Retorna los id de los contratos relacionados con el cliente indicado.
     *
     * @param clienteId
     *            Long
     * @return contratos
     */
    public List<Long> buscarContratos(Long clienteId) {
    	return null;
    }

    /**
     * Busca la persona que le corresponde al cliente indicado.
     *
     * @param clienteId
     *            id del cliente
     * @return id de la persona
     */
    public Long buscarPersona(Long clienteId) {
    	return null;
    }

    /**
     * Borra logicamente un cliente de la tabla de cliente y liberar los
     * contratos.
     *
     * @param clienteId
     *            Long
     */
    public void cancelarCliente(Long clienteId) {
    }

    /**
     * Busca e inserta los nuevos contratos vencidos para el cliente.
     *
     * @param clienteId id
     */
    public void insertarNuevosContratosVencidos(Long clienteId) {
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
    }

    /**
     * Busca e inserta todos los nuevos contratos vencidos y no vencidos para el cliente.
     * @param clienteId long
     */
    public void insertarNuevosContratos(Long clienteId) {
    }
}
