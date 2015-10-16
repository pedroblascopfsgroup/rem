package es.pfgroup.monioring.bach.load.exceptions;

public class CheckStatusWrongArgumentsException extends Exception {

    private static final long serialVersionUID = -5991154616696426223L;

    private final CheckStatusErrorType type;
    
    public CheckStatusWrongArgumentsException() {
        super();
        this.type = CheckStatusErrorType.MISSING_ARGUMENTS;
    }
    
    public CheckStatusErrorType getErrorType() {
        return this.type;
     }

   

}
