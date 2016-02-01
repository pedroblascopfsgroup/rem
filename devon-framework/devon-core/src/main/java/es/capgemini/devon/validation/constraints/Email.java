package es.capgemini.devon.validation.constraints;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import javax.validation.Constraint;

import es.capgemini.devon.validation.constraints.impl.EmailValidator;

@Documented
@Constraint(validatedBy = EmailValidator.class)
@Target( { ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface Email {

    public abstract String message() default "{es.capgemini.devon.validation.constraints.Email.message}";

    public abstract Class<?>[] groups() default {};

    public abstract Class<?>[] payload() default {};

}
