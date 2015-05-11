package es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions;

import java.sql.SQLException;

/**
 * La fachada no ha podido abrir una conexión.
 * @author bruno
 *
 */
public class CannotOpenConnectionException extends Exception {

	private static final long serialVersionUID = -8672509903765927599L;

	public CannotOpenConnectionException(SQLException e) {
		super(e);
	}

}
