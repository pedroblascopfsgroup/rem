package es.capgemini.pfs.batch.revisar.clientes.dao;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.stereotype.Service;

/**
 * Clase que agrupa método para la creación y acceso de datos de los clientes.
 * @author Andrés Esteban
 *
 */
@Service
public interface ClientesBatchDao {

    /**
     * Borra la relación entre el contrato indicado y el cliente.
     * @param clienteId Long
     * @param contratoId Long
     */
    void borrarContrato(Long clienteId, Long contratoId);

    /**
     * Retorna el id del arquetipo actual del cliente.
     * @param clienteId Long
     * @return arquetipo
     */
    Long buscarArquetipo(Long clienteId);

    /**
     * Busca el id del cliente para la persona en la tabla de clientes. De no encontrar returna nulo
     * @param personaId Long
     * @return cliente
     */
    Long buscarCliente(Long personaId);

    /**
     * Retorna una lista con los id de los clientes activos.
     * @return Clientes
     */

    List<Long> buscarClientesActivos();

    /**
     * Retorna el id del contrato principal del cliente indicado.
     * @param clienteId Long
     * @return contratoPrincipal
     */
    Long buscarContratoPrincipal(Long clienteId);

    /**
     * Retorna los id  de los contratos relacionados con el cliente indicado.
     * @param clienteId Long
     * @return contratos
     */
    List<Long> buscarContratos(Long clienteId);

    /**
     * Busca la persona que le corresponde al cliente indicado.
     * @param clienteId id del cliente
     * @return id de la persona
     */
    Long buscarPersona(Long clienteId);

    /**
     * Borra logicamente un cliente de la tabla de cliente y liberar los contratos.
     * @param clienteId Long
     */
    void cancelarCliente(Long clienteId);

    /**
     * Busca e inserta los nuevos contratos vencidos para el cliente.
     * @param clienteId id
     */
    void insertarNuevosContratosVencidos(Long clienteId);

    /**
     * Busca el contrato principal (el que tiene movimientos con menor posición vencida)
     * y lo marca como contrato principal.
     * <br>No valida si ya existe otro contrato principal
     * @param clienteId Long
     */
    void marcarContratoPrincipal(Long clienteId);

    /**
     * Busca e inserta todos los nuevos contratos vencidos y no vencidos para el cliente.
     * @param clienteId long
     */
    void insertarNuevosContratos(Long clienteId);

    //----------------------------------------------------------------------
    // Setters
    //----------------------------------------------------------------------

    /**
     * Setea el dataSource.
     * @param dataSource DataSource
     */
    void setDataSource(DataSource dataSource);

    /**
     * Setea el sql para los contratos de un cliente.
     * @param borrarClienteContratosQuery String
     */
    void setBorrarClienteContratosQuery(String borrarClienteContratosQuery);

    /**
     * Setea el sql para buscar el cliente a partir del id de una persona.
     * @param buscarClienteQuery String
     */
    void setBuscarClienteQuery(String buscarClienteQuery);

    /**
     * Setea el sql para buscar todos los clientes activos.
     * @param buscarClientesActivosQuery String
     */
    void setBuscarClientesActivosQuery(String buscarClientesActivosQuery);

    /**
     * Setea el sql para buscar el contrato principal de un cliente.
     * @param buscarContratoPrincipalQuery String
     */
    void setBuscarContratoPrincipalQuery(String buscarContratoPrincipalQuery);

    /**
     * Setea el sql para buscar los contratos de un cliente.
     * @param buscarContratosQuery String
     */
    void setBuscarContratosQuery(String buscarContratosQuery);

    /**
     * Seta el sql para recuperar el arquetipo de un cliente.
     * @param buscarArquetipoQuery String
     */
    void setBuscarArquetipoQuery(String buscarArquetipoQuery);

    /**
     * Setea el sql para marcar el contrato principal de un cliente.
     * @param marcarContratoPrincipalQuery String
     */
    void setMarcarContratoPrincipalQuery(String marcarContratoPrincipalQuery);

    /**
     * Setea el sql para borrar un contrato de un cliente.
     * @param borrarClienteContratoQuery String
     */
    void setBorrarClienteContratoQuery(String borrarClienteContratoQuery);

    /**
     * Setea el sql para desactivar un cliente.
     * @param desactivarClienteQuery String
     */
    void setDesactivarClienteQuery(String desactivarClienteQuery);

    /**
     * @param buscarPersonaClienteQuery the buscarPersonaClienteQuery to set
     */
    void setBuscarPersonaClienteQuery(String buscarPersonaClienteQuery);

    /**
     * @param insertarNuevosContratosVencidosQuery the insertarNuevosContratosVencidosQuery to set
     */
    void setInsertarNuevosContratosVencidosQuery(String insertarNuevosContratosVencidosQuery);

    /**
     * @param limpiarContratoPrincipalQuery the limpiarContratoPrincipalQuery to set
     */
    void setLimpiarContratoPrincipalQuery(String limpiarContratoPrincipalQuery);

    /**
     * @param insertarNuevosContratosQuery the insertarNuevosContratosQuery to set
     */
    void setInsertarNuevosContratosQuery(String insertarNuevosContratosQuery);
}
