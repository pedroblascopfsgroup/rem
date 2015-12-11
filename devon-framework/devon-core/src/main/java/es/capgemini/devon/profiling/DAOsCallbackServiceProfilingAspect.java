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
public class DAOsCallbackServiceProfilingAspect extends AbstractJamonProfilerAspect {

    @Override
    @Pointcut("bean(*Dao)")
    public void profiledOperations() {
    }

    /**
     * @see es.capgemini.devon.profiling.AbstractJamonProfilerAspect#getKey(org.aspectj.lang.ProceedingJoinPoint)
     */
    @Override
    protected String getKey(ProceedingJoinPoint joinPoint) {
        String className = joinPoint.getTarget().getClass().getName();
        return "DAO:" + className.substring(className.lastIndexOf(".") + 1) + "." + joinPoint.getSignature().getName();
    }

    /**
     * @see es.capgemini.devon.profiling.AbstractJamonProfilerAspect#getArgsAsString()
     */
    @Override
    public String getArgsAsString(ProceedingJoinPoint joinPoint) {
        return toString(joinPoint.getArgs());
    }

}
