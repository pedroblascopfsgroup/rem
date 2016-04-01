package es.capgemini.pfs.batch.revisar.movimientos;

import java.text.NumberFormat;
import java.util.Date;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.revisar.antecedentes.AntecedentesBatchManager;
import es.capgemini.pfs.batch.revisar.contratos.ContratosBatchManager;
import es.capgemini.pfs.batch.revisar.movimientos.dao.MovimientosBatchDao;
import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Clase manager de la entidad movimientos.
 *
 * @author mtorrado
 *
 */
public class MovimientosBatchManager {

    private final Log logger = LogFactory.getLog(getClass());

    private static final int PORCENTAJETOTAL = 100;

    @Autowired
    private ContratosBatchManager contratosBatchManager;
    @Autowired
    private AntecedentesBatchManager antecedentesBatchManager;
    @Autowired
    private TareaNotificacionManager tareaNotificacionManager;
    @Autowired
    private ContratoManager contratoManager;

    @Autowired
    private MovimientosBatchDao movimientosDao;

    @Autowired
    private TareaNotificacionDao tareaNotificacionDao;

    /**
     * Revisa los movimientos del contrato indicado y generara las
     * notificaciones seg�n corresponda.
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
        logger.debug("Revisando movimientos para el contrato con id " + cntId);
        Boolean respuesta = false;

        try {
            Map<String, Object> results = movimientosDao.buscarDiferenciaContrato(cntId);
            Double diff = new Double(results.get("Diferencia").toString());
            boolean contratoSaldado = results.get("Saldado").toString().equals("1");
            boolean contratoSaldadoSinMovAnterior = results.get("SaldadoSinMovAnterior").toString().equals("1");
            Date fechaVencido = (Date) results.get("fechaVencido");

            Double importe = new Double(results.get("Importe").toString());
            Double importeAnt = new Double(results.get("ImporteAnterior").toString());

            // Verifico si el contrato est� cancelado
            if (results.get("Cancelado").toString().equals("1")) {
                //Comprobamos si el mensaje no ha sido enviado ninguna vez
                SubtipoTarea subtipoTarea = tareaNotificacionManager.buscarSubtipoTareaPorCodigo(SubtipoTarea.CODIGO_NOTIFICACION_CONTRATO_CANCELADO);
                String mensaje = subtipoTarea.getDescripcion() + "\nCod. Contrato: " + contratoManager.get(cntId).getCodigoContrato();

                Integer nNotif = tareaNotificacionDao.getNumNotificaciones(mensaje, cliId, expId, asuId);

                // est� cencelado y no se ha enviado todav�a ninguna notificaci�n, env�o notificaci�n
                if (nNotif.intValue() == 0) {

                    logger.debug("El contrato " + cntId + " est� cancelado");
                    if (generarNotificacion) {
                        enviarNotificacion(cliId, expId, asuId, cntId, diff, SubtipoTarea.CODIGO_NOTIFICACION_CONTRATO_CANCELADO);
                    }
                }
                //CU WEB-20 F3. Si el contrato fue saldado y era el �nico contrato del procedimiento se debe eliminar el procedimiento.
                //No se tiene claro que se debe hacer en caso de cancelar el contrato dentro de un procedimiento propuesto (en decision)
                //contratoManager.eliminarProcedimientoPorCancelacion(cntId, expId);
                respuesta = true;
            } else if (contratoSaldado) {

                // No est� cancelado, busco reducciones
                logger.debug("El contrato " + cntId + " NO est� cancelado");

                //Comprobamos si el mensaje no ha sido enviado ninguna vez
                SubtipoTarea subtipoTarea = tareaNotificacionManager.buscarSubtipoTareaPorCodigo(SubtipoTarea.CODIGO_NOTIFICACION_CONTRATO_PAGADO);
                String mensaje = subtipoTarea.getDescripcion() + "\nCod. Contrato: " + contratoManager.get(cntId).getCodigoContrato();

                Integer nNotif = tareaNotificacionDao.getNumNotificaciones(mensaje, cliId, expId, asuId);

                // est� Cancelado y no se ha enviado todav�a ninguna notificaci�n, env�o notificaci�n
                if (nNotif.intValue() == 0) {
                    // Cancelaci�n total de la deuda
                    logger.debug("El contrato " + cntId + " fue pagado en su totalidad");
                    if (generarNotificacion) {
                        enviarNotificacion(cliId, expId, asuId, cntId, diff, SubtipoTarea.CODIGO_NOTIFICACION_CONTRATO_PAGADO);
                    }
                }

                //Solo se registra un antecedente si se ha saldado y adem�s tiene fecha pos vencido en el movAnterior
                if (fechaVencido != null) antecedentesBatchManager.registrarAntecedenteInterno(cntId, fecha, importeAnt);

                //CU WEB-20 F3. Si el contrato fue saldado y era el �nico contrato del procedimiento se debe eliminar el procedimiento.
                //No se tiene claro que se debe hacer en caso de cancelar el contrato dentro de un procedimiento propuesto (en decision)
                //contratoManager.eliminarProcedimientoPorCancelacion(cntId, expId);
                respuesta = indicarContratoSaldado;
            } else {
                //Se comprueba el saldado sin llegar a contrastar con el movimiento anterior, para liberar contratos NO vencidos
                if (contratoSaldadoSinMovAnterior) {
                    respuesta = indicarContratoSaldado;
                }
            }

            //Long tipo = Long.decode(results.get("activo").toString());
            //if (!(tipo.longValue() == 0 && (importe - importeAnt) > 0)) {
            if (diff > 0) {
                if (contratosBatchManager.existeRecuperacion(cntId, fecha)) {
                    logger.debug("Ya ha sido registrado el contrato con id: " + cntId);
                    return false;
                }
                contratosBatchManager.registrarRecuperacion(cntId, cliId, expId, asuId, diff);
                logger.debug("El contrato " + cntId + " tuvo una reducci�n, pas� de $" + importeAnt + " a $" + importe);
                // Eval�o el porcentaje de disminuci�n contra los establecidos por la entidad.
                double porcentaje = calcularPorcentajeDisminucion(importeAnt, importe);
                if (porcentaje >= movimientosDao.getPorcentajeDisminucion()) {
                    // Genero notificaci�n para el gestor y el supervisor del asunto
                    logger.debug("El contrato " + cntId + " tuvo una disminuci�n del %" + porcentaje + " MAYOR al %"
                            + movimientosDao.getPorcentajeDisminucion());
                    if (generarNotificacion) {
                        enviarNotificacion(cliId, expId, asuId, cntId, diff, SubtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO);
                    }
                } else {
                    // no hay disminuci�n
                    logger.debug("El contrato " + cntId + " NO tuvo la disminuci�n esperada %" + porcentaje + " MENOR al %"
                            + movimientosDao.getPorcentajeDisminucion());
                }
            } else {
                // No hubo reducci�n, termina el proceso.
                logger.debug("El contrato " + cntId + " NO tuvo una reducci�n");
            }
            /*
                }
                else {
                    // ES PASIVO CON SALDO POSITIVO
                    logger.debug("El contrato " + cntId + " Es de pasivo con saldo positivo.");
                }
            */
        } catch (Exception e) {
            logger.error("Hubo alg�n problema al revisar el movimiento para [cnt: " + cntId + ", cli: " + cliId + ", exp: " + expId + ", asu: "
                    + asuId + ", fecha: " + fecha + "]", e);
        }
        return respuesta;
    }

    /**
     * Genera tarea de notificaci�n.
     * @param idCliente Long
     * @param idExpediente Long
     * @param idAsunto Long
     * @param idContrato Long
     * @param montoMovimiento Double
     * @param codTarea String
     */
    private void enviarNotificacion(Long idCliente, Long idExpediente, Long idAsunto, Long idContrato, Double montoMovimiento, String codTarea) {
        SubtipoTarea subtipoTarea = tareaNotificacionManager.buscarSubtipoTareaPorCodigo(codTarea);
        String monto = NumberFormat.getCurrencyInstance().format(montoMovimiento);
        String mensaje = subtipoTarea.getDescripcion() + "\nCod. Contrato: " + contratoManager.get(idContrato).getCodigoContrato()
                + "\nImporte recuperado: " + monto;
        String codTipoEntidad = null;
        Long id = null;
        if (idCliente != null) {
            codTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE;
            id = idCliente;
        } else if (idExpediente != null) {
            codTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE;
            id = idExpediente;
        } else if (idAsunto != null) {
            codTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
            id = idAsunto;
        }
        tareaNotificacionManager.crearNotificacion(id, codTipoEntidad, codTarea, mensaje);
    }

    /**
     * calcularPorcentajeDisminucion.
     *
     * @param saldoAnterior double
     * @param saldoActual double
     * @return double
     */
    private double calcularPorcentajeDisminucion(double saldoAnterior, double saldoActual) {
        return PORCENTAJETOTAL - (saldoActual * PORCENTAJETOTAL / saldoAnterior);
    }

    /**
     * Retorna la cantidad de dias que estuvo vencido el movimiento desde la
     * fecha actual.
     *
     * @param movimientoId Long: ID
     * @return Long
     */
    public Long buscarDiasPosicionVencida(Long movimientoId) {
        return movimientosDao.buscarDiasPosicionVencida(movimientoId);
    }

    /**
     * Retorna la cantidad de dias que estuvo descubierta la posici�n vencida
     * desde el movimiento anterior.
     *
     * @param contratoId long
     * @return Long
     */
    public Long buscarDiasDescubiertoMovimiento(long contratoId) {
        return movimientosDao.buscarDiasDescubiertoMovimiento(contratoId);
    }

    /**
     * Metodo encargado de la historificacion de los movimientos.
     * @return Long
     */
    public Long historificarMovimiento() {
        Long numMovHist = movimientosDao.historificarMovimiento();
        logger.info("Se han historificado " + numMovHist + " movimientos");
        return numMovHist;
    }

}
