package es.capgemini.pfs.bien;

import java.text.NumberFormat;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.mail.MessagingException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.mail.MailManager;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.bien.dao.BienDao;
import es.capgemini.pfs.bien.dto.DtoBien;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;

/**
 * Manager para el modelo de Bien .
 *
 */
@Service
@Transactional
public class BienManager {

	@Autowired
    private Executor executor;

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private BienDao bienDao;

    @Resource(name = "mailManager")
    private MailManager mailManager;

    @Resource
    private MessageService messageService;

    /**
     * Recupera el Bien indicado.
     * @param id Long
     * @return Bien
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_BIEN_MGR_GET)
    public Bien get(Long id) {
        return bienDao.get(id);
    }

    /**
     * Recupera los Bienes existentes.
     * @return list
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_BIEN_MGR_GET_LIST)
    public List<Bien> getList() {
        return bienDao.getList();
    }

    /**
     * Metodo que lista todos los obj incluidos los eliminados mediante auditoria.
     * @return lista FULL de todos los obj
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_BIEN_MGR_GET_LIST_FULL)
    public List<Bien> getListFull() {
        return bienDao.getListFull();
    }

    /**
     * Save or udate.
     * @param object Bien
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_BIEN_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(Bien object) {
        bienDao.saveOrUpdate(object);
    }

    /**
     * Delete.
     * @param id Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_BIEN_MGR_DELETE)
    @Transactional(readOnly = false)
    public void delete(Long id) {
        bienDao.deleteById(id);
    }

    /**
     * Create or update.
     * @param dtoBien DtoBien
     * @param idPersona Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_BIEN_MGR_CREATE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void createOrUpdate(DtoBien dtoBien, Long idPersona) {
        //obtener el ddtipobien
        Bien bien = dtoBien.getBien();

        //sÃ­lo asocio la persona si estoy creando un bien nuevo
        if (bien.getId() == null) {
            Set<Persona> personas = bien.getPersonas();
            if (personas == null) {
                personas = new HashSet<Persona>();
                bien.setPersonas(personas);
            }
            Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
            personas.add(persona);
            persona.getBienes().add(bien);
        }

        saveOrUpdate(bien);
    }

    /**
     * Manda un mail a la persona indicada en la configuracion del tipo del bien
     * y graba la fecha actual como fecha de verificacion del bien.
     *
     * El mail quedaria asi (a modo de ejemplo):
     *
     * Se solicita la verificación del Bien:
    		Código: 1 Descripción: 12 Ref.Catastral: Finca Rstica

    	Con los siguientes datos catastrales del mismo:
    		Tipo: Finca Rstica
    		Titular: JOSE
    		Participación: 12%
    		Valor Actual: $12,00
    		Cargas: $12,00
    		Ref. Catastral: 12
    		Superificie: 12 m2
    		Población: 12
    		Datos registrales: 12

    	Gracias.
     * @param idBien id del bien a verificar.
     * @throws MessagingException ni idea
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_BIEN_MGR_VERIFICAR_BIEN)
    @Transactional(readOnly = false)
    public void verificarBien(Long idBien) throws MessagingException {
        try {
            Bien bien = get(idBien);

            MimeMessageHelper helper = mailManager.createMimeMessageHelper();
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            helper.setFrom(usuario.getEmail());
            helper.setSubject(crearTituloMail(bien));
            String destinatario = bien.getTipoBien().getConfiguracionMailTipoBien().getDestinatario();
            helper.setTo(destinatario);
            helper.setText(crearCuerpoMail(bien));
            mailManager.send(helper);
        } catch (Exception e) {
            logger.debug(e);
            throw new UserException(messageService.getMessage("bien.verificacion.mail.error", null));
        }
    }

    /**
     * Titulo del mail.
     * código: x Descripción: x Ref.Catastral: x
     * @param bien
     * @return
     */
    private String crearTituloMail(Bien bien) {
        Object[] param = { bien.getId(), bien.getDescripcionBien(), bien.getTipoBien().getDescripcion(), bien.getReferenciaCatastral() };
        return messageService.getMessage("bien.verificacion.mail.cabecera", param);
    }

    private String crearCuerpoMail(Bien bien) {
        String variable1 = "";
        String variable2 = "";
        String variable3 = "";
        String variable4 = "";
        String titular = "";
        if (bien.getReferenciaCatastral() != null) {
            Object[] param = { bien.getReferenciaCatastral() };
            variable1 = messageService.getMessage("bien.verificacion.mail.cuerpoMensaje.variable1", param);
        }
        if (bien.getSuperficie() != null) {
            Object[] param = { bien.getSuperficie() };
            variable2 = messageService.getMessage("bien.verificacion.mail.cuerpoMensaje.variable2", param);
        }
        if (bien.getPoblacion() != null) {
            Object[] param = { bien.getPoblacion() };
            variable3 = messageService.getMessage("bien.verificacion.mail.cuerpoMensaje.variable3", param);
        }
        if (bien.getDatosRegistrales() != null) {
            Object[] param = { bien.getDatosRegistrales() };
            variable4 = messageService.getMessage("bien.verificacion.mail.cuerpoMensaje.variable4", param);
        }
        if (bien.getPersonas() != null) {
            //TODO Cambiar cuando se permitan varias personas por bien
            Persona persona = null;
            for (Persona per : bien.getPersonas()) {
                persona = per;
                break;
            }

            titular = persona.getApellidoNombre();
        }

        NumberFormat nf = NumberFormat.getCurrencyInstance();
        Object[] param = { bien.getId(), bien.getDescripcionBien(), bien.getTipoBien().getDescripcion(), bien.getTipoBien().getDescripcion(),
                bien.getParticipacion(), nf.format(Checks.esNulo(bien.getValorActual()) ? 0 : bien.getValorActual()), nf.format(Checks.esNulo(bien.getImporteCargas()) ? 0 : bien.getImporteCargas()), variable1, variable2, variable3,
                variable4, titular };
        return messageService.getMessage("bien.verificacion.mail.cuerpoMensaje", param);
    }
}
