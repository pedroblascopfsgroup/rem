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
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Handler del Estado Formalizar Propuesta.
 * @author cperez
 *
 */
public class PROFormalizarPropuestaActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    @Autowired
    private EstadoProcesoManager estadoProcesoManager;


    @Autowired
    private JBPMProcessManager jbpmUtils;

    /**Este metodo controla la formalización de la propuesta
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("FormalizarPropuestaActionHandler......");
        }
        
        ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);
        ArquetipoApi arquetipoManager = proxyFactory.proxy(ArquetipoApi.class);
        
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);

        String comeFrom = executionContext.getTransitionSource().getName();
        if (!GENERAR_NOTIFICACION.equals(comeFrom) && !SOLICITAR_PRORROGA_EXTRA.equals(comeFrom)) {
            //Se deber� generar la tarea para el gestor
        	Estado estadoCE = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
        	Estado estadoRE = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);
        	Estado estadoDC = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_DECISION_COMIT);
        	Estado estadoFP = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA);
        	
            estadoProcesoManager.pasarDeEstado(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, estadoFP, executionContext.getProcessInstance()
                    .getId());
            Long idTareaAnterior = (Long) executionContext.getVariable(TAREA_ASOCIADA_FP);
            Long fechaFin = obtenerFinTareaAnterior(idTareaAnterior);
            Long plazoRestante = calcularTiempoRestante(idExpediente, estadoCE.getPlazo() + estadoRE.getPlazo() + estadoDC.getPlazo() + estadoFP.getPlazo(), fechaFin);
            Long seconds = (plazoRestante.longValue() / MILLISECONDS);

            DtoGenerarTarea dto = new DtoGenerarTarea(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                    SubtipoTarea.CODIGO_FORMALIZAR_PROPUESTA, false, false, plazoRestante, "");
            Long idTareaFP = notificacionManager.crearTarea(dto);
            if (fechaFin != null) {
                TareaNotificacion tareaActual = notificacionManager.get(idTareaFP);
                tareaActual.setFechaVenc(new Date(fechaFin));
                notificacionManager.saveOrUpdate(tareaActual);
            }

            expedienteManager.setInstanteCambioEstadoExpediente(idExpediente);
            executionContext.setVariable(TAREA_ASOCIADA_FP, idTareaFP);
            //Si venimos de "devolver a revisión" se desactiva el avance automático en todos los casos.
//            if (!DEVOLVER_REVISION.equals(comeFrom) && estadoFP.getAutomatico() != null && estadoFP.getAutomatico()) {
//                executionContext.setVariable(GENERAALERTA, Boolean.TRUE);
//                executionContext.setVariable(WHERE_TO_GO, TRANSITION_ENVIARADECISIONCOMITE);
//            } else {
                executionContext.setVariable(GENERAALERTA, Boolean.TRUE);
                executionContext.setVariable(WHERE_TO_GO, FORMALIZAR_PROPUESTA);
//            }

            BPMUtils.createTimer(executionContext, TIMER_TAREA_FP, seconds + " seconds", GENERAR_NOTIFICACION);
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
