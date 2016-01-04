package es.capgemini.pfs.users;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.mail.MessagingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.mail.MailManager;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.dsm.EntityDataSource;
import es.capgemini.pfs.dsm.dao.EntidadConfigDao;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.dsm.model.EntidadConfig;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.users.dao.PerfilDao;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.users.dto.DtoBuscarUsuarios;
import es.capgemini.pfs.users.dto.DtoUsuario;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * TODO Documentar.
 *
 * @author Nicolás Cornaglia
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = true)
public class UsuarioManager {
    
    public static final String USER_SESSION_KEY="user_login"; 

    @Autowired
    private UsuarioDao usuarioDao;
    @Autowired
    private PerfilDao perfilDao;
    @Autowired(required = false)
    @Qualifier("securityDefaultUserId")
    private Long defaultUserId;
    @Resource(name = "mailManager")
    private MailManager mailManager;
    @Resource
    private MessageService messageService;
    @Autowired
    private EntidadDao entidadDao;
    @Autowired
    private EntidadConfigDao entidadConfigDao;
	@Autowired
	private EntityDataSource entityDataSource;
    
    

    /**
     * Obtener un listado de usuarios por nombre.
     *
     * @param usernameToFind string
     * @return lista de usuario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_FIND_BY_USERNAME)
    @Transactional
    public List<Usuario> findByUsername(String usernameToFind) {
        //        throw new UserNotDeleteable();
        return usuarioDao.findByUsername(usernameToFind);
    }

    /**
     * Obtener un usuario por nombre.
     *
     * @param usernameToFind String
     * @return Usuario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_BY_USERNAME)
    public Usuario getByUsername(String usernameToFind) {
        return usuarioDao.getByUsername(usernameToFind);
    }

    /**
     * Buscar usuarios por nombre.
     * @param usernameToFind string
     * @return Lista de usuarios
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_FIND_USERNAME_ARRAY)
    @Transactional
    public Usuario[] findByUsernameArray(String usernameToFind) {
        //        throw new UserNotDeleteable();
        List<Usuario> usuarios = usuarioDao.findByUsername(usernameToFind);
        Usuario[] result = new Usuario[usuarios.size()];
        int i = 0;
        for (Usuario usuario : usuarios) {
            result[i++] = usuario;
        }
        return result;
    }

    /**
     * Buscar usuarios por nombre.
     * @param busqueda DtoBuscarUsuarios
     * @return Page
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_FIND_USERS_PAGE)
    @Transactional
    public Page findUsersPage(DtoBuscarUsuarios busqueda) {
        return usuarioDao.findByUsername(busqueda.getCriterio(), busqueda);
    }

    /**
     * @param usuarioDao UsuarioDao
     */
    public void setUsuarioDao(UsuarioDao usuarioDao) {
        this.usuarioDao = usuarioDao;
    }

    /**
     * @return Long
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_DEFAULT_USER_ID)
    public Long getDefaultUserId() {
        return defaultUserId;
    }

    /**
     * @param defaultUserId the defaultUserId to set
     */
    @BusinessOperation(ConfiguracionBusinessOperation.SET_DEFAULT_USER_ID)
    public void setDefaultUserId(Long defaultUserId) {
        this.defaultUserId = defaultUserId;
    }

    /**
     * @param id Long
     * @return Usuario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET)
    public Usuario get(Long id) {
        return usuarioDao.get(id);
    }

    /**
     * Actualiza el usario en la BBDD.
     * @param usuario Usuario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_UPDATE)
    @Transactional
    public void update(Usuario usuario) {
        usuarioDao.update(usuario);
    }

    /**
     * Actualiza los usarios en la BBDD.
     * @param usuarios array
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_UPDATE_ARRAY)
    @Transactional
    public void updateArray(Object[] usuarios) {
        if (usuarios == null) { return; }
        for (int i = 0; i < usuarios.length; i++) {
            Usuario usuario = (Usuario) usuarios[i];
            usuarioDao.update(usuario);
        }
    }

    /**
     * Actualiza los usarios en la BBDD.
     * @param usuarios array
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_UPDATE_ARRAY_USUARIO)
    @Transactional
    public void updateArray(Usuario[] usuarios) {
        if (usuarios == null) { return; }
        for (int i = 0; i < usuarios.length; i++) {
            Usuario usuario = usuarios[i];
            usuarioDao.update(usuario);
        }
    }

    /**
     * Actualiza los usarios en la BBDD.
     * @param usuarios array
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_UPDATE_LIST)
    @Transactional
    public void updateList(List<Usuario> usuarios) {
        for (Usuario usuario : usuarios) {
            usuarioDao.update(usuario);
        }
    }

    /**
     * Guarda el usuario en la BBDD.
     * @param usuario Ususario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_SAVE)
    @Transactional
    public void save(Usuario usuario) {
        usuarioDao.save(usuario);
    }

    /**
     * Actualiza el usuario en la BBDD.
     * @param usuario Ususario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_SAVE_OR_UPDATE)
    @Transactional
    public void saveOrUpdate(Usuario usuario) {
        usuarioDao.saveOrUpdate(usuario);
    }

    /**
     * Borra el usuario en la BBDD.
     * @param id Long
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_DELETE)
    @Transactional
    public void delete(Long id) {
        usuarioDao.deleteById(id);
    }

    /**
     * Borra los usuarios en la BBDD.
     * @param ids List
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_DELETE_LIST)
    @Transactional
    public void delete(List ids) {
        for (Object object : ids) {
            Long id = (Long) object;
            delete(id);
        }
    }

    /**
     * Borra el usuario en la BBDD.
     * @param usuario usuario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_DELETE_USUARIO)
    @Transactional
    public void delete(Usuario usuario) {
        usuarioDao.delete(usuario);
    }

    /**
     * Recupera el usuario logeado. Y si no hay el usuario por defecto.
     * @return usuario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)
    @Transactional
    public Usuario getUsuarioLogado() {
    	EventFactory.onMethodStart(this.getClass());
        Usuario loggedUser = null;
        
        if( RequestContextHolder.getRequestAttributes()!=null && RequestContextHolder.getRequestAttributes().getAttribute(USER_SESSION_KEY,RequestAttributes.SCOPE_SESSION)!=null){
        	return (Usuario)RequestContextHolder.getRequestAttributes().getAttribute(USER_SESSION_KEY,RequestAttributes.SCOPE_SESSION);
        }
        
        if (SecurityUtils.getCurrentUser() == null && defaultUserId != null) {
            loggedUser = get(defaultUserId);
        } else {
            loggedUser = get(((UsuarioSecurity) SecurityUtils.getCurrentUser()).getId());
        }
        
        loggedUser.initialize();
        
        if( RequestContextHolder.getRequestAttributes()!=null)
            RequestContextHolder.getRequestAttributes().setAttribute(USER_SESSION_KEY,loggedUser,RequestAttributes.SCOPE_SESSION);
        EventFactory.onMethodStop(this.getClass());
        return loggedUser;
    }
    
    /**
     * Recupera el usuario logeado. Y si no hay el usuario por defecto.
     * @return usuario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_CAMBIAR_ENTIDAD_USU_LOGADO)
    @Transactional
    public Usuario cambiarEntidadUsuarioLogado(String codEntidadSeleccionada) {
    	EventFactory.onMethodStart(this.getClass());
        Usuario loggedUser = null;
        Entidad enti = entidadDao.findByDescripcion(codEntidadSeleccionada);
        EntidadConfig entidadConfig = entidadConfigDao.findByEntidad(enti.getId());
        
        if( RequestContextHolder.getRequestAttributes()!=null && RequestContextHolder.getRequestAttributes().getAttribute(USER_SESSION_KEY,RequestAttributes.SCOPE_SESSION)!=null){
        	loggedUser = (Usuario)RequestContextHolder.getRequestAttributes().getAttribute(USER_SESSION_KEY,RequestAttributes.SCOPE_SESSION);
            DbIdContextHolder.setDbId(enti.getId());
            loggedUser.setEntidad(enti);
            usuarioDao.update(loggedUser);    
        }
        
        try {
			entityDataSource.getConnectionMultientidad(entidadConfig.getDataValue());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        if (SecurityUtils.getCurrentUser() == null && defaultUserId != null) {
            loggedUser = get(defaultUserId);
        } else {
            loggedUser = get(((UsuarioSecurity) SecurityUtils.getCurrentUser()).getId());
        }
        
        loggedUser.initialize();
        
        if( RequestContextHolder.getRequestAttributes()!=null)
            RequestContextHolder.getRequestAttributes().setAttribute(USER_SESSION_KEY,loggedUser,RequestAttributes.SCOPE_SESSION);
        EventFactory.onMethodStop(this.getClass());
        return loggedUser;
    }

    /**
     * Devuelve los usuarios que estén en esa zona y perfil.
     * @param idZona Zona del usuario
     * @param idPerfil Perfil del usuario
     * @return lista de usuarios
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIOS_ZONA_PERFIL)
    public List<Usuario> getUsuariosZonaPerfil(Long idZona, Long idPerfil) {
    	EventFactory.onMethodStart(this.getClass());
        return usuarioDao.getUsuariosZonaPerfil(idZona, idPerfil);
    }

    /**
     * Obtiene una lista de las funciones a las que el usuario puede acceder
     * basado en los perfiles que tiene asignados.
     *
     * @param usuario Usuario
     * @return Set GrantedAuthority
     */
    public Set<GrantedAuthority> getAuthorities(Usuario usuario) {
        // Deprecated: usuarioDao.getAuthorities(usuario);
        Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();

        for (Perfil perfil : usuario.getPerfiles()) {
            for (Funcion funcion : perfil.getFunciones()) {
                authorities.add(new GrantedAuthorityImpl(funcion.getDescripcion()));
            }
        }

        return authorities;
    }

    /**
     * devuelve las oficinas del usuario.
     * @param usuario usuario
     * @return oficinas
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_OFICINAS)
    public List<Oficina> getOficinas(Usuario usuario) {
        List<Oficina> oficinas = new ArrayList<Oficina>();
        for (DDZona zona : usuario.getZonas()) {
            oficinas.addAll(zona.getOficinas());
        }
        return oficinas;
    }

    /**
     * Retorna las zonas del usuario logueado.
     * @return List
     */
    @BusinessOperation
    public List<DDZona> getZonasUsuarioLogado() {
        return new ArrayList<DDZona>(getUsuarioLogado().getZonas());
    }

    /**
     * Envia un mail al usuario con el password.
     * @param username String
     * @return mensaje de exito o fracaso.
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_RECUPERAR_PASSWORD)
    public String recuperarPassword(String username) {
        Usuario usuario = usuarioDao.getByUsername(username);
        if (usuario == null) { return messageService.getMessage("admin.users.noExiste"); }
        try {
            enviarMail(usuario);
        } catch (MessagingException e) {
            return e.getLocalizedMessage();
        }
        return messageService.getMessage("admin.users.mailEnviado");
    }

    private void enviarMail(Usuario usuario) throws MessagingException {
        try {
            MimeMessageHelper helper = mailManager.createMimeMessageHelper();
            helper.setFrom(usuario.getEmail());
            helper.setSubject(crearTituloMail(usuario));
            String destinatario = usuario.getEmail();
            helper.setTo(destinatario);
            helper.setText(crearCuerpoMail(usuario));
            mailManager.send(helper);
        } catch (Exception e) {
            throw new MessagingException(messageService.getMessage("admin.users.mail.error", null));
        }
    }

    private String crearTituloMail(Usuario usuario) {
        Object[] param = { usuario.getUsername() };
        return messageService.getMessage("admin.users.mail.cabecera", param);
    }

    private String crearCuerpoMail(Usuario usuario) {
        Object[] param = { usuario.getPassword() };
        return messageService.getMessage("admin.users.mail.cuerpoMensaje", param);

    }

    /**
     * Guarda los cambios del usuario logado.
     * @param dto parámetros
     * @return Mensaje de exito o el error que ocurra
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GUARDAR_USUARIO)
    @Transactional(readOnly = false)
    public String guardarUsuario(DtoUsuario dto) {
        try {
            guardarUsuarioInterno(dto);
        } catch (BusinessOperationException e) {
            return e.getLocalizedMessage();
        }
        return "OK";
    }

    /**
     * Guarda los cambios del usuario logado.
     * @param dto parámetros
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GUARDAR_USUARIO_INTERNO)
    @Transactional(readOnly = false)
    public void guardarUsuarioInterno(DtoUsuario dto) {
        Usuario usr = usuarioDao.get(dto.getId());
        
        //Este metodo se llama antes de estar logeado y por lo tanto no se conoce la entidad de BD 
        //En caso de que no este especificada debemos setearla
        if(DbIdContextHolder.getDbId()<=0){
            DbIdContextHolder.setDbId(usr.getEntidad().getId());  
        }
        validarPasswords(usr, dto);

        usr.setUsername(dto.getUsername());
        usr.setNombre(dto.getNombre());
        usr.setApellido1(dto.getApellido1());
        usr.setApellido2(dto.getApellido2());
        usr.setEmail(dto.getEmail());
        usr.setTelefono(dto.getTelefono());
        if (!dto.getPasswordNuevo().trim().isEmpty()) {
            usr.setFechaVigenciaPassword(usr.getNuevaFechaVigenciaPassword());
            usr.setPassword(dto.getPasswordNuevo().trim());
        }

        usuarioDao.update(usr);
    }

    /**
     * Valida que el password ingresado sea el actual, que el nuevo se el mismo que su verficacion, y que el nuevo sea distinto al actual.
     * Caso contrario Excepcion.
     * @param usr Usuario actual
     * @param dto parametros
     */
    private void validarPasswords(Usuario usr, DtoUsuario dto) {
        if (!usr.getPassword().equals(dto.getPassword())) { throw new BusinessOperationException("admin.users.password.invalid"); }
        if (!dto.getPasswordNuevo().trim().isEmpty()) {
            if (!dto.getPasswordNuevo().equals(dto.getPasswordNuevoVerificado())) { throw new BusinessOperationException(
                    "admin.users.password.new.invalid"); }
            if (dto.getPasswordNuevo().equals(usr.getPassword())) { throw new BusinessOperationException("admin.users.password.eqactual"); }
        }

    }

    /**
     * Recupera el perfil correspondiente al codigo indicado.
     * @param codigo String
     * @return Perfil
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_BUSCAR_PERFIL_POR_CODIGO)
    public Perfil buscarPerfilPorCodigo(String codigo) {
        return perfilDao.buscarPorCodigo(codigo);
    }

    /**
     * Todos los perfiles.
     * @return List Perfil
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_PERFIL_LIST)
    public List<Perfil> getPerfiList() {
        return perfilDao.getList();
    }
}
