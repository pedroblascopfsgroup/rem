package es.capgemini.pfs.tareaNotificacion.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Handler del Nodo activar alerta.
 * @author jbosnjak
 *
 */
@Component
public class ActivarAlertaActionHandler extends JbpmActionHandler implements TareaBPMConstants {

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
    		logger.debug("EJECUTANDO ActivarAlertaActionHandler");
    	}
    	Long idTarea = (Long)executionContext.getVariable(ID_TAREA);
    	TareaNotificacion tarea = notificacionManager.get(idTarea);
    	tarea.setAlerta(true);
    	notificacionManager.saveOrUpdate(tarea);
    	executionContext.getProcessInstance().signal(TRANSITION_ALERTA_ACTIVADA);
    }

}
