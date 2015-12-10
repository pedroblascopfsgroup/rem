package es.capgemini.devon.view;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.ObjectUtils;
import org.springframework.web.servlet.view.JstlView;

import es.capgemini.devon.events.Event;
import es.capgemini.devon.events.WebEventsSubscriptor;
import es.capgemini.devon.exception.ExceptionUtils;
import es.capgemini.devon.validation.ErrorMessage;
import es.capgemini.devon.validation.Severity;
import es.capgemini.devon.validation.ValidationException;

/**
 * Con esta vista interceptamos la respuesta y añadimos datos al modelo para que
 * se puedan usar en la JSP. 
 */
@SuppressWarnings("unchecked")
public class JSPView extends JstlView {

    public static final String FWK_EXECUTION_EXCEPTION = "fwkExecutionException";
    public static final String WEB_EVENT_SUBSCRIPTOR = "webEventsSubscriptor";

    protected static final String FWK_EXCEPTIONS = "fwkExceptions";
    protected static final String FWK_USER_EXCEPTIONS = "fwkUserExceptions";
    protected static final String __SUCCESS = "__success";
    protected static final String MESSAGES_REGEX = "\\w[^:]*: ";

    private static final String APP_PROPERTIES = "appProperties";

    @Override
    protected void renderMergedOutputModel(Map model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        try {
            introduceVariables(model);

            super.renderMergedOutputModel(model, request, response);
        } catch (Exception e) {
            logger.error(e);
            devolverRespuestaError(response);

        }
    }

    private void devolverRespuestaError(HttpServletResponse response) throws IOException {
        response.reset();
        response.setContentType("application/error");
        response.getOutputStream().println("{success:false}");
        response.flushBuffer();
    }

    /**
     * aquí introducimos todas las variables necesarias en el modelo. Todas irán
     * bajo el nombre "fwk"
     * 
     * @param model
     */
    protected void introduceVariables(Map model) {
        // introducimos el valor de success true/false (necesario para ExtJS)
        model.put(__SUCCESS, Boolean.TRUE);

        Map<String, Object> params = new HashMap<String, Object>();
        model.put("fwk", params);

        introduceToken(model, params);
        introduceUUID(params);
        resuelveExcepciones(model, params);
        introduceProperties(model);
        introduceEventos(model);
        params.put("success", model.get(__SUCCESS));

    }

    /** 
     * El appProperties lo hemos inyectado en la JSPView a través del map de atributos
     * @return
     */
    protected void introduceProperties(Map model) {
        if (getAttribute(APP_PROPERTIES) != null) {
            model.put(APP_PROPERTIES, getAttribute(APP_PROPERTIES));
        }

    }

    /**
     * @param model
     */
    protected void introduceEventos(Map model) {
        List<Event> eventos = getEvents();

        if (eventos.size() > 0) {
            List eventosJSON = new ArrayList();
            for (Event e : eventos) {
                Map ev = new HashMap();
                Map params = new HashMap();
                ev.put("type", getClassName(e));
                if (e.getProperties().keySet().size() > 0) {
                    for (Object o : e.getProperties().keySet()) {
                        params.put(o.toString(), e.getProperty(o.toString()).toString());
                    }
                    ev.put("params", params);
                }
                eventosJSON.add(ev);
            }
            ((Map) model.get("fwk")).put("events", eventosJSON);
        }

    }

    /** 
     * Obtiene el nombre de la clase sin el package
     * 
     * @param e
     * @return
     */
    protected String getClassName(Event e) {
        return org.apache.commons.lang.ClassUtils.getShortClassName(e.getClass());

    }

    /** 
     * El webEventsSubscriptor lo hemos inyectado en la JSPView a través del map de atributos
     * @return
     */
    protected List<Event> getEvents() {
        if (getAttribute(WEB_EVENT_SUBSCRIPTOR) != null) {
            return ((WebEventsSubscriptor) getAttribute(WEB_EVENT_SUBSCRIPTOR)).receive();
        }
        return new ArrayList<Event>();
    }

    /**
     * @param message
     * @return
     */
    protected String limpia(String message) {
        if (message != null) {
            return message.replaceFirst(MESSAGES_REGEX, "");
        }
        return message;
    }

    /**
     * @param model
     * @param params
     */
    protected void introduceToken(Map model, Map<String, Object> params) {
    }

    /**
     * @param model
     * @param params
     */
    protected void resuelveExcepciones(Map model, Map<String, Object> params) {

        Throwable ex = getException(model, params);

        if (ex == null) {
            if (model.containsKey(FWK_EXECUTION_EXCEPTION)) {
                ex = (Throwable) model.get(FWK_EXECUTION_EXCEPTION);
            }
        }

        if (ex == null)
            return;

        logger.debug(ExceptionUtils.getStackTraceAsString(ex));

        String source = null;
        String message = null;
        if (ExceptionUtils.hasUserExceptionCause(ex)) {
            source = FWK_USER_EXCEPTIONS;
            message = limpia(ExceptionUtils.getUserExceptionCause(ex).getMessage());
            logger.info(ex);
        } else if (ExceptionUtils.getCauseOfType(ex, ValidationException.class) != null) {
            //metemos los mensajes de error 
            introduceErrores(model, params, (ValidationException) ExceptionUtils.getCauseOfType(ex, ValidationException.class));

        } else if (ExceptionUtils.hasFwkExceptionCause(ex)) {
            source = FWK_EXCEPTIONS;
            message = limpia(ExceptionUtils.getFwkExceptionCause(ex).getMessage());
            logger.error(ex);
        } else {
            source = FWK_EXCEPTIONS;
            message = ex.getMessage().replaceFirst(MESSAGES_REGEX, "");
            logger.error(ex);
        }
        if (message != null) {
            addFwkError(params, source, message);
        }
        markResponseAsError(model);
    }

    private Object getAttribute(Object key) {
        return getAttributesMap().get(key);
    }

    /**
     * Introduce un UUID para las JSP, por si es necesario.
     * 
     * actualmente ya no es necesario
     * 
     * @param params
     */
    protected void introduceUUID(Map<String, Object> params) {
        params.put("uuid", UUID.randomUUID().toString());
    }

    /**
     * Indica que la respuesta es errónea
     * 
     * @param params
     */
    private void markResponseAsError(Map model) {
        model.put(__SUCCESS, Boolean.FALSE);
    }

    /**
     * Gestiona los errores que se encuentren en el messageContext. En caso de
     * haber errores la respuesta que viaja llevará success:false
     * 
     * @param model
     * @param params
     */
    private void introduceErrores(Map model, Map params, ValidationException ex) {
        for (ErrorMessage message : ex.getMessages()) {
            if (message.getSeverity() == Severity.ERROR) {
                markResponseAsError(model);
                if (isFwkError(message)) {
                    addFwkError(params, message);
                } else {
                    addError(model, message);
                }
            }
        }

    }

    /**
     * @param model
     * @param message
     */
    private void addError(Map model, ErrorMessage message) {
        Map errors = (Map) MapUtils.getObject(model, "errors", new HashMap());
        model.put("errors", errors);
        errors.put(message.getSource().toString(), message.getText());
    }

    /**
     * @param message
     * @return
     */
    private boolean isFwkError(ErrorMessage message) {
        String source = ObjectUtils.toString(message.getSource(), FWK_EXCEPTIONS);
        return FWK_EXCEPTIONS.equals(source) || FWK_USER_EXCEPTIONS.equals(source);
    }

    /**
     * Añade un nuevo mensaje a la lista de errores del framework que viajarán a
     * la papágina usarán la clave FWK_EXCEPTIONS o FWK_USEREXCEPTIONS
     * 
     * @param model
     * @param message
     */
    private void addFwkError(Map model, ErrorMessage message) {
        String source = ObjectUtils.toString(message.getSource(), FWK_EXCEPTIONS);
        addFwkError(model, source, message.getText());
    }

    /**
     * @param model
     * @param source
     * @param text
     */
    private void addFwkError(Map model, String source, String text) {
        List fwk_errores = (List) MapUtils.getObject(model, source, new ArrayList());
        model.put(source, fwk_errores);
        fwk_errores.add(text);
    }

    protected Throwable getException(Map model, Map<String, Object> params) {
        return null;
    }

}
