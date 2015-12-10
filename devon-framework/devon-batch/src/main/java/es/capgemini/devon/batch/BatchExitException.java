package es.capgemini.devon.batch;


/**
 * @author Nicolás Cornaglia
 */
public class BatchExitException extends BatchException {

    private static final long serialVersionUID = 1L;

    protected BatchExitException() {
        super();
    }

    public BatchExitException(Throwable cause) {
        super(cause);
    }

}
