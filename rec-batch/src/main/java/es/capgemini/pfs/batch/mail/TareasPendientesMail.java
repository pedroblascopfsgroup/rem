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
import es.capgemini.pfs.users.dao.UsuarioDao;
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

        determinarBBDD(context);

        Entidad entidad = (Entidad) context.getMergedJobDataMap().get("entidad");
        UsuarioDao usuarioDao = (UsuarioDao) getAplicationContext(context).getBean("UsuarioDao");
        List<Usuario> vUsuarios = usuarioDao.getUsuariosWithMail(entidad.getId());
        TareaNotificacionDao tareaNotificacionDao = (TareaNotificacionDao) getAplicationContext(context).getBean("TareaNotificacionDao");

        for (Usuario usuario : vUsuarios) {
            String email = usuario.getEmail();
            Long tareaPendientes = recuperaNumeroTareas(usuario, tareaNotificacionDao);

            if (tareaPendientes != null && tareaPendientes.longValue() > 0) {
                enviaCorreo(context, email, tareaPendientes.toString());
            }
        }

    }

    private Long recuperaNumeroTareas(Usuario usuario, TareaNotificacionDao tareaNotificacionDao) {
        DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();

        List<Perfil> perfiles = usuario.getPerfiles();
        List<DDZona> zonas = usuario.getZonas();
        dto.setZonas(zonas);
        dto.setPerfiles(perfiles);
        dto.setUsuarioLogado(usuario);
        dto.setCodigoTipoTarea(TipoTarea.TIPO_TAREA);
        Long result = tareaNotificacionDao.obtenerCantidadDeTareasPendientes(dto);

        return result;

    }

    private void determinarBBDD(JobExecutionContext context) {
        Entidad entidad = (Entidad) context.getMergedJobDataMap().get("entidad");
        DbIdContextHolder.setDbId(entidad.getId());
    }

    private ApplicationContext getAplicationContext(JobExecutionContext context) {
        return (ApplicationContext) context.getMergedJobDataMap().get("applicationContext");
    }

    @SuppressWarnings("unchecked")
    private void enviaCorreo(JobExecutionContext context, String address, String tareasPendientes) {
        MimeMessageHelper helper;
        try {
            MailManager mailManager = getMailManager(context);
            helper = mailManager.createMimeMessageHelper();
            helper.setSubject("PFS REcovery: Tareas pendientes");
            helper.setTo(address);
            Map datos = new HashMap();
            datos.put("tareas", tareasPendientes);
            helper.setText(mailManager.mergeTemplateIntoString("correoTareasPendientes.vm", datos));
            mailManager.send(helper);
        } catch (MessagingException e) {
            logger.error(e);
        }

    }

    /**
     * @param context JobExecutionContext
     * @return MailManager
     */
    public MailManager getMailManager(JobExecutionContext context) {
        return (MailManager) getAplicationContext(context).getBean("mailManager");
    }

}
