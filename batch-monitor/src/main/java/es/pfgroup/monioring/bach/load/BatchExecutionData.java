package es.pfgroup.monioring.bach.load;

/**
 * Información sobre la ejecución del batch.
 * 
 * @author bruno
 * 
 */
public class BatchExecutionData {

    private final boolean running;
    private final boolean errors;
    private final boolean executed;
	private boolean noop;
    
    public BatchExecutionData(final boolean flagRunning, final boolean flagErrors, final boolean flagExecuted, final boolean flagNoop) {
        running = flagRunning;
        errors = flagErrors;
        executed = flagExecuted;
        noop = flagNoop;
    }

    /**
     * Indica si se ha detectado alguna ejecución del batch.
     * 
     * @return
     */
    public boolean hasExecuted() {
        return executed;
    }

    /**
     * Indica si hay algún error en alguna ejecución del batch.
     * @return
     */
    public boolean hasErrors() {
        return errors;
    }

    /**
     * Indica si el job se está ejecutando en este momento
     * @return
     */
    public boolean isRunning() {
        return running;
    }
    
    /**
     * Indica si el job ha finalizado con un código NOOP
     * @return
     */
    public boolean finishWithNOOP(){
    	return noop;
    }

}
