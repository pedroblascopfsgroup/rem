package es.capgemini.devon.batch.tasks;

import es.capgemini.devon.batch.BatchException;

/**
 * @author Nicolás Cornaglia
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
