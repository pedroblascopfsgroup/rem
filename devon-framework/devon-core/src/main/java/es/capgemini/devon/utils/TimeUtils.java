package es.capgemini.devon.utils;

import java.text.ParseException;
import java.util.Date;

import org.springframework.scheduling.quartz.CronTriggerBean;

/**
 * @author Nicolás Cornaglia
 */
public class TimeUtils {

    public static Date shouldProcessOn(Date date, long windowInMinutes, String cronExpression) {
        long window = windowInMinutes * 1000 * 60;
        boolean shouldProcessNow = true;
        Date check = new Date(date.getTime() - window);
        Date next = null;
        if (cronExpression != null) {
            CronTriggerBean cron = null;
            try {
                cron = new CronTriggerBean();
                cron.setCronExpression(cronExpression);
                cron.setStartTime(new Date(check.getTime() - window - 1000));
                next = cron.getFireTimeAfter(check);
            } catch (ParseException e) {
                System.out.println("error:" + e);
            }
        }
        if (next != null) {
            shouldProcessNow = ((next.getTime() - date.getTime()) < window) && ((next.getTime() - date.getTime()) > -window);
        }
        return shouldProcessNow ? null : next;
    }

}
