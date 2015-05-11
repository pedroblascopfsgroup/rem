package es.capgemini.pfs.batch.revisar.movimientos.dao;

import java.util.Map;

import javax.sql.DataSource;

/**
 * Clase que contiene los métodos de acceso a la bbdd para la entidad Movimientos.
 *
 * @author mtorrado
 *
 */
public interface MovimientosBatchDao {

    /**
     * Retorna un mapa con los siguientes campo 'Cancelado', 'Saldado', 'Diferencia', 'Importe' e 'ImporteAnterior'.
     * @param contratoId Long
     * @return map
     */
    Map<String, Object> buscarDiferenciaContrato(Long contratoId);

    /**
     * Retorna la cantidad de dias que estuvo vencido el movimiento desde la
     * fecha actual.
     *
     * @param movimientoId Long: ID
     * @return Long
     */
    Long buscarDiasPosicionVencida(Long movimientoId);

    /**
     * Retorna la cantidad de dias que estuvo descubierta la posición vencida
     * desde el movimiento anterior.
     *
     * @param contratoId long
     * @return Long
     */
    Long buscarDiasDescubiertoMovimiento(long contratoId);

    /**
     * Metodo encargado de la historificacion de los movimientos.
     *
     * @return Long
     */
    Long historificarMovimiento();

    // ------------------------------
    // Setters
    // ------------------------------

    /**
     * Setea el DataSource.
     *
     * @param dataSource
     *            datasource to set
     */
    void setDataSource(DataSource dataSource);

    /**
     * @param buscarDiasPosVencidaQuery
     *            the buscarDiasPosVencidaQuery to set
     */
    void setBuscarDiasPosVencidaQuery(String buscarDiasPosVencidaQuery);

    /**
     * @param buscarDiasDescubiertoMovimientoQuery
     *            the buscarDiasDescubiertoMovimientoQuery to set
     */
    void setBuscarDiasDescubiertoMovimientoQuery(String buscarDiasDescubiertoMovimientoQuery);

    /**
     * getPorcentajeDisminucion.
     *
     * @return porcentajeDisminucion double
     */
    Double getPorcentajeDisminucion();

    /**
     * @param buscarDiferenciaContratoQuery the buscarDiferenciaContratoQuery to set
     */
    void setBuscarDiferenciaContratoQuery(String buscarDiferenciaContratoQuery);
}
