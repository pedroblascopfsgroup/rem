package es.pfsgroup.plugin.messagebroker.exceptions;

import java.util.LinkedHashSet;
import java.util.List;

public class DuplicateHandlerException extends RuntimeException {

	private static final long serialVersionUID = 1859206441916551090L;

	public DuplicateHandlerException(List<String> handlers) {
		super((new LinkedHashSet<String>(handlers)).toString());
	}
}
