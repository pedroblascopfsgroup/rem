package es.capgemini.pfs.batch.mail;

import java.text.ParseException;
import java.util.Date;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.startup.Initializable;
import es.capgemini.pfs.dsm.model.Entidad;

/**
 * Genera los jobs para el envío de correos a cada una de las entidades.
 * @author amarinso
 *
 */
@Component
public class TareasPendientesMailScheduler implements ApplicationContextAware, Initializable {


    /**
     * Start scheduler.
     */
    @Override
    public void initialize() {
    }

    /**
     * set applicationContext.
     * @param applicationContext applicationContext
     */
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {

    }

    /**
     * @return 1001
     */
    @Override
    public int getOrder() {
        return 1001;
    }
}
