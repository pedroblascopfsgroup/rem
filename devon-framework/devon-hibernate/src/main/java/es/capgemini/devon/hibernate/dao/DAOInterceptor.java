package es.capgemini.devon.hibernate.dao;

import org.apache.commons.lang.time.StopWatch;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class DAOInterceptor {

    protected Log log = LogFactory.getLog(DAOInterceptor.class);

    @Around("execution(* es.capgemini.devon.hibernate.dao.HibernateDao.*(..))")
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
