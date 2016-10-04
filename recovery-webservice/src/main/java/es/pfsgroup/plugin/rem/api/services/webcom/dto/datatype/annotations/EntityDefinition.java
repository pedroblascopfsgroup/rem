package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import es.pfsgroup.plugin.rem.rest.api.RestApi.TRANSFORM_TYPE;



@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface EntityDefinition {
	String propertyName() default "";
	@SuppressWarnings("rawtypes")
	Class classObj() default Object.class;
	String foreingField() default "codigo";
	boolean procesar() default true;
	String motivo() default "";
	boolean unique() default false;
	TRANSFORM_TYPE transform() default TRANSFORM_TYPE.NONE;

}
