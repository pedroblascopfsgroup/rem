package es.capgemini.devon.webflow;

import java.lang.reflect.Method;
import java.util.Arrays;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyEditorRegistrar;
import org.springframework.beans.PropertyEditorRegistry;
import org.springframework.binding.message.MessageContext;
import org.springframework.binding.message.MessageContextErrors;
import org.springframework.core.style.StylerUtils;
import org.springframework.stereotype.Service;
import org.springframework.validation.DataBinder;
import org.springframework.validation.MessageCodesResolver;
import org.springframework.validation.Validator;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.webflow.execution.RequestContext;

import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;

/**
 * @author amarinso
 * 
 */
@Service("binder")
public class RequestBinder {

    private static final Log logger = LogFactory.getLog(RequestBinder.class);
    private MessageCodesResolver messageCodesResolver;
    private PropertyEditorRegistrar propertyEditorRegistrar;

    @Resource(name = "validator")
    private Validator validator;

    /**
     * Hace el bind de los parámetros de la request al objeto del binder
     * 
     * copiado de FormAction de webflow
     * 
     * @param context
     * @param binder
     */
    protected void doBind(RequestContext context, DataBinder binder) {
        if (logger.isDebugEnabled()) {
            logger.debug("Binding allowed request parameters in " + StylerUtils.style(context.getExternalContext().getRequestParameterMap())
                    + " to form object with name '" + binder.getObjectName() + "', pre-bind formObject toString = " + binder.getTarget());
            if (binder.getAllowedFields() != null && binder.getAllowedFields().length > 0) {
                logger.debug("(Allowed fields are " + StylerUtils.style(binder.getAllowedFields()) + ")");
            } else {
                logger.debug("(Any field is allowed)");
            }
        }
        binder.bind(new MutablePropertyValues(context.getRequestParameters().asMap()));
        if (logger.isDebugEnabled()) {
            logger.debug("Binding completed for form object with name '" + binder.getObjectName() + "', post-bind formObject toString = "
                    + binder.getTarget());
            logger
                    .debug("There are [" + binder.getBindingResult().getErrorCount() + "] errors, details: "
                            + binder.getBindingResult().getAllErrors());
        }
    }

    /**
     * @param context
     * @param bean
     * @return
     * @throws Throwable
     */
    public void bindAndValidate(RequestContext context, Object bean) throws Throwable {
        if (logger.isDebugEnabled()) {
            logger.debug("Executing bind");
        }
        Object formObject = bean;
        DataBinder binder = createBinder(context, formObject);
        doBind(context, binder);

        if (logger.isDebugEnabled()) {
            logger.debug("bind done");
        }

        // vamos a validar con un método que se llame validateSTATE con
        // STATE==nombre del currentState.
        // podemos realizar la validación automática tras la personalizada si
        // devolvemos Boolean.TRUE
        String methodName = "validate" + StringUtils.capitalize(context.getCurrentState().getId());

        Method method = null;
        boolean cont = true;
        try {
            method = formObject.getClass().getMethod(methodName, new Class[] { MessageContext.class });
        } catch (NoSuchMethodException e) {
            // pues vale, no hay método
        }

        if (method != null) {
            Object result = method.invoke(formObject, new Object[] { context.getMessageContext() });
            cont = !Boolean.FALSE.equals(result);
        }

        // vamos a llamar al sistema de validación por defecto del framework
        if (method == null || cont) {
            MessageContextErrors errors = new MessageContextErrors(context.getMessageContext());
            validator.validate(formObject, errors);

            //si hay errores, lanzamos una excepción
            org.springframework.binding.message.Message[] messages = context.getMessageContext().getAllMessages();
            if (messages != null && messages.length > 0) {
                throw new ValidationException(ErrorMessageUtils.convertMessages(Arrays.asList(messages)));
            }
        }
    }

    protected DataBinder createBinder(RequestContext context, Object formObject) throws Exception {
        DataBinder binder = new WebDataBinder(formObject, formObject.getClass().toString());
        if (getMessageCodesResolver() != null) {
            binder.setMessageCodesResolver(getMessageCodesResolver());
        }
        initBinder(context, binder);
        registerPropertyEditors(context, binder);
        return binder;
    }

    protected void initBinder(RequestContext context, DataBinder binder) {
    }

    /**
     * Return the strategy to use for resolving errors into message codes.
     */
    public MessageCodesResolver getMessageCodesResolver() {
        return messageCodesResolver;
    }

    /**
     * Set the strategy to use for resolving errors into message codes. Applies
     * the given strategy to all data binders used by this action.
     * <p>
     * Default is null, i.e. using the default strategy of the data binder.
     * 
     * @see #createBinder(RequestContext, Object)
     * @see org.springframework.validation.DataBinder#setMessageCodesResolver(org.springframework.validation.MessageCodesResolver)
     */
    public void setMessageCodesResolver(MessageCodesResolver messageCodesResolver) {
        this.messageCodesResolver = messageCodesResolver;
    }

    protected void registerPropertyEditors(RequestContext context, PropertyEditorRegistry registry) {
        registerPropertyEditors(registry);
    }

    /**
     * Register custom editors to perform type conversion on fields of your form
     * object during data binding and form display. This method is called on
     * form errors initialization and
     * {@link #initBinder(RequestContext, DataBinder) data binder}
     * initialization.
     * <p>
     * Property editors give you full control over how objects are transformed
     * to and from a formatted String form for display on a user interface such
     * as a HTML page.
     * <p>
     * This default implementation will simply call
     * <tt>registerCustomEditors</tt> on the
     * {@link #getPropertyEditorRegistrar() propertyEditorRegistrar} object that
     * has been set for the action, if any.
     * 
     * @param registry
     *            the property editor registry to register editors in
     */
    protected void registerPropertyEditors(PropertyEditorRegistry registry) {
        if (getPropertyEditorRegistrar() != null) {
            if (logger.isDebugEnabled()) {
                logger.debug("Registering custom property editors using configured registrar");
            }
            getPropertyEditorRegistrar().registerCustomEditors(registry);
        } else {
            if (logger.isDebugEnabled()) {
                logger.debug("No property editor registrar set, no custom editors to register");
            }
        }
    }

    public PropertyEditorRegistrar getPropertyEditorRegistrar() {
        return propertyEditorRegistrar;
    }

    /**
     * Set a property editor registration strategy for this action's data
     * binders. This is an alternative to overriding the
     * {@link #registerPropertyEditors(PropertyEditorRegistry)} method.
     */
    public void setPropertyEditorRegistrar(PropertyEditorRegistrar propertyEditorRegistrar) {
        this.propertyEditorRegistrar = propertyEditorRegistrar;
    }

    public void setValidator(Validator validator) {
        this.validator = validator;
    }

    public Validator getValidator() {
        return validator;
    }

}
