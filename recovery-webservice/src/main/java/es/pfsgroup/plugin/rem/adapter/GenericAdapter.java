package es.pfsgroup.plugin.rem.adapter;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.api.controlAcceso.EXTControlAccesoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramitacionOfertasApi;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.thread.EnvioCorreoAsync;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

@Service
public class GenericAdapter {

	@Autowired
	private UsuarioApi usuarioApi;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private DictionaryManager diccionarioManager;

	@Autowired
	private RemCorreoUtils remCorreoUtils;

	@Autowired
	EXTControlAccesoApi controlAccesoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
    private ActivoManager activoManager;
	
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private AgrupacionAdapter agrupacionAdapter;
	
	@Autowired
	private TramitacionOfertasApi tramitacionOfertasApi;
	
	@Resource
	private Properties appProperties;

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	private static final String DD_SUBTIPO_GASTO_IBI_RUSTICA = "01";
	private static final String DD_SUBTIPO_GASTO_IBI_URBANA = "02";
	private static final String DD_SUBTIPO_GASTO_OTRAS_TASAS_AYUNTAMIENTO = "17";
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Dictionary> getDiccionario(String diccionario) {

		List lista = new ArrayList();		
		if("gestorCommiteLiberbank".equals(diccionario)) {			
			lista.add(diccionarioApi.dameValorDiccionarioByCod(DDCartera.class, DDCartera.CODIGO_CARTERA_LIBERBANK));
		}else {
			List<UsuarioCartera> usuarioCartera = null;
			Class<?> clase = DiccionarioTargetClassMap.convertToTargetClass(diccionario);
			if (clase.equals(DDCartera.class) || clase.equals(DDSubcartera.class)) {				
				usuarioCartera = genericDao.getList(UsuarioCartera.class,	genericDao.createFilter(FilterType.EQUALS, "usuario.id", getUsuarioLogado().getId()));
				if (usuarioCartera != null) {
					for (UsuarioCartera usu : usuarioCartera) {
						if (DDCartera.class.equals(clase) && !lista.contains(usu.getCartera().getCodigo())) {
							lista.add(diccionarioApi.dameValorDiccionarioByCod(clase, usu.getCartera().getCodigo()));
						} else if (DDSubcartera.class.equals(clase)) {
							lista.add(diccionarioApi.dameValorDiccionarioByCod(clase, usu.getSubCartera().getCodigo()));
						}
					}	
				}				
			}
			
			if(usuarioCartera == null) {
				lista = diccionarioApi.dameValoresDiccionario(clase);
			}
		}
		return lista;
	}
	
	public List<Dictionary> getDiccionarioDeGastos(String diccionario) {
		
		Class<?> clase = null;

		List<Dictionary> listaImpuestos = new ArrayList<Dictionary>();
			
			clase = DiccionarioTargetClassMap.convertToTargetClass(diccionario);
			DDSubtipoGasto impuestoRustico = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DD_SUBTIPO_GASTO_IBI_RUSTICA);
			DDSubtipoGasto impuestoUrbano = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DD_SUBTIPO_GASTO_IBI_URBANA);
			DDSubtipoGasto impuestoOtrosAyuntamiento = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DD_SUBTIPO_GASTO_OTRAS_TASAS_AYUNTAMIENTO);
			DDSubtipoGasto impuestoAgua = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_AGUA);
			DDSubtipoGasto impuestoAlcantarillado = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_ALCANTARILLADO);
			DDSubtipoGasto impuestoBasura = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_BASURA);
			DDSubtipoGasto impuestoExaccionesMunicipales = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_EXACCIONES_MUNICIPALES);
			DDSubtipoGasto impuestoOtrasTasasMunicipales = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_OTRAS_TASAS_MUNICIPALES);
			DDSubtipoGasto impuestoTasaCanalones = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_TASA_CANALONES);
			DDSubtipoGasto impuestoTasaIncendios = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_TASA_INCENDIOS);
			DDSubtipoGasto impuestoRegulacionCatastral = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_REGULACION_CATASTRAL);
			DDSubtipoGasto impuestoTasasAdministrativas = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_TASAS_ADMINISTRATIVAS);
			DDSubtipoGasto impuestoTributoMetroMov = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_TRIBUTO_METROPOLITANO_MOVILIDAD);
			DDSubtipoGasto impuestoVado = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, DDSubtipoGasto.COD_VADO);
			
			listaImpuestos.add(impuestoUrbano);
			listaImpuestos.add(impuestoOtrosAyuntamiento);
			listaImpuestos.add(impuestoRustico);
			listaImpuestos.add(impuestoAgua);
			listaImpuestos.add(impuestoAlcantarillado);
			listaImpuestos.add(impuestoBasura);
			listaImpuestos.add(impuestoExaccionesMunicipales);
			listaImpuestos.add(impuestoOtrasTasasMunicipales);
			listaImpuestos.add(impuestoTasaCanalones);
			listaImpuestos.add(impuestoTasaIncendios);
			listaImpuestos.add(impuestoRegulacionCatastral);
			listaImpuestos.add(impuestoTasasAdministrativas);
			listaImpuestos.add(impuestoTributoMetroMov);
			listaImpuestos.add(impuestoVado);
				
		return listaImpuestos;
	}

	public List<Dictionary> getDiccionarioTareas(String diccionario) {

		return diccionarioManager.getList(diccionario);

	}

	public Usuario getUsuarioLogado() {

		Usuario usuario = usuarioApi.getUsuarioLogado();
		return usuario;
	}

	/**
	 * 
	 * @param mailsPara
	 * @param mailsCC
	 * @param asunto
	 * @param cuerpo
	 *            Manda un correo electrónico sin adjunto al listado de emails
	 *            indicado en mailsPara y mailsCC
	 * @param adjuntos Archivos adjuntos a manar por correo
	 */
	@Deprecated
	public void sendMailSinc(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo, List<DtoAdjuntoMail> adjuntos ,List<String> mailsBCC) {
		remCorreoUtils.enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo, adjuntos, mailsBCC);
		
	}
	
	public void sendMail(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo,
			List<DtoAdjuntoMail> adjuntos) {
		String usuarioLogado = RestApi.REST_LOGGED_USER_USERNAME;
		if(this.getUsuarioLogado() != null){
			try{
				usuarioLogado = this.getUsuarioLogado().getUsername();
			}catch(Exception e){
				logger.info("No se puede obtner usuariologado, usamos rest",e);
			}
		}
		Thread hiloCorreo = new Thread(
				new EnvioCorreoAsync(mailsPara, mailsCC, asunto, cuerpo, adjuntos, usuarioLogado));

		hiloCorreo.start();
	}
	
	/**
	 * 
	 * @param mailsPara
	 * @param mailsCC
	 * @param asunto
	 * @param cuerpo
	 *            Manda un correo electrónico sin adjunto al listado de emails
	 *            indicado en mailsPara y mailsCC
	 */
	public void sendMail(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo) {
		this.sendMail(mailsPara, mailsCC, asunto, cuerpo, null);
	}

	/**
	 * LLama a la api de control de acceso para registrar al usuario
	 * identificado
	 */
	public void registerUser() {
		controlAccesoApi.registrarAccesoDeUsuario();
	}

	public Boolean isSuper(Usuario usuario) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYASUPER");
		Perfil perfilSuper = genericDao.get(Perfil.class, filtro);

		return usuario.getPerfiles().contains(perfilSuper);
	}

	public Boolean isProveedor(Usuario usuario) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAPROV");
		Perfil perfilProveedor = genericDao.get(Perfil.class, filtro);

		return usuario.getPerfiles().contains(perfilProveedor);
	}
	
	public Boolean isExternoEspecial(Usuario usuario) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "EXTERNOESPECIAL");
		Perfil perfilExternoEspecial = genericDao.get(Perfil.class, filtro);

		for (Perfil perfil : usuario.getPerfiles()) {
			if (!Checks.esNulo(perfilExternoEspecial) 
					&& perfil.getCodigo().equals(perfilExternoEspecial.getCodigo())) {
				return true;
			}
		}
		
		return false;
	}
	
	

	
	
	

	/**
	 * Es proveedor HAYA o CEE?
	 * 
	 * @param usuario
	 * @return
	 */
	public Boolean isProveedorHayaOrCee(Usuario usuario) {
		Perfil perfilProveedorHaya = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAPROV"));

		Perfil perfilProveedorCEE = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYACERTI"));

		return usuario.getPerfiles().contains(perfilProveedorHaya)
				|| usuario.getPerfiles().contains(perfilProveedorCEE);
	}

	/**
	 * Es gestoria?
	 * 
	 * @param usuario
	 * @return
	 */
	public Boolean isGestoria(Usuario usuario) {
		Perfil GESTOADM = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTOADM"));

		Perfil GESTIAFORM = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTIAFORM"));

		Perfil HAYAGESTADMT = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAGESTADMT"));

		Perfil GESTOCED = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTOCED"));

		Perfil GESTOPLUS = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTOPLUS"));
		
		Perfil GTOPOSTV = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GTOPOSTV"));

		Perfil GESTOPDV = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTOPDV"));

		return usuario.getPerfiles().contains(GESTOADM) || usuario.getPerfiles().contains(GESTIAFORM)
				|| usuario.getPerfiles().contains(HAYAGESTADMT) || usuario.getPerfiles().contains(GESTOCED)
				|| usuario.getPerfiles().contains(GESTOPLUS) || usuario.getPerfiles().contains(GTOPOSTV) || usuario.getPerfiles().contains(GESTOPDV);
	}

	/**
	 * Comprueba si el usuario tiene el perfil pasado por parametro
	 */
	public Boolean tienePerfil(String codPerfil, Usuario u) {

		if (Checks.esNulo(u) || Checks.esNulo(codPerfil)) {
			return false;
		}
		for (Perfil p : u.getPerfiles()) {
			if (codPerfil.equals(p.getCodigo()))
				return true;
		}

		return false;
	}
	
	/**
	 * Comprueba si un usuario es gestor Haya a través de su perfil.
	 * @param usuario
	 * @return Boolean
	 */
	public Boolean isGestorHaya(Usuario usuario) {
		
		
		
		Perfil HAYAGESTCOM = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAGESTCOM"));

		Perfil FVDBACKOFERTA = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "FVDBACKOFERTA"));

		Perfil FVDBACKVENTA = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "FVDBACKVENTA"));

		Perfil HAYABACKOFFICE = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYABACKOFFICE"));

		Perfil FVDNEGOCIO = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "FVDNEGOCIO"));
		

		return usuario.getPerfiles().contains(HAYAGESTCOM) || usuario.getPerfiles().contains(FVDBACKOFERTA)
				|| usuario.getPerfiles().contains(FVDBACKVENTA) || usuario.getPerfiles().contains(HAYABACKOFFICE)
				|| usuario.getPerfiles().contains(FVDNEGOCIO);		
	}
	
	public Oferta clonateOferta(String idOferta, boolean esAgrupacion) {
		Long numIdOferta = Long.parseLong(idOferta);
		
		Oferta ofertaOrigen = ofertaApi.getOfertaById(numIdOferta);
		Oferta ofertaCreada = null;
		
		ExpedienteComercial expedienteOfertaNueva = null;

		if(!Checks.esNulo(ofertaOrigen)) {			
			try {
				// CLONANDO OFERTA NUEVA
				logger.error("Clonando oferta " + ofertaOrigen.getNumOferta() + "...");
				
				DtoOfertasFilter dtoOfertaNueva = new DtoOfertasFilter();
				
				dtoOfertaNueva.setVentaDirecta(false);
				
				dtoOfertaNueva.setIdActivo(ofertaOrigen.getActivoPrincipal().getId());
				dtoOfertaNueva.setTipoOferta(ofertaOrigen.getTipoOferta().getCodigo());
				
				ClienteComercial clienteOfertaOrigen = ofertaOrigen.getCliente();
				
				if(clienteOfertaOrigen.getTipoDocumento() != null) {
					dtoOfertaNueva.setTipoDocumento(clienteOfertaOrigen.getTipoDocumento().getCodigo());
				}

				dtoOfertaNueva.setNombreCliente(clienteOfertaOrigen.getNombre());
				dtoOfertaNueva.setApellidosCliente(clienteOfertaOrigen.getApellidos());
				dtoOfertaNueva.setNumDocumentoCliente(clienteOfertaOrigen.getDocumento());
				dtoOfertaNueva.setRazonSocialCliente(clienteOfertaOrigen.getRazonSocial());
				
				if(clienteOfertaOrigen.getTipoPersona() != null) {
					dtoOfertaNueva.setTipoPersona(clienteOfertaOrigen.getTipoPersona().getCodigo());
				}
				
				dtoOfertaNueva.setIdOfertaOrigen(numIdOferta);
				
				if(!Checks.esNulo(ofertaOrigen.getOfrDocRespPrescriptor())) {
					dtoOfertaNueva.setOfrDocRespPrescriptor(ofertaOrigen.getOfrDocRespPrescriptor());
				}
				
				if(!Checks.esNulo(clienteOfertaOrigen.getEstadoCivil())) {
					dtoOfertaNueva.setEstadoCivil(clienteOfertaOrigen.getEstadoCivil().getCodigo());
				}
				
				DDRegimenesMatrimoniales reg = clienteOfertaOrigen.getRegimenMatrimonial();
				if(!Checks.esNulo(reg)) {
					dtoOfertaNueva.setRegimenMatrimonial(reg.getCodigo());					
				}			
				
				dtoOfertaNueva.setCesionDatos(clienteOfertaOrigen.getCesionDatos());
				dtoOfertaNueva.setTransferenciasInternacionales(clienteOfertaOrigen.getTransferenciasInternacionales());
				dtoOfertaNueva.setComunicacionTerceros(clienteOfertaOrigen.getComunicacionTerceros());
				dtoOfertaNueva.setImporteOferta("" + ofertaOrigen.getImporteOferta());
				dtoOfertaNueva.setDerechoTanteo(ofertaOrigen.getDesdeTanteo());
				if(!Checks.esNulo(ofertaOrigen.getPrescriptor())) {
					dtoOfertaNueva.setCodigoPrescriptor("" + ofertaOrigen.getPrescriptor().getCodigoProveedorRem());
				}
				Integer intencionFinanciar = ofertaOrigen.getIntencionFinanciar();
				dtoOfertaNueva.setIntencionFinanciar((Checks.esNulo(intencionFinanciar)) ? null : intencionFinanciar == 1); // No entiendo por qué hay gente que usa los booleanos como Integers

				// En las ofertas no se están guardando el código de la sucursal. 
				// Lo que se está haciendo es un cálculo de oficina y luego guarda el valor oficina+sucursal,
				// por lo que tengo que hacer el calculo inverso para que a la hora de crear la nueva oferta,
				// se le pase el código de sucursal "limpio".
				if(!esAgrupacion) {
					if(!Checks.esNulo(ofertaOrigen.getSucursal())) {
						String oficinaSucursal = ofertaOrigen.getSucursal().getCodProveedorUvem();
						String sucursal;
						if (ofertaOrigen.getActivoPrincipal().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)
							|| ofertaOrigen.getActivoPrincipal().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
							sucursal = oficinaSucursal.substring(4, oficinaSucursal.length());
							dtoOfertaNueva.setCodigoSucursal(sucursal);
						}					
					}
				}
				
				Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaOrigen.getId());
				ExpedienteComercial expedienteOrigen = genericDao.get(ExpedienteComercial.class, filtroExpediente);	
				
				Comprador compradorPrincipalOfertaOrigen = null;
				if(!Checks.esNulo(expedienteOrigen)) {
					
					compradorPrincipalOfertaOrigen =expedienteOrigen.getCompradorPrincipal();
					if(!Checks.esNulo(compradorPrincipalOfertaOrigen)) {
						if(!Checks.esNulo(compradorPrincipalOfertaOrigen.getAdjunto())) {
							dtoOfertaNueva.setIdDocAdjunto(compradorPrincipalOfertaOrigen.getAdjunto().getId());
						}
					}
					else {
						logger.error("No se ha podido encontrar el comprador relacionado con la oferta que se está intentando clonar.");
						return null;
					}
				}
				else {
					logger.error("No se ha podido encontrar el expediente relacionado con la oferta que se está intentando clonar.");
					return null;
				}
				
				if(esAgrupacion) {
					dtoOfertaNueva.setIdAgrupacion(ofertaOrigen.getAgrupacion().getId());
					dtoOfertaNueva.setIdUvem(ofertaOrigen.getIdUvem());
				}
				
				dtoOfertaNueva.setClaseOferta(ofertaOrigen.getClaseOferta() != null ? ofertaOrigen.getClaseOferta().getCodigo() : null);
				
				if(!esAgrupacion) {
					ofertaCreada = activoAdapter.createOfertaActivo(dtoOfertaNueva);
				}
				else {
					ofertaCreada = agrupacionAdapter.createOfertaAgrupacion(dtoOfertaNueva);
				}
				
				logger.error("Oferta " + ofertaOrigen.getNumOferta() + " clonada correctamente.");
				
				ClienteComercial clienteOrigen = ofertaOrigen.getCliente();
				ClienteComercial clienteNuevo = ofertaCreada.getCliente();
				Long idCliente =clienteNuevo.getId();
				Long idClienteWebcom= clienteNuevo.getIdClienteWebcom();
				BeanUtils.copyProperties(clienteNuevo, clienteOrigen);
				
				clienteNuevo.setId(idCliente);
				clienteNuevo.setIdClienteWebcom(idClienteWebcom);
				
				genericDao.update(ClienteComercial.class, clienteNuevo);
				
				// TRAMITANDO OFERTA NUEVA
				
				logger.error("Tramitando la oferta clonada...");
				
				DtoOfertaActivo dtoTramitar = new DtoOfertaActivo();
				
				dtoTramitar.setIdOferta(ofertaCreada.getId());
				dtoTramitar.setCodigoEstadoOferta(DDEstadoOferta.CODIGO_ACEPTADA);
				
				if(!esAgrupacion) {				
					dtoTramitar.setIdActivo(ofertaOrigen.getActivoPrincipal().getId());
				}else {
					dtoTramitar.setIdAgrupacion(ofertaOrigen.getAgrupacion().getId());
				}
				
				tramitacionOfertasApi.saveOferta(dtoTramitar, esAgrupacion,false);				
				
				logger.error("Oferta clonada tramitada correctamente.");
				
				// COPIANDO DATOS DE COMPRADORES
				 
				logger.error("Copiando valores de compradores...");
				
				Filter filtroExpedienteOfertaNueva = genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaCreada.getId());
				expedienteOfertaNueva = genericDao.get(ExpedienteComercial.class, filtroExpedienteOfertaNueva);	
				
				List<CompradorExpediente> compradoresOfertaOrigen = expedienteOrigen.getCompradores();
				List<CompradorExpediente> compradoresOfertaNueva = expedienteOfertaNueva.getCompradores();
				

				CompradorExpediente compradorNuevo = genericDao.getList(CompradorExpediente.class, 
						genericDao.createFilter(FilterType.EQUALS,"expediente",expedienteOfertaNueva.getId()),
						genericDao.createFilter(FilterType.EQUALS, "comprador",expedienteOfertaNueva.getCompradorPrincipal().getId())).get(0);
				
				
				for (CompradorExpediente cexOfertaOrigen : compradoresOfertaOrigen) {
					if(!cexOfertaOrigen.getComprador().equals(compradorPrincipalOfertaOrigen.getId())) {
						CompradorExpediente cexOfertaNueva = new CompradorExpediente();
						BeanUtils.copyProperties(cexOfertaNueva, cexOfertaOrigen);
											
						cexOfertaNueva.setExpediente(expedienteOfertaNueva.getId());
						
						CompradorExpedientePk pk = new CompradorExpedientePk();
						pk.setComprador(cexOfertaOrigen.getPrimaryKey().getComprador());
						pk.setExpediente(expedienteOfertaNueva);					
						cexOfertaNueva.setPrimaryKey(pk);
						
						compradoresOfertaNueva.add(cexOfertaNueva);		
					}else{			

						compradorNuevo.setAntiguoDeudor(cexOfertaOrigen.getAntiguoDeudor());
						compradorNuevo.setApellidosRepresentante(cexOfertaOrigen.getApellidosRepresentante());						
						compradorNuevo.setClienteUrsusConyuge(cexOfertaOrigen.getClienteUrsusConyuge());
						compradorNuevo.setCodigoPostalRepresentante(cexOfertaOrigen.getCodigoPostalRepresentante());
						compradorNuevo.setDireccionRepresentante(cexOfertaOrigen.getDireccionRepresentante());
						compradorNuevo.setDocumentoAdjunto(cexOfertaOrigen.getDocumentoAdjunto());
						compradorNuevo.setDocumentoConyuge(cexOfertaOrigen.getDocumentoConyuge());
						compradorNuevo.setDocumentoRepresentante(cexOfertaOrigen.getDocumentoRepresentante());
						compradorNuevo.setEmailRepresentante(cexOfertaOrigen.getEmailRepresentante());
						compradorNuevo.setEstadoCivil(cexOfertaOrigen.getEstadoCivil());
						compradorNuevo.setEstadosPbc(cexOfertaOrigen.getEstadosPbc());
						compradorNuevo.setFechaBaja(cexOfertaOrigen.getFechaBaja());
						compradorNuevo.setFechaFactura(cexOfertaOrigen.getFechaFactura());
						compradorNuevo.setFechaPeticion(cexOfertaOrigen.getFechaPeticion());
						compradorNuevo.setFechaResolucion(cexOfertaOrigen.getFechaResolucion());
						compradorNuevo.setGradoPropiedad(cexOfertaOrigen.getGradoPropiedad());
						compradorNuevo.setIdPersonaHaya(cexOfertaOrigen.getIdPersonaHaya());
						compradorNuevo.setImporteFinanciado(cexOfertaOrigen.getImporteFinanciado());
						compradorNuevo.setImporteProporcionalOferta(cexOfertaOrigen.getImporteProporcionalOferta());
						compradorNuevo.setLocalidadRepresentante(cexOfertaOrigen.getLocalidadRepresentante());
						compradorNuevo.setNombreRepresentante(cexOfertaOrigen.getNombreRepresentante());
						compradorNuevo.setNumFactura(cexOfertaOrigen.getNumFactura());
						compradorNuevo.setNumUrsusConyuge(cexOfertaOrigen.getNumUrsusConyuge());
						compradorNuevo.setNumUrsusConyugeBh(cexOfertaOrigen.getNumUrsusConyugeBh());
						compradorNuevo.setPais(cexOfertaOrigen.getPais());
						compradorNuevo.setPorcionCompra(cexOfertaOrigen.getPorcionCompra());
						compradorNuevo.setProvinciaRepresentante(cexOfertaOrigen.getProvinciaRepresentante());
						compradorNuevo.setRegimenMatrimonial(cexOfertaOrigen.getRegimenMatrimonial());
						compradorNuevo.setRelacionAntDeudor(cexOfertaOrigen.getRelacionAntDeudor());
						compradorNuevo.setRelacionHre(cexOfertaOrigen.getRelacionHre());
						compradorNuevo.setResponsableTramitacion(cexOfertaOrigen.getResponsableTramitacion());
						compradorNuevo.setTelefono1Representante(cexOfertaOrigen.getTelefono1Representante());
						compradorNuevo.setTelefono2Representante(cexOfertaOrigen.getTelefono2Representante());
						compradorNuevo.setTipoDocumentoConyuge(cexOfertaOrigen.getTipoDocumentoConyuge());
						compradorNuevo.setTipoInquilino(cexOfertaOrigen.getTipoInquilino());
						compradorNuevo.setTitularContratacion(cexOfertaOrigen.getTitularContratacion());
						compradorNuevo.setTitularReserva(cexOfertaOrigen.getTitularReserva());
						compradorNuevo.setUsoActivo(cexOfertaOrigen.getUsoActivo());
						
						genericDao.update(CompradorExpediente.class, compradorNuevo);
					}
				}
				
				expedienteOfertaNueva.setCompradores(compradoresOfertaNueva);
								
				genericDao.update(ExpedienteComercial.class, expedienteOfertaNueva);
								
				logger.error("Compradores copiados correctamente.");
							
				logger.error("Oferta clonada sin problemas.");
				
				try {
					ofertaApi.congelarOfertasPendientes(expedienteOfertaNueva);
					logger.error("Las ofertas pendientes han sido congeladas.");
				} catch (Exception e) {
					logger.error("Error descongelando ofertas.", e);
				}
				
			}catch(Exception ex) {
				logger.error("Error al intentar clonar la oferta. Es posible que se haya cambiado la forma de crear ofertas y la funcion de clonarlas este obsoleta.", ex);
				if(!Checks.esNulo(ofertaCreada)) {
					if(!Checks.esNulo(expedienteOfertaNueva)) {
						genericDao.deleteById(ExpedienteComercial.class, expedienteOfertaNueva.getId());
					}
					activoManager.deleteActOfr(ofertaCreada.getActivoPrincipal().getId(), ofertaCreada.getId());
					genericDao.deleteById(Oferta.class, ofertaCreada.getId());
				}
			}			
		}
		else {
			logger.error("No se ha podido encontrar la oferta que se está intentando clonar.");
			return null;
		}	
		
		return ofertaCreada;		
	}
	
	 public <T extends Dictionary> T dameValorDiccionarioByMatricula(Class<T> clase, String valor) {
	  if (Checks.esNulo(valor)) {
	   return null;
	  }
	  Filter f1 = genericDao.createFilter(FilterType.EQUALS, "matricula", valor);
	  Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
	  return genericDao.get(clase, f1, f2);
	 }
	 
	 public void sendMailCopiaOculta(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo,List<String> mailsBCC) {
			this.sendMailCopiaOculta(mailsPara, mailsCC, asunto, cuerpo, null,mailsBCC);
		}
	 
	 public void sendMailCopiaOculta(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo,
				List<DtoAdjuntoMail> adjuntos, List<String> mailsBCC) {
			String usuarioLogado = RestApi.REST_LOGGED_USER_USERNAME;
			if(this.getUsuarioLogado() != null){
				try{
					usuarioLogado = this.getUsuarioLogado().getUsername();
				}catch(Exception e){
					logger.info("No se puede obtner usuariologado, usamos rest",e);
				}
			}
			Thread hiloCorreo = new Thread(
					new EnvioCorreoAsync(mailsPara, mailsCC, asunto, cuerpo, adjuntos, usuarioLogado,mailsBCC));

			hiloCorreo.start();
		}

}
