package es.pfsgroup.commons.utils.web.controller.metaform;

import es.capgemini.devon.bo.BusinessOperationException;

public class MetaformControllerException extends BusinessOperationException {

	public static enum Type {
		UNKNOWN, CREATE_BO_REQUIRED, ID_FIELD_REQUIRED, ID_TYPE_MSMACTH, PARAMETER_NOT_FOUND
	}

	private Class<?> clazz;

	private Throwable cause;

	private Type type = Type.UNKNOWN;

	private Object[] objects;

	public MetaformControllerException(Class<?> clazz, Throwable e) {
		super(e);
		this.clazz = clazz;
		this.cause = e;
	}

	public MetaformControllerException(Class<?> clazz, Type t,
			Object... objects) {
		this.clazz = clazz;
		this.type = t;
		this.objects = objects;
	}

	private static final long serialVersionUID = 8989984151707563351L;

	@Override
	public String getMessage() {
		if (clazz == null) {
			return "Unknown Meta Data DTO Type";
		}

		return "Error on " + this.clazz.getName() + ". " + causeMsg();
	}

	private String causeMsg() {
		if (cause != null) {
			return cause.getMessage();
		}
		switch (type) {

		case CREATE_BO_REQUIRED:
			return ". Business Operation to CREATE required";

		case ID_FIELD_REQUIRED:
			return ". Missing @Id field. Identifier required";

		case ID_TYPE_MSMACTH:
			if (objects != null) {
				return ". Type of @Id not supported for object "
						+ objects[0].getClass().getName() + "[" + objects[0]
						+ "]";
			} else {
				return ". Type of @Id not supported";
			}

		case PARAMETER_NOT_FOUND:
			if (objects != null) {
				String parameters = "";
				for (Object o : objects) {
					parameters += "[" + o.toString() + "] ";
				}
				return ". Required parameter not found on request "
						+ parameters;
			} else {
				return ". Required parameter not found on request";
			}

		default:
			return ". Unknown cause";
		}
	}
}
