package es.capgemini.devon.events.defered;

import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.scheduling.quartz.JobDetailBean;

import es.capgemini.devon.scheduling.Schedulable;
import es.capgemini.devon.scheduling.SchedulableTriggerBean;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
public class ReQueueEventCronTriggerBean extends SchedulableTriggerBean implements Schedulable {

    private static final long serialVersionUID = 1L;

    private String channel = "";
    private String beanName;

    /**
     * @see org.springframework.scheduling.quartz.CronTriggerBean#afterPropertiesSet()
     */
    @SuppressWarnings("unchecked")
    @Override
    public void afterPropertiesSet() throws ParseException {
        JobDetailBean job = new JobDetailBean();
        job.setJobClass(ReQueueEvent.class);
        Map jobDataMap = new HashMap();
        jobDataMap.put("channel", channel);
        job.setName(beanName);
        job.setJobDataAsMap(jobDataMap);
        job.afterPropertiesSet();
        this.setJobDetail(job);
        super.afterPropertiesSet();
        ((JobDetailBean) getJobDetail()).setApplicationContext(null);
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    @Override
    public void setBeanName(String beanName) {
        this.beanName = beanName;
        super.setBeanName(beanName);
    }

}
