package es.pfsgroup.plugin.recovery.config.despachoExterno;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

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
import es.capgemini.pfs.despachoExterno.model.DespachoAmbitoActuacion;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.multigestor.dao.EXTTipoGestorPropiedadDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;
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
import es.pfsgroup.recovery.ext.api.multigestor.EXTDDTipoGestorApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
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
						despachoAmbitoActuacion.setPorcentaje(dto.getPorcentajeProvincia());
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
}
