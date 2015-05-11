package es.capgemini.pfs.batch.revisar.movimientos.dao.impl;

import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.revisar.movimientos.dao.MovimientosBatchDao;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;

/**
 * Clase que contiene los métodos de acceso a la bbdd para la entidad Movimientos.
 *
 * @author mtorrado
 *
 */
public class MovimientosBatchDaoImpl implements MovimientosBatchDao {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ParametrizacionDao parametrizacionDao;

    private Double porcentajeDisminucion;
    private DataSource dataSource;

    private String buscarDiasPosVencidaQuery;
    private String buscarDiasDescubiertoMovimientoQuery;
    private String buscarDiferenciaContratoQuery;
    private String historificarMovimientosQuery;
    private String eliminarMovimientosHistorificadosQuery;

    /**
     * Retorna un mapa con los siguientes campo 'Cancelado', 'Saldado', 'Diferencia', 'Importe' e 'ImporteAnterior'.
     * @param contratoId Long
     * @return map
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> buscarDiferenciaContrato(Long contratoId) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] args = { DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, contratoId };
        return jdbcTemplate.queryForMap(buscarDiferenciaContratoQuery, args);
    }

    /**
     * Retorna la cantidad de dias que estuvo vencido el movimiento desde la
     * fecha actual.
     *
     * @param movimientoId Long: ID
     * @return Long
     */
    public Long buscarDiasPosicionVencida(Long movimientoId) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForLong(buscarDiasPosVencidaQuery, new Object[] { movimientoId });
    }

    /**
     * {@inheritDoc}
     */
    public Long buscarDiasDescubiertoMovimiento(long contratoId) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForLong(buscarDiasDescubiertoMovimientoQuery, new Object[] { contratoId });
    }

    /**
     * {@inheritDoc}
     */
    public Long historificarMovimiento() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        int[] result = jdbcTemplate.batchUpdate(new String[] { historificarMovimientosQuery, eliminarMovimientosHistorificadosQuery });
        if (result[0] != result[1]) {
            logger.error("Hay una diferencia entre los movimientos historificados [" + result[0] + "]y los eliminados[" + result[1] + "]");
        }
        return Long.valueOf(result[0]);
    }

    // ------------------------------
    // Setters
    // ------------------------------

    /**
     * Setea el DataSource.
     *
     * @param dataSource
     *            datasource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * @param buscarDiasPosVencidaQuery
     *            the buscarDiasPosVencidaQuery to set
     */
    public void setBuscarDiasPosVencidaQuery(String buscarDiasPosVencidaQuery) {
        this.buscarDiasPosVencidaQuery = buscarDiasPosVencidaQuery;
    }

    /**
     * @param porcentajeDisminucion
     *            the porcentajeDisminucion to set
     */
    public void setPorcentajeDisminucion(double porcentajeDisminucion) {
        this.porcentajeDisminucion = porcentajeDisminucion;
    }

    /**
     * @param buscarDiasDescubiertoMovimientoQuery
     *            the buscarDiasDescubiertoMovimientoQuery to set
     */
    public void setBuscarDiasDescubiertoMovimientoQuery(String buscarDiasDescubiertoMovimientoQuery) {
        this.buscarDiasDescubiertoMovimientoQuery = buscarDiasDescubiertoMovimientoQuery;
    }

    /**
     * getPorcentajeDisminucion.
     *
     * @return porcentajeDisminucion double
     */
    public Double getPorcentajeDisminucion() {
        if (porcentajeDisminucion == null) {
            porcentajeDisminucion = new Double(parametrizacionDao.buscarParametroPorNombre(Parametrizacion.PORCENTAJE_DISMINUCION_MOVIMIENTOS)
                    .getValor());
        }
        return porcentajeDisminucion;
    }

    /**
     * @param buscarDiferenciaContratoQuery the buscarDiferenciaContratoQuery to set
     */
    public void setBuscarDiferenciaContratoQuery(String buscarDiferenciaContratoQuery) {
        this.buscarDiferenciaContratoQuery = buscarDiferenciaContratoQuery;
    }

    /**
     * @param historificarMovimientosQuery the historificarMovimientosQuery to set
     */
    public void setHistorificarMovimientosQuery(String historificarMovimientosQuery) {
        this.historificarMovimientosQuery = historificarMovimientosQuery;
    }

    /**
     * @param eliminarMovimientosHistorificadosQuery the eliminarMovimientosHistorificadosQuery to set
     */
    public void setEliminarMovimientosHistorificadosQuery(String eliminarMovimientosHistorificadosQuery) {
        this.eliminarMovimientosHistorificadosQuery = eliminarMovimientosHistorificadosQuery;
    }

}
