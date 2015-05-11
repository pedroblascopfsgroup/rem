package es.capgemini.pfs.batch.revisar.clientes.dao.impl;

import java.util.List;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.StopWatch;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.batch.revisar.clientes.dao.ClientesBatchDao;
import es.capgemini.pfs.cliente.dao.ClienteDao;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.model.EstadoCliente;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Clase que agrupa método para la creación y acceso de datos de los clientes.
 * @author Andrés Esteban
 *
 */
//@Repository("ClientesBatchDao")
public class ClientesBatchDaoImpl implements ClientesBatchDao {

    private final Log logger = LogFactory.getLog(getClass());

    private DataSource dataSource;
    private String buscarClienteQuery;
    private String buscarPersonaClienteQuery;
    private String desactivarClienteQuery;
    private String borrarClienteContratoQuery;
    private String borrarClienteContratosQuery;
    private String buscarClientesActivosQuery;
    private String buscarContratoPrincipalQuery;
    private String buscarContratosQuery;
    private String buscarArquetipoQuery;
    private String limpiarContratoPrincipalQuery;
    private String marcarContratoPrincipalQuery;
    private String insertarNuevosContratosVencidosQuery;
    private String insertarNuevosContratosQuery;

    private String buscarContratosOrdenadoFechaPosVencidaQuery;

    @Autowired
    private ClienteDao clienteDao;
    @Autowired
    private JBPMProcessManager jbpmUtil;

    /**
     * {@inheritDoc}
     */
    public void borrarContrato(Long clienteId, Long contratoId) {
        logger.debug("Borrando contrato con id: " + contratoId + " del cliente con id: " + clienteId);
        StopWatch sw = new StopWatch();
        sw.start();
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

        Object[] cntArgs = { clienteId, contratoId };
        jdbcTemplate.update(borrarClienteContratoQuery, cntArgs);

        sw.stop();
        logger.debug("Relación borrada. Tiempo total: " + sw.getTotalTimeMillis());
    }

    /**
     * Borra logicamente las relaciones entre el cliente y sus contratos.
     * @param clienteId Long
     */
    private void borrarContratos(Long clienteId) {
        logger.debug("Borrando relaciones para los contratos del cliente con id: " + clienteId);
        StopWatch sw = new StopWatch();
        sw.start();
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

        Object[] cntArgs = { clienteId };
        jdbcTemplate.update(borrarClienteContratosQuery, cntArgs);

        sw.stop();
        logger.debug("Relaciones borradas. Tiempo total: " + sw.getTotalTimeMillis());
    }

    /**
     * {@inheritDoc}
     */
    public Long buscarArquetipo(Long clienteId) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForLong(buscarArquetipoQuery, new Object[] { clienteId });
    }

    /**
     * {@inheritDoc}
     */
    public Long buscarCliente(Long personaId) {
        logger.debug("Buscando cliente para la persona con id: " + personaId);
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] args = { personaId };
        Long clienteID = null;
        try {
            clienteID = jdbcTemplate.queryForLong(buscarClienteQuery, args);
        } catch (EmptyResultDataAccessException e) {
            logger.debug("No existe el cliente para la persona con id: " + personaId);
        }
        return clienteID;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Long> buscarClientesActivos() {
        logger.debug("Buscando clientes activos");

        StopWatch sw = new StopWatch();
        sw.start();
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] args = { EstadoCliente.ESTADO_CLIENTE_ACTIVO };
        List<Long> clientes = jdbcTemplate.queryForList(buscarClientesActivosQuery, args, Long.class);
        sw.stop();
        logger.debug("Se encontraron " + clientes.size() + " clientes activos");
        return clientes;
    }

    /**
     * {@inheritDoc}
     */
    public Long buscarContratoPrincipal(Long clienteId) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForLong(buscarContratoPrincipalQuery, new Object[] { clienteId });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Long> buscarContratos(Long clienteId) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForList(buscarContratosQuery, new Object[] { clienteId }, Long.class);
    }

    /**
     * {@inheritDoc}
     */
    public Long buscarPersona(Long clienteId) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForLong(buscarPersonaClienteQuery, new Object[] { clienteId });
    }

    /**
     * {@inheritDoc}
     */
    public void cancelarCliente(Long clienteId) {
        logger.debug("Cancelando cliente con id: " + clienteId);
        // Artifact artf460483 : Deshabilitar Notificaciones Clientes en Revisión Clientes
        //tareaNotificacionManager.crearNotificacion(clienteId, TipoEntidad.CODIGO_ENTIDAD_CLIENTE,SubtipoTarea.CODIGO_NOTIFICACION_CLIENTE_CANCELADO, null);
        borrarContratos(clienteId);

        Cliente cliente = clienteDao.get(clienteId);
        if (cliente.getProcessBPM() != null) {
            jbpmUtil.destroyProcess(cliente.getProcessBPM());
        }

        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] cliArgs = { EstadoCliente.ESTADO_CLIENTE_CANCELADO, clienteId };
        jdbcTemplate.update(desactivarClienteQuery, cliArgs);
        logger.debug("Cliente cancelado");
    }

    /**
     * {@inheritDoc}
     */
    public void insertarNuevosContratosVencidos(Long clienteId) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] cntArgs = { clienteId, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO, DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO, clienteId };
        jdbcTemplate.update(insertarNuevosContratosVencidosQuery, cntArgs);
    }

    /**
     * {@inheritDoc}
     */
    public void insertarNuevosContratos(Long clienteId) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] cntArgs = { clienteId, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO, DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO, clienteId };
        jdbcTemplate.update(insertarNuevosContratosQuery, cntArgs);
    }

    /**
     * {@inheritDoc}
     */
    public void marcarContratoPrincipal(Long clienteId) {
        Long contratoId = buscarContratoConMenorFechaPosVencida(clienteId);
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(limpiarContratoPrincipalQuery, new Long[] { clienteId });
        Object[] cntArgs = { contratoId, clienteId };
        jdbcTemplate.update(marcarContratoPrincipalQuery, cntArgs);
    }

    private Long buscarContratoConMenorFechaPosVencida(Long clienteId) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Long[] args = new Long[] { clienteId };
        return (Long) jdbcTemplate.queryForList(buscarContratosOrdenadoFechaPosVencidaQuery, args, Long.class).iterator().next();
    }

    //----------------------------------------------------------------------
    // Setters
    //----------------------------------------------------------------------

    /**
     * Setea el dataSource.
     * @param dataSource DataSource
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * Setea el sql para los contratos de un cliente.
     * @param borrarClienteContratosQuery String
     */
    public void setBorrarClienteContratosQuery(String borrarClienteContratosQuery) {
        this.borrarClienteContratosQuery = borrarClienteContratosQuery;
    }

    /**
     * Setea el sql para buscar el cliente a partir del id de una persona.
     * @param buscarClienteQuery String
     */
    public void setBuscarClienteQuery(String buscarClienteQuery) {
        this.buscarClienteQuery = buscarClienteQuery;
    }

    /**
     * Setea el sql para buscar todos los clientes activos.
     * @param buscarClientesActivosQuery String
     */
    public void setBuscarClientesActivosQuery(String buscarClientesActivosQuery) {
        this.buscarClientesActivosQuery = buscarClientesActivosQuery;
    }

    /**
     * Setea el sql para buscar el contrato principal de un cliente.
     * @param buscarContratoPrincipalQuery String
     */
    public void setBuscarContratoPrincipalQuery(String buscarContratoPrincipalQuery) {
        this.buscarContratoPrincipalQuery = buscarContratoPrincipalQuery;
    }

    /**
     * Setea el sql para buscar los contratos de un cliente.
     * @param buscarContratosQuery String
     */
    public void setBuscarContratosQuery(String buscarContratosQuery) {
        this.buscarContratosQuery = buscarContratosQuery;
    }

    /**
     * Seta el sql para recuperar el arquetipo de un cliente.
     * @param buscarArquetipoQuery String
     */
    public void setBuscarArquetipoQuery(String buscarArquetipoQuery) {
        this.buscarArquetipoQuery = buscarArquetipoQuery;
    }

    /**
     * Setea el sql para marcar el contrato principal de un cliente.
     * @param marcarContratoPrincipalQuery String
     */
    public void setMarcarContratoPrincipalQuery(String marcarContratoPrincipalQuery) {
        this.marcarContratoPrincipalQuery = marcarContratoPrincipalQuery;
    }

    /**
     * Setea el sql para borrar un contrato de un cliente.
     * @param borrarClienteContratoQuery String
     */
    public void setBorrarClienteContratoQuery(String borrarClienteContratoQuery) {
        this.borrarClienteContratoQuery = borrarClienteContratoQuery;
    }

    /**
     * Setea el sql para desactivar un cliente.
     * @param desactivarClienteQuery String
     */
    public void setDesactivarClienteQuery(String desactivarClienteQuery) {
        this.desactivarClienteQuery = desactivarClienteQuery;
    }

    /**
     * @param buscarPersonaClienteQuery the buscarPersonaClienteQuery to set
     */
    public void setBuscarPersonaClienteQuery(String buscarPersonaClienteQuery) {
        this.buscarPersonaClienteQuery = buscarPersonaClienteQuery;
    }

    /**
     * @param buscarContratosConMenorFechaPosVencidaQuery the buscarContratosConMenorFechaPosVencidaQuery to set
     */
    public void setBuscarContratosOrdenadoFechaPosVencidaQuery(String buscarContratosConMenorFechaPosVencidaQuery) {
        this.buscarContratosOrdenadoFechaPosVencidaQuery = buscarContratosConMenorFechaPosVencidaQuery;
    }

    /**
        * @param insertarNuevosContratosVencidosQuery the insertarNuevosContratosVencidosQuery to set
        */
    public void setInsertarNuevosContratosVencidosQuery(String insertarNuevosContratosVencidosQuery) {
        this.insertarNuevosContratosVencidosQuery = insertarNuevosContratosVencidosQuery;
    }

    /**
     * @param insertarNuevosContratosQuery the insertarNuevosContratosQuery to set
     */
    public void setInsertarNuevosContratosQuery(String insertarNuevosContratosQuery) {
        this.insertarNuevosContratosQuery = insertarNuevosContratosQuery;
    }

    /**
     * @param limpiarContratoPrincipalQuery the limpiarContratoPrincipalQuery to set
     */
    public void setLimpiarContratoPrincipalQuery(String limpiarContratoPrincipalQuery) {
        this.limpiarContratoPrincipalQuery = limpiarContratoPrincipalQuery;
    }

}
