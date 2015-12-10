package es.capgemini.devon.events.defered;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import es.capgemini.devon.events.EventManager;

public class ReQueueEvent extends QuartzJobBean {

    final Log logger = LogFactory.getLog(getClass());

    private ApplicationContext ctx;

    @Override
    protected void executeInternal(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        EventManager eventManager = (EventManager) ctx.getBean("eventManager");
        String channel = (String) jobExecutionContext.getJobDetail().getJobDataMap().get("channel");
        eventManager.reQueueJobs(channel, new Date());
    }

    public void setApplicationContext(ApplicationContext applicationContext) {
        this.ctx = applicationContext;
    }

}