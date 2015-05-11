package es.capgemini.pfs.batch.mail;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.springframework.context.ApplicationContext;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.mail.MailManager;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * TODO FO.
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = false)
public class TareasPendientesMail implements Job {

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Ejecuta el job.
     * @param context JobExecutionContext
     */
    @Override
    public void execute(JobExecutionContext context) {


    }


    /**
     * @param context JobExecutionContext
     * @return MailManager
     */
    public MailManager getMailManager(JobExecutionContext context) {
    	return null;
    }

}
