package es.capgemini.pfs.batch.analisisexterna;

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

/** Genera los jobs para el el proceso de prepoliticas.
 * @author lgiavedo
 *
 */
@Component
public class ProcesarAnalisisExternaScheduler implements ApplicationContextAware, Initializable {


    /**
     * Punto de entrada.
     */
    @Override
    public void initialize() {
    }

    /**
     * Setea el applicationContext.
     * @param applicationContext el contexto.
     */
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {

    }

    /**
     * devuelve el orden.
     * @return el orden.
     */
    @Override
    public int getOrder() {
        return 1001;
    }
}
