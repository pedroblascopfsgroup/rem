package es.capgemini.pfs.bpm.generic;

import static es.capgemini.pfs.BPMContants.TOKEN_JBPM_PADRE;

import org.springframework.stereotype.Component;

/**
 * PONER JAVADOC FO.
 */
@Component
public class EndProcessActionHandler extends BaseActionHandler {
    private static final long serialVersionUID = 1L;

    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {

        logger.debug("Llegamos al final del BPM [" + getNombreProceso() + "]");

        //si este proceso ha sido iniciado por otro, lanzará una señal con su nombre
        if (hasVariable(TOKEN_JBPM_PADRE)) {

            Long idToken = (Long) getVariable(TOKEN_JBPM_PADRE);
            String transitionName = getNombreProceso();

            //Si cuando vayamos a avisar al nodo, existe ese nodo activo y existe una transición correcta
            if (processUtils.hasTransitionToken(idToken, transitionName)) {
                processUtils.signalToken(idToken, transitionName);
            }
        }
    }

}
