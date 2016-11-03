package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;

import es.pfsgroup.plugin.rem.rest.validator.UniqueKeyValidator;

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueKeyValidator.class)
public @interface UniqueKey {

	@SuppressWarnings("rawtypes")
	Class clase();

	String message();

	Class<?>[] groups() default {};

	Class<? extends Payload>[] payload() default {};
	
	String field();
	

}
