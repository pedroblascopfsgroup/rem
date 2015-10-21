package es.pfgroup.monioring.bach.load.exceptions;

public class CheckStatusMalfunctionError extends RuntimeException {

    private static final long serialVersionUID = -955781104130530230L;

    public CheckStatusMalfunctionError(final Throwable e) {
        super(e);
    }

}
