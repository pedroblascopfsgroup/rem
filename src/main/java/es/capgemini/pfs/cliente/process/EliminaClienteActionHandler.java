package es.capgemini.pfs.cliente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.ActionHandler;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.itinerario.EstadoProcesoManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Elimina El cliente al final del proceso.
 * @author jbosnjak
 *
 */
@Component
public class EliminaClienteActionHandler implements ActionHandler, ClienteBPMConstants, ExpedienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ClienteManager clienteMgr;
    @Autowired
    private EstadoProcesoManager estadoProcesoManager;

    /**
     * Crea el proceso de expediente.
     * @param executionContext Contexto JBPM
     * @throws Exception e
     */
    public void execute(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("EliminaClienteActionHandler......");
        }
        Long idCliente = (Long) executionContext.getVariable(CLIENTE_ID);

        //TODO revisar fase 2 porque no quieren la generacion/borrado de la tarea del cliente.
        //Long idTarea = (Long) executionContext.getVariable(ID_TAREA_GV);
        if (idCliente != null) {
            clienteMgr.eliminarCliente(idCliente);
            estadoProcesoManager.borrarEstadoProcesoActivo(idCliente, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
            if (logger.isDebugEnabled()) {
                logger.debug("Cliente con id " + idCliente + " eliminado");
            }
        }
        /*if (idTarea!=null){
          notificacionManager.borrarNotificacionTarea(idTarea);
        }*/
        // Borro los timers y jobs asociados
        BPMUtils.deleteTimer(executionContext);
    }
}
