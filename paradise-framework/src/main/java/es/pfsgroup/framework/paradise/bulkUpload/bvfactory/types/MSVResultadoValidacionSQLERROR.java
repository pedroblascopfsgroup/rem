package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types;

/**
 * Resultado de la ejecución de una SQL ERROR
 * @author bruno
 *
 */
public class MSVResultadoValidacionSQLERROR implements MSVResultadoValidacionSQL{

	private String errorMessage;
	
	public MSVResultadoValidacionSQLERROR(String errorMessage) {
		super();
		this.errorMessage = errorMessage;
	}

	public MSVResultadoValidacionSQLERROR() {
		super();
	}
	@Override
	public boolean isError() {
		return true;
	}

	@Override
	public String getErrorMessage() {
		return this.errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	
}
