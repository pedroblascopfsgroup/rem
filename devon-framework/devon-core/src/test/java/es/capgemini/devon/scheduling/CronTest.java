package es.capgemini.devon.scheduling;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.junit.Test;

import es.capgemini.devon.utils.TimeUtils;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
public class CronTest {

    @Test
    public void testWhen() throws Exception {

        String cronExpression = "0 0/5 * ? * MON-FRI";
        long window = 1;

        System.out.println("cron:" + cronExpression + " window:" + window);

        assertNotNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:43:59"), window, cronExpression));
        assertNotNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:44:00"), window, cronExpression));

        assertNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:44:01"), window, cronExpression));
        assertNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:44:59"), window, cronExpression));
        assertNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:45:00"), window, cronExpression));
        assertNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:45:01"), window, cronExpression));
        assertNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:45:59"), window, cronExpression));

        assertNotNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:46:00"), window, cronExpression));
        assertNotNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:46:01"), window, cronExpression));
        assertNotNull(TimeUtils.shouldProcessOn(getDate("2008-06-16 15:46:59"), window, cronExpression));
    }

    private Date getDate(String data) throws ParseException {
        return ((DateFormat) new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).parse(data);
    }

}
