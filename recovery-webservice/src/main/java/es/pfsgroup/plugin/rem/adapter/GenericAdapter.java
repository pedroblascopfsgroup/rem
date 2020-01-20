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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramitacionOfertasApi;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
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
	private ActivoApi activoApi;
	
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
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Dictionary> getDiccionario(String diccionario) {
		
		Class<?> clase = null;
		List lista = null;
		
		//TODO: Código bueno:
//		try {
//			if(!Checks.esNulo(clase.getMethod("getAuditoria"))){
//				lista = diccionarioApi.dameValoresDiccionario(clase);
//			}
//		} catch (SecurityException e) {
//			lista = diccionarioApi.dameValoresDiccionarioSinBorrado(clase);
//		} catch (NoSuchMethodException e) {
//			lista = diccionarioApi.dameValoresDiccionarioSinBorrado(clase);
//		}
		
		//TODO: Para ver que diccionarios no tienen auditoria.
		if("gestorCommiteLiberbank".equals(diccionario)) {
			lista = new ArrayList();
			lista.add(diccionarioApi.dameValorDiccionarioByCod(DiccionarioTargetClassMap.convertToTargetClass("entidadesPropietarias")
					, DDCartera.CODIGO_CARTERA_LIBERBANK));
		}else {
			clase = DiccionarioTargetClassMap.convertToTargetClass(diccionario);
			lista = diccionarioApi.dameValoresDiccionario(clase);

			List listaPeriodicidad = new ArrayList();
			//sí el diccionario es 'tiposPeriodicidad' modificamos el orden
			if(clase.equals(DDTipoPeriocidad.class)){
				if(!Checks.esNulo(lista)){
					for(int i=1; i<=lista.size();i++){
						String cod;
						if(i<10)
							cod = "0"+i;
						else
							cod = ""+i;
						listaPeriodicidad.add(diccionarioApi.dameValorDiccionarioByCod(clase, cod));
					}
				}
			} else if (clase.equals(DDCartera.class)) {
				Usuario usuarioLogado = getUsuarioLogado();
				UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
						genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
				if (!Checks.esNulo(usuarioCartera)) { 	
					listaPeriodicidad.add(diccionarioApi.dameValorDiccionarioByCod(clase, usuarioCartera.getCartera().getCodigo()));
					lista = listaPeriodicidad;	
				}
			}else if (clase.equals(DDSubcartera.class)) {
				Usuario usuarioLogado = getUsuarioLogado();
				UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
						genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
				if (!Checks.esNulo(usuarioCartera) && !Checks.esNulo(usuarioCartera.getSubCartera()) && !Checks.esNulo(usuarioCartera.getSubCartera().getCodigo())) {
					listaPeriodicidad.add(diccionarioApi.dameValorDiccionarioByCod(DDSubcartera.class, usuarioCartera.getSubCartera().getCodigo()));
					lista = listaPeriodicidad;
				}
			}
		}
		return lista;
	}
	
	

	public List<Dictionary> getDiccionarioDeGastos(String diccionario) {
		
		Class<?> clase = null;
		String ibiRustica ="01";
		String ibiUrbana ="02";
		String otrasTasas ="17";
		List<Dictionary> listaImpuestos = new ArrayList<Dictionary>();
			
			clase = DiccionarioTargetClassMap.convertToTargetClass(diccionario);
			DDSubtipoGasto impuestoRustico = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, ibiRustica);
			DDSubtipoGasto impuestoUrbano = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, ibiUrbana);
			DDSubtipoGasto impuestoOtrosAyuntamiento = (DDSubtipoGasto) diccionarioApi.dameValorDiccionarioByCod(clase, otrasTasas);
			listaImpuestos.add(impuestoUrbano);
			listaImpuestos.add(impuestoOtrosAyuntamiento);
			listaImpuestos.add(impuestoRustico);
				
				
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
	public void sendMailSinc(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo, List<DtoAdjuntoMail> adjuntos) {
		remCorreoUtils.enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo, adjuntos);
		
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
			if (perfil.getCodigo().equals(perfilExternoEspecial.getCodigo())) {
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
				dtoOfertaNueva.setTipoDocumento(clienteOfertaOrigen.getTipoDocumento().getCodigo());
				dtoOfertaNueva.setNombreCliente(clienteOfertaOrigen.getNombre());
				dtoOfertaNueva.setApellidosCliente(clienteOfertaOrigen.getApellidos());
				dtoOfertaNueva.setNumDocumentoCliente(clienteOfertaOrigen.getDocumento());
				dtoOfertaNueva.setRazonSocialCliente(clienteOfertaOrigen.getRazonSocial());
				dtoOfertaNueva.setTipoPersona(clienteOfertaOrigen.getTipoPersona().getCodigo());
				
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
				
				Filter filtroIdExpediente = null;
				Long idExpediente = null;
				Comprador compradorPrincipalOfertaOrigen = null;
				if(!Checks.esNulo(expedienteOrigen)) {
					
					Filter compradorDocumento = genericDao.createFilter(FilterType.EQUALS, "documento", ofertaOrigen.getCliente().getDocumento());
					compradorPrincipalOfertaOrigen = genericDao.get(Comprador.class, compradorDocumento);
					idExpediente = expedienteOrigen.getId();
					filtroIdExpediente = genericDao.createFilter(FilterType.EQUALS, "expediente", idExpediente);
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
				if(!esAgrupacion) {
					ofertaCreada = activoAdapter.createOfertaActivo(dtoOfertaNueva);
				}
				else {
					ofertaCreada = agrupacionAdapter.createOfertaAgrupacion(dtoOfertaNueva);
				}
				
				logger.error("Oferta " + ofertaOrigen.getNumOferta() + " clonada correctamente.");
				
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
				
				tramitacionOfertasApi.saveOferta(dtoTramitar, esAgrupacion);				
				
				logger.error("Oferta clonada tramitada correctamente.");
				
				// COPIANDO DATOS DE COMPRADORES
				 
				logger.error("Copiando valores de compradores...");
				
				Filter filtroExpedienteOfertaNueva = genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaCreada.getId());
				expedienteOfertaNueva = genericDao.get(ExpedienteComercial.class, filtroExpedienteOfertaNueva);	
				
				List<CompradorExpediente> compradoresOfertaOrigen = expedienteOrigen.getCompradores();
				List<CompradorExpediente> compradoresOfertaNueva = expedienteOfertaNueva.getCompradores();
				
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

}
