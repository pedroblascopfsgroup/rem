package es.pfsgroup.plugin.messagebroker.exceptions;

public class InvalidHandler extends RuntimeException {

	private static final long serialVersionUID = -7507775094768479387L;

	
	@SuppressWarnings("rawtypes")
	public InvalidHandler(Class clazz, String errMsg, Throwable e) {
		super(createErrorMessage(clazz, errMsg), e);
	}
	
	@SuppressWarnings("rawtypes")
	public InvalidHandler(Class clazz, String errMsg) {
		super(createErrorMessage(clazz, errMsg));
	}


	@SuppressWarnings("rawtypes")
	private static String createErrorMessage(Class clazz, String errMsg) {
		return "Invalid message handler [" + clazz.getName() + "]. " + errMsg;
	}
}
