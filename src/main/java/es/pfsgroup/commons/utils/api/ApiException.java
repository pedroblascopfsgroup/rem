package es.pfsgroup.commons.utils.api;

import es.capgemini.devon.bo.BusinessOperationException;

public class ApiException  extends BusinessOperationException{

	public ApiException(String messageKey, Object... messageArgs) {
		super(messageKey, messageArgs);
	}

}
