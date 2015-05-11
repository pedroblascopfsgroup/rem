package es.capgemini.pfs.cliente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.ActionHandler;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;

/**
 * Clase que inicializa el proceso bpm de clientes y llama al crea clientes.
 * @author jbosnjak
 *
 */
@Component
public class IniciarProcesoClienteActionHandler implements ActionHandler, ClienteBPMConstants {

   private static final long serialVersionUID = 1L;
   private final Log logger = LogFactory.getLog(getClass());

   /**
    * funciona como delay para que no demore la generacion de clientes.
    * @param executionContext Contexto JBPM
    * @throws Exception e
    */
   public void execute(ExecutionContext executionContext) throws Exception {
      if (logger.isDebugEnabled()) {
         logger.debug("IniciarProcesoClienteActionHandler......");
      }
      String durationString = "1 seconds";
      BPMUtils.createTimer(executionContext, TIMER_INICIAR_PROCESO_CLIENTE, durationString, TRANSTION_CREA_CLIENTE);
   }
}
