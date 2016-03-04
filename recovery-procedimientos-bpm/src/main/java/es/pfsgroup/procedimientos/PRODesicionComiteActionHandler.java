package es.pfsgroup.procedimientos;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
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
import es.pfsgroup.recovery.api.ArquetipoApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Handler del Estado Decision Comite.
 * @author jbosnjak
 *
 */
public class PRODesicionComiteActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

   

    @Autowired
    private EstadoProcesoManager estadoProcesoManager;


    private static final long serialVersionUID = 1L;

    /**
     * Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("DesicionComiteActionHandler......");
        }
        
        ArquetipoApi arquetipoManager = proxyFactory.proxy(ArquetipoApi.class);
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);
        ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);

        String comeFrom = executionContext.getTransitionSource().getName();

        if (!(GENERAR_NOTIFICACION.equals(comeFrom) || DECISION_COMITE_AUTO.equals(comeFrom))) {
            //Se deber� generar la tarea para el gestor
            Estado estadoRE = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);
            Estado estadoCE = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
            Estado estadoDC = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_DECISION_COMIT);
            Long idTareaAnterior = (Long) executionContext.getVariable(TAREA_ASOCIADA_DC);
            Long fechaFin = obtenerFinTareaAnterior(idTareaAnterior);
            Long plazoRestante = 0L;
            if (estadoDC.getAutomatico() != null && estadoDC.getAutomatico()) {
            	plazoRestante = estadoDC.getPlazo();
            } else {
            	plazoRestante = calcularTiempoRestante(idExpediente, estadoCE.getPlazo() + estadoRE.getPlazo() + estadoDC.getPlazo(), fechaFin);
            }
            estadoProcesoManager.pasarDeEstado(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, estadoDC, executionContext.getProcessInstance()
                    .getId());
            Long seconds = (plazoRestante.longValue() / MILLISECONDS);
            //SIEMPRE SE DEBE GENERAR LA TAREA DE DC
            //if (estadoDC.getAutomatico() != null && !estadoDC.getAutomatico())
            //{
            DtoGenerarTarea dto = new DtoGenerarTarea(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, SubtipoTarea.CODIGO_DECISION_COMITE,
                    false, false, plazoRestante, "");
            Long idTareaDC = notificacionManager.crearTarea(dto);
            if (fechaFin != null) {
                TareaNotificacion tareaActual = notificacionManager.get(idTareaDC);
                tareaActual.setFechaVenc(new Date(fechaFin));
                notificacionManager.saveOrUpdate(tareaActual);
            }
            executionContext.setVariable(TAREA_ASOCIADA_DC, idTareaDC);
            //}

            expedienteManager.setInstanteCambioEstadoExpediente(idExpediente);

            //En caso de que el estado sea automatico, llamar al caso de uso de generar
            //Decision automatica de asuntos.

            if (estadoDC.getAutomatico() != null && estadoDC.getAutomatico()) {
                BPMUtils.createTimer(executionContext, TIMER_TAREA_DC, seconds + " seconds", DECISION_COMITE_AUTO);
            } else {
                executionContext.setVariable(WHERE_TO_GO, DECISION_COMITE);
                BPMUtils.createTimer(executionContext, TIMER_TAREA_DC, seconds + " seconds", GENERAR_NOTIFICACION);
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
        return plazo - tiempoTranscurrido;
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
