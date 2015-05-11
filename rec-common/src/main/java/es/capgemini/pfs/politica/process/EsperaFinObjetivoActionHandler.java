package es.capgemini.pfs.politica.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.politica.ObjetivoBPMConstants;
import es.capgemini.pfs.politica.ObjetivoManager;
import es.capgemini.pfs.politica.model.Objetivo;

/**
 * Clase que maneja la comprobación de un objetivo.
 * @author pajimene
 *
 */
@Component
public class EsperaFinObjetivoActionHandler extends JbpmActionHandler {

    private static final long serialVersionUID = 1L;

    @Autowired
    private ObjetivoManager objetivoManager;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Comprueba el cumplimiento de un objetivo.
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        Long idObjetivo = (Long) executionContext.getVariable(ObjetivoBPMConstants.ID_OBJETIVO);
        if (idObjetivo == null) {
            logger.error("No se encuentra el objetivo para recuperar. BPM: " + executionContext.getProcessInstance().getId());
        }
        Objetivo objetivo = objetivoManager.getObjetivo(idObjetivo);
        if (idObjetivo == null) {
            logger.error("No se puede recuperar el objetivo con ID: " + idObjetivo);
        }

        BPMUtils.createTimer(executionContext, "timer_" + ObjetivoBPMConstants.TRANSICION_COMPRUEBA_OBJETIVO, objetivo.getFechaLimite(),
                ObjetivoBPMConstants.TRANSICION_COMPRUEBA_OBJETIVO);
    }
}
