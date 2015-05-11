package es.capgemini.pfs.batch.politicas;

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
import es.capgemini.pfs.dsm.EntidadManager;
import es.capgemini.pfs.dsm.model.Entidad;

/** Genera los jobs para el el proceso de alertas.
 * @author Pablo Müller
 *
 */
@Component
public class ProcesarObjetivosScheduler implements ApplicationContextAware, Initializable {

    private static final String DEFAULT_GROUP = "schedulerManager";
    private static final String CRON_EXPRESSION_KEY = "cronExpressionProcObjetivos";

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    @Qualifier("quartzSchedulerManager")
    private Scheduler scheduler;

    @Autowired
    private EntidadManager entidadManager;

    private ApplicationContext applicationContext;

    /**
     * Punto de entrada.
     */
    @Override
    public void initialize() {
        for (Entidad entidad : entidadManager.getListaEntidades()) {
            String cronExpression = entidad.configValue(CRON_EXPRESSION_KEY);
            if (StringUtils.isBlank(cronExpression)) {
                continue;
            }
            JobDetail jobDetail = new JobDetail("procesarObjetivos_entidad" + entidad.getId(), DEFAULT_GROUP, ProcesarObjetivosJob.class);
            jobDetail.getJobDataMap().put("applicationContext", applicationContext);
            jobDetail.getJobDataMap().put("entidad", entidad);
            logger.info("-- CREO EL TIMER DE OBJETIVOS --");
            Trigger trigger;
            try {
                trigger = new CronTrigger("triggerObjetivos_entidad" + entidad.getId(), DEFAULT_GROUP, cronExpression);
                try {
                    scheduler.scheduleJob(jobDetail, trigger);
                    Date now = new Date();
                    Date next = trigger.getFireTimeAfter(now);
                    logger.info("Scheduling job [" + jobDetail.getName() + ":" + cronExpression + "] Next fire [" + next + "]");
                } catch (SchedulerException e) {
                    throw new FrameworkException(e);
                }
            } catch (ParseException e1) {
                logger.error(e1);
            }
        }
    }

    /**
     * Setea el applicationContext.
     * @param applicationContext el contexto.
     */
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;

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
