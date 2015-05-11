package es.capgemini.pfs.tareaNotificacion.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;

/**
 * Handler del nodo de tarea completada.
 * @author jbosnjak
 *
 */
@Component
public class TareaCompletadaActionHandler extends JbpmActionHandler implements TareaBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private TareaNotificacionManager notificacionManager;

    private static final long serialVersionUID = 1L;

    /**Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
    	if (logger.isDebugEnabled()){
    		logger.debug("EJECUTANDO TareaCompletadaActionHandler");
    	}
    	Long idTarea = (Long)executionContext.getVariable(ID_TAREA);
    	notificacionManager.borrarNotificacionTarea(idTarea);
    	executionContext.getProcessInstance().signal(TRANSITION_FIN);
    }

}
