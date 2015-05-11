package es.capgemini.pfs.politica.process;

import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;

/**
 * Handler del Nodo Congelar Expediente.
 * @author jbosnjak
 *
 */
@Component
public class ObjetivoExpiradoActionHandler extends JbpmActionHandler {

    private static final long serialVersionUID = 1L;

    /**
    * Este metodo debe llamar al caso de uso de decision de expediente.
    * @throws Exception e
    */
    @Override
    public void run() throws Exception {
        BPMUtils.deleteTimer(executionContext);
        executionContext.getProcessInstance().signal();
    }

}
