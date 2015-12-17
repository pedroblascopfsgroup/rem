package es.capgemini.devon.webflow;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.webflow.core.FlowException;

import es.capgemini.devon.exception.ExceptionUtils;
import es.capgemini.devon.view.JSPView;

public class WebflowMVCExceptionResolver implements HandlerExceptionResolver {
    private static final String ERROR_VIEW = "default";

    private final Log logger = LogFactory.getLog(getClass());

    @Override
    public ModelAndView resolveException(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception e) {
        // return the Error Page view in case of any unhandled exception

        if (e != null) {
            logger.debug(ExceptionUtils.getStackTraceAsString(e));
            if (e instanceof FlowException) {
                if (!ExceptionUtils.hasFwkExceptionCause(e)) {
                    return null;
                }
            }
            Map model = new HashMap();
            model.put(JSPView.FWK_EXECUTION_EXCEPTION, e);
            return new ModelAndView(ERROR_VIEW, model);
        } else {
            return null;
        }

    }

}
