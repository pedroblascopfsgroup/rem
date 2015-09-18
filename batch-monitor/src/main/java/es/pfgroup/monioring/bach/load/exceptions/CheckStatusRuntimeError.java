package es.pfgroup.monioring.bach.load.exceptions;

import java.sql.SQLException;

public class CheckStatusRuntimeError extends AbstractCheckStatusError {

    public CheckStatusRuntimeError(SQLException cause) {
        super(CheckStatusErrorType.DATABASE_ERROR, cause);
        // TODO Auto-generated constructor stub
    }

}
