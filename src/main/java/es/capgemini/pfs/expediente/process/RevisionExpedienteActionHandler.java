package es.capgemini.pfs.expediente.process;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.job.Timer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.arquetipo.ArquetipoManager;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.itinerario.EstadoProcesoManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Handler del Estado Revision de Expediente.
 * @author jbosnjak
 *
 */
@Component
public class RevisionExpedienteActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    @Autowired
    private ArquetipoManager arquetipoManager;

    @Autowired
    private TareaNotificacionManager notificacionManager;

    @Autowired
    private EstadoProcesoManager estadoProcesoManager;

    @Autowired
    private ExpedienteManager expedienteManager;

    @Autowired
    private JBPMProcessManager jbpmUtils;

    /**Este metodo controla la revision del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("RevisionExpedienteActionHandler......");
        }
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);

        String comeFrom = executionContext.getTransitionSource().getName();
        if (!GENERAR_NOTIFICACION.equals(comeFrom) && !SOLICITAR_PRORROGA_EXTRA.equals(comeFrom)) {
            //Se deberï¿½ generar la tarea para el gestor
            Estado estadoRE = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);
            Estado estadoCE = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
            estadoProcesoManager.pasarDeEstado(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, estadoRE, executionContext.getProcessInstance()
                    .getId());
            Long idTareaAnterior = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);
            Long fechaFin = obtenerFinTareaAnterior(idTareaAnterior);
            Long plazoRestante = calcularTiempoRestante(idExpediente, estadoCE.getPlazo() + estadoRE.getPlazo(), fechaFin);
            Long seconds = (plazoRestante.longValue() / MILLISECONDS);

            DtoGenerarTarea dto = new DtoGenerarTarea(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                    SubtipoTarea.CODIGO_REVISAR_EXPEDIENE, false, false, plazoRestante, "");
            Long idTareaRE = notificacionManager.crearTarea(dto);
            if (fechaFin != null) {
                TareaNotificacion tareaActual = notificacionManager.get(idTareaRE);
                tareaActual.setFechaVenc(new Date(fechaFin));
                notificacionManager.saveOrUpdate(tareaActual);
            }

            expedienteManager.setInstanteCambioEstadoExpediente(idExpediente);
            executionContext.setVariable(TAREA_ASOCIADA_RE, idTareaRE);
            if (estadoRE.getAutomatico() != null && estadoRE.getAutomatico()) {
                executionContext.setVariable(GENERAALERTA, Boolean.FALSE);
                executionContext.setVariable(WHERE_TO_GO, TRANSITION_ENVIARADECISIONCOMITE);
            } else {
                executionContext.setVariable(GENERAALERTA, Boolean.TRUE);
                executionContext.setVariable(WHERE_TO_GO, REVISION_EXPEDIENTE);
            }

            BPMUtils.createTimer(executionContext, TIMER_TAREA_RE, seconds + " seconds", GENERAR_NOTIFICACION);
        }

        /**
         * @deprecated Este trozo de código está deprecado, en fase 1 se usaba, ahora ya no
         */
        if (SOLICITAR_PRORROGA_EXTRA.equals(comeFrom)) {
            Long idTareaRE = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);
            Date fechaPropuesta = (Date) executionContext.getVariable(FECHA_PROPUESTA);

            TareaNotificacion tarea = notificacionManager.get(idTareaRE);
            tarea.setFechaVenc(fechaPropuesta);
            notificacionManager.saveOrUpdate(tarea);

            //Si el timer ya existía lo recalculamos
            Timer timer = BPMUtils.getTimer(executionContext.getJbpmContext(), executionContext.getProcessInstance(), TIMER_TAREA_RE);
            if (timer != null) {
                jbpmUtils.recalculaTimer(executionContext.getProcessInstance().getId(), TIMER_TAREA_RE, fechaPropuesta);
            } else {
                //Si el timer no existía lo creamos
                BPMUtils.createTimer(executionContext, TIMER_TAREA_RE, fechaPropuesta, GENERAR_NOTIFICACION);
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
        Long now = new Date().getTime();
        if (fechaFin != null) { return fechaFin - now; }
        Long creacionExp = expedienteManager.getExpediente(idExpediente).getAuditoria().getFechaCrear().getTime();
        Long tiempoTranscurrido = now - creacionExp;
        return plazo - tiempoTranscurrido;
    }

    /**
     * obtenerFinTareaAnterior.
     * @param idTareaAnterior idTareaAnterior
     * @return fecha
     */
    private Long obtenerFinTareaAnterior(Long idTareaAnterior) {
        TareaNotificacion tareaAnterior = null;
        if (idTareaAnterior != null) {
            tareaAnterior = notificacionManager.get(idTareaAnterior);
        }
        if (tareaAnterior != null) { return tareaAnterior.getFechaVenc().getTime(); }
        return null;
    }
}
