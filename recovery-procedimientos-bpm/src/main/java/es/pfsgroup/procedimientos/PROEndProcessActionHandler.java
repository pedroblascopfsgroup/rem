package es.pfsgroup.procedimientos;

import static es.capgemini.pfs.BPMContants.TOKEN_JBPM_PADRE;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;


/**
 * PONER JAVADOC FO.
 */
public class PROEndProcessActionHandler extends PROBaseActionHandler {
    private static final long serialVersionUID = 1L;

    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {

        logger.debug("Llegamos al final del BPM [" + getNombreProceso(executionContext) + "]");

        //si este proceso ha sido iniciado por otro, lanzará una señal con su nombre
        if (hasVariable(TOKEN_JBPM_PADRE, executionContext)) {

            Long idToken = (Long) getVariable(TOKEN_JBPM_PADRE, executionContext);
            String transitionName = getNombreProceso(executionContext);

            //Si cuando vayamos a avisar al nodo, existe ese nodo activo y existe una transición correcta
            if (proxyFactory.proxy(JBPMProcessApi.class).hasTransitionToken(idToken, transitionName)) {
            	proxyFactory.proxy(JBPMProcessApi.class).signalToken(idToken, transitionName);
            }
        }
    }

}
