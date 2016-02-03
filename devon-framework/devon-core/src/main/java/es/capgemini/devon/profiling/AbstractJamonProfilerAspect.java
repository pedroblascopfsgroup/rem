package es.capgemini.devon.profiling;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.message.GenericMessage;
import org.springframework.stereotype.Component;

import com.jamonapi.Monitor;
import com.jamonapi.MonitorFactory;

import es.capgemini.devon.events.EventManager;

/**
 * Clase padre para los profilers de JAMon.
 * Se envía un evento asíncrono si está habilitado el log, con los datos del profiler.
 * 
 * @author Nicolás Cornaglia
 */
@Aspect
@Component
public abstract class AbstractJamonProfilerAspect {

    @Autowired
    private ProfilerManager profilerManager;
    @Autowired
    private EventManager eventManager;

    /**
     * Método a ser sobreescrito con el pointcut deseado
     */
    @Pointcut
    public abstract void profiledOperations();

    /**  
     * @return Reptresentación como string de los parámetros, para el logger.
     */
    public abstract String getArgsAsString(ProceedingJoinPoint joinPoint);

    //    @Pointcut("within(com.fdsapi..*) || within(com.jamonapi..*)")
    //    public void withinProfiler() {
    //    }

    @Around("profiledOperations()")
    //"&& !withinProfiler()")
    public Object profile(final ProceedingJoinPoint joinPoint) throws Throwable {
        Object ret;
        String args = "";
        long t1 = 0;
        if (profilerManager.isStatisticsEnabled()) {
            String key = getKey(joinPoint);
            if (profilerManager.isLogEnabled()) {
                args = getArgsAsString(joinPoint);
                t1 = System.currentTimeMillis();
            }

            Monitor monitor = MonitorFactory.start(key);
            ret = joinPoint.proceed();
            monitor.stop();

            if (profilerManager.isLogEnabled()) {
                long t2 = System.currentTimeMillis() - t1;
                ProfileData profileData = new ProfileData(key, args, t2);
                eventManager.fireEvent("profilingChannel", new GenericMessage<ProfileData>(profileData));
            }

        } else {
            ret = joinPoint.proceed();
        }
        return ret;
    }

    /**
     * Obtiene la key donde se guardará la performance
     * 
     * @param joinPoint
     * @return
     */
    protected String getKey(ProceedingJoinPoint joinPoint) {
        return joinPoint.getArgs().toString();
    }

    /**
     * @param args
     * @return
     */
    protected String toString(Object[] args) {
        String result = "";
        if (args != null) {
            for (Object o : args) {
                result += ("[" + (o == null ? "null" : o.toString()) + "]");
            }
        }
        return result;
    }

}
