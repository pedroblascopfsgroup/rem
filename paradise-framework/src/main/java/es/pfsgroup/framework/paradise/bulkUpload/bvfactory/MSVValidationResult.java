package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

/**
 * Resultado de una validación de negocio
 * @author bruno
 *
 */
public class MSVValidationResult {
	
	private boolean valid;
	
	private String errorMessage;
	
	public MSVValidationResult(boolean valid, String errorMessage) {
		super();
		this.valid = valid;
		this.errorMessage = errorMessage;
	}

	public boolean isValid() {
		return valid;
	}

	public void setValid(boolean valid) {
		this.valid = valid;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

}
