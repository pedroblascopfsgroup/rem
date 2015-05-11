package es.capgemini.pfs.tareaNotificacion.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.ComunicacionBPM;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Handler del Nodo solicitar tarea.
 * @author jbosnjak
 *
 */
@Component
public class SolicitarTareaActionHandler extends JbpmActionHandler implements TareaBPMConstants {

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
        if (logger.isDebugEnabled()) {
            logger.debug("EJECUTANDO SolicitarTareaActionHandler");
        }
        //Debo crear la tarea
        Long idEntidad = (Long) executionContext.getVariable(ID_ENTIDAD_INFORMACION);
        String tipoEntidad = (String) executionContext.getVariable(CODIGO_TIPO_ENTIDAD);
        String codigoSubtipoTarea = (String) executionContext.getVariable(CODIGO_SUBTIPO_TAREA);
        Long plazo = (Long) executionContext.getVariable(PLAZO_PROPUESTA);
        Boolean espera = JBPMProcessManager.getFixeBooleanValue(executionContext, ESPERA);
        if (espera == null) {
            espera = true;
        }

        String descripcion = (String) executionContext.getVariable(DESCRIPCION_TAREA);
        DtoGenerarTarea dto = new DtoGenerarTarea(idEntidad, tipoEntidad, codigoSubtipoTarea, espera, false, plazo, descripcion);
        Long idTarea = notificacionManager.crearTarea(dto);

        Prorroga prorroga = (Prorroga) executionContext.getVariable(PRORROGA_ASOCIADA);
        ComunicacionBPM comunicacion = (ComunicacionBPM) executionContext.getVariable(COMUNICACION_BPM);
        //Seteo la prorroga y la comunicacion en caso de que corresponda
        TareaNotificacion tarea = notificacionManager.get(idTarea);
        tarea.setProrroga(prorroga);
        tarea.setComunicacionBPM(comunicacion);
        notificacionManager.saveOrUpdate(tarea);
        executionContext.setVariable(ID_TAREA, idTarea);

        executionContext.getProcessInstance().signal(TRANSITION_TAREA_SOLICITADA);
    }

}
