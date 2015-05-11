package es.capgemini.pfs.batch.revisar.movimientos.dao.impl;

import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.pfs.batch.revisar.movimientos.dao.MovimientosBatchDao;

/**
 * Clase que contiene los métodos de acceso a la bbdd para la entidad Movimientos.
 *
 * @author mtorrado
 *
 */
public class MovimientosBatchDaoImpl implements MovimientosBatchDao {

    private final Log logger = LogFactory.getLog(getClass());

    

    /**
     * Retorna un mapa con los siguientes campo 'Cancelado', 'Saldado', 'Diferencia', 'Importe' e 'ImporteAnterior'.
     * @param contratoId Long
     * @return map
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> buscarDiferenciaContrato(Long contratoId) {
    	return null;
    }

    /**
     * Retorna la cantidad de dias que estuvo vencido el movimiento desde la
     * fecha actual.
     *
     * @param movimientoId Long: ID
     * @return Long
     */
    public Long buscarDiasPosicionVencida(Long movimientoId) {
    	return null;
    }

    /**
     * {@inheritDoc}
     */
    public Long buscarDiasDescubiertoMovimiento(long contratoId) {
    	return null;
    }

    /**
     * {@inheritDoc}
     */
    public Long historificarMovimiento() {
    	return null;
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
       
    }

    /**
     * @param buscarDiasPosVencidaQuery
     *            the buscarDiasPosVencidaQuery to set
     */
    public void setBuscarDiasPosVencidaQuery(String buscarDiasPosVencidaQuery) {
    }

    /**
     * @param porcentajeDisminucion
     *            the porcentajeDisminucion to set
     */
    public void setPorcentajeDisminucion(double porcentajeDisminucion) {
    }

    /**
     * @param buscarDiasDescubiertoMovimientoQuery
     *            the buscarDiasDescubiertoMovimientoQuery to set
     */
    public void setBuscarDiasDescubiertoMovimientoQuery(String buscarDiasDescubiertoMovimientoQuery) {
    }

    /**
     * getPorcentajeDisminucion.
     *
     * @return porcentajeDisminucion double
     */
    public Double getPorcentajeDisminucion() {
    	return null;
    }

    /**
     * @param buscarDiferenciaContratoQuery the buscarDiferenciaContratoQuery to set
     */
    public void setBuscarDiferenciaContratoQuery(String buscarDiferenciaContratoQuery) {
    }

    /**
     * @param historificarMovimientosQuery the historificarMovimientosQuery to set
     */
    public void setHistorificarMovimientosQuery(String historificarMovimientosQuery) {
    }

    /**
     * @param eliminarMovimientosHistorificadosQuery the eliminarMovimientosHistorificadosQuery to set
     */
    public void setEliminarMovimientosHistorificadosQuery(String eliminarMovimientosHistorificadosQuery) {
    }

}
