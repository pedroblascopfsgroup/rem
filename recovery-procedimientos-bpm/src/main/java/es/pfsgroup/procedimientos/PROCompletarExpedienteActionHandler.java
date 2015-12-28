package es.pfsgroup.procedimientos;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.job.Timer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.itinerario.EstadoProcesoManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.recovery.api.ArquetipoApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.JBPMProcessApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Handler del nodo Completar Expediente.
 * @author jbosnjak
 *
 */
public class PROCompletarExpedienteActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    @Autowired
    private EstadoProcesoManager estadoProcesoManager;


    /**Este metodo controla el estado de completar expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("CompletarExpedienteActionHandler......");
        }
        
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);
        ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        JBPMProcessApi jbpmUtils = proxyFactory.proxy(JBPMProcessApi.class);
        
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);

        String comeFrom = executionContext.getTransitionSource().getName();
        if (!GENERAR_NOTIFICACION.equals(comeFrom) && !SOLICITAR_PRORROGA_EXTRA.equals(comeFrom)) {
            //Se deber� generar la tarea para el gestor
            Estado estadoCE = proxyFactory.proxy(ArquetipoApi.class).getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
            estadoProcesoManager.pasarDeEstado(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, estadoCE, executionContext.getProcessInstance()
                    .getId());
            Long idTareaAnterior = (Long) executionContext.getVariable(TAREA_ASOCIADA_CE);
            Long fechaFin = obtenerFinTareaAnterior(idTareaAnterior);
            Long plazoRestante = calcularTiempoRestante(idExpediente, estadoCE.getPlazo(), fechaFin);
            Long seconds = (plazoRestante.longValue() / MILLISECONDS);

            DtoGenerarTarea dto = new DtoGenerarTarea(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                    SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE, false, false, plazoRestante, "");
            Long idTareaCE = notificacionManager.crearTarea(dto);
            if (fechaFin != null) {
                TareaNotificacion tareaActual = notificacionManager.get(idTareaCE);
                tareaActual.setFechaVenc(new Date(fechaFin));
                notificacionManager.saveOrUpdate(tareaActual);
            }

            expedienteManager.setInstanteCambioEstadoExpediente(idExpediente);
            executionContext.setVariable(TAREA_ASOCIADA_CE, idTareaCE);
            //Si venimos de "devolver a completar" se desactiva el avance automático en todos los casos.
            if (!DEVOLVER_COMPLETAR.equals(comeFrom) && estadoCE.getAutomatico() != null && estadoCE.getAutomatico()) {
                executionContext.setVariable(GENERAALERTA, Boolean.TRUE);
                executionContext.setVariable(WHERE_TO_GO, TRANSITION_ENVIARAREVISION);
            } else {
                executionContext.setVariable(GENERAALERTA, Boolean.TRUE);
                executionContext.setVariable(WHERE_TO_GO, COMPLETAR_EXPEDIENTE);
            }
            executionContext.setVariable(AVANCE_AUTOMATICO, Boolean.FALSE);
            BPMUtils.createTimer(executionContext, TIMER_TAREA_CE, seconds + " seconds", GENERAR_NOTIFICACION);
        }

        /**
         * @deprecated Este trozo de c�digo est� deprecado, en fase 1 se usaba, ahora ya no
         */

        if (SOLICITAR_PRORROGA_EXTRA.equals(comeFrom)) {
            Long idTareaCE = (Long) executionContext.getVariable(TAREA_ASOCIADA_CE);
            Date fechaPropuesta = (Date) executionContext.getVariable(FECHA_PROPUESTA);

            TareaNotificacion tarea = notificacionManager.get(idTareaCE);
            tarea.setFechaVenc(fechaPropuesta);
            notificacionManager.saveOrUpdate(tarea);

            //Si el timer ya exist�a lo recalculamos
            Timer timer = BPMUtils.getTimer(executionContext.getJbpmContext(), executionContext.getProcessInstance(), TIMER_TAREA_CE);
            if (timer != null) {
                jbpmUtils.recalculaTimer(executionContext.getProcessInstance().getId(), TIMER_TAREA_CE, fechaPropuesta);
            } else {
                //Si el timer no exist�a lo creamos
                BPMUtils.createTimer(executionContext, TIMER_TAREA_CE, fechaPropuesta, GENERAR_NOTIFICACION);
            }
        }
    }

    /**
     * calcular el tiempo restante para la tarea.
     * @param idExpediente id expediente
     * @param plazo plazo
     * @param fechaFin fechaFin
     * @return plazo restante
     */
    private Long calcularTiempoRestante(Long idExpediente, Long plazo, Long fechaFin) {
    	ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        Long now = new Date().getTime();
        if (fechaFin != null) { return fechaFin - now; }
        Long creacionExp = expedienteManager.getExpediente(idExpediente).getAuditoria().getFechaCrear().getTime();
        Long tiempoTranscurrido = now - creacionExp;
        Long tiempoRestante = plazo - tiempoTranscurrido;        
        return (tiempoRestante<0) ? (24*60*60*1000L) : tiempoRestante;
    }

    /**
     * obtenerFinTareaAnterior.
     * @param idTareaAnterior idTareaAnterior
     * @return fecha
     */
    private Long obtenerFinTareaAnterior(Long idTareaAnterior) {
    	TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);
        TareaNotificacion tareaAnterior = null;
        if (idTareaAnterior != null) {
            tareaAnterior = notificacionManager.get(idTareaAnterior);
        }
        if (tareaAnterior != null) { return tareaAnterior.getFechaVenc().getTime(); }
        return null;
    }
}
