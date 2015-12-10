package es.capgemini.devon.validation;

import java.util.Map;
import java.util.Set;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.validation.Configuration;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorFactory;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.ValidatorFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

/**
 * Servicio de validación del framework
 * 
 * @author amarinso
 * @author Nicolás Cornaglia
 * 
 */
@Service("validator")
public class BeanValidator implements Validator, ConstraintValidatorFactory {

    @Autowired
    private ApplicationContext applicationContext;

    @Resource(name = "messageSource")
    private AbstractMessageSource messageSource;

    private static javax.validation.Validator validator;
    private static org.springframework.validation.Validator instance;

    @PostConstruct
    public void init() throws Exception {
        Configuration<?> configuration = Validation.byDefaultProvider().configure();

        ValidatorFactory validatorFactory = configuration //--
                .messageInterpolator(new DefaultMessageInterpolator(configuration.getDefaultMessageInterpolator(), messageSource)) //--
                .constraintValidatorFactory(this) //--
                .buildValidatorFactory();

        validator = validatorFactory.usingContext().getValidator();
        instance = this;
    }

    public static Validator getDefaultInstance() {
        return instance;
    }

    @SuppressWarnings("unchecked")
    public <T extends ConstraintValidator<?, ?>> T getInstance(Class<T> key) {
        Map beansByNames = applicationContext.getBeansOfType(key);
        if (beansByNames.isEmpty()) {
            try {
                return key.newInstance();
            } catch (InstantiationException e) {
                throw new RuntimeException("Could not instantiate constraint validator class '" + key.getName() + "'", e);
            } catch (IllegalAccessException e) {
                throw new RuntimeException("Could not instantiate constraint validator class '" + key.getName() + "'", e);
            }
        }
        if (beansByNames.size() > 1) {
            throw new RuntimeException("Only one bean of type '" + key.getName() + "' is allowed in the application context");
        }
        return (T) beansByNames.values().iterator().next();
    }

    @SuppressWarnings("unchecked")
    public boolean supports(Class clazz) {
        return true;
    }

    public void validate(Object target, Errors errors) {
        Set<ConstraintViolation<Object>> constraintViolations = validator.validate(target);
        for (ConstraintViolation<Object> constraintViolation : constraintViolations) {
            String propertyPath = constraintViolation.getPropertyPath().toString();
            String message = constraintViolation.getMessage();
            errors.rejectValue(propertyPath, "", message);
        }
    }

}
