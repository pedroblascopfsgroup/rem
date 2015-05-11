package es.capgemini.pfs.comite;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comite.dao.AsistenteDao;
import es.capgemini.pfs.comite.dao.ComiteDao;
import es.capgemini.pfs.comite.dao.SesionComiteDao;
import es.capgemini.pfs.comite.dao.TraspasoExpedienteDao;
import es.capgemini.pfs.comite.dto.DtoAsistente;
import es.capgemini.pfs.comite.dto.DtoSesionComite;
import es.capgemini.pfs.comite.model.Asistente;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.comite.model.DtoActa;
import es.capgemini.pfs.comite.model.PuestosComite;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.comite.model.TraspasoExpediente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Servicios de comite.
 * @author Andres Esteban
 *
 */
@Service
public class ComiteManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private Executor executor;

    @Autowired
    private ComiteDao comiteDao;

    @Autowired
    private SesionComiteDao sesionComiteDao;

    @Autowired
    private AsistenteDao asistenteDao;

    @Autowired
    private TraspasoExpedienteDao traspasoExpedienteDao;

    @Resource
    private MessageService messageService;

    /**
     * Recupera un listado de comites.
     * @return Listado de comites
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_GET_COMITES)
    public List<Comite> getComites() {
        return comiteDao.getList();
    }

    /**
     * Retorna el comite que corresponde al id indicado.
     * @param id arquetipo id
     * @return arquetipo
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_GET)
    public Comite get(Long id) {
        return comiteDao.get(id);
    }

    /**
     * Genera el objeto Acta con los datos necesario para generar el pdf.
     * @param sesionId long
     * @return Acta
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_GET_ACTA_PDF)
    public DtoActa getActaPDF(Long sesionId) {
        DtoActa acta = new DtoActa();
        acta.setDtoSesion(getDtoParaSesion(sesionId));
        acta.getDtoSesion().setAsistentes(getAsistentes(acta.getSesion(), acta.getComite(), false));
        List<Asunto> asuntos = sesionComiteDao.buscarAsuntos(sesionId);
        acta.setAsuntos(asuntos);
        acta.setExpedientes(sesionComiteDao.buscarExpedientes(sesionId));
        acta.setMarcadoPoliticas(sesionComiteDao.buscarMarcadosPoliticaExpedientes(sesionId));
        acta.setTipoCierre(messageService.getMessage("cierreComite.manual"));

        // Inicializo objeto a usar en la generacion del pdf
        for (Asunto asu : asuntos) {
            for (Contrato contrato : asu.getContratos()) {
                for (Procedimiento procedimiento : contrato.getProcedimientos()) {
                    Hibernate.initialize(procedimiento.getPersonasAfectadas());
                }
            }
        }
        long numPoliticasGeneradas = 0;
        for (Expediente exp : acta.getExpedientes()) {
            if (exp.getSeguimiento()) {
                numPoliticasGeneradas += (Long) executor.execute(InternaBusinessOperation.BO_POL_MGR_GET_NUM_POLITICAS_GENERADAS, exp.getId());
            }
        }
        acta.setNumPoliticasGeneradas(numPoliticasGeneradas);
        return acta;
    }

    /**
     * Recupera la lista de comites con expedientes para el usuario actual.
     * @return Lista de comites.
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_FIND_COMITES_CURRENT_USER)
    public Set<DtoSesionComite> findComitesCurrentUser() {
        Set<DtoSesionComite> dtoComites = new TreeSet<DtoSesionComite>();

        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<Comite> list = comiteDao.findComitesValidosCurrentUser(usuario);

        for (Comite c : list) {
            DtoSesionComite dto = new DtoSesionComite();
            dto.setComite(c);
            dtoComites.add(dto);
        }

        /*
        for (Comite comite : buscarComitesParaUsuarioActual()) {
            if (!comite.getExpedientes().isEmpty() || !comite.getPreasuntos().isEmpty()
                    || Comite.INICIADO.equals(Comite.calcularEstado(comite.getUltimaSesion()))) {
                DtoSesionComite dto = new DtoSesionComite();
                dto.setComite(comite);
                dtoComites.add(dto);
            }
        }
        */
        return dtoComites;
    }

    /**
     * Recupera la lista de sesiones cerradas para los comites para el usuario actual.
     * @return Lista de comites.
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_FIND_SESIONES_COMITE)
    public Set<DtoSesionComite> findSesionesComiteCerradasCurrentUser() {
        Set<DtoSesionComite> comites = new TreeSet<DtoSesionComite>();
        for (Comite comite : buscarComitesParaUsuarioActual()) {
            for (SesionComite sesion : comite.getSesiones()) {
                if (sesion.getFechaFin() != null) {
                    DtoSesionComite dto = new DtoSesionComite();
                    dto.setComite(comite);
                    dto.setSesion(sesion);
                    comites.add(dto);
                }
            }
        }
        return comites;
    }

    /**
     * Busca los comite que corresponden al perfil y la zona del usuario.
     * @return lista de comites
     */
    private Set<Comite> buscarComitesParaUsuarioActual() {
        Set<Comite> comites = new TreeSet<Comite>();
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        for (Perfil perfil : usuario.getPerfiles()) {
            for (PuestosComite puesto : perfil.getPuestosComites()) {
                if (usuario.getZonas().contains(puesto.getZona())) {
                    comites.add(get(puesto.getComite().getId()));
                }
            }
        }
        return comites;
    }

    /**
     * Inicia la sesion del comite.
     * @param dtoSesionComite dto
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_CREAR_SESION)
    @Transactional(readOnly = false)
    public void crearSesion(DtoSesionComite dtoSesionComite) {
        Comite comite = get(dtoSesionComite.getComite().getId());
        Hibernate.initialize(comite.getSesiones());
        SesionComite sesion = new SesionComite();
        sesion.setFechaInicio(new Date());
        sesion.setComite(comite);
        sesionComiteDao.save(sesion);

        registrarAsistencias(dtoSesionComite, comite, sesion);

        logger.debug("Sesion iniciada el " + sesion.getFechaInicio() + " para el comite " + comite.getNombre());
    }

    @Transactional(readOnly = false)
    private void registrarAsistencias(DtoSesionComite dtoSesionComite, Comite comite, SesionComite sesion) {
        for (DtoAsistente dtoAsistente : dtoSesionComite.getAsistentes()) {
            Asistente asistente = new Asistente();
            asistente.setComite(comite);
            asistente.setSesionComite(sesion);
            asistente.setRestrictivo(dtoAsistente.getEsRestrictivo());
            asistente.setSupervisor(dtoAsistente.getEsSupervisor());
            asistente.setUsuario(dtoAsistente.getUsuario());
            asistente.setAsistio(dtoAsistente.getAsiste());
            asistente.setCargo(calcularCargo(comite, dtoAsistente.getUsuario().getId()));
            asistenteDao.saveAndFlush(asistente);
            logger.debug("Asistencia registrada para " + dtoAsistente.getUsuario().getApellidoNombre());
        }
    }

    /**
     * Calcula el cargo del usuario. Para el mismo concatena la descripcion del perfil con la zona.
     * Deberia haber solo un perfil que coincida con el puesto definido para la zona del comite.
     * @param comiteId comite
     * @param usuarioId long
     * @return string cargo
     */
    private String calcularCargo(Comite comite, Long usuarioId) {
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET, usuarioId);
        List<Perfil> perfilesComite = comite.getPerfiles();
        List<Perfil> perfilesUsuario = usuario.getPerfiles();
        for (Perfil perfil : perfilesComite) {
            if (perfilesUsuario.contains(perfil)) { return perfil.getDescripcion() + " " + comite.getZona().getDescripcion(); }
        }
        return "";
    }

    /**
     * Cierra la sesion del comite, guarda las asistencias y
     * genera las notificaciones para los asuntos.
     * @param idComite long
     * @param ignorarErrores Boolean
     * @return String
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_CERRAR_SESION)
    @Transactional(readOnly = false)
    public String cerrarSesion(Long idComite, boolean ignorarErrores) {
        Comite comite = this.get(idComite);
        AbstractMessageSource ms = MessageUtils.getMessageSource();
        if (comite.getEstado().equals(Comite.CERRADO)) {
            String resolved = ms.getMessage("celebracionComite.error.cerrado", new Object[] { comite.getNombre() }, MessageUtils.DEFAULT_LOCALE);
            throw new BusinessOperationException(resolved);
        }
        if (!ignorarErrores) {
            if (comite.getExpedientesSinDecision().size() > 0) { return ms.getMessage("celebracionComite.error.expedientes", null,
                    MessageUtils.DEFAULT_LOCALE); }
            for (Asunto asunto : comite.getPreasuntos()) {
                if (!asunto.getEstaConfirmado()) { return ms.getMessage("celebracionComite.error.preasuntos", null, MessageUtils.DEFAULT_LOCALE); }
            }
        }

        SesionComite sesion = comite.getUltimaSesion();
        sesion.setFechaFin(new Date());
        sesionComiteDao.saveOrUpdate(sesion);
        comite.addSesion(sesion);
        comiteDao.saveOrUpdate(comite);

        logger.debug("Sesion cerrada el " + sesion.getFechaFin() + " para el comite " + comite.getNombre());

        for (Expediente expediente : sesionComiteDao.buscarExpedientes(sesion.getId())) {
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, expediente.getId(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                    SubtipoTarea.CODIGO_NOTIFICACION_CIERRA_SESION, null);

            break;
        }

        return "Sesion cerrada";
    }

    /**
     * Crea un DtoSesionComite.
     * @param comiteId comite
     * @return DtoSesionComite
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_GET_DTO)
    public DtoSesionComite getDto(Long comiteId) {
        DtoSesionComite dto = new DtoSesionComite();
        Comite comite = comiteDao.get(comiteId);
        dto.setComite(comite);
        dto.setAsistentes(buscarAsistentesParaComite(comite));
        return dto;
    }

    /**
     * Retorna los asistentes que pueden participar en el comité.
     * @param comite
     * @return lista de asistentes
     */
    @SuppressWarnings("unchecked")
    private Set<DtoAsistente> buscarAsistentesParaComite(Comite comite) {
        Map<Long, DtoAsistente> dtoAsistentes = new HashMap<Long, DtoAsistente>();

        for (PuestosComite puesto : comite.getPuestosComites()) {

            DDZona zona = puesto.getZona();
            Perfil perfil = puesto.getPerfil();

            List<Usuario> usuarios = (List<Usuario>) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIOS_ZONA_PERFIL, zona
                    .getId(), perfil.getId());
            for (Usuario usuario : usuarios) {

                DtoAsistente dtoAsistente = dtoAsistentes.get(usuario.getId());

                //Comprobamos si ya estaba insertado en asistentes le revisamos sus restricciones
                if (dtoAsistente != null) {
                    dtoAsistente.setEsSupervisor(dtoAsistente.getEsSupervisor() || puesto.getEsSupervisor());
                    dtoAsistente.setEsRestrictivo(dtoAsistente.getEsRestrictivo() || puesto.getEsRestrictivo());
                } else {
                    //Si no estaba insertado lo insertamos
                    dtoAsistente = new DtoAsistente();
                    dtoAsistente.setUsuario(usuario);
                    dtoAsistente.setEsSupervisor(puesto.getEsSupervisor());
                    dtoAsistente.setEsRestrictivo(puesto.getEsRestrictivo());
                    dtoAsistente.setAsiste(false);
                    dtoAsistente.setComite(comite);

                    dtoAsistentes.put(usuario.getId(), dtoAsistente);
                }
            }
        }

        Set<DtoAsistente> resultado = new TreeSet<DtoAsistente>();

        for (DtoAsistente dto : dtoAsistentes.values()) {
            resultado.add(dto);
        }
        return resultado;
    }

    /**
     * Crea un DtoSesionComite para la sesion indicada.
     * @param sesionId sesionId
     * @return DtoSesionComite
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_GET_DTO_PARA_SESION)
    public DtoSesionComite getDtoParaSesion(Long sesionId) {
        SesionComite sesion = sesionComiteDao.get(sesionId);
        Comite comite = sesion.getComite();
        DtoSesionComite dto = new DtoSesionComite();
        dto.setComite(comite);
        dto.setSesion(sesion);
        dto.setAsistentes(getAsistentes(sesion, comite, true));
        return dto;
    }

    private Set<DtoAsistente> getAsistentes(SesionComite sesion, Comite comite, boolean filtrar) {
        Set<DtoAsistente> dtoAsistentes = new TreeSet<DtoAsistente>();
        for (Asistente asitente : sesion.getAsistentes()) {
            DtoAsistente dtoAsistente = new DtoAsistente();
            dtoAsistente.setAsistente(asitente);
            dtoAsistente.setAsiste(true);
            dtoAsistente.setComite(comite);
            if (!filtrar) {
                dtoAsistentes.add(dtoAsistente);
                continue;
            }
            if (asitente.isAsistio()) {
                dtoAsistentes.add(dtoAsistente);
            }
        }
        return dtoAsistentes;
    }

    /**
     * Retorna el comite que corresponde al id indicado.
     * @param id arquetipo id
     * @return arquetipo
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_GET_WITH_SESSIONS)
    public Comite getWithSessiones(Long id) {
        Comite c = comiteDao.get(id);
        Hibernate.initialize(c.getSesiones());
        return c;
    }

    /**
     * Valida que todos los expedientes tenga una decision.
     * @param comite Comite
     * @param ignorarErrores boolean
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_VALIDATE_CERRAR_SESION)
    public void validateCerrarSesion(Comite comite, boolean ignorarErrores) {
        if (comite.getEstado().equals(Comite.CERRADO)) { throw new BusinessOperationException("celebracionComite.error.cerrado"); }

        if (ignorarErrores) { return; }

        for (Expediente expediente : comite.getExpedientesSinDecision()) {
            if (!expediente.getEstaDecidido()) { throw new BusinessOperationException("cerrarSesionComite.error.expedientes"); }
        }

        for (Asunto asunto : comite.getPreasuntos()) {
            if (!asunto.getEstaConfirmado()) { throw new BusinessOperationException("cerrarSesionComite.error.preasuntos"); }
        }
    }

    /**
     * Busca el comité al que habría que se elevará el expediente en el caso de necesitarlo.
     * @param idExpediente el id del expediente.
     * @return el comité al que se elevará o null si no se puede hacer.
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_BUSCAR_COMITE_PARA_ELEVAR)
    public Comite buscarComiteParaElevar(Long idExpediente) {
        Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);
        //TODO puede ser que no tenga comite???
        Comite com = exp.getComite();
        if (com == null) { return null; }
        return comiteDao.buscarComiteParaElevar(com);
    }

    /**
     * Eleva un expediente a un comité superior.
     * @param idComite id del nuevo comité
     * @param idExpediente id del expediente a elevar
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_ELEVAR_A_COMITE_SUPERIOR)
    @Transactional(readOnly = false)
    public void elevarAComiteSuperior(Long idComite, Long idExpediente) {
        Comite comite = get(idComite);
        Expediente expediente = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);
        Comite comiteAnterior = expediente.getComite();
        for (Asunto asunto : expediente.getAsuntos()) {
            if (asunto.getEstaPropuesto()) {
                asunto.setComite(comite);
                executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, asunto);
            }
        }
        expediente.setComite(comite);
        executor.execute(InternaBusinessOperation.BO_EXP_MGR_SAVE_OR_UPDATE, expediente);
        //Registro el traspaso
        TraspasoExpediente traspaso = new TraspasoExpediente();
        traspaso.setExpediente(expediente);
        traspaso.setComiteDestino(comite);
        traspaso.setComiteOrigen(comiteAnterior);
        traspaso.setFecha(new Date());
        traspasoExpedienteDao.save(traspaso);
    }

    /**
     * Busca los comités a los que se podría delegar un expediente.
     * @param idExpediente el id del Expediente
     * @return devuelve el listado de comités al que puede delegar.
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_BUSCAR_COMITES_DELEGAR)
    public Set<DtoSesionComite> buscarComitesDelegar(Long idExpediente) {
        Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);
        Comite com = exp.getComite();
        if (com == null) { return null; }

        Set<DtoSesionComite> dtoComites = new TreeSet<DtoSesionComite>();
        for (Comite comite : comiteDao.buscarComitesParaDelegar(com)) {
            DtoSesionComite dto = new DtoSesionComite();
            dto.setComite(comite);
            dtoComites.add(dto);
        }
        return dtoComites;
    }

    /**
     * Retorna la SesionComite que corresponde al id indicado.
     * @param id arquetipo id
     * @return arquetipo
     */
    @BusinessOperation(InternaBusinessOperation.BO_COMITE_MGR_GET_SESION_WITH_ASISTENTES)
    public SesionComite getWithAsistentes(Long id) {
        SesionComite s = sesionComiteDao.get(id);
        Hibernate.initialize(s.getAsistentes());
        return s;
    }

}
