package es.capgemini.pfs.batch.revisar.contratos.dao.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.arquetipo.model.DDTipoSaltoNivel;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.batch.revisar.contratos.dao.ContratosBatchDao;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;

/**
 * Clase que contiene los métodos de acceso a bbdd para la entidad Contratos.
 *
 * @author mtorrado
 *
 */
//@Repository("ContratosBatchDao")
public class ContratosBatchDaoImpl implements ContratosBatchDao {

    private final Log logger = LogFactory.getLog(getClass());
    private DataSource dataSource;

    private String buscarFechaPosVencidaParaContratosQuery;
    private String buscarFuturosClientesQuery;

    // Scripts para la gestión de recuperaciones
    private String registrarRecuperacionQuery;
    private String buscarRecuperacionesQuery;
    private String buscarIdRecuperacionesQuery;
    private String buscarSaldoProcedimientoAsuntoQuery;

    private SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * {@inheritDoc}
     */
    public Date buscarFechaPosVencida(List<Long> contratosId) {
        Iterator<Long> it = contratosId.iterator();
        String query = buscarFechaPosVencidaParaContratosQuery;
        while (it.hasNext()) {
            Long cntId = it.next();
            query += " cnt_id=" + cntId;
            if (it.hasNext()) {
                query += " OR ";
            }

        }
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        return (Date) jdbcTemplate.queryForObject(query, Date.class);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Long> buscarFuturosClientes() {
        logger.debug("Buscando titulares de contratos vencidos");

        Object[] args = { DDTipoItinerario.ITINERARIO_RECUPERACION, DDTipoSaltoNivel.CODIGO_CUALQUIER_SALTO, DDTipoSaltoNivel.CODIGO_SALTO_ARRIBA,
                DDTipoSaltoNivel.CODIGO_SALTO_ABAJO, DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO,
                DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO, DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO,
                DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO, DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO };

        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        List<Long> titularesID = jdbcTemplate.queryForList(buscarFuturosClientesQuery, args, Long.class);

        logger.debug("Se encotraron " + titularesID.size() + " titulares.");

        return titularesID;
    }

    /**
     * {@inheritDoc}
     */
    public void registrarRecuperacion(Long cntId, Long cliId, Long expId, Long asuId, Double importeRecuperado) {
        String usuarioCrear = "";
        if (cliId != null) {
            usuarioCrear = "REV_CLI";
        }
        if (expId != null) {
            usuarioCrear = "REV_EXP";
        }

        if (asuId != null) {
            usuarioCrear = "REV_ASU";
        }

        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] args = { cntId, cliId, asuId, expId, cliId, importeRecuperado, importeRecuperado, usuarioCrear, cntId, cntId, cntId };
        jdbcTemplate.update(registrarRecuperacionQuery, args);
        logger.debug("La recuperación del contrato " + cntId + " fue registrada");
    }

    /**
     * {@inheritDoc}
     */
    public Long buscarIdRecuperacion(Long cntId, Date fecha) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForLong(buscarIdRecuperacionesQuery, new Object[] { cntId, df.format(fecha) });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> buscarRecuperacion(Long cntId, Date fecha) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        try {
            return jdbcTemplate.queryForMap(buscarRecuperacionesQuery, new Object[] { cntId, df.format(fecha) });
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    /**
     * {@inheritDoc}
     */
    public Double buscarSaldoProcedimientoAsunto(Long asuntoId, Long contratoId) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return (Double) jdbcTemplate.queryForObject(buscarSaldoProcedimientoAsuntoQuery, new Object[] { asuntoId, contratoId }, Double.class);
    }

    /*------------------------------
     * Setters
     *------------------------------*/

    /**
     * {@inheritDoc}
     */
    @Required
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * {@inheritDoc}
     */
    public void setRegistrarRecuperacionQuery(String registrarRecuperacionQuery) {
        this.registrarRecuperacionQuery = registrarRecuperacionQuery;
    }

    /**
     * {@inheritDoc}
     */
    public void setBuscarFechaPosVencidaParaContratosQuery(String buscarFechaPosVencidaParaContratosQuery) {
        this.buscarFechaPosVencidaParaContratosQuery = buscarFechaPosVencidaParaContratosQuery;
    }

    /**
     * {@inheritDoc}
     */
    public void setBuscarSaldoProcedimientoAsuntoQuery(String buscarSaldoProcedimientoAsuntoQuery) {
        this.buscarSaldoProcedimientoAsuntoQuery = buscarSaldoProcedimientoAsuntoQuery;
    }

    /**
     * {@inheritDoc}
     */
    public void setBuscarRecuperacionesQuery(String buscarRecuperacionesQuery) {
        this.buscarRecuperacionesQuery = buscarRecuperacionesQuery;
    }

    /**
     * {@inheritDoc}
     */
    public void setBuscarIdRecuperacionesQuery(String buscarIdRecuperacionesQuery) {
        this.buscarIdRecuperacionesQuery = buscarIdRecuperacionesQuery;
    }

    /**
     * {@inheritDoc}
     */
    public void setBuscarFuturosClientesQuery(String buscarFuturosClientesQuery) {
        this.buscarFuturosClientesQuery = buscarFuturosClientesQuery;
    }
}
