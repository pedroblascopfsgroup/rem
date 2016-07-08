package es.pfsgroup.plugin.recovery.config.despachoExterno;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.multigestor.dao.EXTTipoGestorPropiedadDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.config.PluginConfigBusinessOperations;
import es.pfsgroup.plugin.recovery.config.dao.ADMAsuntoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDDTipoViaDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoAmbitoActuacionDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoExternoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMGestorDespachoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMTipoDespachoExternoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dto.ADMDtoBusquedaDespachoExterno;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dto.ADMDtoDespachoExterno;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dao.DespachoExternoExtrasDao;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dao.DespachoExtrasAmbitoDao;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dto.DespachoExternoExtrasDto;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoClasiPerfil;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoCodEstado;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoContratoVigor;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoExternoExtras;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoExtrasAmbito;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoIvaDes;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoRelEntidad;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTDDTipoGestorApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.turnadodespachos.DespachoAmbitoActuacion;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDao;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDespachoDto;

@Service("ADMDespachoExternoManager")
public class ADMDespachoExternoManager {
	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;
		
	@Autowired
	private ADMDespachoExternoDao despachoExternoDao;

	@Autowired
	private ADMDespachoAmbitoActuacionDao despachoAmbitoActuacionDao;
	
	@Autowired
	private ADMGestorDespachoDao gestorDespachoDao;

	@Autowired
	private ADMDDTipoViaDao ddTipoViaDao;

	@Autowired
	private ADMTipoDespachoExternoDao tipoDespachoDao;
	
	@Autowired
	private EXTTipoGestorPropiedadDao tipoGestorPropiedadDao;

	@Autowired
	private Executor executor;
	
	@Autowired
	private ADMAsuntoDao asuntoDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private EsquemaTurnadoDao esquemaTurnadoDao;
	
	@Autowired
	private DespachoExternoExtrasDao despachoExtrasDao;
	
	@Autowired
	private EXTGestoresDao gestoresDao;
	
	@Autowired
	private CoreProjectContext context;
	
	@Autowired
	private DespachoExtrasAmbitoDao extrasAmbitoDao;

	public ADMDespachoExternoManager() {

	}

	public ADMDespachoExternoManager(ADMDespachoExternoDao despachoExternoDao,
			ADMGestorDespachoDao gestorDespachoDao,
			ADMTipoDespachoExternoDao tipoDespachoDao, Executor ex) {
		super();
		this.despachoExternoDao = despachoExternoDao;
		this.gestorDespachoDao = gestorDespachoDao;
		this.tipoDespachoDao = tipoDespachoDao;
		this.executor = ex;
	}
	
	public ADMDespachoExternoManager(ADMDespachoExternoDao despachoExternoDao,
			ADMGestorDespachoDao gestorDespachoDao,
			ADMTipoDespachoExternoDao tipoDespachoDao,EXTTipoGestorPropiedadDao tipoGestorPropiedadDao, ApiProxyFactory proxyFactory, Executor ex) {
		super();
		this.despachoExternoDao = despachoExternoDao;
		this.gestorDespachoDao = gestorDespachoDao;
		this.tipoDespachoDao = tipoDespachoDao;
		this.tipoGestorPropiedadDao = tipoGestorPropiedadDao;		
		this.proxyFactory = proxyFactory;
		this.executor = ex;
	}

	/**
	 * Devuelve el despacho al que pertenece un gestor externo.
	 * 
	 * <strong>Un gestor externo sólo puede pertenecer a un despacho</strong>
	 * 
	 * @param idGestor
	 *            ID del Usuario, <b>debe ser gestor externo y
	 *            no-supervisor</b>.
	 * @return Devuelve NULL si el Usuario no es gestor externo o supervisor.
	 */
	@BusinessOperation("ADMDespachoExternoManager.buscaPorGestor")
	public DespachoExterno buscaPorGestor(Long idGestor) {
		// NORMA Un gestor externo no puede supervisar despachos.
		return despachoExternoDao.buscarPorGestor(idGestor);
	}

	/**
	 * Devuelve todos los despachos externos.
	 * 
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.buscaDespachosExternos")
	public List<DespachoExterno> buscaDespachosExternos() {
		EventFactory.onMethodStart(this.getClass());
		return despachoExternoDao.getList();
	}

	/**
	 * Devuelve un el Despacho Externo con esa ID.
	 * 
	 * @param idDespachoExterno
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.getDespachoExterno")
	public DespachoExterno getDespachoExterno(Long idDespachoExterno) {
		return despachoExternoDao.get(idDespachoExterno);
	}

	/**
	 * Devuelve un el Despacho Externo con esa ID.
	 * 
	 * @param idDespachoExterno
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.getAmbitoGeograficoDespacho")
	public List<DespachoAmbitoActuacion> getAmbitoGeograficoDespacho(Long idDespachoExterno) {
		return despachoAmbitoActuacionDao.getAmbitoGeograficoDespacho(idDespachoExterno);
	}
	
	/**
	 * Almacena un despacho externo.
	 * 
	 * Este método sirve tanto para dar de alta un nuevo despacho externo como
	 * para modificar uno existente. En el caso que el DTO contenga el id del
	 * despacho externo intentará actualizarlo, si no creará uno nuevo.
	 * 
	 * 
	 * @param dto
	 * 
	 * @return El despacho que se acaba de dar de alta
	 */
	@BusinessOperation("ADMDespachoExternoManager.guardaDespachoExterno")
	@Transactional(readOnly = false)
	public DespachoExterno guardaDespachoExterno(ADMDtoDespachoExterno dto) {
		Assertions.assertNotNull(dto.getTipoDespacho(),
				"El tipo de despacho no puede ser NULL");
		DespachoExterno d;
		if (dto.getId() == null) {
			d = despachoExternoDao.createNewDespachoExterno();
		} else {
			d = despachoExternoDao.get(dto.getId());
		}
		DDTipoDespachoExterno tipo = tipoDespachoDao.get(dto.getTipoDespacho());
		if (Checks.esNulo(tipo)) {
			throw new BusinessOperationException("plugin.config.despachoExterno.admdespachoexternomanager.guardardespacho.tiponoencontrado");
		} else {
			d.setTipoDespacho(tipo);
		}

		d.setDespacho(dto.getDespacho());
		d.setTipoVia(dto.getTipoVia());
		d.setDomicilio(dto.getDomicilio());
		d.setDomicilioPlaza(dto.getDomicilioPlaza());
		d.setCodigoPostal(dto.getCodigoPostal());
		d.setPersonaContacto(dto.getPersonaContacto());
		d.setTelefono1(dto.getTelefono1());
		d.setTelefono2(dto.getTelefono2());

		if (dto.getId() != null) {
			despachoExternoDao.saveOrUpdate(d);
		} else {
			Long id = despachoExternoDao.save(d);
			d.setId(id);
		}
		
		guardaGestorPropiedad(tipo.getCodigo(),dto.getTipoGestor());

		return d;
	}


	private void guardaGestorPropiedad(String codTipoDespacho, String tiposGestor) {
		String[] tipoGestor = tiposGestor.split(",");
		
		//Borrar los que no están en tiposGestor
		List<EXTTipoGestorPropiedad> tiposGestorPropiedad = tipoGestorPropiedadDao.getByClaveValor(EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS, codTipoDespacho);
		for (EXTTipoGestorPropiedad extTipoGestorPropiedad : tiposGestorPropiedad) {
			boolean encontrado = false;
			for (String tg : tipoGestor) {
				if (tg.equals(extTipoGestorPropiedad.getTipoGestor().getCodigo())) {
					encontrado = true;
					break;
				}
			}
			if (!encontrado) {
				borrarGestorPropiedad(codTipoDespacho, extTipoGestorPropiedad);
			}
		}
		
		
		//Añadir los nuevos
		addGestoresPropiedad(codTipoDespacho, tipoGestor);
		
		
	}

	private void addGestoresPropiedad(String codTipoDespacho, String[] tipoGestor) {
		for (String tg : tipoGestor) {
			EXTTipoGestorPropiedad tipoGestorPropiedad = tipoGestorPropiedadDao.getGestorPropiedad(tg, EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS, codTipoDespacho);
			if (Checks.esNulo(tipoGestorPropiedad)) {
				
				EXTDDTipoGestor ddTipoGestor = proxyFactory.proxy(EXTDDTipoGestorApi.class).getByCod(tg);
				if (!Checks.esNulo(ddTipoGestor)) {
					tipoGestorPropiedad = tipoGestorPropiedadDao.getByGestorClave(tg, EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS);
					if (Checks.esNulo(tipoGestorPropiedad)) {
						//Si no existe se añade nuevo
						tipoGestorPropiedad = new EXTTipoGestorPropiedad();
						tipoGestorPropiedad.setTipoGestor(ddTipoGestor);
						tipoGestorPropiedad.setClave(EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS);
						tipoGestorPropiedad.setValor(codTipoDespacho);
						tipoGestorPropiedadDao.save(tipoGestorPropiedad);
					} else {
						//Si existe se le añade el nuevo tipo de despacho
						tipoGestorPropiedad.setValor(tipoGestorPropiedad.getValor()+","+codTipoDespacho);
						tipoGestorPropiedadDao.saveOrUpdate(tipoGestorPropiedad);
					}
				}
			}
		}
		
	}

	/**
	 * Borra un tipo de despacho del tipo de gestorPropiedad
	 * @param codTipoDespacho
	 * @param tipoGestorPropiedad
	 */
	private void borrarGestorPropiedad(String codTipoDespacho, EXTTipoGestorPropiedad tipoGestorPropiedad) {
		String[] valor = tipoGestorPropiedad.getValor().split(",");
		String newValor="";
		if (valor.length<2) {
			tipoGestorPropiedadDao.delete(tipoGestorPropiedad);
		} else {
			for (String v : valor) {
				if (!codTipoDespacho.equals(v)) {
					newValor += newValor.equals("") ? v : ","+v;
				}
			}
			tipoGestorPropiedad.setValor(newValor);
			tipoGestorPropiedadDao.saveOrUpdate(tipoGestorPropiedad);
		}
		
		
	}

	/**
	 * Elimina un Despacho Externo
	 * 
	 * @param idDespachoExterno
	 * @return Si el id del despacho externo no existe o se le pasa como entrada
	 *         un null se deberá lanzar una excepción
	 * 
	 */
	@BusinessOperation("ADMDespachoExternoManager.borrarDespachoExterno")
	@Transactional(readOnly = false)
	public void borrarDespachoExterno(Long idDespachoExterno) {
		if (idDespachoExterno == null) {
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if ((despachoExternoDao.get(idDespachoExterno) == null)) {
			throw new BusinessOperationException(
					"plugin.config.despachoExterno.admdespachoexternomanager.borrardespachoexterno.despachonoencontrado");
		}
		List<GestorDespacho> gds = despachoExternoDao
				.buscarGestoresDespacho(idDespachoExterno);
		if (!Checks.estaVacio(gds)) {
			throw new BusinessOperationException(
					"plugin.config.despachoExterno.admdespachoexternomanager.borrardespachoexterno.despachocongestores");
		}
		despachoExternoDao.deleteById(idDespachoExterno);
		despachoExtrasDao.deleteById(idDespachoExterno);
		extrasAmbitoDao.deleteById(idDespachoExterno);
		
	}

	/**
	 * Elimina una relación Gestor-Despacho Este método es exactamente igual que
	 * borrarSupervisorDespacho
	 * 
	 * @param idGestor
	 */

	@BusinessOperation("ADMDespachoExternoManager.borrarGestorDespacho")
	@Transactional(readOnly = false)
	public void borrarGestorDespacho(Long idGestor) {
		// TODO Eliminar este método, es el mismo que borrarSupervisorDespacho
		if (idGestor == null) {
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if (gestorDespachoDao.get(idGestor) == null) {
			throw new BusinessOperationException(
					"plugin.config.despachoExterno.admdespachoexternomanager.borrargestordespacho.gestornoexiste");
		}
		List<EXTAsunto> asuntos = asuntoDao.getAsuntosGestor(idGestor);
		if (!Checks.estaVacio(asuntos) ){
			throw new BusinessOperationException(
					"plugin.config.perfiles.admusuariomanager.checkasuntosusuario.tieneasuntos");
			}
		gestorDespachoDao.deleteById(idGestor);
	}

	/**
	 * Elimina una relación Gestor - Despacho
	 * 
	 * @param idSupervisor
	 * @return debera devolver una excepción si se le pasa como entrada un null
	 *         o un id que no existe
	 */
	@BusinessOperation("ADMDespachoExternoManager.borrarSupervisorDespacho")
	@Transactional(readOnly = false)
	public void borrarSupervisorDespacho(Long idSupervisor) {
		if (idSupervisor == null) {
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if (gestorDespachoDao.get(idSupervisor) == null) {
			throw new BusinessOperationException(
					"plugin.config.despachoExterno.admdespachoexternomanager.borrarsupervisordespacho.supervisornoexiste");
		}
		List<EXTAsunto> asuntos = asuntoDao.getAsuntosSupervisor(idSupervisor);
		if (!Checks.estaVacio(asuntos)){
			throw new BusinessOperationException(
					"plugin.config.perfiles.admusuariomanager.checkasuntosusuario.tieneasuntos");
			}
	
		gestorDespachoDao.deleteById(idSupervisor);
	}

		

	/**
	 * Devuelve una lista de relación Gestor - Despacho en la que
	 * despachoExterno coincide con el id que le pasamos como parámetro y tiene
	 * el campo supervisor = true.
	 * 
	 * @param idDespacho
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.getSupervisoresDespacho")
	public List<GestorDespacho> getSupervisoresDespacho(Long idDespacho) {
		EventFactory.onMethodStart(this.getClass());
		if (idDespacho == null) {
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if (despachoExternoDao.get(idDespacho) == null) {
			throw new BusinessOperationException(
					"plugin.config.despachoExterno.admdespachoexternomanager.getsupervisoresdespachoe.noexistedespacho");
		}
		EventFactory.onMethodStop(this.getClass());
		return despachoExternoDao.buscarSupervisoresDespacho(idDespacho);
	}

	/**
	 * Devuelve una lista de relación Gestor - Despacho en la que
	 * GestorDespacho.despachoExterno.id coincide con el id que le pasamos como
	 * parámetro. No devolverá la fila en la que el usuario sea supervisor.
	 * 
	 * @param idDespacho
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.getGestoresDespacho")
	public List<GestorDespacho> getGestoresDespacho(Long idDespacho) {
		if (idDespacho == null) {
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if (despachoExternoDao.get(idDespacho) == null) {
			throw new BusinessOperationException(
					"plugin.config.despachoExterno.admdespachoexternomanager.getgestoresdespacho.noexistedespacho");
		}
		return despachoExternoDao.buscarGestoresDespacho(idDespacho);
	}

	/**
	 * Devuelve el gestor por defecto de un despacho externo. Un despacho
	 * externo sólo puede tener un gestor por defecto.
	 * 
	 * @param idDespacho
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.dameGestorDefecto")
	public GestorDespacho dameGestorDefecto(Long idDespacho) {
		List<GestorDespacho> listaGestoresDespacho = despachoExternoDao
				.buscarGestoresDespacho(idDespacho);
		GestorDespacho result = null;
		for (GestorDespacho gd : listaGestoresDespacho) {
			if (gd.getGestorPorDefecto()) {
				if (result == null) {
					result = gd;
				} else {
					throw new BusinessOperationException(
							"plugin.config.despachoExterno.admdespachoexternomanager.damegestorpordefecto.masdeungestordefecto");
				}
			}
		}
		return result;
	}

	/**
	 * Cambia el gestor por defecto de un despacho externo.
	 * 
	 * @param idGestor
	 * 
	 * @return Devuelve el nuevo Gestor por defecto del despacho
	 */
	@BusinessOperation("ADMDespachoExternoManager.cambiaGestorDefecto")
	@Transactional(readOnly = false)
	public GestorDespacho cambiaGestorDefecto(Long idGestor) {
		if (idGestor == null) {
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if (gestorDespachoDao.get(idGestor) == null) {
			throw new BusinessOperationException(
					"plugin.config.despachoExterno.admdespachoexternomanager.cambiagestordefecto.noexistegestor");
		}
		GestorDespacho gd = gestorDespachoDao.get(idGestor);
		List<GestorDespacho> gdlist = despachoExternoDao
				.buscarGestoresDespacho(gd.getDespachoExterno().getId());
		for (GestorDespacho g : gdlist) {
			g.setGestorPorDefecto(false);
		}
		gd.setGestorPorDefecto(true);
		gestorDespachoDao.saveOrUpdate(gd);
		return gd;
	}

	/**
	 * Busca despachos externos según los criterios definidos en el DTO de
	 * búsqueda
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.findDespachosExternos")
	public Page findDespachosExternos(ADMDtoBusquedaDespachoExterno dto) {
		EventFactory.onMethodStart(this.getClass());
		return despachoExternoDao.findDespachosExternos(dto);
	}

	@BusinessOperation("ADMDespachoExternoManager.getTipoVia")
	public List<DDTipoVia> getTipoVia() {
		// TODO Eliminar este método
		return ddTipoViaDao.getList();
	}

	/**
	 * Asigna una zona a un despacho
	 * 
	 * @param idDespacho
	 *            ID del despacho
	 * @param idZona
	 *            ID de la zona a asignar.
	 */
	@BusinessOperation(PluginConfigBusinessOperations.DESPACHOEXTERNO_MGR_ZONIFICA)
	@Transactional(readOnly = false)
	public void zonificarDespacho(Long idDespacho, Long idZona) {
		Assertions.assertNotNull(idDespacho, "idDespacho no puede ser NULL");
		Assertions.assertNotNull(idZona, "codZona no puede ser NULL");

		DespachoExterno desp = despachoExternoDao.get(idDespacho);
		if (Checks.esNulo(desp)) {
			throw new BusinessOperationException("plugin.config.despachoExterno.admdespachoexternomanager.zonificardespacho.noexistedespacho");
		}
		DDZona zona = (DDZona) executor.execute(
				PluginConfigBusinessOperations.ZONA_MGR_GET, idZona);
		if (Checks.esNulo(zona)) {
			throw new BusinessOperationException("plugin.config.despachoExterno.admdespachoexternomanager.zonificardespacho.noexistezona");
		}

		desp.setZona(zona);

		despachoExternoDao.saveOrUpdate(desp);

	}

	/**
	 * Obtiene los despachos externos de un determinado tipo.
	 * 
	 * @param tipoDespacho
	 *            Tipo de despacho. Debe ser distinto de NULL.
	 * @return Devuelve una lista vacía si no existen despachos del tipo
	 *         especificado, o si no existe el tipo.
	 */
	@BusinessOperation(PluginConfigBusinessOperations.DESPACHOEXTERNO_MGR_GET_BY_TIPO)
	public List<DespachoExterno> getDespachoExternoByTipo(Long tipoDespacho) {
		Assertions.assertNotNull(tipoDespacho,
				"tipoDespacho: no puede ser NULL");
		return despachoExternoDao.getByTipo(tipoDespacho);

	}
	
	@BusinessOperation("plugin.config.web.despachoExterno.buttons.left")
	List<DynamicElement> getButtonConfiguracionDespachoExternoLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.config.web.despachoExterno.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.config.web.despachoExterno.buttons.right")
	List<DynamicElement> getButtonsConfiguracionDespachoExternoRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.config.web.despachoExterno.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}
	
	@Transactional(readOnly = false)
	public void saveEsquemaDespacho(EsquemaTurnadoDespachoDto dto) {
		
		try {
			// Se guardan los datos directamente relacionados con el despacho
			DespachoExterno despachoExterno = despachoExternoDao.get(dto.getId());
			if(!Checks.esNulo(dto.getTurnadoCodigoImporteLitigios()) && dto.getTurnadoCodigoImporteLitigios() != "")
			{
				despachoExterno.setTurnadoCodigoImporteLitigios(dto.getTurnadoCodigoImporteLitigios());
				despachoExterno.setTurnadoCodigoCalidadLitigios(dto.getTurnadoCodigoCalidadLitigios());
				despachoExterno.setTurnadoCodigoImporteConcursal(dto.getTurnadoCodigoImporteConcursal());
				despachoExterno.setTurnadoCodigoCalidadConcursal(dto.getTurnadoCodigoCalidadConcursal());
				
				despachoExternoDao.saveOrUpdate(despachoExterno);
			}
			
			if((!Checks.esNulo(dto.getListaComunidades()) && dto.getListaComunidades() != "")
					|| (!Checks.esNulo(dto.getListaProvincias()) && dto.getListaProvincias() != "")) {
				
				// Se marcan como borrados los ámbitos de actuación que han sido eliminados de la lista de comunidades y provincias
				List<DespachoAmbitoActuacion> listDespachoAmbitoActuacion = despachoAmbitoActuacionDao.getAmbitosActuacionExcluidos(dto.getId(), dto.getListaComunidades(), dto.getListaProvincias());
				for(DespachoAmbitoActuacion despachoAmbitoActuacion : listDespachoAmbitoActuacion) {
					despachoAmbitoActuacion.getAuditoria().setFechaBorrar(new Date());
					despachoAmbitoActuacion.getAuditoria().setUsuarioBorrar(SecurityUtils.getCurrentUser().getUsername());
					despachoAmbitoActuacion.getAuditoria().setBorrado(true);
				}
				
				// Se buscan las relaciones existentes entre el despacho y las comunidades. En caso de no existir se crea
				List<String> listaComunidades = Arrays.asList(StringUtils.split(dto.getListaComunidades(), ","));
				for(String codigoComunidad : listaComunidades) {
					
					DespachoAmbitoActuacion despachoAmbitoActuacion = despachoAmbitoActuacionDao.getByDespachoYComunidad(dto.getId(), codigoComunidad);
					
					if(despachoAmbitoActuacion == null) {
						DDComunidadAutonoma comunidad = genericDao.get(DDComunidadAutonoma.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoComunidad));
						
						despachoAmbitoActuacion = new DespachoAmbitoActuacion();
						despachoAmbitoActuacion.setDespacho(despachoExterno);
						despachoAmbitoActuacion.setComunidad(comunidad);
					}
					
					listDespachoAmbitoActuacion.add(despachoAmbitoActuacion);				
				}
				
				// Se buscan las relaciones existentes entre el despacho y las provincias. En caso de no existir se crea
				List<String> listaProvincias = Arrays.asList(StringUtils.split(dto.getListaProvincias(), ","));
				for(String codigoProvincia : listaProvincias) {
					
					DespachoAmbitoActuacion despachoAmbitoActuacion = despachoAmbitoActuacionDao.getByDespachoYProvincia(dto.getId(), codigoProvincia);
					
					DDProvincia provincia = genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoProvincia));
					if(despachoAmbitoActuacion == null) {
						despachoAmbitoActuacion = new DespachoAmbitoActuacion();
						despachoAmbitoActuacion.setDespacho(despachoExterno);
						despachoAmbitoActuacion.setProvincia(provincia);		
					}
					if(dto.getNombreProvincia() != null && provincia.getDescripcion().toUpperCase().equals(dto.getNombreProvincia().toUpperCase())) {
						EsquemaTurnado esquema = new EsquemaTurnado();
						esquema = esquemaTurnadoDao.getEsquemaVigente();
						despachoAmbitoActuacion.setEtcLitigio(esquema.getConfigByCodigo(dto.getProvinciaCalidadLitigio()));
						despachoAmbitoActuacion.setEtcConcurso(esquema.getConfigByCodigo(dto.getProvinciaCalidadConcurso()));
					}
					
					listDespachoAmbitoActuacion.add(despachoAmbitoActuacion);				
				}
				
				// Se guardan las modificaciones realizadas en los ámbitos de actuación del despacho
				for(DespachoAmbitoActuacion despachoAmbitoActuacion : listDespachoAmbitoActuacion) {
					despachoAmbitoActuacionDao.saveOrUpdate(despachoAmbitoActuacion);
				}
			}
		}
		catch(Exception e) {
			logger.error("Error en el método saveEsquemaDespacho: " + e .getMessage());
			throw new BusinessOperationException(e);
		}
	}
	
	@Transactional(readOnly = false)
	public void guardarAmbitoActuacion(DespachoAmbitoActuacion despachoAmbitoActuacion)
	{
		despachoAmbitoActuacionDao.saveOrUpdate(despachoAmbitoActuacion);
	}
	
	@BusinessOperation("ADMDespachoExternoManager.dameDespachoExtras")
	public DespachoExternoExtrasDto dameDespachoExtras(Long idDespacho) {
		
		return despachoExtrasDao.getDtoDespachoExtras(idDespacho);
	}
	
	/**
	 * Devuelve una lista de usuarios externos, y que no existen ya en el despacho
	 * @param idDespacho
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.getGestoresExtList")
	public List<Usuario> getGestoresExtList(Long idDespacho) {
		List<Usuario> listaUsuarios = genericDao.getList(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "usuarioExterno", true));
		List<Usuario> listaUsuariosExistentes = gestoresDao.getGestoresByDespacho(idDespacho);
		
		listaUsuarios.removeAll(listaUsuariosExistentes);
		
		return listaUsuarios;
	}
	
	@Transactional(readOnly = false)
	public void guardarGestorDespacho(GestorDespacho gestor) {
		gestorDespachoDao.saveOrUpdate(gestor);
	}
	
	/** 
	 * PRODUCTO-1272
	 * Devuelve el listado de las provincias del despacho
	 * @param idDespacho
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.dameAmbitoDespachoExtras")
	public List<DDProvincia> dameAmbitoDespachoExtras(Long idDespacho) {
		
		return despachoExtrasDao.getProvinciasDespachoExtras(idDespacho);
	}
	
	/**
	 * PRODUCTO-1274
	 * Devuelve los codigos de provincias asociados al despacho
	 * @param idDespacho
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.dameAmbitoDespachoExtrasCodigos")
	public List<String> dameAmbitoDespachoExtrasCodigos(Long idDespacho) {
		
		List<String> listaProvinciasDespacho = new LinkedList<String>();
		for(DDProvincia provincia : despachoExtrasDao.getProvinciasDespachoExtras(idDespacho)) {
			/* PRODUCTO-1274 ; BKREC-2291
			 * Cambiar la linea cuando se requiera multiples provincias para un despacho
			 * listaProvinciasDespacho.add(provincia.getCodigo());
			 * */
			listaProvinciasDespacho.add(provincia.getId().toString());
		}
		
		return listaProvinciasDespacho;
	}
	
	
	/** 
	 * PRODUCTO-1274
	 * Guarda Despacho Extras, a través del dto de DespachoExterno
	 * @param idDespacho
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.guardarExtrasDespacho")
	@Transactional(readOnly = false)
	public DespachoExternoExtras guardarExtrasDespacho(ADMDtoDespachoExterno dto, Long idDespacho) {
		DespachoExternoExtras desExtras;
		if (dto.getId() == null) {
			desExtras = new DespachoExternoExtras();
		} else {
			desExtras = despachoExtrasDao.get(dto.getId());
			//Si todavía no hay registro en extras de este despacho, debemos inicializarlo para crearlo.
			if(Checks.esNulo(desExtras)) {
				desExtras = new DespachoExternoExtras();
			}
		}
		//Si no es de Tipo Letrado no aplica /*
/*if(dto.getTipoDespacho() != getIdTipoLetrado() && dto.getTipoDespacho() != getIdTipoProcurador()) {
			return desExtras;
		}*/
		
		desExtras.setId(idDespacho);
		desExtras = this.transformaDtoAEntityDespachOExtras(dto, desExtras);
		//Guardamos los extras del despacho
		despachoExtrasDao.saveOrUpdate(desExtras);
		
		//Ahora guardamos las provincias de los extras del despacho (Para cuando se hace alta de un nuevo despacho)
		if(dto.getId() == null && !Checks.esNulo(dto.getListaProvincias()) && !Checks.esNulo(dto.getListaProvincias()[0])) {
			this.guardarAmbitoDespachoExtras(dto.getListaProvincias(), idDespacho);
		}
		else if(dto.getId() != null && !Checks.esNulo(dto.getListaProvincias()) /*&& !Checks.esNulo(dto.getListaProvincias()[0])*/){ 
			//Actualizar el ambito (si quitan o añaden provicinas)
			this.actualizarAmbitoDespachoExtras(dto.getListaProvincias(), idDespacho);
		}
		return desExtras;
	}
	
	/**
	 * De un mapa de Strings, devuelve la KEY a partir del VALUE.
	 * @param mapa
	 * @param valor
	 * @return
	 */
	private String getKeyByValue(Map<String,String> mapa, String valor) {
		
		for(Map.Entry<String,String> map : mapa.entrySet()){
			if( valor.equals(map.getValue()))
				return map.getKey();
		}
		
		return null;
	}
	
	/**
	 * PRODUCTO-1274
	 * Devuelve un listado con listas de mapas, para despachoExtras. 
	 * ---Atención: Si en un futuro cambias el orden, afectará a los combos del jsp.
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.getMapasDespachoExtras")
	public List<List<String>> getMapasDespachoExtras() {
		List<List<String>> listaMapas = new ArrayList<List<String>>();
		
		listaMapas.add(listaMapeadaDespachoExtras(context.getMapaContratoVigor()));
		listaMapas.add(listaMapeadaDespachoExtras(context.getMapaClasificacionDespachoPerfil()));
		listaMapas.add(listaMapeadaDespachoExtras(context.getMapaCodEstAse()));
		listaMapas.add(listaMapeadaDespachoExtras(context.getMapaDescripcionIVA()));
		listaMapas.add(listaMapeadaDespachoExtras(context.getMapaRelacionEntidad()));
		
		return listaMapas;
	}
	
	/**
	 * Rellena los valores de contexto según el mapa pasado por parámetro
	 * @param mapa
	 * @return
	 */
	private List<String> listaMapeadaDespachoExtras(Map<String,String> mapa) {
		List<String> lista = new ArrayList<String>();
		
		for(Map.Entry<String,String> map : mapa.entrySet()){
			lista.add(map.getValue());
		}
		
		return lista;
	}
	
	
	
	@SuppressWarnings("unchecked")
	@BusinessOperation("ADMDespachoExternoManager.getDDProvincias")
	public List<DDProvincia> getDDProvincias() {
		return proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDProvincia.class);
	}
	
	@SuppressWarnings("unchecked")
	@BusinessOperation("ADMDespachoExternoManager.getDDTipoDocumento")
	public List<DDTipoDocumento> getDDTipoDocumento() {
		return proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDTipoDocumento.class);
	}
	
	/**
	 * Las provincias de los extras del despacho se guardan en una tabla a parte (DEA_DESPACHO_EXTRAS_AMBITO)
	 * @param provincias
	 * @param idDespacho
	 */
	private void guardarAmbitoDespachoExtras(String[] provincias, Long idDespacho) {
		
		DespachoExtrasAmbito despachoExtrasAmbito;
		
		if(provincias.length > 0 && provincias[0].length() >0) {
			for(String codProvincia : provincias) {
				if(!extrasAmbitoDao.isDespachoEnProvincia(codProvincia, idDespacho)) {				
					despachoExtrasAmbito = new DespachoExtrasAmbito();
					/*PRODUCTO-1274 ; BKREC-2291
					 * Se modifica para que coja por id, si al final se requieren mas de una provincia por despacho, cambiar el setter
					* de provincia, en vez de por id, por codigo.
					* 
					* despachoExtrasAmbito.setProvincia(genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codProvincia)));
					*/
					despachoExtrasAmbito.setProvincia(genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(codProvincia))));
					despachoExtrasAmbito.setDespacho(despachoExternoDao.get(idDespacho));
					
					extrasAmbitoDao.saveOrUpdate(despachoExtrasAmbito);
				}
			}	
		}
	}
	
	/**
	 * Actualiza Provincias dle ambito del despacho.
	 * @param provincias
	 * @param idDespacho
	 */
	private void actualizarAmbitoDespachoExtras(String[] provincias, Long idDespacho) {
		List<DespachoExtrasAmbito> listaAmbitoExtras = genericDao.getList(DespachoExtrasAmbito.class, genericDao.createFilter(FilterType.EQUALS, "despacho.id", idDespacho));
		List<String> listaCodProvincias = new ArrayList<String>();
		for(int i=0; i< provincias.length; i++) {
			listaCodProvincias.add(provincias[i]);
		}
		List<String> provinciasSobrantes = new ArrayList<String>();
		for(DespachoExtrasAmbito ambito : listaAmbitoExtras) {
			/*
			 * PRODUCTO-1274 ; BKREC-2291
			 * Cambiar la linea comentada cuando vaya a ser por multiples provincias
			 * if(!listaCodProvincias.contains(ambito.getProvincia().getCodigo())) {
			 */
			if(!listaCodProvincias.contains(ambito.getProvincia().getId())) {
				ambito.getAuditoria().setBorrado(true);
				extrasAmbitoDao.saveOrUpdate(ambito);	
			} else {
				//provinciasSobrantes.add(ambito.getProvincia().getCodigo());
				provinciasSobrantes.add(ambito.getProvincia().getId().toString());
			}
		}
		listaCodProvincias.removeAll(provinciasSobrantes);
		
		this.guardarAmbitoDespachoExtras(listaCodProvincias.toArray(new String[listaCodProvincias.size()]), idDespacho);
	}
	
	/**
	 * Ya que al crear o editar un despacho, si es de tipo LETRADO, se mostrará
	 * la pestanya datos Adicionales, con campos que solo tendrán este tipo de despachos.
	 * @return
	 */
	@BusinessOperation("ADMDespachoExternoManager.getIdTipoLetrado")
	public Long getIdTipoLetrado() {
		Long idLetrado = null;
		
		for(DDTipoDespachoExterno tipo : tipoDespachoDao.getList()) {
			if(tipo.getCodigo().equals("1")) {
				return tipo.getId();
			}
		}
		
		return idLetrado;
	}
	@BusinessOperation("ADMDespachoExternoManager.getIdTipoProcurador")
	public Long getIdTipoProcurador() {
		Long idLetrado = null;
		
		for(DDTipoDespachoExterno tipo : tipoDespachoDao.getList()) {
			if(tipo.getCodigo().equals("2")) {
				return tipo.getId();
			}
		}
		
		return idLetrado;
	}

	/**
	 * Transforma el dto en la entidad DespachoExternoExtras, el dto incluso tanto despacho como despachoExtras, pero
	 * este metodo solo coge la parte que se guardará en DES_DESPACHO_EXTRAS
	 * @param dto
	 * @param desExtras
	 * @return
	 */
	private DespachoExternoExtras transformaDtoAEntityDespachOExtras(ADMDtoDespachoExterno dto, DespachoExternoExtras desExtras) {
		
		desExtras.setFax(dto.getFax());
		if (!Checks.esNulo(dto.getFechaAlta())) {
			try {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
				Date fechaAlta = formatter.parse(dto.getFechaAlta());
				desExtras.setFechaAlta(fechaAlta);
			} catch (ParseException e) {
				logger.error("Error parseando la fecha Alta ", e);
			}
		}
		else {
			desExtras.setFechaAlta(null);
		}
		desExtras.setCorreoElectronico(dto.getCorreoElectronico());
		desExtras.setDocumentoCif(dto.getDocumentoCif());
		if(!Checks.esNulo(dto.getTipoDocumento())) {
			desExtras.setTipoDocumento(genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dto.getTipoDocumento()))));
		}
		else {
			desExtras.setTipoDocumento(null);
		}
		if(!Checks.esNulo(dto.getClasificacionPerfil())) {
			DespachoClasiPerfil clasif = genericDao.get(DespachoClasiPerfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getClasificacionPerfil()), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
			desExtras.setClasifPerfil(clasif);
		}
		else {
			desExtras.setClasifPerfil(null);
		}
		if(!Checks.esNulo(dto.getAsesoria())) {
			desExtras.setAsesoria(Boolean.parseBoolean(dto.getAsesoria()));
		}
		else {
			desExtras.setAsesoria(null);
		}
		if(!Checks.esNulo(dto.getClasificacionConcursos())) {
			desExtras.setClasifConcursos(Boolean.parseBoolean(dto.getClasificacionConcursos()));
		}
		else {
			desExtras.setClasifConcursos(null);
		}
		if(!Checks.esNulo(dto.getCodEstAse())) {
			DespachoCodEstado codEstado = genericDao.get(DespachoCodEstado.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodEstAse()), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
			desExtras.setCodEstAse(codEstado);
		}
		else {
			desExtras.setCodEstAse(null);
		}
		desExtras.setCuentaEntregas(dto.getCuentaEntregas());
		desExtras.setCuentaLiquidacion(dto.getCuentaLiquidacion());
		desExtras.setCuentaProvisiones(dto.getCuentaProvisiones());
		desExtras.setDigconEntregas(dto.getDigconEntregas());
		desExtras.setDigconLiquidacion(dto.getDigconLiquidacion());
		desExtras.setDigconProvisiones(dto.getDigconProvisiones());
		desExtras.setEntidadContacto(dto.getEntidadContacto());
		desExtras.setEntidadEntregas(dto.getEntidadEntregas());
		desExtras.setEntidadLiquidacion(dto.getEntidadLiquidacion());
		desExtras.setEntidadProvisiones(dto.getEntidadProvisiones());
		desExtras.setOficinaContacto(dto.getOficinaContacto());
		desExtras.setOficinaEntregas(dto.getOficinaEntregas());
		desExtras.setOficinaLiquidacion(dto.getOficinaLiquidacion());
		desExtras.setOficinaProvisiones(dto.getOficinaProvisiones());
		desExtras.setCentroRecuperacion(dto.getCentroRecuperacion());
		if(!Checks.esNulo(dto.getRelacionEntidad())) {
			DespachoRelEntidad relEntidad = genericDao.get(DespachoRelEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getRelacionEntidad()), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
			desExtras.setRelacionEntidad(relEntidad);	
		}
		else {
			desExtras.setRelacionEntidad(null);
		}
		if(!Checks.esNulo(dto.getServicioIntegral())) {
			desExtras.setServicioIntegral(Boolean.parseBoolean(dto.getServicioIntegral()));
		}
		else {
			desExtras.setServicioIntegral(null);
		}
		if (!Checks.esNulo(dto.getFechaServicioIntegral())) {
			try {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
				Date fechaServicioIntegral = formatter.parse(dto.getFechaServicioIntegral());
				desExtras.setFechaServicioIntegral(fechaServicioIntegral);
			} catch (ParseException e) {
				logger.error("Error parseando la fecha Alta ", e);
			}
		}
		else {
			desExtras.setFechaServicioIntegral(null);
		}
		
		if(!Checks.esNulo(dto.getContratoVigor())) {
			DespachoContratoVigor contratoVigor = genericDao.get(DespachoContratoVigor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getContratoVigor()), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
			desExtras.setContratoVigor(contratoVigor);		
		}
		else {
			desExtras.setContratoVigor(null);
		}
		if(!Checks.esNulo(dto.getImpuesto())) {
			DespachoIvaDes ivaDes = genericDao.get(DespachoIvaDes.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getImpuesto()), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
			desExtras.setDescripcionIVA(ivaDes);
		}
		
		return desExtras;
	}
}
