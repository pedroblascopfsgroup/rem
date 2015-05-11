package es.pfsgroup.recovery.bpmframework.exceptions;

import es.capgemini.devon.bo.BusinessOperationException;

/**
 * Error genérico al invocar operaciones batch.
 * 
 * @author bruno
 * 
 */
public class RecoveryBPMfwkError extends BusinessOperationException {

    private static final long serialVersionUID = 5580411642648619077L;

    /**
     * Enumeración con los problemas que sabemos que puede haber.
     * 
     * @author bruno
     * 
     */
    public static enum ProblemasConocidos {
        ARGUMENTOS_INCORRECTOS,
        CONFIGURACION_AMBIGUA,
        CONFIGURACION_ERRONEA,
        ERROR_DE_PERSISTENCIA,
        ERROR_DE_EJECUCION,
        DESCONOCIDO, 
        ERROR_PROGRAMAR_BATCH,
        ERROR_PRE_PROCESADO_INPUT,
        ERROR_POST_PROCESADO_INPUT
    }

    final private ProblemasConocidos problema;

    final private Throwable excepcionOriginal;

    final private String mensajeError;

    /**
     * Creamos una excepción para un problema concreto.
     * 
     * @param problema
     */
    public RecoveryBPMfwkError(final ProblemasConocidos problema) {
        super();
        this.problema = problema;
        this.excepcionOriginal = null;
        this.mensajeError = dameMensajeErrorPara(problema);
    }

    /**
     * Creamos una excepción para un problema concreto, causado por una
     * excepción definida.
     * 
     * @param problema
     * @param excepcionOriginal
     */
    public RecoveryBPMfwkError(final ProblemasConocidos problema, final Throwable excepcionOriginal) {
        super(excepcionOriginal);
        this.problema = problema;
        this.excepcionOriginal = excepcionOriginal;
        this.mensajeError = dameMensajeErrorPara(problema);;
    }

    /**
     * Creamos una excepción para un problema concreto.
     * 
     * @param problema
     * @param mensajeError
     *            Mensaje de error que queremos que se muestre
     */
    public RecoveryBPMfwkError(final ProblemasConocidos problema, final String mensajeError) {
        super(mensajeError);
        this.problema = problema;
        this.excepcionOriginal = null;
        this.mensajeError = mensajeError;
    }
    
    /**
     * Crea una excepción para un problema concreto, con un texto concreto y causado por una
     * excepción definida.
     * 
     * @param problema
     * @param mensajeError 
     * 				 Mensaje de error que queremos que se muestre
     * @param excepcionOriginal
     */
    public RecoveryBPMfwkError(final ProblemasConocidos problema, final String mensajeError, final Throwable excepcionOriginal) {
        super(mensajeError);
        this.problema = problema;
        this.excepcionOriginal = excepcionOriginal;
        this.mensajeError = mensajeError;
    }    

    /**
     * Devuelve el problema que ha causado la excepción.
     * 
     * @return
     */
    public final ProblemasConocidos getProblema() {
        return problema;
    }

    /**
     * Devuelve la excepción original.
     * 
     * @return
     */
    public final Throwable getExcepcionOriginal() {
        return this.excepcionOriginal;
    }

    /**
     * Devuelve un mensaje con una breve explicación del error.
     * 
     * @return
     */
    public String getMensajeError() {
        return mensajeError;
    }

    /**
     * Método a sobreescribible por las clases hijas para que definan el mensaje de
     * error que se quiere mostrar para cada problema.
     * 
     * @param problema
     * @return
     */
    protected  String dameMensajeErrorPara(ProblemasConocidos problema){
        return "Ha habido un problema al ejecutar la operación";
    }

}
