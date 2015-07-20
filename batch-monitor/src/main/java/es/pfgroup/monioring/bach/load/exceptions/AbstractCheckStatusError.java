package es.pfgroup.monioring.bach.load.exceptions;

public abstract class AbstractCheckStatusError extends RuntimeException {
    
    private static final long serialVersionUID = 2926125274276003858L;
    
    private final CheckStatusErrorType type;

    public AbstractCheckStatusError(CheckStatusErrorType type) {
        super();
        this.type = type;
    }
    
    public AbstractCheckStatusError(CheckStatusErrorType type, Throwable cause) {
        super(cause);
        this.type = type;
    }

    public CheckStatusErrorType getErrorType() {
        return this.type;
    }

}
