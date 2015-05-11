package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.pfsgroup.recovery.api.ClienteApi;

/**
 * Envia el proceso a gestion de vencidos.
 * @author jbosnjak
 *
 */
@Component
public class PROEnviarGestionVencidosActionHandler extends PROBaseActionHandler implements ClienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());


    /**
     * Envia a Gestion de vencidos.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("EnviarGestionVencidosActionHandler......");
        }

        Long idCliente = (Long) executionContext.getVariable(CLIENTE_ID);

        proxyFactory.proxy(ClienteApi.class).cambiarEstadoItinerarioCliente(idCliente, DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        
        if (logger.isDebugEnabled()) {
            logger.debug("Cambie el estado del cliente a GV");
        }
        executionContext.getToken().signal();
    }

}
