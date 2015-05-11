package es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions;

import java.sql.SQLException;

/**
 * La fachada no ha podido realizar el commit o cerrar la conexión.
 * @author bruno
 *
 */
public class CannotCommitOrCloseConnectionException extends Exception {


	private static final long serialVersionUID = -4880791796686055863L;

	public CannotCommitOrCloseConnectionException(SQLException e) {
		super(e);
	}

}
