package es.pfsgroup.plugin.recovery.config.usuarios;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.seguridadPw.PasswordApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.config.dao.ADMAsuntoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.ADMDespachoExternoManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoExternoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMGestorDespachoDao;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.ADMPerfilDao;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMUsuarioDao;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMZonaUsuarioPerfilDao;
import es.pfsgroup.plugin.recovery.config.usuarios.dto.ADMDiccionarioGrupoUsuario;
import es.pfsgroup.plugin.recovery.config.usuarios.dto.ADMDtoBusquedaUsuario;
import es.pfsgroup.plugin.recovery.config.usuarios.dto.ADMDtoGuardarDespachoSupervisor;
import es.pfsgroup.plugin.recovery.config.usuarios.dto.ADMDtoUsuario;
import es.pfsgroup.plugin.recovery.config.zonas.dao.ADMZonaDao;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

@Service("ADMUsuarioManager")
public class ADMUsuarioManager {

	@Autowired
	private ADMUsuarioDao usuarioDao;

	@Autowired
	private ADMGestorDespachoDao gestorDespachoDao;

	@Autowired
	private ADMDespachoExternoDao despachoExternoDao;

	@Autowired
	private ADMPerfilDao perfilDao;

	@Autowired
	private ADMZonaDao zonaDao;

	@Autowired
	private ADMZonaUsuarioPerfilDao zonaUsuarioPerfilDao;

	@Autowired
	private ADMDespachoExternoManager despachoExternoManager;
	
	@Autowired
	private ADMAsuntoDao asuntoDao;

	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private FuncionManager funcionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	public ADMUsuarioManager() {

	}

	public ADMUsuarioManager(ADMUsuarioDao usuarioDao,
			ADMGestorDespachoDao gestorDespachoDao,
			ADMDespachoExternoDao despachoExternoDao, ADMPerfilDao perfilDao,
			ADMZonaDao zonaDao, ADMZonaUsuarioPerfilDao zonaUsuarioPerfilDao,
			Executor executor) {
		super();
		this.usuarioDao = usuarioDao;
		this.gestorDespachoDao = gestorDespachoDao;
		this.despachoExternoDao = despachoExternoDao;
		this.perfilDao = perfilDao;
		this.zonaDao = zonaDao;
		this.zonaUsuarioPerfilDao = zonaUsuarioPerfilDao;
		this.executor = executor;
	}

	/**
	 * Busca un usuario en funci�n del ID
	 * 
	 * @param id
	 * @return
	 */
	@BusinessOperation("ADMUsuarioManager.getUsuario")
	public Usuario getUsuario(Long id) {
		EventFactory.onMethodStart(this.getClass());
		Usuario u = getUsuarioLogado();
		EventFactory.onMethodStop(this.getClass());
		return usuarioDao.getByEntidad(id, u.getEntidad().getId());
	}

	/**
	 * Este m�todo nos devuelve las relaciones existentes con Zonas y Perfiles.
	 * 
	 * @param idUsuario
	 * @return
	 */
	@BusinessOperation("ADMUsuarioManager.getZonaUsuarioPerfil")
	public List<ZonaUsuarioPerfil> getZonaUsuarioPerfil(Long idUsuario) {
		Usuario usuarioLogado = getUsuarioLogado();
		Usuario u = usuarioDao.getByEntidad(idUsuario, usuarioLogado
				.getEntidad().getId());
		return u.getZonaPerfil();
	}

	@BusinessOperation("ADMUsuarioManager.buscaUsuarios")
	public List<Usuario> buscaUsuarios() {
		Usuario usuarioLogado = getUsuarioLogado();
		return usuarioDao.getListByEntidad(usuarioLogado.getEntidad().getId());
	}

	/**
	 * Busca usuarios seg�n los criterios definidos en el DTO de b�squeda
	 * 
	 * @param dtoBusquedaUsuario
	 *            DTO de b�squeda.
	 * @return Devuelve una lista de objetos Usuario paginada.
	 */
	@BusinessOperation("ADMUsuarioManager.findUsuarios")
	public Page findUsuarios(ADMDtoBusquedaUsuario dtoBusquedaUsuario) {
		EventFactory.onMethodStart(this.getClass());
		Usuario u = getUsuarioLogado();
		dtoBusquedaUsuario.setIdEntidad(u.getEntidad().getId());
		EventFactory.onMethodStop(this.getClass());
		return usuarioDao.findUsuarios(dtoBusquedaUsuario);

	}

	/**
	 * Lista todos los usuarios que tienen el atributo usuarioExterno=false.
	 * 
	 * @return
	 */
	@BusinessOperation("ADMUsuarioManager.getUsuariosNoExternos")
	public List<Usuario> getUsuariosNoExternos() {
		Usuario u = getUsuarioLogado();
		return usuarioDao.getUsuariosNoExternos(u.getEntidad().getId());

	}

	/**
	 * Lista todos los usuarios que tienen el atributo usuarioExterno=true.
	 * 
	 * @return
	 */
	@BusinessOperation("ADMUsuarioManager.getUsuariosExternos")
	public List<Usuario> getUsuariosExternos() {
		Usuario u = getUsuarioLogado();
		return usuarioDao.getUsuariosExternos(u.getEntidad().getId());

	}

	@BusinessOperation("ADMUsuarioManager.getDespachosSupervisor")
	public List<DespachoExterno> getDespachosSupervisor(Long idUsuario) {
		Usuario u = getUsuarioLogado();
		return usuarioDao.findDespachoSupervisor(idUsuario, u.getEntidad()
				.getId());

	}
	
	/*
	 * 
	 * @return
	 */
	@BusinessOperation("ADMUsuarioManager.getGruposUsuario")
	public HashMap<String, Object> getGruposUsuario(ADMDtoBusquedaUsuario dto) {
		HashMap<String, Object> resultado = new HashMap<String, Object>();
		List<Usuario> lista = null;
		if(!Checks.esNulo(dto.getId())){
			Usuario usu = getUsuario(dto.getId());
			Usuario usuLogado = getUsuarioLogado();
			List<Long> idsGrupos = proxyFactory.proxy(EXTGrupoUsuariosApi.class).buscaIdsGrupos(usu);
			Iterator<Long> it = idsGrupos.iterator();
			lista = new ArrayList<Usuario>();
			while (it.hasNext()) {
				Long id = (Long) it.next();
				if(!Checks.esNulo(id)){
					
					// Se recupera el grupo para comprobar que su entidad sea la misma que la del usuario logado
					Usuario usuGrupo =  getUsuario(id);
					if(usuGrupo != null && usuGrupo.getEntidad().getId().equals(usuLogado.getEntidad().getId())) {
						lista.add(usuGrupo);
					}
				}
			}
			resultado.put("results", lista);
			resultado.put("totalCount", lista.size());
		}else{
			resultado.put("results", null);
			resultado.put("totalCount", 0);
			return resultado;
		}
		return resultado;
	}
	
	/**
	 * 
	 * @return usuarioManager.getUsuarioLogado().getEntidad().getId()
	 */
	@BusinessOperation("ADMUsuarioManager.getGrupos")
	public List<ADMDiccionarioGrupoUsuario> getGrupos() {
		List<ADMDiccionarioGrupoUsuario> resultado = new ArrayList<ADMDiccionarioGrupoUsuario>();
		ADMDiccionarioGrupoUsuario bean = null;
		List<Usuario> usuarios = genericDao.getList(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "usuarioGrupo", true)
				,genericDao.createFilter(FilterType.EQUALS, "entidad.id", usuarioManager.getUsuarioLogado().getEntidad().getId())
				,genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		Iterator<Usuario> it = usuarios.iterator();
		while (it.hasNext()) {
			Usuario usuario = (Usuario) it.next();
			bean = new ADMDiccionarioGrupoUsuario();
			bean.setId(usuario.getId());
			bean.setCodigo(usuario.getUsername());
			bean.setDescripcion(usuario.getApellidoNombre());
			bean.setDescripcionLarga(usuario.getApellidoNombre());
			resultado.add(bean);
		}
		return resultado;
	}
	
	/**
	 * 
	 * @return
	 */
	@Transactional(readOnly = false)
	@BusinessOperation("ADMUsuarioManager.guardaGrupo")
	public void guardaGrupo(ADMDiccionarioGrupoUsuario dto) {
		boolean comprovacion = false;
		if(!Checks.esNulo(dto.getIdusuario()) && !Checks.esNulo(dto.getGrupo())){
			Usuario usu = getUsuario(dto.getIdusuario());
			List<Long> idsGrupos = proxyFactory.proxy(EXTGrupoUsuariosApi.class).buscaIdsGrupos(usu);
			Iterator<Long> it = idsGrupos.iterator();
			while (it.hasNext()) {
				Long id = (Long) it.next();
				if(id.equals(dto.getGrupo())){
					comprovacion = true;
					break;
				}
			}
			if(!comprovacion){
				EXTGrupoUsuarios grupoUsuario = new EXTGrupoUsuarios();
				grupoUsuario.setGrupo(getUsuario(dto.getGrupo()));
				grupoUsuario.setUsuario(getUsuario(dto.getIdusuario()));
				genericDao.save(EXTGrupoUsuarios.class, grupoUsuario);
			}
		}
	}
	

	@BusinessOperation("ADMUsuarioManager.quitarGrupo")
	@Transactional(readOnly = false)
	public void quitarGrupo(Long idUsuario, Long idGrupoUsuario) {	
		if(!Checks.esNulo(idUsuario) && !Checks.esNulo(idGrupoUsuario)){
			EXTGrupoUsuarios grupo = genericDao.get(EXTGrupoUsuarios.class, 
					genericDao.createFilter(FilterType.EQUALS, "grupo", getUsuario(idGrupoUsuario)),
					genericDao.createFilter(FilterType.EQUALS, "usuario", getUsuario(idUsuario)));			
			if(!Checks.esNulo(grupo)){genericDao.deleteById(EXTGrupoUsuarios.class, grupo.getId());}
		}
	}


	/**
	 * Almacena un usuario.
	 * 
	 * Este m�todo sirve tanto para dar de alta un nuevo usuario como para
	 * modificar uno existente. En el caso que el DTO contenga el id del usuario
	 * intentar� actualizarlo, si no crear� uno nuevo.
	 * 
	 * <strong>Cuando modifica un usuario, nunca cambia el password</strong>
	 * 
	 * @param dto
	 */
	@BusinessOperation("ADMUsuarioManager.guardaUsuario")
	@Transactional(readOnly = false)
	public Usuario guardaUsuario(ADMDtoUsuario dto) {
		Usuario u;
		if (dto.getId() == null) {
			u = usuarioDao.createNewUsuario();
			u.setPassword(dto.getPassword());
			u.setFechaVigenciaPassword(new Date(System.currentTimeMillis() - 24 * 60 * 60 * 1000L));
			checkUsernameUnico(dto.getUsername());
		} else {
			u = usuarioDao.get(dto.getId());
			checkEntidadUsuarioLogado(u.getEntidad().getId());

			if (!Checks.esNulo(dto.getPassword())) {
				u.setPassword(dto.getPassword());
				u.setFechaVigenciaPassword(new Date(System.currentTimeMillis() - 24 * 60 * 60 * 1000L));
			}
		}
		u.setUsername(dto.getUsername());
		u.setNombre(dto.getNombre());
		u.setApellido1(dto.getApellido1());
		u.setApellido2(dto.getApellido2());
		u.setEmail(dto.getEmail());
		// TODO - Añadir un dblselect para añadir los usuarios del grupo en
		// "GRU_GRUPOS_USUARIOS"
		u.setUsuarioGrupo(dto.getUsuarioGrupo());
		// u.setUsuarioExterno(dto.getUsuarioExterno());
		// NORMA La entidad del nuevo usuario siempre va a ser igual que la del
		// usuario logado
		u.setEntidad(getUsuarioLogado().getEntidad());
		if (dto.getId() == null) {
			u.setUsuarioExterno(dto.getUsuarioExterno());
			Long id = usuarioDao.save(u);
			u.setId(id);
		} else {
			checkGestorDefecto(u, dto);
			if (!u.getUsuarioExterno().equals(dto.getUsuarioExterno())) {
				checkAsuntosUsuario(u.getId());
				u.setUsuarioExterno(dto.getUsuarioExterno());
			}
			usuarioDao.saveOrUpdate(u);
		}

		List<GestorDespacho> lgd = gestorDespachoDao.getList();
		
		//BKREC-970
		Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Boolean tieneFuncion = funcionManager.tieneFuncion(usuLogado, "ROLE_DESACTIVAR_DEPENDENCIA_USU_EXTERNO");
				
		if (dto.getUsuarioExterno() || tieneFuncion) {
			if (dto.getDespachoExterno() == null && !tieneFuncion) {
				throw new BusinessOperationException("plugin.config.perfiles.admusuariomanager.guardausuario.despachoexternonull");
			}
			
			for (GestorDespacho g : lgd) {
				if (g.getUsuario().getId().equals(dto.getId())) {
					if (!g.getDespachoExterno().getId().equals(dto.getDespachoExterno())){
						checkAsuntosUsuario(dto.getId());
						
						if(!Checks.esNulo(dto.getDespachoExterno())){
							
							if(!g.getDespachoExterno().equals(dto.getDespachoExterno())){
								gestorDespachoDao.deleteById(g.getId());
								
								GestorDespacho gd = new GestorDespacho();
								gd.setDespachoExterno(despachoExternoDao.get(dto
										.getDespachoExterno()));
								gd.setUsuario(usuarioDao.get(u.getId()));
								gd.setGestorPorDefecto(Boolean.FALSE);
								gd.setSupervisor(Boolean.FALSE);
								gestorDespachoDao.saveOrUpdate(gd);
								
							}
						}
					}
					
					
				}
			}
			
		} else {
			if(u.getUsuarioExterno()){
				checkAsuntosUsuario(dto.getId());
			}
			for (GestorDespacho g : lgd) {
				if (g.getUsuario().getId().equals(dto.getId())
						&& !g.getSupervisor()) {
					
					if(dto.getDespachoExterno()!=null){
					gestorDespachoDao.deleteById(g.getId());
					
					GestorDespacho gd = new GestorDespacho();
					gd.setDespachoExterno(g.getDespachoExterno());
					gd.setUsuario(usuarioDao.get(u.getId()));
					gd.setGestorPorDefecto(g.getGestorPorDefecto());
					gd.setSupervisor(g.getSupervisor());
					gestorDespachoDao.saveOrUpdate(gd);
					
					}
				}
			}
		}

		return u;
	}

	private void checkUsernameUnico(String username) {
		Usuario existe = usuarioDao.findByUsername(username);
		if(!Checks.esNulo(existe)){
			throw new BusinessOperationException("plugin.config.perfiles.admusuariomanager.checkUsernameUnico.usernameRepetido");
		}
		
	}

	private void checkGestorDefecto(Usuario u, ADMDtoUsuario dto) {
		DespachoExterno oldDesp = despachoExternoDao.buscarPorGestor(u.getId());
		if (oldDesp != null) {
			GestorDespacho gestordefecto = despachoExternoManager
					.dameGestorDefecto(oldDesp.getId());
			if ((gestordefecto != null)
					&& (gestordefecto.getUsuario().getId().equals(u.getId()))
					&& ((!oldDesp.getId().equals(dto.getDespachoExterno()) || (!dto
							.getUsuarioExterno())))) {
				throw new BusinessOperationException(
						"plugin.config.perfiles.admusuariomanager.checkgestordefecto.esgestordefecto");
			}
		}

	}
	

	/**
	 * Asocia un perfil para diversas zonas a un usuario
	 * 
	 * @param zonas
	 *            Lista de zonas
	 * @param idUsuario
	 *            ID del usuario. Debe pertenecer a la misma entidad que el
	 *            usuario logado. En caso contrario se lanzar� una excepci�n
	 * @param idPerfil
	 *            ID del perfil
	 */
	@BusinessOperation("ADMUsuarioManager.asociaZonaUsuarioPerfil")
	@Transactional(readOnly = false)
	public void asociaZonaUsuarioPerfil(Collection<Long> zonas, Long idUsuario,
			Long idPerfil) {
		Usuario u = usuarioDao.get(idUsuario);
		checkEntidadUsuarioLogado(u.getEntidad().getId());
		EXTPerfil p = perfilDao.get(idPerfil);
		for (Long z : zonas) {
			ZonaUsuarioPerfil existe = zonaUsuarioPerfilDao.buscaZonPefUsu(z,idUsuario,idPerfil);
			if(Checks.esNulo(existe)){
				ZonaUsuarioPerfil zup = createNewZonaUsuarioPerfil();
				zup.setUsuario(u);
				zup.setPerfil(p);
				zup.setZona(zonaDao.get(z));
				zonaUsuarioPerfilDao.save(zup);
			}else{
				throw new BusinessOperationException(
						"plugin.config.perfiles.admusuariomanager.checkgestordefecto.perfilExistente");
			}
		}
	}

	/**
	 * Asocia un perfil para diversas zonas a un usuario (con comprobación de password)
	 * 
	 * @param zonas
	 *            Lista de zonas
	 * @param idUsuario
	 *            ID del usuario. Debe pertenecer a la misma entidad que el
	 *            usuario logado. En caso contrario se lanzar� una excepci�n
	 * @param idPerfil
	 *            ID del perfil
	 * @param password
	 *            Password de la persona que está haciendo la operación
	 */
	@BusinessOperation("ADMUsuarioManager.asociaZonaUsuarioPerfilSeguro")
	@Transactional(readOnly = false)
	public void asociaZonaUsuarioPerfilSeguro(Collection<Long> zonas, Long idUsuario,
			Long idPerfil, String password) {
		Usuario logado = getUsuarioLogado();
		boolean passwordCorrecta = proxyFactory.proxy(PasswordApi.class).isPwCorrect(logado, password);
		if (!passwordCorrecta) {
			throw new BusinessOperationException("admin.users.password.invalid");
		}
		
		Usuario u = usuarioDao.get(idUsuario);		
		checkEntidadUsuarioLogado(u.getEntidad().getId());
		EXTPerfil p = perfilDao.get(idPerfil);
		for (Long z : zonas) {
			ZonaUsuarioPerfil existe = zonaUsuarioPerfilDao.buscaZonPefUsu(z,idUsuario,idPerfil);
			if(Checks.esNulo(existe)){
				ZonaUsuarioPerfil zup = createNewZonaUsuarioPerfil();
				zup.setUsuario(u);
				zup.setPerfil(p);
				zup.setZona(zonaDao.get(z));
				zonaUsuarioPerfilDao.save(zup);
			}else{
				throw new BusinessOperationException(
						"plugin.config.perfiles.admusuariomanager.checkgestordefecto.perfilExistente");
			}
		}
	}

	private void checkEntidadUsuarioLogado(Long idEntidad) {
		Usuario logado = getUsuarioLogado();
		if (!logado.getEntidad().getId().equals(idEntidad))
			throw new BusinessOperationException("plugin.config.perfiles.admusuariomanager.checkentidadusuariologado.noexisteentidad");
	}
	
	@SuppressWarnings("unused")
	private void checkSupervisor (Long idUsuario){
		List<GestorDespacho> supervisores = gestorDespachoDao.getList();
		for(GestorDespacho gd : supervisores){
			if (gd.getUsuario().getId().equals(idUsuario)){
				throw new BusinessOperationException(
				"plugin.config.perfiles.admusuariomanager.checkasuntosusuario.supervisaDespacho");
				
			}
		}
			
		
	}

	private void checkAsuntosUsuario(Long idUsuario) {
		List<EXTAsunto> asuntos = getAsuntos(idUsuario);
		if (!Checks.estaVacio(asuntos)){
			throw new BusinessOperationException(
					"plugin.config.perfiles.admusuariomanager.checkasuntosusuario.tieneasuntos");}
	}

	private Usuario getUsuarioLogado() {
		Usuario logado = (Usuario) executor
				.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		return logado;
	}

	
	private List<EXTAsunto> getAsuntos(Long idUsuario) {
		List<EXTAsunto> asuntosGestor = asuntoDao.getAsuntosUsuario(idUsuario);
		List<EXTAsunto> asuntosProc = asuntoDao.getAsuntosUsuarioProcurador(idUsuario);
		asuntosGestor.addAll(asuntosProc);
		List<EXTAsunto> asuntosSupervisor = asuntoDao.getAsuntosUsuarioSupervisor(idUsuario);
		asuntosGestor.addAll(asuntosSupervisor);
		return asuntosGestor;
	}

	@BusinessOperation("ADMUsuarioManager.borrarUsuario")
	@Transactional(readOnly = false)
	public void borrarUsuario(Long idUsuario) {
		if (idUsuario == null) {
			throw new IllegalArgumentException("Id de usuario no v�lido");
		}
		Usuario usuario = usuarioDao.get(idUsuario);
		if (usuario == null) {
			throw new BusinessOperationException("plugin.config.perfiles.admusuariomanager.borrarusuario.noexisteusuario");
		}

		checkEntidadUsuarioLogado(usuario.getEntidad().getId());
		List<GestorDespacho> supervisores = gestorDespachoDao.getList();
		for (GestorDespacho gd: supervisores){
			if (gd.getUsuario().getId().equals(idUsuario)){
				throw new BusinessOperationException(
				"plugin.config.perfiles.admusuariomanager.checkasuntosusuario.supervisaDespacho");
			}
		}
		checkAsuntosUsuario(idUsuario);	
		usuarioDao.deleteById(idUsuario);
	}

	/**
	 * Borra una relacion Zona - Usuario - Perfil
	 * 
	 * @param id
	 *            Id de la relacion
	 */
	@BusinessOperation("ADMUsuarioManager.quitarZonaUsuarioPerfil")
	@Transactional(readOnly = false)
	public void quitarZonaUsuarioPerfil(Long id) {
		if (id == null) {
			throw new IllegalArgumentException("El id no es v�lido");
		}
		ZonaUsuarioPerfil zpu = zonaUsuarioPerfilDao.get(id);
		if (zpu == null) {
			throw new BusinessOperationException(
					"plugin.config.perfiles.admusuariomanager.quitarzonausuarioperfil.noexistezpu");
		}
		if (zpu.getUsuario().getZonaPerfil().size() <= 1) {
			throw new BusinessOperationException(
					"plugin.config.perfiles.admusuariomanager.quitarzonausuarioperfil.zonificacionvacia");
		}
		checkEntidadUsuarioLogado(zpu.getUsuario().getEntidad().getId());
		zonaUsuarioPerfilDao.deleteById(id);

	}

	/**
	 * Borra una relacion Zona - Usuario - Perfil
	 * 
	 * @param id
	 *            Id de la relacion
	 */
	@BusinessOperation("ADMUsuarioManager.quitarZonaUsuarioPerfilSeguro")
	@Transactional(readOnly = false)
	public void quitarZonaUsuarioPerfilSeguro(Long id, String password) {
		if (id == null) {
			throw new IllegalArgumentException("El id no es valido");
		}
		
		// Comprobamos que la contraseña sea correcta (doble confirmación)
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		boolean passwordCorrecta = proxyFactory.proxy(PasswordApi.class).isPwCorrect(usuario, password);
		if (!passwordCorrecta) {
			throw new BusinessOperationException("admin.users.password.invalid");
		}
		
		ZonaUsuarioPerfil zpu = zonaUsuarioPerfilDao.get(id);
		if (zpu == null) {
			throw new BusinessOperationException(
					"plugin.config.perfiles.admusuariomanager.quitarzonausuarioperfil.noexistezpu");
		}
		if (zpu.getUsuario().getZonaPerfil().size() <= 1) {
			throw new BusinessOperationException(
					"plugin.config.perfiles.admusuariomanager.quitarzonausuarioperfil.zonificacionvacia");
		}
		checkEntidadUsuarioLogado(zpu.getUsuario().getEntidad().getId());
		zonaUsuarioPerfilDao.deleteById(id);

	}

	/**
	 * Borra una relaci�n Gestor - Despacho
	 * 
	 * @param idUsuario
	 * @param idDespachoExterno
	 */
	@BusinessOperation("ADMUsuarioManager.quitarGestorDespacho")
	@Transactional(readOnly = false)
	public void quitarGestorDespacho(Long idUsuario, Long idDespachoExterno) {
		List<GestorDespacho> gd = gestorDespachoDao.getList();
		for (GestorDespacho g : gd) {
			checkEntidadUsuarioLogado(g.getUsuario().getEntidad().getId());
			if ((g.getUsuario().getId().equals(idUsuario))
					&& (g.getDespachoExterno().getId()
							.equals(idDespachoExterno))) {
				gestorDespachoDao.deleteById(g.getId());
			}
		}
	}

	/**
	 * Crea una relaci�n en la tabla Gestor - Despacho con el atributo
	 * supervisor = true.
	 * 
	 * @param dto
	 */
	@BusinessOperation("ADMUsuarioManager.guardaDespachoSupervisor")
	@Transactional(readOnly = false)
	public void guardaDespachoSupervisor(ADMDtoGuardarDespachoSupervisor dto) {
		// NORMA S�lo podr� ser supervisor de un despacho un usuario no externo.
		if (Checks.esNulo(dto.getUsuarioExterno())
				|| (!dto.getUsuarioExterno())) {
			GestorDespacho gd = new GestorDespacho();
			gd.setDespachoExterno(despachoExternoDao.get(dto
					.getDespachoExterno()));
			gd.setUsuario(usuarioDao.get(dto.getIdusuario()));
			gd.setGestorPorDefecto(Boolean.FALSE);
			gd.setSupervisor(Boolean.TRUE);
			gestorDespachoDao.saveOrUpdate(gd);
		}
	}

	public ZonaUsuarioPerfil createNewZonaUsuarioPerfil() {
		return new ZonaUsuarioPerfil();
	}
	
	@BusinessOperation("plugin.config.web.usuarios.buttons.left")
	List<DynamicElement> getButtonConfiguracionDespachoExternoLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.config.web.usuarios.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.config.web.usuarios.buttons.right")
	List<DynamicElement> getButtonsConfiguracionDespachoExternoRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.config.web.usuarios.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

}
