package es.pfsgroup.commons.utils.web.dto.metadata.tmpl;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Textfield {
	
	String labelCode();
	
	String width() default "";
	String height() default "";
	String style() default "";
	String labelStyle() default "";
	boolean readOnly() default false;
}
