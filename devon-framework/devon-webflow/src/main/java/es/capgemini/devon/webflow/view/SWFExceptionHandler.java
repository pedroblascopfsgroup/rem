package es.capgemini.devon.webflow.view;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.webflow.engine.RequestControlContext;
import org.springframework.webflow.engine.ViewState;
import org.springframework.webflow.engine.support.TransitionExecutingFlowExecutionExceptionHandler;
import org.springframework.webflow.execution.FlowExecutionException;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.exception.FrameworkException;

@Service("swfExceptionHandler")
public class SWFExceptionHandler extends TransitionExecutingFlowExecutionExceptionHandler {

    public static final String SWF_EXCEPTION_KEY = "swfException";

    @Autowired
    private EventManager eventManager;

    @Override
    public void handle(FlowExecutionException ex, RequestControlContext context) {

        FrameworkException exception = new FrameworkException(ex);

        context.getAttributes().put(SWF_EXCEPTION_KEY, ex);
        eventManager.fireEvent(EventManager.ERROR_CHANNEL, exception);

        Object testState = context.getCurrentState();

        if (testState instanceof ViewState) {
            ViewState viewState = (ViewState) testState;
            try {
                viewState.getViewFactory().getView(context).render();
                return;
            } catch (IOException e) {
                //Properly handle rendering errors here
            }
        }
        super.handle(ex, context);
    }

    @Override
    public boolean canHandle(FlowExecutionException e) {
        return true;
    }

    public EventManager getEventManager() {
        return eventManager;
    }

    public void setEventManager(EventManager eventManager) {
        this.eventManager = eventManager;
    }

}
