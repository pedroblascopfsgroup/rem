package es.capgemini.devon.webflow.view;

import java.util.Map;

import org.springframework.webflow.engine.RequestControlContext;

import es.capgemini.devon.view.JSPView;

/**
 * @author Nicolás Cornaglia
 */
@SuppressWarnings("unchecked")
public class WebflowJSPView extends JSPView {

    public static final String FLOW_EXECUTION_KEY = "flowExecutionKey";

    /**
     * @return
     */
    @Override
    protected Throwable getException(Map model, Map<String, Object> params) {
        //las excepciones pueden venir del SWFExceptionHandler
        Throwable ex = null;
        RequestControlContext rcc = getRequestControlContext(model);
        if (rcc != null) {
            ex = (Throwable) rcc.getAttributes().get(SWFExceptionHandler.SWF_EXCEPTION_KEY);
        }
        return ex;
    }

    private RequestControlContext getRequestControlContext(Map model) {
        return (RequestControlContext) model.get("flowRequestContext");
    }

    /**
     * @param model
     * @param params
     */
    @Override
    protected void introduceToken(Map model, Map<String, Object> params) {
        params.put(FLOW_EXECUTION_KEY, model.get(FLOW_EXECUTION_KEY));
    }

}
