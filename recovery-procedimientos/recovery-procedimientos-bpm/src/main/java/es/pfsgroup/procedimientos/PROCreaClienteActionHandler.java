package es.pfsgroup.procedimientos;

import java.util.Date;

import org.apache.commons.lang.time.StopWatch;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.pfsgroup.recovery.api.ClienteApi;

/**
 * Clase que maneja el nodo CrearCliente.
 * @author jbosnjak
 *
 */
public class PROCreaClienteActionHandler extends PROBaseActionHandler implements ClienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

 
    /**
     * Crea un cliente.
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("CreaClienteActionHandler......");
        }
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();
        //Creo el cliente
        Long idPersona = (Long) executionContext.getVariable(PERSONA_ID);
        Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);
        Long clienteId = null;
        try {
        	clienteId = proxyFactory.proxy(ClienteApi.class).crearCliente(idPersona, new Long(executionContext.getProcessInstance().getId()), idArquetipo, false);
            executionContext.setVariable(CLIENTE_ID, clienteId);
        } catch (RuntimeException e) {

            //Si la excepción la ha provocado una excepcion controlada por duplicidad de cliente la mostramos como info
            if (e.getMessage().startsWith("Esta persona")) {
                logger.info(e.getMessage());
                //Si es una excepción sin controlar la mostramos como error
            } else {
                logger.error("Error al crear el cliente para la persona " + idPersona, e);
            }
            executionContext.getProcessInstance().end();
            return;
        }
        stopWatch.stop();
        if (logger.isDebugEnabled()) {
            logger.debug("CREA CLIENTE: " + clienteId + " -> " + stopWatch.getTime() + " ms.");
        }
        
        Cliente cliente = proxyFactory.proxy(ClienteApi.class).getWithContratos(clienteId);
        Date fechaVencida = cliente.getFechaCreacion();

        Long hoy = System.currentTimeMillis();
        Long tiempoVencido = hoy - fechaVencida.getTime();
        executionContext.setVariable(TIEMPO_VENCIDO_CLIENTE, tiempoVencido);
        executionContext.getToken().signal();
    }
}
