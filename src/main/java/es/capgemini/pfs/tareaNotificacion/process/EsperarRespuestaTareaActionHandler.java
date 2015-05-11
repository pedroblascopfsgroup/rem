package es.capgemini.pfs.tareaNotificacion.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;

/**
 * Handler del nodo Completar Expediente.
 * @author jbosnjak
 *
 */
@Component
public class EsperarRespuestaTareaActionHandler extends JbpmActionHandler implements TareaBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    /**Este metodo controla el estado de esperar por respuesta.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("EJECUTANDO EsperarRespuestaTareaActionHandler");
        }
        String comeFrom = executionContext.getTransitionSource().getName();
        if (!NODE_ACTIVAR_ALERTA.equals(comeFrom)) {
            Long plazo = (Long) executionContext.getVariable(PLAZO_PROPUESTA);
            Long seconds = plazo.longValue() / MILLISECONDS;

            BPMUtils.createTimer(executionContext, TIMER_TAREA_SOLICITADA, seconds + " seconds", TRANSITION_ACTIVAR_ALERTA);
        }
    }

}
