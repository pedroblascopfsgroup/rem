package es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions;

import java.sql.SQLException;

/**
 * La fachada no ha podido realizar el insert.
 * 
 * @author bruno
 * 
 */
public class CannotExecuteInsertException extends Exception {

	private static final long serialVersionUID = -3989549431707901622L;

	public CannotExecuteInsertException(final SQLException e, final String sql) {
		super(new StringBuilder("Error al ejecutar la siguiente sentencia: <SQL-START>").append(sql).append("<SQL-END>").toString(), e);
	}

	public CannotExecuteInsertException(SQLException e) {
		super(e);
	}

}
