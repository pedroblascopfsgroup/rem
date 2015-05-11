package es.capgemini.pfs.batch.revisar.movimientos;

import java.util.Date;

/**
 * Clase manager de la entidad movimientos.
 *
 * @author mtorrado
 *
 */
public class MovimientosBatchManager {


    /**
     * Revisa los movimientos del contrato indicado y generara las
     * notificaciones según corresponda.
     * Retorna true si el contrato fue cancelado o saldado
     *
     * @param cntId long
     * @param fecha fecha
     * @param cliId cliente
     * @param expId expedienteId
     * @param asuId asuntoId
     * @param indicarContratoSaldado boolean
     * @param generarNotificacion boolean
     * @return boolean true si el contrato fue cancelado o saldado
     */
    public boolean revisarMovimientos(Long cntId, Date fecha, Long cliId, Long expId, Long asuId, boolean indicarContratoSaldado,
            boolean generarNotificacion) {
        return false;
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
     * Retorna la cantidad de dias que estuvo descubierta la posición vencida
     * desde el movimiento anterior.
     *
     * @param contratoId long
     * @return Long
     */
    public Long buscarDiasDescubiertoMovimiento(long contratoId) {
    	return null;    }

    /**
     * Metodo encargado de la historificacion de los movimientos.
     * @return Long
     */
    public Long historificarMovimiento() {
    	return null;
    }

}
