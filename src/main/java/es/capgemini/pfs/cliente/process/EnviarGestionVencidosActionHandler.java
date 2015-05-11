package es.capgemini.pfs.cliente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;

/**
 * Envia el proceso a gestion de vencidos.
 * @author jbosnjak
 *
 */
@Component
public class EnviarGestionVencidosActionHandler extends JbpmActionHandler implements ClienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ClienteManager clienteManager;

    /**
     * Envia a Gestion de vencidos.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("EnviarGestionVencidosActionHandler......");
        }

        Long idCliente = (Long) executionContext.getVariable(CLIENTE_ID);

        clienteManager.cambiarEstadoItinerarioCliente(idCliente, DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        if (logger.isDebugEnabled()) {
            logger.debug("Cambie el estado del cliente a GV");
        }
        executionContext.getToken().signal();
    }

}
