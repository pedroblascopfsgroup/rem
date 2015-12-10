package es.capgemini.devon.batch.tasks;

import es.capgemini.devon.batch.BatchException;

/**
 * @author Nicol�s Cornaglia
 */
public class BatchTaskletException extends BatchException {

    private static final long serialVersionUID = 1L;

    protected BatchTaskletException() {
        super();
    }

    public BatchTaskletException(Throwable cause) {
        super(cause);
    }

}
