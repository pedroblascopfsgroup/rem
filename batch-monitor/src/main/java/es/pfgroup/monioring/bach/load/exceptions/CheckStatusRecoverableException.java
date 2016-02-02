package es.pfgroup.monioring.bach.load.exceptions;

import java.sql.SQLRecoverableException;

public class CheckStatusRecoverableException extends Exception{
	
	private static final long serialVersionUID = -3767122868472338283L;

	public CheckStatusRecoverableException(SQLRecoverableException sre) {
	}
	
}
