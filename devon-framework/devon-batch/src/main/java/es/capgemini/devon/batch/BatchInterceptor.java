package es.capgemini.devon.batch;

import org.apache.commons.lang.time.StopWatch;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class BatchInterceptor {

    protected Log log = LogFactory.getLog(BatchInterceptor.class);

    @Around("execution(* org.springframework.batch.core.step.tasklet.Tasklet.*(..))")
    public Object logHibernateQueryTimes(ProceedingJoinPoint pjp) throws Throwable {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();
        Object retVal = pjp.proceed();
        stopWatch.stop();

        String str = pjp.getTarget().toString();
        log.debug(str.substring(str.lastIndexOf(".") + 1, str.lastIndexOf("@")) + " - " + pjp.getSignature().getName() + ": " + stopWatch.getTime()
                + "ms");
        return retVal;
    }

}
