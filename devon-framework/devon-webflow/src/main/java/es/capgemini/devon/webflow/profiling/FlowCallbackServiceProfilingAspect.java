package es.capgemini.devon.webflow.profiling;

import java.util.Iterator;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.webflow.mvc.servlet.FlowController;

import es.capgemini.devon.profiling.AbstractJamonProfilerAspect;

/**
 * Profiler de los DAOs
 * 
 * @author Nicolás Cornaglia
 */
@Component
@Aspect
public class FlowCallbackServiceProfilingAspect extends AbstractJamonProfilerAspect {

    @Override
    @Pointcut("bean(flowController)")
    public void profiledOperations() {
    }

    /**
     * @see es.capgemini.devon.profiling.AbstractJamonProfilerAspect#getKey(org.aspectj.lang.ProceedingJoinPoint)
     */
    @Override
    protected String getKey(ProceedingJoinPoint joinPoint) {
        String flowId = ((FlowController) joinPoint.getTarget()).getFlowUrlHandler().getFlowId((HttpServletRequest) joinPoint.getArgs()[0]);
        return "FE:" + flowId;
    }

    /**
     * @see es.capgemini.devon.profiling.AbstractJamonProfilerAspect#getArgsAsString()
     */
    @Override
    public String getArgsAsString(ProceedingJoinPoint joinPoint) {
        // FIXME: Obtener los parámetros de la request ( (HttpServletRequest) joinPoint.getArgs()[0] )
        String result = "";
        HttpServletRequest request = (HttpServletRequest) joinPoint.getArgs()[0];
        Iterator iter = request.getParameterMap().entrySet().iterator();
        while (iter.hasNext()) {
            Entry n = (Entry) iter.next();
            String key = n.getKey().toString();
            String values[] = (String[]) n.getValue();
            result += ("[" + key + "=" + values[0] + "]");
        }
        return result;
    }
}
