package es.capgemini.devon.validation;

import java.util.Locale;

import javax.validation.MessageInterpolator;

import org.apache.commons.lang.StringUtils;
import org.springframework.context.support.AbstractMessageSource;

import es.capgemini.devon.utils.MessageUtils;

/**
 * Custom interpolator with MessageSource 
 */
public class DefaultMessageInterpolator implements MessageInterpolator {

    private AbstractMessageSource messageSource;
    private MessageInterpolator defaultInterpolator;

    /**
     * @param messageSource
     */
    public DefaultMessageInterpolator(MessageInterpolator defaultInterpolator, AbstractMessageSource messageSource) {
        this.defaultInterpolator = defaultInterpolator;
        this.messageSource = messageSource;
    }

    /**
     * @see javax.validation.MessageInterpolator#interpolate(java.lang.String, javax.validation.MessageInterpolator.Context)
     */
    public String interpolate(String message, Context context) {
        return interpolate(message, context, MessageUtils.DEFAULT_LOCALE);
    }

    /**
     * @see javax.validation.MessageInterpolator#interpolate(java.lang.String, javax.validation.MessageInterpolator.Context, java.util.Locale)
     */
    public String interpolate(String message, Context context, Locale locale) {
        String result = null;
        if (message.startsWith("{")) {
            result = messageSource.getMessage(message.substring(1, message.length() - 1), new Object[0], locale);
        } else {
            result = messageSource.getMessage(message, new Object[0], locale);
        }
        if (StringUtils.isEmpty(result)) {
            result = defaultInterpolator.interpolate(message, context, locale);
        } else {
            result = defaultInterpolator.interpolate(result, context, locale);
        }
        return result;
    }
}
