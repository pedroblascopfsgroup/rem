package es.capgemini.pfs.expediente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Handler del Nodo Congelar Expediente.
 * @author jbosnjak
 *
 */
@Component
public class ExpedienteDecididoActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    @Autowired
    private TareaNotificacionManager notificacionManager;

    /**
     * Este metodo debe llamar al caso de uso de decision de expediente.
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        logger.debug("---------ENTRE EN ExpedienteDecididoActionHandler---------");
        //Borra el timer en caso de que no se haya ejecutado
        BPMUtils.deleteTimer(executionContext);

        //Borra la tarea asociada a RE
        Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_DC);
        if (idTarea != null) {
            notificacionManager.borrarNotificacionTarea(idTarea);
        }

        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);

        notificacionManager.crearNotificacion(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_DECISION_TOMADA, null);

        executionContext.getProcessInstance().signal();
    }

}
