package es.pfsgroup.commons.utils.web.dto.metadata;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface FormOptions {
	public static final String FORM_OPTION_COLUMNS = "columnCount";
	public static final String FORM_OPTION_WIDTH = "width";
	public static final String FORM_OPTION_HEIGHT = "height";
	public static final String FORM_OPTION_TITLE = "title";
	public static final String FORM_OPTION_READONLY = "readOnly";
	
	Option[] options();
}
