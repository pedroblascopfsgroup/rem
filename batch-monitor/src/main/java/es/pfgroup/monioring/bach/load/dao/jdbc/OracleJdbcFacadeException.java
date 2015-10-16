package es.pfgroup.monioring.bach.load.dao.jdbc;

public class OracleJdbcFacadeException extends RuntimeException {

	
	public OracleJdbcFacadeException(String string, Exception e) {
		super(string, e);
	}

	private static final long serialVersionUID = -1808914056937757474L;

}
