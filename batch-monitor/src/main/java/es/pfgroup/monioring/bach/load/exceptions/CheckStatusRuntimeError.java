package es.pfgroup.monioring.bach.load.exceptions;

import java.sql.SQLException;

public class CheckStatusRuntimeError extends AbstractCheckStatusError {
	
	private static final long serialVersionUID = 3009857690640681517L;

	public CheckStatusRuntimeError(SQLException cause) {
        super(CheckStatusErrorType.DATABASE_ERROR, cause);
    }

}
