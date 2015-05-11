package es.capgemini.pfs.expediente.process;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.arquetipo.ArquetipoManager;
import es.capgemini.pfs.asunto.AsuntosManager;
import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Handler del Estado Decision Comite Autom�tico.
 * @author aesteban
 *
 */
@Component
public class DecisionComiteAutomaticaActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ArquetipoManager arquetipoManager;

    @Autowired
    private ExpedienteManager expedienteManager;

    @Autowired
    private AsuntosManager asuntoManager;

    @Autowired
    private TareaNotificacionManager tareaNotificacionManager;

    private static final long serialVersionUID = 1L;

    /**
     * Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("DesicionComiteAutomaticaActionHandler......");
        }

        Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);
        Estado estadoDC = arquetipoManager.getWithEstado(idArquetipo).getItinerario().getEstado(DDEstadoItinerario.ESTADO_DECISION_COMIT);
        DecisionComiteAutomatico dca = estadoDC.getDecisionComiteAutomatico();
        if (dca == null) { throw new BusinessOperationException("batch.dca.configuracion.noExiste"); }

        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        Long idAsunto = expedienteManager.crearDatosParaDecisionComiteAutomatica(idExpediente, dca);

        if (dca.getAceptacionAutomatico() && idAsunto != null) {
            List<TareaNotificacion> lista = tareaNotificacionManager.getListByAsunto(idAsunto);
            //Finalizo la tarea de confirmacion de asunto.
            for (TareaNotificacion tarea : lista) {
                if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                    tarea.setBorrado(true);
                    tareaNotificacionManager.saveOrUpdate(tarea);
                } else if (SubtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                    tarea.setBorrado(true);
                    tareaNotificacionManager.saveOrUpdate(tarea);
                }
            }
        }

        executionContext.getProcessInstance().signal();
    }

}
