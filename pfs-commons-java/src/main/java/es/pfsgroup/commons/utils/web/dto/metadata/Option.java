package es.pfsgroup.commons.utils.web.dto.metadata;

public @interface Option {
	public static final String TRUE = "true";
	public static final String FALSE = "false";
	String key();
	String value();
}
