package es.capgemini.pfs.cliente.process;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.Node;
import org.jbpm.graph.def.Transition;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.itinerario.EstadoProcesoManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;

/**
 * Espera a que termine la gestion de  vencidos y expedimenta.
 * @author jbosnjak
 *
 */
@Component
public class GestionVencidosActionHandler extends JbpmActionHandler implements ClienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ClienteManager clienteManager;

    @Autowired
    private EstadoProcesoManager estadoProcesoManager;

    /**
     * Espera una determinada cantidad de tiempo.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("GestionVencidosActionHandler......");
        }
        Long clienteId = (Long) executionContext.getVariable(CLIENTE_ID);

        Cliente cliente = clienteManager.getWithEstado(clienteId);

        Estado estadoGV = cliente.getArquetipo().getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);

        estadoProcesoManager.pasarDeEstado(clienteId, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE, estadoGV, executionContext.getProcessInstance().getId());
        cliente.setFechaEstado(new Date());
        clienteManager.saveOrUpdate(cliente);

        if (estadoGV.getTelecobro()) {
            /*
             * De validar los plazos seria razonable que el plazo inicial menos lo dias de antelacion sea negativo
             * para que se ejecute inmediatamente
             */
            EstadoTelecobro estTelecobro = estadoGV.getEstadoTelecobro();
            // Tiempo que pasa antes de crear tarea de verificar telecobro
            Long telecobro = (estTelecobro.getPlazoInicial().longValue() / MILLISECONDS) - estTelecobro.getDiasAntelacion().longValue()
                    * SECONDS_IN_A_DAY;

            String durationString = telecobro + " seconds";
            BPMUtils.createTimer(executionContext, TIMER_TELECOBRO, durationString, TRANSITION_VERIFICAR_TELECOBRO);

            //Creamos las transiciones si no existieran (existen a partir de la version 2.0.0.0.32)
            nuevaTransicion(executionContext, TRANSITION_EXPEDIMENTAR_CLIENTE, "VerificarTelecobro");
            nuevaTransicion(executionContext, TRANSITION_EXPEDIMENTAR_CLIENTE, "ConTelecobro");
            nuevaTransicion(executionContext, TRANSITION_EXPEDIMENTAR_CLIENTE, "SolicitarExcluirTelecobro");
            nuevaTransicion(executionContext, TRANSITION_EXPEDIMENTAR_CLIENTE, "SinTelecobro");
        }

        cliente = clienteManager.getWithEstado(clienteId);
        Long plazo = cliente.getTiempoParaCambioEstado();
        Date dueDate = new Date(System.currentTimeMillis() + plazo);

        BPMUtils.createTimer(executionContext, TIMER_GESTION_VENCIDO_CLIETE, dueDate, TRANSITION_EXPEDIMENTAR_CLIENTE);
    }

    /**
     * Comprueba si existe la transicion.
     * @param executionContext ExecutionContext
     * @param nombreTransicion String
     * @param nombreNodo String
     * @return boolean
     */
    protected boolean existeTransicion(ExecutionContext executionContext, String nombreTransicion, String nombreNodo) {
        Node node = executionContext.getProcessDefinition().getNode(nombreNodo);
        return node.hasLeavingTransition(nombreTransicion);
    }

    /**
     * Le añade una transición al nodo.
     * @param executionContext ExecutionContext
     * @param nombreTransicion String
     * @param nombreNodo String
     */
    protected void nuevaTransicion(ExecutionContext executionContext, String nombreTransicion, String nombreNodo) {

        //Si existe no la creamos
        if (existeTransicion(executionContext, nombreTransicion, nombreNodo)) { return; }

        Node nodoOrigen = executionContext.getNode();
        Node nodoDestino = executionContext.getProcessDefinition().getNode(nombreNodo);

        Transition transition = new Transition();
        transition.setFrom(nodoOrigen);
        transition.setTo(nodoDestino);
        transition.setName(nombreTransicion);
        transition.setProcessDefinition(executionContext.getProcessDefinition());

        nodoOrigen.addLeavingTransition(transition);
    }

}
