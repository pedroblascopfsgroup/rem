package es.pfsgroup.commons.utils.web.dto.dynamic;

public class DynamicDTOException extends RuntimeException{

	
	private static final long serialVersionUID = -4074760405890399627L;

	public DynamicDTOException(String string, Exception e) {
		super(string,e);
	}

	public DynamicDTOException(String message) {
		super(message);
	}

}
