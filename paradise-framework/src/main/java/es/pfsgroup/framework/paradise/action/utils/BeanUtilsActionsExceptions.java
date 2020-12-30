package es.pfsgroup.framework.paradise.action.utils;

public class BeanUtilsActionsExceptions extends Exception{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public BeanUtilsActionsExceptions( String msg ) {
		super(msg);
	}

	public BeanUtilsActionsExceptions ( String msg, Throwable cause) {
		super ( msg, cause);
	}

	/*TEMPLATES*/
	public static String propertyNotExist ( String property, String obj) {
		return String.format("No existe la propiedad %s, en el objeto %s", property, obj);
	}
}
