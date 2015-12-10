package es.capgemini.devon.profiling;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

/**
 * Profiler de los DAOs
 * 
 * @author Nicolás Cornaglia
 */
@Component
@Aspect
public class BusinessOperationCallbackServiceProfilingAspect extends AbstractJamonProfilerAspect {

    @Override
    @Pointcut("execution(* es.capgemini.devon.bo.DefaultExecutor.execute(..))")
    public void profiledOperations() {
    }

    /**
     * @see es.capgemini.devon.profiling.AbstractJamonProfilerAspect#getKey(org.aspectj.lang.ProceedingJoinPoint)
     */
    @Override
    protected String getKey(ProceedingJoinPoint joinPoint) {
        return "BO:" + joinPoint.getArgs()[0];
    }

    /**
     * @see es.capgemini.devon.profiling.AbstractJamonProfilerAspect#getArgsAsString()
     */
    @Override
    public String getArgsAsString(ProceedingJoinPoint joinPoint) {
        return toString(joinPoint.getArgs());
    }

}
