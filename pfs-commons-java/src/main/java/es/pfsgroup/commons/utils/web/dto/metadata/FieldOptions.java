package es.pfsgroup.commons.utils.web.dto.metadata;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface FieldOptions {
	public static final String FIELD_OPTION_LABEL_CODE = "fieldLabelCode";
	
	Option[] options();
}
