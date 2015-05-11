package es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions;

import java.sql.SQLException;

/**
 * La fachada no ha podido realizar el insert.
 * @author bruno
 *
 */
public class CannotExecuteDDLException extends Exception {

	private static final long serialVersionUID = -3989549431707901622L;
	
	public CannotExecuteDDLException(final SQLException e, final String sql) {
		super(new StringBuilder("Error al ejecutar la siguiente sentencia: <DDL-START>").append(sql).append("<DDL-END>").toString(), e);
	}

	public CannotExecuteDDLException(final SQLException e) {
		super(e);
	}

}
