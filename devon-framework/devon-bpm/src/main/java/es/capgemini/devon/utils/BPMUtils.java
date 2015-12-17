package es.capgemini.devon.utils;

import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.jbpm.JbpmContext;
import org.jbpm.calendar.BusinessCalendar;
import org.jbpm.calendar.Duration;
import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.job.Timer;
import org.jbpm.scheduler.SchedulerService;
import org.jbpm.svc.Services;
import org.jbpm.util.Clock;

import es.capgemini.devon.exception.FrameworkException;

/**
 * Clase de utilidad para los proceso BPM.
 * @author Nicolás Cornaglia
 */
public class BPMUtils {

    private static final String SELECT_TIMER = "select job from org.jbpm.job.Job as job where job.processInstance = :processInstance and name = :name";

    /**
     * Creates a timer with endDate 
     * 
     * @param executionContext
     * @param name
     * @param dueDate
     * @param transitionName
     * @return
     */
    public static Timer createTimer(ExecutionContext executionContext, String name, Date dueDate, String transitionName) {
        Timer timer = new Timer(executionContext.getToken());
        timer.setName(name);
        timer.setTransitionName(transitionName);
        timer.setGraphElement(executionContext.getEventSource());
        timer.setTaskInstance(executionContext.getTaskInstance());
        timer.setProcessInstance(executionContext.getProcessInstance());
        timer.setDueDate(dueDate);
        timer.setLockTime(new Date());
        timer.setExclusive(true);

        SchedulerService schedulerService = (SchedulerService) Services.getCurrentService(Services.SERVICENAME_SCHEDULER);
        schedulerService.createTimer(timer);

        return timer;
    }

    /**
     * Creates a  Timer with duration
     * 
     * @param executionContext contexto
     * @param name nombre del timer
     * @param durationString duracion
     * @param transitionName nombre de la transicion
     * @return
     */
    public static Timer createTimer(ExecutionContext executionContext, String name, String durationString, String transitionName) {
        BusinessCalendar businessCalendar = new BusinessCalendar();
        Duration duration = new Duration(durationString);
        Date dueDate = businessCalendar.add(Clock.getCurrentTime(), duration);

        return createTimer(executionContext, name, dueDate, transitionName);
    }

    /**
     * Delete Timer.
     * @param executionContext contexto
     * @param name nombre del timer
     */
    public static void deleteTimer(ExecutionContext executionContext, String name) {
        SchedulerService schedulerService = (SchedulerService) Services.getCurrentService(Services.SERVICENAME_SCHEDULER);
        schedulerService.deleteTimersByName(name, executionContext.getToken());
    }

    /**
     * Delete Timer.
     * @param executionContext contexto
     * @param name nombre del timer
     */
    public static void deleteTimer(ExecutionContext executionContext) {
        SchedulerService schedulerService = (SchedulerService) Services.getCurrentService(Services.SERVICENAME_SCHEDULER);
        schedulerService.deleteTimersByProcessInstance(executionContext.getProcessInstance());
    }

    /**
     * gets a timer by name
     * 
     * @param context
     * @param processInstance
     * @param name
     * @return
     */
    public static Timer getTimer(JbpmContext context, ProcessInstance processInstance, String name) {
        Session session = context.getSession();
        Query query = session.createQuery(SELECT_TIMER);

        query.setParameter("processInstance", processInstance);
        query.setParameter("name", name);

        List jobs = query.list();
        if (jobs.size() > 1) {
            throw new FrameworkException(new IllegalArgumentException("More than 1 timer named [" + name + "] for process instance ["
                    + processInstance.getId() + "]"));
        } else if (jobs.size() == 0) { return null; }

        return (Timer) jobs.iterator().next();
    }

}
