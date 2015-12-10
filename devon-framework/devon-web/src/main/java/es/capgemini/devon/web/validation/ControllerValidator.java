package es.capgemini.devon.web.validation;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;

/**
 * Aspect to validate a {@link Controller} parameter annotated with {@link Validatable}. <br/>
 * The Controller must conform the following: <br/>
 * <pre>
 *   methodName(@Validatable DtoClassName dto, ...) {...}
 * </pre>
 * 
 * @author Nicolás Cornaglia
 */
@Aspect
@Component("controllerValidator")
public class ControllerValidator {

    @Autowired
    Validator validator;

    @SuppressWarnings("unchecked")
    @Before("execution(* (@org.springframework.stereotype.Controller *).*(@es.capgemini.devon.web.validation.Validatable (*),..)) && args(dto,..)")
    public void validate(JoinPoint joinPoint, Object dto) throws Throwable {

        // Get @Validatable annotation to obtain a "profile" for validators:  @Validatable("profileName"). 
        // In future versions (AspectJ 1.6+) we will do it by binding, like the dto & bindingResult.
        // Already checked by the pointcut, the @Validatable parameter is the first.
        // Not used until Spring Validator supports it. (JSR 303?)
        //
        //        Annotation[] annotations = (((MethodSignature) joinPoint.getSignature()).getMethod().getParameterAnnotations())[0];
        //        Validatable validatable = null;
        //        for (Annotation annotation : annotations) {
        //            if (annotation.annotationType().isAssignableFrom(Validatable.class)) {
        //                validatable = (Validatable) annotation;
        //                break;
        //            }
        //        }
        //        String profile = validatable.value();

        Errors errors = new BeanPropertyBindingResult(dto, "dto");
        validator.validate(dto, errors);

        if (errors.hasErrors()) {
            throw new ValidationException(ErrorMessageUtils.convertFieldErrors(errors.getFieldErrors(), errors.getGlobalErrors()));
        }

    }
}
