package es.capgemini.pfs.users;

/**
 * Excepcion cuando no se puede borrar el usuario.
 *
 */
public class UserNotDeleteableException extends es.capgemini.devon.exception.UserException {

    private static final long serialVersionUID = 5410693621584153775L;

    /**
     * Constructor.
     */
    public UserNotDeleteableException() {
        super("El usuario no se puede borrar");
    }

}
