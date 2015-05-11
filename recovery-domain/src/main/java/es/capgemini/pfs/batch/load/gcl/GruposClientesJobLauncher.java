package es.capgemini.pfs.batch.load.gcl;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import es.capgemini.devon.batch.BatchExitStatus;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.events.Event;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.events.GenericEvent;
import es.capgemini.devon.events.router.GenericRouter;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchJobLauncher;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;

/**
 * @author pamuller
 */
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class GruposClientesJobLauncher extends BatchJobLauncher implements BatchGruposClientesConstants {


    /**
     * {@inheritDoc}
     */
    @Override
    public void handle(File file) {
    }


    /**
     * {@inheritDoc}
     */
    @Override
    public void run() {

    }

}
