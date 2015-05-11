package es.capgemini.pfs.batch.revisar;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.pfs.batch.common.ValidationTasklet;
import es.capgemini.pfs.batch.revisar.cargaVolumenContratos.CargaVolumenContratosBatchManager;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;

/**
 * Realiza las validaciones de volúmenes de los contratos cargados en el job de validaciones
 * previa a la carga a producción (ver BATCH-83).
 * @author Mariano Ruiz
 */
public class CargaVolumenContratosValidationTasklet implements ValidationTasklet {

    

    /**
     * Método de ejecución de la clase.
     * @return ExitStatus
     */
    @Override
    public ExitStatus execute() {

       
        return ExitStatus.FINISHED;

    }

   

    /**
     * afterStep.
     * @param stepExecution StepExecution
     * @return ExitStatus
     */
    @Override
    public ExitStatus afterStep(StepExecution stepExecution) {
        return null;
    }

    /**
     * beforeStep.
     * @param stepExecution StepExecution
     */
    @Override
    public void beforeStep(StepExecution stepExecution) {
    }

    /**
     * onErrorInStep.
     * @param stepExecution StepExecution
     * @param throwable Throwable
     * @return ExitStatus
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable throwable) {
        return null;
    }

    /*
     *
     *  Getters y Setters
     *
     */

    /**
     * @param severidad the severidad to set
     */
    public void setSeveridad(String severidad) {
    }

    /**
     * @param cargaVolumenContratosBatchManager the cargaVolumenContratosBatchManager to set
     */
    public void setCargaVolumenContratosBatchManager(CargaVolumenContratosBatchManager cargaVolumenContratosBatchManager) {
    }

    /**
     * @param mensajeActivoLineas the mensajeActivoLineas to set
     */
    public void setMensajeActivoLineas(String mensajeActivoLineas) {
    }

    /**
     * @param mensajeActivoPosicionViva the mensajeActivoPosicionViva to set
     */
    public void setMensajeActivoPosicionViva(String mensajeActivoPosicionViva) {
    }

    /**
     * @param mensajeActivoPosicionVencida the mensajeActivoPosicionVencida to set
     */
    public void setMensajeActivoPosicionVencida(String mensajeActivoPosicionVencida) {
    }

    /**
     * @param mensajePasivoLineas the mensajePasivoLineas to set
     */
    public void setMensajePasivoLineas(String mensajePasivoLineas) {
    }

    /**
     * @param mensajePasivoPosicionVencida the mensajePasivoPosicionVencida to set
     */
    public void setMensajePasivoPosicionVencida(String mensajePasivoPosicionVencida) {
    }

    /**
     * @param mensajePasivoPosicionViva the mensajePasivoPosicionViva to set
     */
    public void setMensajePasivoPosicionViva(String mensajePasivoPosicionViva) {
    }

    /**
     * @param mensajeFinal the mensajeFinal to set
     */
    public void setMensajeFinal(String mensajeFinal) {
    }

    /**
     * @param fileName the fileName to set
     */
    public void setFileName(String fileName) {
    }

    /**
     * @return the bindings
     */
    public String getBindings() {
    	return null;
    }

    /**
     * @param bindings the bindings to set
     */
    public void setBindings(String bindings) {
    }

    /**
     * @return the porcentajeToleranciaActivoLineas
     */
    public Double getPorcentajeToleranciaActivoLineas() {
        return null;
    }

    /**
     * @return the porcentajeToleranciaActivoPosicionVencida
     */
    public Double getPorcentajeToleranciaActivoPosicionVencida() {
       return null;
    }

    /**
     * @return the porcentajeToleranciaActivoPosicionViva
     */
    public Double getPorcentajeToleranciaActivoPosicionViva() {
    	return null;
    }

    /**
     * @return the porcentajeToleranciaPasivoLineas
     */
    public Double getPorcentajeToleranciaPasivoLineas() {
    	return null;
    }

    /**
     * @return the porcentajeToleranciaPasivoPosicionVencida
     */
    public Double getPorcentajeToleranciaPasivoPosicionVencida() {
    	return null;
    }

    /**
     * @return the porcentajeToleranciaPasivoPosicionViva
     */
    public Double getPorcentajeToleranciaPasivoPosicionViva() {
    	return null;
    }

}
