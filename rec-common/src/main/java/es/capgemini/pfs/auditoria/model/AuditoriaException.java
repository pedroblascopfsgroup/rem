package es.capgemini.pfs.auditoria.model;

import es.capgemini.devon.exception.UserException;

/**
 * TODO Documentar.
 * @author Nicolás Cornaglia
 */
public class AuditoriaException extends UserException {

    private static final long serialVersionUID = 1L;

    /**
     * Constructor.
     */
    public AuditoriaException() {
        super("auditoria.excepcion");
    }

}
