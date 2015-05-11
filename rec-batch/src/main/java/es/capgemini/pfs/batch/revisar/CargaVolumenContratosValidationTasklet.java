package es.capgemini.pfs.batch.revisar;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.pfs.batch.common.ValidationTasklet;
import es.capgemini.pfs.batch.revisar.cargaVolumenContratos.CargaVolumenContratosBatchManager;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;

/**
 * Realiza las validaciones de volúmenes de los contratos cargados en el job de validaciones
 * previa a la carga a producción (ver BATCH-83).
 * @author Mariano Ruiz
 */
public class CargaVolumenContratosValidationTasklet implements ValidationTasklet {

    private static final double CIEN_PORCIENTO = 100.0;

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private CargaVolumenContratosBatchManager cargaVolumenContratosBatchManager;

    @Autowired
    private ParametrizacionDao parametrizacionDao;
    // Severidad del error en caso de superarse alguno de los umbrales de tolerancia
    private String severidad;

    private static final String ALTO = " alto";
    private static final String BAJO = " bajo";
    private String mensajeFinal;
    private String mensajeActivoLineas;
    private String mensajeActivoPosicionViva;
    private String mensajeActivoPosicionVencida;
    private String mensajePasivoLineas;
    private String mensajePasivoPosicionVencida;
    private String mensajePasivoPosicionViva;

    // Porcentajes de tolerancia a cambios con respecto a la carga anterior
    private Double porcentajeToleranciaActivoLineas;
    private Double porcentajeToleranciaActivoPosicionVencida;
    private Double porcentajeToleranciaActivoPosicionViva;
    private Double porcentajeToleranciaPasivoLineas;
    private Double porcentajeToleranciaPasivoPosicionVencida;
    private Double porcentajeToleranciaPasivoPosicionViva;

    private String fileName;
    private String bindings;

    /**
     * Método de ejecución de la clase.
     * @return ExitStatus
     */
    @Override
    public ExitStatus execute() {

        // Datos estadísticos de la carga actual
        Date fechaExtraccion = new Date();
        String perFicheroCarga = fileName;

        Map<String, Object> result = cargaVolumenContratosBatchManager.buscarVolumenContratos();

        BigDecimal activoLineas = castObjectToBigDecimal(result.get("activoLineas"));
        BigDecimal activoPosVencida = castObjectToBigDecimal(result.get("activoPosicionVencida"));
        BigDecimal pasivoLineas = castObjectToBigDecimal(result.get("pasivoLineas"));
        BigDecimal pasivoPosVencida = castObjectToBigDecimal(result.get("pasivoPosicionVencida"));
        BigDecimal activoPosViva = castObjectToBigDecimal(result.get("activoPosicionViva"));
        BigDecimal pasivoPosViva = castObjectToBigDecimal(result.get("pasivoPosicionViva"));

        // Obtiene el Id de la última registración
        Long idUltimaValidacion = cargaVolumenContratosBatchManager.buscarUltimaValidacion();
        // Se compara la última registración con el estado actual de los registros, y luego se graba
        if (idUltimaValidacion != null) {
            // Valores de las variables del registro anterior
            result = cargaVolumenContratosBatchManager.buscarDatosValidacionAnterior(idUltimaValidacion);

            BigDecimal activoLineasAnterior = castObjectToBigDecimal(result.get("activoLineas"));
            BigDecimal activoPosVencidaAnt = castObjectToBigDecimal(result.get("activoPosicionVencida"));
            BigDecimal pasivoLineasAnterior = castObjectToBigDecimal(result.get("pasivoLineas"));
            BigDecimal pasivoPosVencidaAnt = castObjectToBigDecimal(result.get("pasivoPosicionVencida"));
            BigDecimal activoPosVivaAnt = castObjectToBigDecimal(result.get("activoPosicionViva"));
            BigDecimal pasivoPosVivaAnt = castObjectToBigDecimal(result.get("pasivoPosicionViva"));

            // Se comparan las variables anteriores con la actual, y se evalúa si supera los umbrales normales
            // Reviso que los porcentajes de los valores de las posiciones sean correctas
            if (isPorcentajeLineasErroneo(activoLineas, activoLineasAnterior, mensajeActivoLineas, getPorcentajeToleranciaActivoLineas())) { return createErrorExit(); }
            if (isPorcentajeLineasErroneo(pasivoLineas, pasivoLineasAnterior, mensajePasivoLineas, getPorcentajeToleranciaPasivoLineas())) { return createErrorExit(); }

            // Reviso que los porcentajes de los valores de las posiciones sean correctas
            if (isPorcentajeValorErroneo(activoPosVencida, activoPosVencidaAnt, mensajeActivoPosicionViva,
                    getPorcentajeToleranciaActivoPosicionVencida())) { return createErrorExit(); }
            if (isPorcentajeValorErroneo(activoPosViva, activoPosVivaAnt, mensajeActivoPosicionVencida, getPorcentajeToleranciaActivoPosicionViva())) { return createErrorExit(); }
            if (isPorcentajeValorErroneo(pasivoPosVencida, pasivoPosVencidaAnt, mensajePasivoPosicionVencida,
                    getPorcentajeToleranciaPasivoPosicionVencida())) { return createErrorExit(); }
            if (isPorcentajeValorErroneo(pasivoPosViva, pasivoPosVivaAnt, mensajePasivoPosicionViva, getPorcentajeToleranciaPasivoPosicionViva())) { return createErrorExit(); }

            // Grabamos en la BD el nuevo registro de validaciones de carga
            cargaVolumenContratosBatchManager.insertValidacionCarga(fechaExtraccion, perFicheroCarga, activoLineas, activoPosVencida, activoPosViva,
                    pasivoLineas, pasivoPosVencida, pasivoPosViva);

            logger.debug("Finalizada la actualización del registro de carga correctamente");
            return ExitStatus.FINISHED;
        }
        logger.debug("No hay registros de carga de datos previos");
        cargaVolumenContratosBatchManager.insertValidacionCarga(fechaExtraccion, perFicheroCarga, activoLineas, activoPosVencida, activoPosViva,
                pasivoLineas, pasivoPosVencida, pasivoPosViva);
        logger.debug("Se ha grabado el primer registro de carga de datos previos");
        return ExitStatus.FINISHED;

    }

    private ExitStatus createErrorExit() {
        logger.error("Finalizada la actualización del registro de carga con errores");
        return new ExitStatus(false, ExitStatus.FAILED.getExitCode(), mensajeFinal);
    }

    /**
     * Evalúa si el valor pasado está dentro de los niveles de volúmenes tolerado.
     * @param valor BigDecimal: valor a evaluar (activo, pasivo..)
     * @param valorAnt BigDecimal: valor anterior
     * @param mensaje String: mensaje de error a lanzar en el error channel
     * @param tolerancia Double: porcentaje de tolerancia (pasado como parámetro al batch)
     * @return boolean: <code>true</code> hubo error, <code>false</code> no hubo error
     */
    private boolean isPorcentajeValorErroneo(BigDecimal valor, BigDecimal valorAnt, String mensaje, Double tolerancia) {
        boolean error = false;
        double porcentaje = 0.0;
        if (valor.longValue() != 0.0) {
            porcentaje = valorAnt.doubleValue() / valor.doubleValue() * CIEN_PORCIENTO;
        } else {
            if (valorAnt.longValue() == 0) {
                porcentaje = CIEN_PORCIENTO;
            }
        }
        if (porcentaje <= CIEN_PORCIENTO - tolerancia) {
            Object[] params = new Object[] { BAJO, porcentaje };
            EventBatchUtil.getInstance().throwEventErrorChannel(mensaje, severidad, false, params);
            error = true;
        } else {
            if (porcentaje >= CIEN_PORCIENTO + tolerancia) {
                Object[] params = new Object[] { ALTO, porcentaje };
                EventBatchUtil.getInstance().throwEventErrorChannel(mensaje, severidad, false, params);
                error = true;
            }
        }
        return error;
    }

    /**
     * Evalúa si el número de líneas pasado está dentro de los niveles de volúmenes tolerado.
     * @param lineas BigDecimal: número de líneas a evaluar (activo, pasivo..)
     * @param lineasAnt BigDecimal: valor anterior
     * @param mensaje String: mensaje de error a lanzar en el error channel
     * @param tolerancia Double: porcentaje de tolerancia (pasado como parámetro al batch)
     * @return boolean: <code>true</code> hubo error, <code>false</code> no hubo error
     */
    private boolean isPorcentajeLineasErroneo(BigDecimal lineas, BigDecimal lineasAnt, String mensaje, Double tolerancia) {
        boolean error = false;
        double porcentaje = 0.0;
        if (lineas != null && lineas.longValue() != 0) {
            porcentaje = lineasAnt.doubleValue() / lineas.doubleValue() * CIEN_PORCIENTO;
        } else {
            if (lineasAnt.longValue() == 0) {
                porcentaje = CIEN_PORCIENTO;
            }
        }
        if (porcentaje <= CIEN_PORCIENTO - tolerancia) {
            Object[] params = new Object[] { BAJO, porcentaje };
            EventBatchUtil.getInstance().throwEventErrorChannel(mensaje, severidad, false, params);
            error = true;
        } else {
            if (porcentaje >= CIEN_PORCIENTO + tolerancia) {
                Object[] params = new Object[] { ALTO, porcentaje };
                EventBatchUtil.getInstance().throwEventErrorChannel(mensaje, severidad, false, params);
                error = true;
            }
        }
        return error;
    }

    /**
     * castObjectToBigDecimal.
     * @param o Object
     * @return Bigdecimal
     */
    private BigDecimal castObjectToBigDecimal(Object o) {
        if (o == null) { return null; }
        return new BigDecimal(o.toString());
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
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
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
        this.severidad = severidad;
    }

    /**
     * @param cargaVolumenContratosBatchManager the cargaVolumenContratosBatchManager to set
     */
    public void setCargaVolumenContratosBatchManager(CargaVolumenContratosBatchManager cargaVolumenContratosBatchManager) {
        this.cargaVolumenContratosBatchManager = cargaVolumenContratosBatchManager;
    }

    /**
     * @param mensajeActivoLineas the mensajeActivoLineas to set
     */
    public void setMensajeActivoLineas(String mensajeActivoLineas) {
        this.mensajeActivoLineas = mensajeActivoLineas;
    }

    /**
     * @param mensajeActivoPosicionViva the mensajeActivoPosicionViva to set
     */
    public void setMensajeActivoPosicionViva(String mensajeActivoPosicionViva) {
        this.mensajeActivoPosicionViva = mensajeActivoPosicionViva;
    }

    /**
     * @param mensajeActivoPosicionVencida the mensajeActivoPosicionVencida to set
     */
    public void setMensajeActivoPosicionVencida(String mensajeActivoPosicionVencida) {
        this.mensajeActivoPosicionVencida = mensajeActivoPosicionVencida;
    }

    /**
     * @param mensajePasivoLineas the mensajePasivoLineas to set
     */
    public void setMensajePasivoLineas(String mensajePasivoLineas) {
        this.mensajePasivoLineas = mensajePasivoLineas;
    }

    /**
     * @param mensajePasivoPosicionVencida the mensajePasivoPosicionVencida to set
     */
    public void setMensajePasivoPosicionVencida(String mensajePasivoPosicionVencida) {
        this.mensajePasivoPosicionVencida = mensajePasivoPosicionVencida;
    }

    /**
     * @param mensajePasivoPosicionViva the mensajePasivoPosicionViva to set
     */
    public void setMensajePasivoPosicionViva(String mensajePasivoPosicionViva) {
        this.mensajePasivoPosicionViva = mensajePasivoPosicionViva;
    }

    /**
     * @param mensajeFinal the mensajeFinal to set
     */
    public void setMensajeFinal(String mensajeFinal) {
        this.mensajeFinal = mensajeFinal;
    }

    /**
     * @param fileName the fileName to set
     */
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    /**
     * @return the bindings
     */
    public String getBindings() {
        return bindings;
    }

    /**
     * @param bindings the bindings to set
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

    /**
     * @return the porcentajeToleranciaActivoLineas
     */
    public Double getPorcentajeToleranciaActivoLineas() {
        if (porcentajeToleranciaActivoLineas == null) {
            porcentajeToleranciaActivoLineas = new Double(parametrizacionDao.buscarParametroPorNombre(
                    Parametrizacion.PORCENTAJE_TOLERANCIA_ACTIVO_LINEAS).getValor());
        }
        return porcentajeToleranciaActivoLineas;
    }

    /**
     * @return the porcentajeToleranciaActivoPosicionVencida
     */
    public Double getPorcentajeToleranciaActivoPosicionVencida() {
        if (porcentajeToleranciaActivoPosicionVencida == null) {
            porcentajeToleranciaActivoPosicionVencida = new Double(parametrizacionDao.buscarParametroPorNombre(
                    Parametrizacion.PORCENTAJE_TOLERANCIA_ACTIVO_POSICION_VENCIDA).getValor());
        }
        return porcentajeToleranciaActivoPosicionVencida;
    }

    /**
     * @return the porcentajeToleranciaActivoPosicionViva
     */
    public Double getPorcentajeToleranciaActivoPosicionViva() {
        if (porcentajeToleranciaActivoPosicionViva == null) {
            porcentajeToleranciaActivoPosicionViva = new Double(parametrizacionDao.buscarParametroPorNombre(
                    Parametrizacion.PORCENTAJE_TOLERANCIA_ACTIVO_POSICION_VIVA).getValor());
        }
        return porcentajeToleranciaActivoPosicionViva;
    }

    /**
     * @return the porcentajeToleranciaPasivoLineas
     */
    public Double getPorcentajeToleranciaPasivoLineas() {
        if (porcentajeToleranciaPasivoLineas == null) {
            porcentajeToleranciaPasivoLineas = new Double(parametrizacionDao.buscarParametroPorNombre(
                    Parametrizacion.PORCENTAJE_TOLERANCIA_PASIVO_LINEAS).getValor());
        }
        return porcentajeToleranciaPasivoLineas;
    }

    /**
     * @return the porcentajeToleranciaPasivoPosicionVencida
     */
    public Double getPorcentajeToleranciaPasivoPosicionVencida() {
        if (porcentajeToleranciaPasivoPosicionVencida == null) {
            porcentajeToleranciaPasivoPosicionVencida = new Double(parametrizacionDao.buscarParametroPorNombre(
                    Parametrizacion.PORCENTAJE_TOLERANCIA_PASIVO_POSICION_VENCIDA).getValor());
        }
        return porcentajeToleranciaPasivoPosicionVencida;
    }

    /**
     * @return the porcentajeToleranciaPasivoPosicionViva
     */
    public Double getPorcentajeToleranciaPasivoPosicionViva() {
        if (porcentajeToleranciaPasivoPosicionViva == null) {
            porcentajeToleranciaPasivoPosicionViva = new Double(parametrizacionDao.buscarParametroPorNombre(
                    Parametrizacion.PORCENTAJE_TOLERANCIA_PASIVO_POSICION_VIVA).getValor());
        }
        return porcentajeToleranciaPasivoPosicionViva;
    }

}
