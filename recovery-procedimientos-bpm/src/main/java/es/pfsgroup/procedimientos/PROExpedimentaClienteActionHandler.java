package es.pfsgroup.procedimientos;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.Node;
import org.jbpm.graph.def.Transition;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.tareaNotificacion.dao.PlazoTareasDefaultDao;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.recovery.api.ClienteApi;
import es.pfsgroup.recovery.api.JBPMProcessApi;

/**
 * Crea el proceso de expediente.
 * @author jbosnjak
 *
 */
public class PROExpedimentaClienteActionHandler extends PROBaseActionHandler implements ClienteBPMConstants, ExpedienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private PlazoTareasDefaultDao plazoTareaDefaultDao;

    /**
     * Crea el proceso de expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("ExpedimentaClienteActionHandler......");
        }
        
        ClienteApi clienteMgr = proxyFactory.proxy(ClienteApi.class);
        JBPMProcessApi expUtil = proxyFactory.proxy(JBPMProcessApi.class);

        //Parche que se ha tenido que hacer por no seguir el estandard de llamar a todos las transiciones 'Fin'
        cambiarNombreTransicion(executionContext, "fin", "Fin");

        //Otro parche por si existen clientes viejos que no tienen transición a fin
        nuevaTransicion(executionContext, "Fin", "Fin");

        Long idCliente = (Long) executionContext.getVariable(CLIENTE_ID);
        Date fechaExtraccion = (Date) executionContext.getVariable(FECHA_EXTRACCION);
        //Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);

        Cliente cli = clienteMgr.getWithContratos(idCliente);

        //Si el cliente no existe o se ha borrado se mata el BPM actual
        if (cli == null || cli.getAuditoria().isBorrado()) {
            logger.debug("Cliente " + cli.getId() + " ya fue borrado por otro proceso. Se controla la paralelización");
            executionContext.getToken().signal("Fin");
        } else {

            Long idContrato = cli.getContratoPrincipal().getId();
            Long idPersona = cli.getPersona().getId();
            Date fechaUmbral = cli.getPersona().getFechaUmbral();
            Float umbral = cli.getPersona().getImporteUmbral();
            //BUG: No se setea cuando se cambia de arquetipo y por tanto se ha tenido que añadir esto

            Long idArquetipo = cli.getArquetipo().getId();
            executionContext.setVariable(ARQUETIPO_ID, idArquetipo);

            Map<String, Object> param = new HashMap<String, Object>();

            param.put(PERSONA_ID, idPersona);
            param.put(CONTRATO_ID, idContrato);
            param.put(FECHA_EXTRACCION, fechaExtraccion);
            param.put(ARQUETIPO_ID, idArquetipo);
            param.put(IDBPMCLIENTE, executionContext.getProcessInstance().getId());
            if (fechaUmbral != null && (fechaUmbral.getTime() > System.currentTimeMillis())) {

                //Float importe = cli.getPersona().getTotalRiesgo();
                Float importe = cli.getPersona().getRiesgoDirectoVencido();

                //Hay que tomar en cuanta el umbral
                if (umbral > importe) {
                    //Se tiene que quedar en GV
                    cli.setFechaGestionVencidos(new Date());
                    clienteMgr.saveOrUpdate(cli);
                    PlazoTareasDefault ptd = plazoTareaDefaultDao.buscarPorCodigo(PlazoTareasDefault.CODIGO_VERIFICACION_UMBRAL);
                    Date dueDate = new Date(System.currentTimeMillis() + ptd.getPlazo());

                    //Compruebo si la transición existe y si no existe la creo para el contexto nuevo

                    nuevaTransicion(executionContext, TRANSITION_GESTION_VENCIDOS, "GestionVencidos");

                    BPMUtils.createTimer(executionContext, TIMER_GESTION_VENCIDO_CLIETE, dueDate, TRANSITION_GESTION_VENCIDOS);
                    logger.warn("\n\n\nMando de nuevo por umbral al cliente " + cli.getId() + "\n\n\n");
                } else {
                    //Crear proceso de expediente
                    expUtil.crearNewProcess(EXPEDIENTE_PROCESO, param);
                    //Esto lo hacemos por si no tiene transicion a Fin, llamamos a la transición por defecto
                    try {
                        executionContext.getToken().signal("Fin");
                    } catch (Exception e) {
                        if (executionContext.getNode().getLeavingTransitions() != null
                                && executionContext.getNode().getLeavingTransitions().size() == 1) {
                            executionContext.getToken().signal();
                        }
                    }
                }
            } else {
                // 	Crear proceso de expediente
                expUtil.crearNewProcess(EXPEDIENTE_PROCESO, param);
                //Esto lo hacemos por si no tiene transicion a Fin, llamamos a la transición por defecto
                try {
                    executionContext.getToken().signal("Fin");
                } catch (Exception e) {
                    if (executionContext.getNode().getLeavingTransitions() != null && executionContext.getNode().getLeavingTransitions().size() == 1) {
                        executionContext.getToken().signal();
                    }
                }
            }
        }
    }

    /**
     * Comprueba si existe la transicion.
     * @param executionContext ExecutionContext
     * @param name String
     * @return boolean
     */
    protected boolean existeTransicion(ExecutionContext executionContext, String name) {
        Node node = executionContext.getNode();
        return node.hasLeavingTransition(name);
    }

    /**
     * @param executionContext ExecutionContext
     * @param oldName String
     * @param newName String
     */
    protected void cambiarNombreTransicion(ExecutionContext executionContext, String oldName, String newName) {
        if (!existeTransicion(executionContext, oldName)) { return; }

        Node node = executionContext.getNode();
        Transition t = node.getLeavingTransition(oldName);
        t.setName(newName);
    }

    /**
     * Le añade una transición al nodo.
     * @param executionContext ExecutionContext
     * @param name String
     * @param nodo String
     */
    protected void nuevaTransicion(ExecutionContext executionContext, String name, String nodo) {
        if (existeTransicion(executionContext, name)) { return; }
        Node nodoOrigen = executionContext.getNode();
        Node nodoDestino = executionContext.getProcessDefinition().getNode(nodo);

        if (nodoOrigen != null && nodoDestino != null) {

            Transition transition = new Transition();
            transition.setFrom(nodoOrigen);
            transition.setTo(nodoDestino);
            transition.setName(name);
            transition.setProcessDefinition(executionContext.getProcessDefinition());

            nodoOrigen.addLeavingTransition(transition);
        }
    }

}
