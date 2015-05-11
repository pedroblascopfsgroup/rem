package es.capgemini.pfs.politica.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.politica.ObjetivoBPMConstants;
import es.capgemini.pfs.politica.ObjetivoManager;
import es.capgemini.pfs.politica.model.Objetivo;

/**
 * Clase que maneja la comprobación de un objetivo.
 * @author pajimene
 *
 */
@Component
public class CompruebaObjetivoActionHandler extends JbpmActionHandler {

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
        if (objetivo == null) {
            logger.error("No se puede recuperar el objetivo con ID: " + idObjetivo);
        }

        try {
            objetivoManager.revisarObjetivo(objetivo, false);
        } catch (Exception e) {
            logger.error("Error al revisar el objetivo con ID: " + idObjetivo, e);
        }

        executionContext.getProcessInstance().signal();
    }
}
