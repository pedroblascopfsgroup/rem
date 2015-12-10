package es.capgemini.devon.scheduling;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.quartz.JobDetailBean;
import org.springframework.stereotype.Component;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.startup.Initializable;

/**
 * Gestiona la agenda de tareas
 * 
 * @author Nicolás Cornaglia
 */
@Component
public class SchedulerManager implements Initializable {

    private static String DEFAULT_GROUP = "schedulerManager";

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    @Qualifier("quartzSchedulerManager")
    Scheduler scheduler;

    @Autowired
    EventManager eventManager;

    @Autowired(required = false)
    Schedulable[] triggers;

    /**
     * @see es.capgemini.devon.startup.Initializable#initialize()
     */
    @Override
    public void initialize() {

        // Delete all current jobs in group
        try {
            String[] names = scheduler.getJobNames(DEFAULT_GROUP);
            for (String name : names) {
                scheduler.deleteJob(name, DEFAULT_GROUP);
            }
        } catch (SchedulerException e) {
            throw new FrameworkException(e);
        }

        // Add jobs
        if (triggers != null) {
            Date now = new Date();
            for (Schedulable schedulable : triggers) {
                SchedulableTriggerBean trigger = (SchedulableTriggerBean) schedulable;
                JobDetail jobDetail = (JobDetail) trigger.getJobDetail();
                if (jobDetail instanceof JobDetailBean) {
                    ((JobDetailBean) jobDetail).setApplicationContext(null);
                }
                jobDetail.setGroup(DEFAULT_GROUP);
                jobDetail.setName(trigger.getName());
                trigger.setJobName(jobDetail.getName());
                trigger.setJobGroup(jobDetail.getGroup());
                try {
                    scheduler.scheduleJob(trigger.getJobDetail(), trigger);
                    Date next = trigger.getFireTimeAfter(now);
                    logger.info("Scheduling job [" + jobDetail.getName() + ":" + trigger.getCronExpression() + "] Next fire [" + next + "]");
                } catch (SchedulerException e) {
                    throw new FrameworkException(e);
                }
            }

        }

    }

    public void setScheduler(Scheduler scheduler) {
        this.scheduler = scheduler;
    }

    public void setTriggers(Schedulable[] triggers) {
        this.triggers = triggers;
    }

    /**
     * @see es.capgemini.devon.startup.Initializable#getOrder()
     */
    @Override
    public int getOrder() {
        return 1000;
    }

    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "SchedulerManager: [" + "order:" + getOrder() + "]";
    }

}
