package es.pfsgroup.plugin.recovery.config.perfiles;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.seguridadPw.PasswordApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.FuncionPerfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.config.funciones.dao.ADMFuncionDao;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.ADMFuncionPerfilDao;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.ADMPerfilDao;
import es.pfsgroup.plugin.recovery.config.perfiles.dto.ADMDtoBuscaPerfil;
import es.pfsgroup.plugin.recovery.config.perfiles.dto.ADMDtoPerfil;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

@Service("ADMPerfilManager")
public class ADMPerfilManager {
	public ADMPerfilManager() {
		super();
	}

	public ADMPerfilManager(ADMPerfilDao perfilDao, ADMFuncionDao funcionDao,
			ADMFuncionPerfilDao funcionPerfilDao, ApiProxyFactory proxyFactory) {
		super();
		this.perfilDao = perfilDao;
		this.funcionDao = funcionDao;
		this.funcionPerfilDao = funcionPerfilDao;
		this.proxyFactory = proxyFactory;
	}

	@Autowired
	private ADMPerfilDao perfilDao;

	@Autowired
	private ADMFuncionDao funcionDao;

	@Autowired
	private ADMFuncionPerfilDao funcionPerfilDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	/**
	 * Devuelve todos los perfiles.
	 * 
	 * @return
	 */
	@BusinessOperation("ADMPerfilManager.buscaPerfiles")
	public List<EXTPerfil> buscaPerfiles() {
		EventFactory.onMethodStart(this.getClass());
		return perfilDao.getList();
	}
	
	/**
	 * Devuelve todos los perfiles.
	 * 
	 * @return
	 */
	@BusinessOperation("ADMPerfilManager.buscaPerfilesNoBorrados")
	public List<EXTPerfil> buscaPerfilesNoBorrados() {
		EventFactory.onMethodStart(this.getClass());
		return perfilDao.getListUndeleted();
	}	

	/**
	 * Busca perfiles seg�n los criterios definidos en el DTO
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperation("ADMPerfilManager.findPerfiles")
	public Page findPerfiles(ADMDtoBuscaPerfil dto) {
		return perfilDao.findPerfiles(dto);
	}

	/**
	 * Almacena un perfil.
	 * 
	 * Este m�todo sirve tanto para dar de alta un nuevo perfil como para
	 * modificar uno existente. En el caso que el DTO contenga el id del perfil
	 * intentar� actualizarlo, si no crear� uno nuevo.
	 * 
	 * @param dto
	 */
	@BusinessOperation("ADMPerfilManager.guardaPerfil")
	@Transactional(readOnly = false)
	public EXTPerfil guardaPerfil(ADMDtoPerfil dto) {
		if (Checks.esNulo(dto.getDescripcion())
				&& Checks.esNulo(dto.getDescripcionLarga())) {
			throw new BusinessOperationException("plugin.config.perfiles.admperfilmanager.guardaperfil.datosdtoinsuficientes");
		}
		EXTPerfil p;
		if (dto.getId() == null) {
			p = perfilDao.createNew();
			p.setCodigo(String.valueOf(perfilDao.getLastCodigo() + 1));
		} else {
			p = perfilDao.get(dto.getId());
		}
		p.setDescripcionLarga(dto.getDescripcionLarga());
		p.setDescripcion(dto.getDescripcion());
		p.setEsCarterizado(false);

		if (dto.getId() == null) {
			Long id = perfilDao.save(p);
			p.setId(id);
		} else {
			perfilDao.saveOrUpdate(p);
		}
		return p;
	}

	/**
	 * A�ade en un perfil una lista de funciones
	 * 
	 * @param idPerfil
	 * @param funciones
	 */
	@BusinessOperation("ADMPerfilManager.guardaFuncionesPerfil")
	@Transactional(readOnly = false)
	public void guardaFuncionesPerfil(Long idPerfil, Collection<Long> funciones, String password) {
		if (Checks.esNulo(idPerfil)) {
			throw new IllegalArgumentException("idPerfil: es null");
		}

		// Comprobamos que la contraseña sea correcta (doble confirmación)
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		boolean passwordCorrecta = proxyFactory.proxy(PasswordApi.class).isPwCorrect(usuario, password);
		if (!passwordCorrecta) {
			throw new BusinessOperationException("admin.users.password.invalid");
		}
		
		if (!Checks.estaVacio(funciones)) {
			EXTPerfil p = perfilDao.get(idPerfil);
			if (p == null) {
				throw new BusinessOperationException(
						"plugin.config.perfiles.admperfilmanager.guardafuncionesperfil.noexisteperfil");
			}
			/*List<FuncionPerfil> listaRelaciones = funcionPerfilDao.getListFull();
			List<FuncionPerfil> listaFuncionesNoBorradas = funcionPerfilDao.getList();
			listaRelaciones.removeAll(listaFuncionesNoBorradas);
			List<FuncionPerfil> listaFuncionesPerfil = new ArrayList<FuncionPerfil>();
			for (FuncionPerfil funcionBorrada : listaRelaciones){
				if (funcionBorrada.getPerfil().getId().equals(idPerfil)){
					listaFuncionesPerfil.add(funcionBorrada);
				}
			}
			
			for (FuncionPerfil funcionPerfil : listaFuncionesPerfil) {
				funcionPerfilDao.delete(funcionPerfil);
				
			}	
			*/	
			for (Long funid : funciones){
				FuncionPerfil fp = funcionPerfilDao.createNewObject();
				fp.setPerfil(p);
				Funcion f = funcionDao.get(funid);
				if (Checks.esNulo(f)) {
					throw new BusinessOperationException(
								"plugin.config.perfiles.admperfilmanager.guardafuncionesperfil.noexistefuncion");
					}
				fp.setFuncion(f);
				funcionPerfilDao.save(fp);	
					}
					
				}		
			}

	/**
	 * Este m�todo elimina la relacion Funci�n- Perfil
	 * 
	 * @param idPerfil
	 * @param idFuncion
	 */
	@BusinessOperation("ADMPerfilManager.borrarFuncionPerfil")
	@Transactional(readOnly = false)
	public void borrarFuncionPerfil(Long idPerfil, Long idFuncion) {
		Assertions.assertNotNull(idFuncion, "idFuncion no puede ser null");
		Assertions.assertNotNull(idPerfil, "idPerfil no puede ser null");
		List<FuncionPerfil> fps = funcionPerfilDao.find(idFuncion, idPerfil);
		for (FuncionPerfil fp : fps) {
			funcionPerfilDao.delete(fp);
		}
	}

	/**
	 * Este metodo elimina la relacion Funcion- Perfil (recibiendo 
	 * 
	 * @param idPerfil
	 * @param idFuncion
	 * @param password
	 */
	@BusinessOperation("ADMPerfilManager.borrarFuncionPerfilSegura")
	@Transactional(readOnly = false)
	public void borrarFuncionPerfilSegura(Long idPerfil, Long idFuncion, String password) {
		Assertions.assertNotNull(idFuncion, "idFuncion no puede ser null");
		Assertions.assertNotNull(idPerfil, "idPerfil no puede ser null");
		Assertions.assertNotNull(password, "password no puede ser null");

		// Comprobamos que la contraseña sea correcta (doble confirmación)
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		boolean passwordCorrecta = proxyFactory.proxy(PasswordApi.class).isPwCorrect(usuario, password);
		if (!passwordCorrecta) {
			throw new BusinessOperationException("admin.users.password.invalid");
		}
		
		List<FuncionPerfil> fps = funcionPerfilDao.find(idFuncion, idPerfil);
		for (FuncionPerfil fp : fps) {
			funcionPerfilDao.delete(fp);
		}
	}

	@BusinessOperation("ADMPerfilManager.borrarPerfil")
	@Transactional(readOnly = false)
	public void borrarPerfil(Long idPerfil) {
		if (Checks.esNulo(idPerfil)) {
			throw new IllegalArgumentException("idPerfil: no puede ser NULL");
		}
		perfilDao.deleteById(idPerfil);
	}

	/**
	 * Busca un Perfil en funcion de su id.
	 * 
	 * @param idPerfil
	 * @return
	 */
	@BusinessOperation("ADMPerfilManager.getPerfil")
	public EXTPerfil getPerfil(Long idPerfil) {
		EventFactory.onMethodStart(this.getClass());
		return perfilDao.get(idPerfil);
	}

	/**
	 * Busca todas las funciones asociadas a un perfil
	 * 
	 * @param idPerfil
	 * @return
	 */
	@BusinessOperation("ADMPerfilManager.buscaFuncionesPerfil")
	public Set<Funcion> buscaFuncionesPerfil(Long idPerfil) {
		EXTPerfil p = perfilDao.get(idPerfil);
		return p.getFunciones();
	}

	/**
	 * Lista todas las funciones que no tiene asociadas el perfil con ese id.
	 * 
	 * @param id
	 * @return
	 */
	@BusinessOperation("ADMPerfilManager.listarRestoFunciones")
	public List<Funcion> listarRestoFunciones(Long id) {
		EXTPerfil p = perfilDao.get(id);
		Set<Funcion> funciones = p.getFunciones();
		List<Funcion> todasfunciones = funcionDao.getList();
		todasfunciones.removeAll(funciones);
		return todasfunciones;

	}
	
	@BusinessOperation("plugin.config.web.perfiles.buttons.left")
	List<DynamicElement> getButtonConfiguracionDespachoExternoLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.config.web.perfiles.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.config.web.perfiles.buttons.right")
	List<DynamicElement> getButtonsConfiguracionDespachoExternoRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.config.web.perfiles.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

}
