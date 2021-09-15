package es.pfsgroup.plugin.rem.api.impl;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.net.URL;
import java.security.Key;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Scanner;
import java.util.Set;
import java.util.UUID;

import javax.annotation.Resource;
import javax.crypto.spec.SecretKeySpec;
import javax.imageio.ImageIO;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.LazyInitializationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.impl.ActivoPatrimonioDaoImpl;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GastoLineaDetalleApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.PerfilApi;
import es.pfsgroup.plugin.rem.controller.GenericController;
import es.pfsgroup.plugin.rem.gestor.GestorActivoManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorReducido;
import es.pfsgroup.plugin.rem.model.AuthenticationData;
import es.pfsgroup.plugin.rem.model.AuxiliarCierreOficinasBankiaMul;
import es.pfsgroup.plugin.rem.model.CarteraCondicionesPrecios;
import es.pfsgroup.plugin.rem.model.ConfiguracionSubpartidasPresupuestarias;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.DtoLocalidadSimple;
import es.pfsgroup.plugin.rem.model.DtoMenuItem;
import es.pfsgroup.plugin.rem.model.DtoPropietario;
import es.pfsgroup.plugin.rem.model.DtoUsuarios;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.GestionCCPP;
import es.pfsgroup.plugin.rem.model.GestorSustituto;
import es.pfsgroup.plugin.rem.model.GrupoUsuario;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.LocalizacionSubestadoGestion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TipoDocumentoSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDCondicionIndicadorPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoLocalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoAgendaSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoTributos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRolMediador;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.propietario.dao.ActivoPropietarioDao;
import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import es.pfsgroup.plugin.rem.rest.dto.DDTipoDocumentoActivoDto;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.CierreOficinaBankiaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.thread.EjecutarEnviarHonorariosUvemAsincrono;

import es.pfsgroup.plugin.rem.trabajo.dao.DDSubtipoTrabajoDao;
import es.pfsgroup.plugin.rem.utils.ImagenWebDto;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.sojo.interchange.json.JsonParser;

@Service("genericManager")
public class GenericManager extends BusinessOperationOverrider<GenericApi> implements GenericApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

	protected static final Log logger = LogFactory.getLog(GenericManager.class);

	private static final String MENU_TAREAS = "MENU_ADMINISTRACION";
	private static final String MENU_ACTIVOS= "MENU_ACTIVOS";
	private static final String MENU_AGRUPACIONES= "MENU_AGRUPACIONES";
	private static final String MENU_TRABAJOS= "MENU_TRABAJOS";
	private static final String MENU_PRECIOS= "MENU_PRECIOS";
	private static final String MENU_PUBLICACION= "MENU_PUBLICACION";
	private static final String MENU_COMERCIAL= "MENU_COMERCIAL";
	private static final String MENU_ADMINISTRACION = "MENU_ADMINISTRACION";
	private static final String MENU_MASIVO= "MENU_MASIVO";
	private static final String MENU_CONFIGURACION= "MENU_CONFIGURACION";
	

	private static final List<String> TABS_BBVA = Arrays.asList(MENU_ACTIVOS, MENU_COMERCIAL);
	private static final List<String> TABS_USUARIOS_BC = Arrays.asList(MENU_ACTIVOS, MENU_COMERCIAL);
	
	private static final String DICCIONARIO_TIPO_DOCUMENTO_ENTIDAD_ACTIVO = "activo";
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter adapter;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private ActivoPatrimonioDaoImpl activoPatrimonio;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Resource
	private Properties appProperties;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private DDSubtipoTrabajoDao ddSubtipoTrabajoDao;

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private GestorActivoManager gestorEntidad;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private GastoLineaDetalleApi gastoLineaDetalleApi;

	@Autowired 
	private ActivoPropietarioDao activoPropietarioDao;
	
	@Autowired 
	private PerfilApi perfilApi;
		
	@Autowired
	private RestApi restApi;



	@Override
	public String managerName() {
		return "genericManager";
	}

	@Override
	@BusinessOperationDefinition("genericManager.getAuthenticationData")
	public AuthenticationData getAuthenticationData() {
		AuthenticationData authData = new AuthenticationData();
		try{
			Usuario usuario = adapter.getUsuarioLogado();
			Filter filtroUca = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());
			List<UsuarioCartera> uca = genericDao.getList(UsuarioCartera.class, filtroUca);

			Filter filtroGru = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());
			List<GrupoUsuario> gruUsu = genericDao.getList(GrupoUsuario.class, filtroGru);


			List<String> authorities = new ArrayList<String>();
			List<String> roles = new ArrayList<String>();
			List<String> groupRoles = new ArrayList<String>();

			/**
			 * Al lanzar este método en un hilo diferente
			 * al principal da un error lazy. Recargamos en la sesión el usuario logado
			 */
			try{
				usuario.getPerfiles();
			}catch(LazyInitializationException e){
				usuario = usuarioApi.get(usuario.getId());
			}


			for (Perfil perfil : usuario.getPerfiles()) {
				for (Funcion funcion : perfil.getFunciones()) {
					authorities.add(funcion.getDescripcion());
				}
				roles.add(perfil.getCodigo());
			}

			for(GrupoUsuario usuarioGrupo : gruUsu) {
				for (Perfil perfil : usuarioGrupo.getGrupo().getPerfiles()) {
					if ( !groupRoles.contains(perfil.getCodigo())) {
						groupRoles.add(perfil.getCodigo());
					}
					for (Funcion funcion : perfil.getFunciones()) {
						if(!authorities.contains(funcion.getDescripcion())) {
							authorities.add(funcion.getDescripcion());
						}
					}
				}
			}

			authData.setUserName(usuario.getApellidoNombre());
			authData.setAuthorities(authorities);
			
			authData.setUserId(usuario.getId());
			authData.setRoles(roles);
			authData.setGroupRoles(groupRoles);
			authData.setCodigoGestor(gestorEntidad.getCodigoGestorPorUsuario(usuario.getId()));

			authData.setEsGestorSustituto(esGestorSustituto(usuario));

			if (uca != null && !uca.isEmpty()) {
				authData.setCodigoCartera(uca.get(0).getCartera().getCodigo());
			}

			String jwtToken = createJwtForTheSession(usuario.getUsername(), roles);
			// El token se traslada a la interfaz, a través del auhtData, y se establece en la sesión de usuario para su uso en el servidor
			authData.setJwt(jwtToken);
			RequestContextHolder.getRequestAttributes().setAttribute("token_jwt", jwtToken, RequestAttributes.SCOPE_SESSION);

		}catch(LazyInitializationException e){
			logger.info(e.getMessage());
		}

		return authData;
	}

	/**
	 * Este método devuelve un Token basado en JWT con los datos de usuario. Utilizado para obtener una sesión reutilizable en REM3.
	 *
	 * @param username nombre de usuario de la sesión iniciada.
	 * @param roles listado de roles asignados al usuario.
	 * @return Devuelve un token compactado "url safe" en String.
	 */
	private String createJwtForTheSession(String username,List<String> roles) {
		// Time for the token to be valid
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
		calendar.add(Calendar.HOUR_OF_DAY, Integer.parseInt(appProperties.getProperty("jwt.valid.signed.time", "12")));
		Date validJwtSignedTime = calendar.getTime();

		//The JWT signature algorithm we will be using to sign the token
		SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;

		long nowMillis = System.currentTimeMillis();
		Date now = new Date(nowMillis);

		//We will sign our JWT with our ApiKey secret
		byte[] apiKeySecretBytes = DatatypeConverter
				.parseBase64Binary(appProperties.getProperty("jwt.secret.key", "1234567890"));
		Key signingKey = new SecretKeySpec(apiKeySecretBytes, signatureAlgorithm.getJcaName());

		//Let's set the JWT Claims
		JwtBuilder builder = Jwts.builder().setId(UUID.randomUUID().toString())
				.setIssuedAt(now)
				.setSubject(username)
				.setIssuer("REM Legacy")
				.setIssuedAt(new Date())
				.setExpiration(validJwtSignedTime)
				.claim("roles", roles)
				.signWith(signatureAlgorithm, signingKey);

		//Builds the JWT and serializes it to a compact, URL-safe string
		return builder.compact();
	}

	public Integer esGestorSustituto(Usuario usuarioLogado) {
		List<GestorSustituto> ges = genericDao.getList(GestorSustituto.class,
				genericDao.createFilter(FilterType.EQUALS, "usuarioGestorSustituto", usuarioLogado));
		Date fechaHoy = new Date();

		if (Checks.estaVacio(ges)) {
			return 0;
		} else {
			for (GestorSustituto gestor : ges) {
				if (fechaHoy.compareTo(gestor.getFechaInicio()) >= 0
						&& (Checks.esNulo(gestor.getFechaFin()) || fechaHoy.compareTo(gestor.getFechaFin()) <= 0)) {
					return 1;
				}
			}
			return 0;
		}
	}

	@Override
	@BusinessOperationDefinition("genericManager.getMenuItems")
	public List<DtoMenuItem> getMenuItems(String tipo) {
		AuthenticationData authData = getAuthenticationData();
		JsonParser jsonParser = new JsonParser();
		List<DtoMenuItem> menuItemsPerm = new ArrayList<DtoMenuItem>();
		// Buscamos el fichero json que incluye todas las opciones del menú
		File menuItemsJsonFile = new File(getClass().getResource("/").getPath() + "menuitems_" + tipo + "_"
				+ MessageUtils.DEFAULT_LOCALE.getLanguage() + ".json");

		Scanner scan = null;
		Object obj = null;
		Usuario usuarioLogado = adapter.getUsuarioLogado();
		
		boolean esUsuCarteraBBVA = perfilApi.usuarioHasPerfil(PerfilApi.COD_PERFIL_CARTERA_BBVA, usuarioLogado.getUsername());
		boolean esUsuBC = perfilApi.usuarioHasPerfil(PerfilApi.COD_PERFIL_USUARIOS_BC, usuarioLogado.getUsername());

			
		// Leemos el fichero completo
		try {
			scan = new Scanner(menuItemsJsonFile);
			scan.useDelimiter("#");
			
			// Lo convertimos en un object y posteriormente en un jsonobject para
			// iterar sobre los elementos de menu y comprobar
			// si el usuario tiene permisos para esa opción.
			obj = jsonParser.parse(scan.next());
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage(),e);
		}finally {
			scan.close();
		}

		JSONObject jsonObject = JSONObject.fromObject(obj);
		JSONArray menuItems = (JSONArray) jsonObject.get("data");

		for (Object item : menuItems) {
			boolean anyadirTab = false;
			String secFunPermToRender = null;
			String nombreEntidad = null;
			JSONObject itemObject = JSONObject.fromObject(item);
			
			if (itemObject.containsKey("text")) {
				nombreEntidad = itemObject.getString("text");
			}
			if (itemObject.containsKey("secFunPermToRender")) {
				secFunPermToRender = itemObject.getString("secFunPermToRender");
			}
			
			if(secFunPermToRender == null || authData.getAuthorities().contains(secFunPermToRender)){
				if(esUsuCarteraBBVA) {
					if(TABS_BBVA.contains(secFunPermToRender)) {
						anyadirTab = true;
					}
				}else if(esUsuBC) {
					if(TABS_BBVA.contains(secFunPermToRender)) {
						anyadirTab = true;				
					}
				}else {
					anyadirTab = true;
				}
			}
			
			if(anyadirTab) {
				DtoMenuItem menuItem = new DtoMenuItem();
				try {
					beanUtilNotNull.copyProperties(menuItem, itemObject);

				} catch (Exception e) {
					logger.error(e.getCause());
				}
				menuItemsPerm.add(menuItem);
			} 
				
		}

		return menuItemsPerm;

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboMunicipio")
	public List<Localidad> getComboMunicipio(String codigoProvincia) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "provincia.codigo", codigoProvincia);

		return  genericDao.getListOrdered(Localidad.class, order, filter);
	}

	@Override
	public List<DtoLocalidadSimple> getComboMunicipioSinFiltro() {
		List<DtoLocalidadSimple> listaDtoLocalidadSimple = new ArrayList<DtoLocalidadSimple>();

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		List<Localidad> listaLocalidades = genericDao.getListOrdered(Localidad.class, order);

		for (Localidad source : listaLocalidades) {
			try {
				DtoLocalidadSimple target = new DtoLocalidadSimple();
				BeanUtils.copyProperties(target, source);
				target.setCodigoProvincia(source.getProvincia().getCodigo());

				listaDtoLocalidadSimple.add(target);
			} catch (IllegalAccessException e) {
				logger.error("Error al consultar las localidades sin filtro", e);
			} catch (InvocationTargetException e) {
				logger.error("Error al consultar las localidades sin filtro", e);
			}
		}

		return listaDtoLocalidadSimple;
	}

	@Override
	public List<DDUnidadPoblacional> getUnidadPoblacionalByProvincia(String codigoProvincia) {
		List<Localidad> localidades = this.getComboMunicipio(codigoProvincia);

		List<DDUnidadPoblacional> unidadesPoblacionales = new ArrayList<DDUnidadPoblacional>();

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		for (Localidad l : localidades) {
			Filter filterUnidadPoblacional = genericDao.createFilter(FilterType.EQUALS, "localidad.id", l.getId());
			List<DDUnidadPoblacional> lista = genericDao.getListOrdered(DDUnidadPoblacional.class, order,
					filterUnidadPoblacional);

			if (!Checks.estaVacio(lista)) {
				unidadesPoblacionales.addAll(lista);
			}
		}

		return unidadesPoblacionales;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getDiccionarioTipoProveedor") // DDTipoProveedor
	public List<DDTipoProveedor> getDiccionarioSubtipoProveedor(String codigoTipoProveedor) {
		List<DDTipoProveedor> listaTipoProveedor = new ArrayList<DDTipoProveedor>();

		if (!Checks.esNulo(codigoTipoProveedor)) {
			Filter filterTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoProveedor);
			DDEntidadProveedor tipo =  genericDao.get(DDEntidadProveedor.class, filterTipo);

			if (!Checks.esNulo(tipo)) {
				Order order = new Order(GenericABMDao.OrderType.ASC, "id");
				Filter filterSubtipo = genericDao.createFilter(FilterType.EQUALS, "tipoEntidadProveedor.codigo",
						tipo.getCodigo());
				listaTipoProveedor =  genericDao.getListOrdered(DDTipoProveedor.class, order,
						filterSubtipo);
			}
		}

		return listaTipoProveedor;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoActivo")
	public List<DDSubtipoActivo> getComboSubtipoActivo(String codigoTipo, String idActivo) {
		Activo act = null;
		if (idActivo != null) {
			act = activoApi.get(Long.parseLong(idActivo));
		}
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoActivo.codigo", codigoTipo);
		Filter filtroNoEsEnBbva = genericDao.createFilter(FilterType.EQUALS, "enBbva",false);
		
		if (act != null && DDCartera.CODIGO_CARTERA_BBVA.equals(act.getCartera().getCodigo())) {
			return genericDao.getListOrdered(DDSubtipoActivo.class, order, filter);
		}else {
			if (act != null) {
				return genericDao.getListOrdered(DDSubtipoActivo.class, order, filter, filtroNoEsEnBbva);
			}else {
				return genericDao.getListOrdered(DDSubtipoActivo.class, order, filter);
			}		
		}

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoCarga")
	public List<DDSubtipoCarga> getComboSubtipoCarga(String codigoTipo) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoCargaActivo.codigo", codigoTipo);
		return  genericDao.getListOrdered(DDSubtipoCarga.class, order, filter);

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboEspecial")
	public List<DtoDiccionario> getComboEspecial(String diccionario) {
		List<DtoDiccionario> listaDD = new ArrayList<DtoDiccionario>();
		if (diccionario.equals("DDSeguros") || diccionario.equals("DDSegurosVigentes")) {
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroAseguradora = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo",
					DDTipoProveedor.COD_ASEGURADORA);
			List<ActivoProveedor> listaSeguros = null;
			Order order = new Order(OrderType.ASC, "nombre");
			if (diccionario.equals("DDSegurosVigentes")) {
				Filter filtroVigente = genericDao.createFilter(FilterType.EQUALS, "estadoProveedor.codigo",
						DDEstadoProveedor.ESTADO_BIGENTE);
				listaSeguros = genericDao.getListOrdered(ActivoProveedor.class, order, filtroBorrado, filtroAseguradora,
						filtroVigente);
			} else {
				listaSeguros = genericDao.getListOrdered(ActivoProveedor.class, order, filtroBorrado,
						filtroAseguradora);
			}

			for (ActivoProveedor seguro : listaSeguros) {
				DtoDiccionario seguroDD = new DtoDiccionario();
				try {
					beanUtilNotNull.copyProperty(seguroDD, "id", seguro.getId());
					beanUtilNotNull.copyProperty(seguroDD, "descripcion", seguro.getNombre());
				} catch (IllegalAccessException e) {
					logger.error(e.getMessage(),e);
				} catch (InvocationTargetException e) {
					logger.error(e.getMessage(),e);
				}
				listaDD.add(seguroDD);
			}
		} else if (diccionario.equals("DDPropietario")) {
			listaDD = this.getListDtoPropietarioDiccionario();
		}

		return listaDD;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoGestor")
	public List<EXTDDTipoGestor> getComboTipoGestor() {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		return genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoGestorActivo")
	public List<EXTDDTipoGestor> getComboTipoGestorByActivo(WebDto webDto, ModelMap model, String idActivo) {
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<EXTDDTipoGestor> listaTiposGestor = genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		try {

			EXTDDTipoGestor tipoGestorEdificaciones = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GEDI"); // Gestor
																				// de
																				// Edificaciones
			EXTDDTipoGestor tipoGestorSuelo = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GSUE"); // Gestor
																				// de
																				// Suelos
			EXTDDTipoGestor tipoGestorAlquileres = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GALQ"); // Gestor
																				// de
																				// Alquileres
			EXTDDTipoGestor tipoSupervisorEdificaciones = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUPEDI"); // Gestor
																					// de
																					// Edificaciones
			EXTDDTipoGestor tipoSupervisorSuelo = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUPSUE"); // Gestor
																					// de
																					// Suelos
			EXTDDTipoGestor tipoSupervisorAlquileres = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUALQ"); // Gestor
																				// de
																				// Alquileres
			// HREOS-5012 - Tipo gestores Solo de Alquiler o Solo de Compra
			EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GCOM"); // Gestor
																				// comercial
			EXTDDTipoGestor tipoSupervisorComercial = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SCOM"); // Supervisor
																				// comercial
			EXTDDTipoGestor tipoGestorComercialAlquileres = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GESTCOMALQ"); // Gestor
																						// comercial
																						// alquiler
			EXTDDTipoGestor tipoSupervisorComercialAlquileres = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUPCOMALQ"); // Supervisor
																					// comercial
																					// alquiler
			Activo activo = activoApi.get(Long.parseLong(idActivo));
			String tipoComercializacion = activo.getActivoPublicacion().getTipoComercializacion().getCodigo();
			String codigoTipoActivo = activo.getTipoActivo().getCodigo();
			ActivoPatrimonio actPatrimonio = activoPatrimonio.getActivoPatrimonioByActivo(activo.getId());

			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo())
					&& (!Checks.esNulo(actPatrimonio) && !Checks.esNulo(actPatrimonio.getCheckHPM()))) {
				// Si el Activo NO es de tipo Suelo eliminamos el gestor de
				// Suelos de la lista

				if (actPatrimonio.getCheckHPM()) {
					listaTiposGestor.remove(tipoGestorSuelo);
					listaTiposGestor.remove(tipoSupervisorSuelo);
					listaTiposGestor.remove(tipoGestorEdificaciones);
					listaTiposGestor.remove(tipoSupervisorEdificaciones);

				}

				else if (!DDTipoActivo.COD_SUELO.equals(codigoTipoActivo)) {
					listaTiposGestor.remove(tipoGestorSuelo);
					listaTiposGestor.remove(tipoSupervisorSuelo);
					listaTiposGestor.remove(tipoGestorAlquileres);
					listaTiposGestor.remove(tipoSupervisorAlquileres);

					// Si el Activo NO es de tipo Suelo y el Estado físico del
					// activo esta vacio eliminamos el gestor de edificacionnes
					if (Checks.esNulo(activo.getEstadoActivo())) {
						listaTiposGestor.remove(tipoGestorEdificaciones);
						listaTiposGestor.remove(tipoSupervisorEdificaciones);
						listaTiposGestor.remove(tipoGestorAlquileres);
						listaTiposGestor.remove(tipoSupervisorAlquileres);

					}
				} else {
					// Si el Activo es de tipo Suelo eliminamos el gestor de
					// edificacionnes y gestor de alquileres
					listaTiposGestor.remove(tipoGestorEdificaciones);
					listaTiposGestor.remove(tipoSupervisorEdificaciones);
					listaTiposGestor.remove(tipoGestorAlquileres);
					listaTiposGestor.remove(tipoSupervisorAlquileres);

				}
			}

			else {
				if (!DDTipoActivo.COD_SUELO.equals(codigoTipoActivo)) {
					listaTiposGestor.remove(tipoGestorSuelo);
					listaTiposGestor.remove(tipoSupervisorSuelo);
					listaTiposGestor.remove(tipoGestorAlquileres);
					listaTiposGestor.remove(tipoSupervisorAlquileres);

					// Si el Activo NO es de tipo Suelo y el Estado físico del
					// activo esta vacio eliminamos el gestor de edificacionnes
					if (Checks.esNulo(activo.getEstadoActivo())) {
						listaTiposGestor.remove(tipoGestorEdificaciones);
						listaTiposGestor.remove(tipoSupervisorEdificaciones);
						listaTiposGestor.remove(tipoGestorAlquileres);
						listaTiposGestor.remove(tipoSupervisorAlquileres);

					}
				} else {
					// Si el Activo es de tipo Suelo eliminamos el gestor de
					// edificacionnes
					listaTiposGestor.remove(tipoGestorEdificaciones);
					listaTiposGestor.remove(tipoSupervisorEdificaciones);
					listaTiposGestor.remove(tipoGestorAlquileres);
					listaTiposGestor.remove(tipoSupervisorAlquileres);

				}
			}
			// Filtramos los gestores dependiendo del tipo de comercialización
			// del activo
			if (!Checks.esNulo(activo) && !Checks.esNulo(tipoComercializacion) && !tipoComercializacion.isEmpty()) {
				if (DDTipoComercializacion.CODIGO_VENTA.equals(tipoComercializacion)) {
					listaTiposGestor.remove(tipoGestorComercialAlquileres);
					listaTiposGestor.remove(tipoSupervisorComercialAlquileres);
				}
				if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion)) {
					listaTiposGestor.remove(tipoGestorComercial);
					listaTiposGestor.remove(tipoSupervisorComercial);
				}
			}
		} catch (NumberFormatException e) {
			logger.error(e.getMessage(),e);
		}

		return listaTiposGestor;
	}

	@Override
	public List<EXTDDTipoGestor> getComboTipoGestorFiltrado(Set<String> tipoGestorCodigos) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<EXTDDTipoGestor> lista = genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		List<EXTDDTipoGestor> listaResultado = new ArrayList<EXTDDTipoGestor>();

		for (EXTDDTipoGestor tipoGestor : lista) {
			if (tipoGestorCodigos.contains(tipoGestor.getCodigo())) {
				listaResultado.add(tipoGestor);
			}
		}

		return listaResultado;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoGestorOfertas")
	public List<EXTDDTipoGestor> getComboTipoGestorOfertas() {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		List<EXTDDTipoGestor> lista = genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		List<EXTDDTipoGestor> listaResultado = new ArrayList<EXTDDTipoGestor>();
		for (EXTDDTipoGestor tipoGestor : lista) {
			if (tipoGestor.getCodigo().equals("GCOM") || tipoGestor.getCodigo().equals("GCBO")
					|| tipoGestor.getCodigo().equals("GFORM") || tipoGestor.getCodigo().equals("FVDNEG")
					|| tipoGestor.getCodigo().equals("FVDBACKOFR") || tipoGestor.getCodigo().equals("FVDBACKVNT")
					|| tipoGestor.getCodigo().equals("HAYAGBOINM")
					|| tipoGestor.getCodigo().equals("SBACKOFFICEINMLIBER") || tipoGestor.getCodigo().equals("GESRES")
					|| tipoGestor.getCodigo().equals("SUPRES")) {
				listaResultado.add(tipoGestor);
			}
		}

		return listaResultado;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoTrabajoCreaFiltered")
	public List<DDTipoTrabajo> getComboTipoTrabajoCreaFiltered(String idActivo,String numTrabajo) {

		List<DDTipoTrabajo> tiposTrabajo = new ArrayList<DDTipoTrabajo>();
		List<DDTipoTrabajo> tiposTrabajoFiltered = new ArrayList<DDTipoTrabajo>();
		tiposTrabajo.addAll((List<DDTipoTrabajo>) (List) adapter.getDiccionario("tiposTrabajo"));
		List<DDTipoTrabajo> tiposTrabajoNoBloqueados = new ArrayList<DDTipoTrabajo>();
		Trabajo trabajo = null;
		
	
		for (DDTipoTrabajo ddTipoTrabajo : tiposTrabajo) {
			if(!Checks.esNulo(ddTipoTrabajo.getBloqueado()) && !ddTipoTrabajo.getBloqueado()) {
				tiposTrabajoNoBloqueados.add(ddTipoTrabajo);
			}
		}
		
		tiposTrabajo = tiposTrabajoNoBloqueados;
		
		if (idActivo != null && !idActivo.isEmpty() && StringUtils.isNumeric(idActivo)) {
			Activo act = activoApi.get(Long.parseLong(idActivo));
			
			
			
			// Si no hay registro en BBDD de perimetro, el get nos
			// devuelve un PerimetroActivo nuevo
			// con todas las condiciones de perimetro activas
			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(Long.parseLong(idActivo));
			
			if(numTrabajo !=null && !numTrabajo.isEmpty() && StringUtils.isNumeric(numTrabajo))
				trabajo = genericDao.get(Trabajo.class, genericDao.createFilter(FilterType.EQUALS, "numTrabajo",Long.parseLong(numTrabajo)) );
			
			if(trabajo != null && trabajo.getTipoTrabajo()!=null) {
				
					if(!Checks.esNulo(perimetroActivo.getAplicaGestion())
						&& perimetroActivo.getAplicaGestion()==0) {
						tiposTrabajoFiltered.add(trabajo.getTipoTrabajo());
						return tiposTrabajoFiltered;
					
					} else if (trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_SUELO) || trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_EDIFICACION )) {
						tiposTrabajoFiltered.add(trabajo.getTipoTrabajo());
						return tiposTrabajoFiltered;
				} 
				
			}
			
			for (DDTipoTrabajo tipoTrabajo : tiposTrabajo) {
				// No se pueden crear tipos de trabajo ACTUACION TECNICA ni
				// OBTENCION DOCUMENTAL
				// cuando el activo no tiene condicion de gestion en el
				// perimetro (check gestion = false)
				if (!Checks.esNulo(act.getEnTramite()) && act.getEnTramite()==1) {
					if (!Checks.esNulo(tipoTrabajo.getFiltroEnTramite()) && tipoTrabajo.getFiltroEnTramite()) {
						tiposTrabajoFiltered.add(tipoTrabajo);
					}
				} else {
					if (!DDTipoTrabajo.CODIGO_COMERCIALIZACION.equals(tipoTrabajo.getCodigo())
							&& !DDTipoTrabajo.CODIGO_PUBLICACIONES.equals(tipoTrabajo.getCodigo())
							&& !DDTipoTrabajo.CODIGO_TASACION.equals(tipoTrabajo.getCodigo())
							&& !DDTipoTrabajo.CODIGO_PRECIOS.equals(tipoTrabajo.getCodigo())) {
						// El resto de tipos, si no es comercialización o
						// tasación,
						// se pueden generar.
						tiposTrabajoFiltered.add(tipoTrabajo);

					}
				}
			}			
		} else {

			for (DDTipoTrabajo tipoTrabajo : tiposTrabajo) {
				// No se generan los tipos de trabajo tasación o
				// comercialización.
				if (!DDTipoTrabajo.CODIGO_COMERCIALIZACION.equals(tipoTrabajo.getCodigo())
						&& !DDTipoTrabajo.CODIGO_TASACION.equals(tipoTrabajo.getCodigo())
						&& !DDTipoTrabajo.CODIGO_PUBLICACIONES.equals(tipoTrabajo.getCodigo())
						&& !DDTipoTrabajo.CODIGO_PRECIOS.equals(tipoTrabajo.getCodigo())) {
					// El resto de tipos, si no es comercialización o tasación,
					// se pueden generar.

					// Excluiremos los trabajos del tipo publicacion para las
					// agrupaciones de tipo asistida o de tipo obra nueva

					tiposTrabajoFiltered.add(tipoTrabajo);

				}
			}
		}		
		return tiposTrabajoFiltered;

	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajo")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajo(String tipoTrabajoCodigo, Long idActivo) {
		List<DDSubtipoTrabajo> lista = new ArrayList<DDSubtipoTrabajo>();
		DDTipoTrabajo tipoTrabajo = genericDao.get(DDTipoTrabajo.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", tipoTrabajoCodigo));
		
		if (!Checks.esNulo(idActivo)) {
			Activo activo = activoApi.get(idActivo);
			if (!Checks.esNulo(activo.getEnTramite()) && activo.getEnTramite()==1) {
				Usuario gestorProveedorTecnico = gestorActivoApi.getGestorByActivoYTipo(activo, "PTEC");
				if (!Checks.esNulo(gestorProveedorTecnico)) {
					if (!Checks.esNulo(activo.getCartera())) { 
						lista = ddSubtipoTrabajoDao.getSubtipoTrabajoconTarifaPlana(activo.getCartera().getId(), tipoTrabajo.getId(), new Date());
					}
				} else {
					Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
					lista = genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
				}
			} else {
				Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
				lista = genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
			}
		} else {
			Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
			lista = genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
		}

		if (!Checks.esNulo(idActivo)) {
			Activo activo2 = activoApi.get(idActivo);
			List<DDSubtipoTrabajo> lista2 = new ArrayList<DDSubtipoTrabajo>();
			if (!Checks.esNulo(activo2.getCartera()) && !Checks.esNulo(activo2.getSubcartera())
					&& !DDCartera.CODIGO_CARTERA_SAREB.equals(activo2.getCartera().getCodigo())
					&& !DDSubcartera.CODIGO_SAR_INMOBILIARIO.equals(activo2.getSubcartera().getCodigo())) {
				for (DDSubtipoTrabajo s : lista) {
					if (!DDSubtipoTrabajo.CODIGO_OTROS_TARIFA_PLANA.equals(s.getCodigo())) {
						lista2.add(s);
					}
				}
				return lista2;
			}
			
		}

		return lista;

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajo")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajoCreaFiltered(String tipoTrabajoCodigo) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
		List<DDSubtipoTrabajo> listaSubtipos = genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
		List<DDSubtipoTrabajo> listaSubtiposFiltered = new ArrayList<DDSubtipoTrabajo>();

		for (DDSubtipoTrabajo subtipo : listaSubtipos) {
			if (!DDTipoTrabajo.CODIGO_PRECIOS.equals(subtipo.getCodigoTipoTrabajo())) {
				return listaSubtipos;
			}
			// Solo se pueden crear por la pantalla de crear trabajo estos
			// subtipos relacionados con precios
			else if (DDSubtipoTrabajo.CODIGO_ACTUALIZACION_PRECIOS.equals(subtipo.getCodigo())
					|| DDSubtipoTrabajo.CODIGO_PRECIOS_BLOQUEAR_ACTIVOS.equals(subtipo.getCodigo())
					|| DDSubtipoTrabajo.CODIGO_PRECIOS_DESBLOQUEAR_ACTIVOS.equals(subtipo.getCodigo())) {
				listaSubtiposFiltered.add(subtipo);
			}
		}

		return listaSubtiposFiltered;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajoTarificado")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajoTarificado(String tipoTrabajoCodigo) {
		// Generar una lista de todos los trabajos relacionados con el tipo de
		// trabajo que
		// llega y finalmente crear otra nueva y copiarla la primera sin
		// aquellos que sean de códigos no tarificados
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
		List<DDSubtipoTrabajo> subtipos = genericDao.getListOrdered(DDSubtipoTrabajo.class,
				order, filter);
		List<DDSubtipoTrabajo> subtiposTarificados = new ArrayList<DDSubtipoTrabajo>();
		for (DDSubtipoTrabajo subtipo : subtipos) {
			if (!subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_OBRA_MENOR_NO_TARIFICADA)
					&& !subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_CONTROL_ACTUACIONES)
					&& !subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_MOBILIARIO)) {
				subtiposTarificados.add(subtipo);
			}
		}
		return subtiposTarificados;

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoClaseActivo")
	public List<DDSubtipoClaseActivoBancario> getComboSubtipoClaseActivo(String tipoClaseActivoCodigo) {

		// Generar una lista de todos los subtipos de clase bancarios
		// relacionados con el tipo de clase bancario
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "claseActivo.codigo", tipoClaseActivoCodigo);

		return genericDao.getListOrdered(DDSubtipoClaseActivoBancario.class, order, filter);

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboMotivoRechazoOferta")
	public List<DDMotivoRechazoOferta> getComboMotivoRechazoOferta(String tipoRechazoOfertaCodigo, Long idOferta) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoRechazo.codigo", tipoRechazoOfertaCodigo);
		Filter filtroMotivoAlquiler = genericDao.createFilter(FilterType.EQUALS, "alquiler", true);
		Filter filtroMotivoVenta = genericDao.createFilter(FilterType.EQUALS, "venta", true);
		Oferta oferta = ofertaApi.getOfertaById(idOferta);
		
		if(tipoRechazoOfertaCodigo.equals("A")) {
			if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
				return genericDao.getListOrdered(DDMotivoRechazoOferta.class, order, filter, filtroMotivoAlquiler);
			}else if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
				return  genericDao.getListOrdered(DDMotivoRechazoOferta.class, order, filter, filtroMotivoVenta);
			}
		}else if (tipoRechazoOfertaCodigo.equals("D")) {
			return  genericDao.getListOrdered(DDMotivoRechazoOferta.class, order, filter);
		}

		return new ArrayList<DDMotivoRechazoOferta>();
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoJuzgadoPlaza")
	public List<TipoJuzgado> getComboTipoJuzgadoPlaza(Long idPlaza) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "plaza.id", idPlaza);
		return  genericDao.getListOrdered(TipoJuzgado.class, order, filter);
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoGasto")
	public List<DDSubtipoGasto> getComboSubtipoGasto(String codigoTipoGasto) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoGasto.codigo", codigoTipoGasto);
		return  genericDao.getListOrdered(DDSubtipoGasto.class, order, filter);

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboEjercicioContabilidad")
	public List<Ejercicio> getComboEjercicioContabilidad() {

		Order order = new Order(GenericABMDao.OrderType.ASC, "anyo");
		return  genericDao.getListOrdered(Ejercicio.class, order);

	}

	/**
	 * Devuelve una lista de ActivoPropietario parseado en DtoDiccionario
	 * 
	 * @return
	 */
	private List<DtoDiccionario> getListDtoPropietarioDiccionario() {

		List<DtoDiccionario> listaDD = new ArrayList<DtoDiccionario>();

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "nombre");
		List<ActivoPropietario> listaPropietarios = genericDao.getListOrdered(ActivoPropietario.class, order,
				filtroBorrado);

		for (ActivoPropietario propietario : listaPropietarios) {
			DtoDiccionario propietarioDD = new DtoDiccionario();
			try {
				beanUtilNotNull.copyProperty(propietarioDD, "id", propietario.getId());
				beanUtilNotNull.copyProperty(propietarioDD, "descripcion", propietario.getFullName());

				if (!Checks.esNulo(propietario.getCartera()))
					beanUtilNotNull.copyProperty(propietarioDD, "codigo", propietario.getCartera().getCodigo());

			} catch (IllegalAccessException e) {
				logger.error(e.getMessage(),e);
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage(),e);
			}
			listaDD.add(propietarioDD);
		}

		return listaDD;
	}

	@Override
	public List<DDComiteSancion> getComitesByCartera(String carteraCodigo, String subcarteraCodigo) {
		List<DDComiteSancion> listaComites = null;
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filtro;
		Filter filtroCartera;
		if(!Checks.esNulo(subcarteraCodigo)){
			
			filtroCartera = genericDao.createFilter(FilterType.EQUALS,"cartera.codigo", carteraCodigo);
			listaComites = genericDao.getList(DDComiteSancion.class,filtroCartera);

		}
		if(Checks.esNulo(subcarteraCodigo) || Checks.estaVacio(listaComites)){
			filtro = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", carteraCodigo);
			listaComites = genericDao.getListOrdered(DDComiteSancion.class,order,filtro);
			
			if(listaComites != null && !listaComites.isEmpty()) {
				List<DDComiteSancion> copiaListaComites =  new  ArrayList<DDComiteSancion>(listaComites);
				for (DDComiteSancion comite : copiaListaComites) {
					if(comite.getSubcartera()!=null){
						listaComites.remove(comite);
					}
				}
			}
		}
		return listaComites;

	}

	@Override
	public List<DDComiteSancion> getComitesByIdExpediente(String expediente) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(expediente));
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

		ExpedienteComercial expComercial = genericDao.get(ExpedienteComercial.class, filter, filtroBorrado);
		Activo activo = expComercial.getOferta().getActivoPrincipal();
		
		if (!Checks.esNulo(activo.getCartera().getCodigo())) {
			return getComitesByCartera(activo.getCartera().getCodigo(), activo.getSubcartera().getCodigo());
		} else {
			return new ArrayList<DDComiteSancion>();
		}
	}

	@Override
	public List<DtoDiccionario> getComboProveedorBySubtipo(String subtipoProveedorCodigo) {

		List<DtoDiccionario> listaDD = new ArrayList<DtoDiccionario>();

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo",
				subtipoProveedorCodigo);
		Filter filtroVigente = genericDao.createFilter(FilterType.NULL, "fechaBaja");
		Order order = new Order(OrderType.ASC, "nombre");
		List<ActivoProveedor> lista = genericDao.getListOrdered(ActivoProveedor.class, order, filtroBorrado,
				filtroSubtipo, filtroVigente);

		for (ActivoProveedor proveedor : lista) {
			DtoDiccionario dto = new DtoDiccionario();

			try {
				beanUtilNotNull.copyProperty(dto, "id", proveedor.getId());
				beanUtilNotNull.copyProperty(dto, "descripcion", proveedor.getNombre());
			} catch (IllegalAccessException e) {
				logger.error(e.getMessage(),e);
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage(),e);
			}
			listaDD.add(dto);
		}

		return listaDD;
	}

	@Override
	public List<DDTipoComercializacion> getComboTipoDestinoComercialCreaFiltered() {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<DDTipoComercializacion> listaDD = genericDao.getListOrdered(DDTipoComercializacion.class, order);
		List<DDTipoComercializacion> listaTiposFiltered = new ArrayList<DDTipoComercializacion>();

		for (DDTipoComercializacion tipo : listaDD) {
			if (!DDTipoComercializacion.CODIGO_ALQUILER_OPCION_COMPRA.equals(tipo.getCodigo())) {
				listaTiposFiltered.add(tipo);
			}
		}

		return listaTiposFiltered;
	}

	@Override
	public List<DDTiposPorCuenta> getDiccionarioPorCuenta(String tipoCodigo) {
		List<DDTiposPorCuenta> listaTiposPorCuenta = genericDao.getList(DDTiposPorCuenta.class);
		List<DDTiposPorCuenta> listaTiposPorCuentaFiltered = new ArrayList<DDTiposPorCuenta>();

		if (!Checks.esNulo(tipoCodigo)) {
			if ("01".equals(tipoCodigo)) { // Venta.
				for (DDTiposPorCuenta tipo : listaTiposPorCuenta) {
					if (!DDTiposPorCuenta.TIPOS_POR_CUENTA_ARRENDADOR.equals(tipo.getCodigo())
							&& !DDTiposPorCuenta.TIPOS_POR_CUENTA_ARRENDATARIO.equals(tipo.getCodigo())) {
						listaTiposPorCuentaFiltered.add(tipo);
					}
				}
			} else { // Alquiler.
				for (DDTiposPorCuenta tipo : listaTiposPorCuenta) {
					if (!DDTiposPorCuenta.TIPOS_POR_CUENTA_COMPRADOR.equals(tipo.getCodigo())
							&& !DDTiposPorCuenta.TIPOS_POR_CUENTA_VENDEDOR.equals(tipo.getCodigo())) {
						listaTiposPorCuentaFiltered.add(tipo);
					}
				}
			}

			return listaTiposPorCuentaFiltered;
		}

		return listaTiposPorCuenta;
	}

	@Override
	public List<DDTipoCalculo> getDiccionarioByTipoOferta(String diccionario, String codTipoOferta) {
		Filter filtroTipoOferta = genericDao.createFilter(FilterType.EQUALS, "tipoOferta.codigo", codTipoOferta);

		return genericDao.getList(DDTipoCalculo.class, filtroTipoOferta);
	}

	@Override
	public List<DtoDiccionario> getComboGestoriasGasto() {

		List<DtoDiccionario> lista = getComboProveedorBySubtipo(DDTipoProveedor.COD_GESTORIA);
		lista.addAll(getComboProveedorBySubtipo(DDTipoProveedor.COD_CERTIFICADORA));

		return lista;
	}

	@Override
	public List<DDTipoBloqueo> getDiccionarioTipoBloqueo(String areaCodigo) {

		List<DDTipoBloqueo> listaTiposBloqueo = new ArrayList<DDTipoBloqueo>();

		if (!Checks.esNulo(areaCodigo)) {
			if (areaCodigo.equals("mostrarTodos")) {
				listaTiposBloqueo = genericDao.getList(DDTipoBloqueo.class);
			} else {
				listaTiposBloqueo = genericDao.getList(DDTipoBloqueo.class,
						genericDao.createFilter(FilterType.EQUALS, "area.codigo", areaCodigo));
			}
		}

		return listaTiposBloqueo;
	}

	@Override
	public List<DDCondicionIndicadorPrecio> getIndicadorCondicionPrecioFiltered(String codigoCartera) {
		List<DDCondicionIndicadorPrecio> listaTipoPropuestas = new ArrayList<DDCondicionIndicadorPrecio>();

		if (Checks.esNulo(codigoCartera)) {
			return listaTipoPropuestas;
		}

		// Obtener todos los tipos de propuestas.
		listaTipoPropuestas.addAll(genericDao.getList(DDCondicionIndicadorPrecio.class));

		// Obtener la lista de reglas actual filtradas por cartera.
		Filter filtroUsadoActualmentePorCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo",
				codigoCartera);
		List<CarteraCondicionesPrecios> listaUsadoActualmentePorCartera = genericDao
				.getList(CarteraCondicionesPrecios.class, filtroUsadoActualmentePorCartera);

		// Por cada regla actual, contrastar la propuesta de precio usada con la
		// lista de todas ellas y si coincide eliminarla de la lista.
		for (CarteraCondicionesPrecios condicion : listaUsadoActualmentePorCartera) {
			if (listaTipoPropuestas.contains(condicion.getCondicionIndicadorPrecio())) {
				listaTipoPropuestas.remove(condicion.getCondicionIndicadorPrecio());
			}
		}

		return listaTipoPropuestas;
	}

	@Override
	public List<DDSubcartera> getComboSubcartera(String codCartera) {
		List<DDSubcartera> listaSubcartera;
		Usuario usuarioLogado = adapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));				
		if (!Checks.esNulo(usuarioCartera) && !Checks.esNulo(usuarioCartera.getSubCartera()) && !Checks.esNulo(usuarioCartera.getSubCartera().getCodigo())){
			Filter filtroSubcartera = genericDao.createFilter(FilterType.EQUALS, "codigo", usuarioCartera.getSubCartera().getCodigo());
			listaSubcartera = genericDao.getList(DDSubcartera.class, filtroSubcartera);
		}else{
			if(Checks.esNulo(codCartera)) {
				listaSubcartera = genericDao.getList(DDSubcartera.class);
			}else {
				Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", codCartera);
				listaSubcartera = genericDao.getList(DDSubcartera.class, filtroCartera);
			}
		}
		return listaSubcartera;
	}

	@Override
	public List<DDComiteAlquiler> getComitesAlquilerByCartera(Long idActivo) {

		Activo activo = activoApi.get(idActivo);

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", activo.getCartera().getCodigo());
		Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getListOrdered(DDComiteAlquiler.class, order, filter, filterBorrado);
	}

	@Override
	public List<DDComiteAlquiler> getComitesAlquilerByCarteraCodigo(String carteraCodigo) {
		Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", carteraCodigo);
		return genericDao.getList(DDComiteAlquiler.class, filtroCartera);

	}

	@Override
	public List<DDTipoAgrupacion> getComboTipoAgrupacion() {
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(DDTipoAgrupacion.class, filtroBorrado);
	}

	@Override
	public List<DDTipoAgrupacion> getTodosComboTipoAgrupacion() {
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(DDTipoAgrupacion.class, filtroBorrado,
				filtroBorrado);
	}
	
	@Override
	public List<DtoUsuarios> getTodosComboUsuarios() {
		List<DtoUsuarios> result = new ArrayList<DtoUsuarios>();
		List<Usuario> lista = genericDao.getList(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		for (Usuario u : lista) {
			DtoUsuarios aux = new DtoUsuarios();
			aux.setCodigo(u.getUsername());
			StringBuilder sb = new StringBuilder(u.getUsername());
			if(!Checks.esNulo(u.getNombre())) {
				sb.append(" - ");
				sb.append(u.getNombre());
				if(!Checks.esNulo(u.getApellido1())) {
					sb.append(" ");
					sb.append(u.getApellido1());
					if(!Checks.esNulo(u.getApellido2())) {
						sb.append(" ");
						sb.append(u.getApellido2());				
					}
				}
			}
			aux.setDescripcion(sb.toString().trim());
			result.add(aux);
		}
		return result; 
	}
	
	@Override
	public List<DDTipoTituloActivoTPA> getComboTipoTituloActivoTPA(Long numActivo) {

		Activo activo = activoApi.getByNumActivo(numActivo);
		List<DDTipoTituloActivoTPA> combo = new ArrayList<DDTipoTituloActivoTPA>();
		
		DDTipoTituloActivoTPA tipoTituloSi = (DDTipoTituloActivoTPA) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoTituloActivoTPA.class, DDTipoTituloActivoTPA.tipoTituloSi);
		DDTipoTituloActivoTPA tipoTituloNo = (DDTipoTituloActivoTPA) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoTituloActivoTPA.class, DDTipoTituloActivoTPA.tipoTituloNo);
		DDTipoTituloActivoTPA tipoTituloNoConIndicios = (DDTipoTituloActivoTPA) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoTituloActivoTPA.class, DDTipoTituloActivoTPA.tipoTituloNoConIndicios);
		
		combo.add(tipoTituloSi);
		
		if(!Checks.esNulo(activo.getCartera())) {
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
				if(!Checks.esNulo(activo.getSituacionPosesoria().getSitaucionJuridica())) {
					if (activo.getSituacionPosesoria().getSitaucionJuridica().getIndicaPosesion() == 1) {
						combo.add(tipoTituloNo);
					} else {
						combo.add(tipoTituloNoConIndicios);
					}
				}					
			}else if(activo.getSubcartera()!=null && (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())
							||DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo()) ||
									DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo()) 
								 || DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo()))) {
				if(activo.getAdjNoJudicial() != null && activo.getAdjNoJudicial().getFechaPosesion()!=null) {
					combo.add(tipoTituloNo);
				}else {
					combo.add(tipoTituloNoConIndicios);
				}
						
				
			}else {
				if (!Checks.esNulo(activo.getSituacionPosesoria().getFechaRevisionEstado())
						|| !Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion())) {
					combo.add(tipoTituloNo);
				} else {
					combo.add(tipoTituloNoConIndicios);
				}
			}
		}
		
		return combo;
	}
	
	@Override
	public List<DDTipoDocumentoTributos> getDiccionarioTiposDocumentoTributo() {
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(DDTipoDocumentoTributos.class, filtroBorrado);
	}

	@Override
	public List<DDTipoRolMediador> getDiccionarioRolesMediador() {
		List<DDTipoRolMediador> listaRoles = new ArrayList<DDTipoRolMediador>();
		
		listaRoles = genericDao.getList(DDTipoRolMediador.class, genericDao.createFilter(FilterType.EQUALS, "ocultar", false));
		
		return listaRoles;
	}
	
	@Override
	public List<DDSubfasePublicacion> getComboSubfase(Long idActivo) {

		List<DDSubfasePublicacion> listaSubfase = new ArrayList<DDSubfasePublicacion>();
		if (!Checks.esNulo(idActivo)){
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			Filter filtroFechaFin = genericDao.createFilter(FilterType.NULL, "fechaFin");
			HistoricoFasePublicacionActivo fasePublicacion = genericDao.get(HistoricoFasePublicacionActivo.class, filtroActivo, filtroFechaFin);
			if (!Checks.esNulo(fasePublicacion.getFasePublicacion())) {
				Filter filtroFase = genericDao.createFilter(FilterType.EQUALS, "fasePublicacion.codigo", fasePublicacion.getFasePublicacion().getCodigo());
				listaSubfase = genericDao.getList(DDSubfasePublicacion.class, filtroFase);
			}
		} 

		return listaSubfase;
	}
	
	@Override
	public List<DDSubfasePublicacion> getComboSubfaseFiltered(String codFase) {

		List<DDSubfasePublicacion> listaSubfase = new ArrayList<DDSubfasePublicacion>();
		if (!Checks.esNulo(codFase)) {
			Filter filtroFase = genericDao.createFilter(FilterType.EQUALS, "fasePublicacion.codigo", codFase);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Order order = new Order(OrderType.ASC, "codigo");
			listaSubfase = genericDao.getListOrdered(DDSubfasePublicacion.class, order, filtroFase, filtroBorrado);
		}

		return listaSubfase;
	}

	@Override
	public List<DDSubestadoGestion> getComboSubestadoGestionFiltered(String codLocalizacion) {
		List<DDSubestadoGestion> listaSubestadoGestion = new ArrayList<DDSubestadoGestion>();
		
		if (!Checks.esNulo(codLocalizacion)) {
			Filter filtroLocCod = genericDao.createFilter(FilterType.EQUALS, "codigo", codLocalizacion);
			DDEstadoLocalizacion estadoLocalizacion = genericDao.get(DDEstadoLocalizacion.class, filtroLocCod);
			
			Filter filtroRelacion = genericDao.createFilter(FilterType.EQUALS, "estadoLocalizacion", estadoLocalizacion.getId());
			List<LocalizacionSubestadoGestion> listRelaciones = genericDao.getList(LocalizacionSubestadoGestion.class, filtroRelacion);
			
			for (LocalizacionSubestadoGestion lsg : listRelaciones) {
				Filter filtroSegId = genericDao.createFilter(FilterType.EQUALS, "id", lsg.getSubestadoGestion());
				listaSubestadoGestion.add(genericDao.get(DDSubestadoGestion.class, filtroSegId));
			}
		}

		return listaSubestadoGestion;
	}

	@Override
	public DDSubestadoGestion getSubestadoGestion(Long idActivo) {
		GestionCCPP gestion = null;
		Activo activo = activoApi.get(idActivo);
		if(!Checks.esNulo(activo)) {
			if(!Checks.esNulo(activo.getComunidadPropietarios())) {
				Filter filtroComunidadPropietarios = genericDao.createFilter(FilterType.EQUALS, "comunidadPropietarios.id", activo.getComunidadPropietarios().getId());
				Filter filtroFechaFin = genericDao.createFilter(FilterType.NULL, "fechaFin");
				
				gestion = genericDao.get(GestionCCPP.class, filtroComunidadPropietarios, filtroFechaFin);
			}
		}
		
		return gestion != null ? gestion.getSubestadoGestion() : null;
	}
	
	@Override
	public List<DDSubtipoActivo> getComboSubtipoActivoFiltered(String codCartera, String codTipoActivo) {

		List<DDSubtipoActivo> listaSubtipos = new ArrayList<DDSubtipoActivo>();
		
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "tipoActivo.codigo", codTipoActivo);
		Filter filtroNoEsEnBbva = genericDao.createFilter(FilterType.EQUALS, "enBbva", false);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "codigo");
		
		if (!Checks.esNulo(codTipoActivo) && !Checks.esNulo(codCartera)) {
			
			if (filtroTipo != null && filtroNoEsEnBbva != null && DDCartera.CODIGO_CARTERA_BBVA.equals(codCartera)) {
				listaSubtipos = genericDao.getListOrdered(DDSubtipoActivo.class, order, filtroTipo, filtroBorrado);
			} else {
				listaSubtipos = genericDao.getListOrdered(DDSubtipoActivo.class, order, filtroTipo, filtroBorrado, filtroNoEsEnBbva);
			}
			
		} else if (!Checks.esNulo(codTipoActivo) && Checks.esNulo(codCartera)) {
			listaSubtipos = genericDao.getListOrdered(DDSubtipoActivo.class, order, filtroTipo, filtroBorrado);
		}

		return listaSubtipos;
	}

	@Override
	public List<DDComiteSancion> getComitesResolucionLiberbank(Long idExp) throws Exception {
		DDComiteSancion comitePropuesto = expedienteComercialApi.comitePropuestoByIdExpediente(idExp);	
		List<DDComiteSancion> listaComites;
		List<String> comitesResolucionComiteCodigos = new ArrayList<String>();
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", DDCartera.CODIGO_CARTERA_LIBERBANK);
		listaComites = genericDao.getListOrdered(DDComiteSancion.class,order,filtro);
		
		if(!Checks.esNulo(comitePropuesto.getCodigo()) && DDComiteSancion.CODIGO_HAYA_LIBERBANK.equals(comitePropuesto.getCodigo())) {
			comitesResolucionComiteCodigos.add(DDComiteSancion.CODIGO_HAYA_LIBERBANK);
		}else {
			comitesResolucionComiteCodigos.add(DDComiteSancion.CODIGO_GESTION_INMOBILIARIA);
			comitesResolucionComiteCodigos.add(DDComiteSancion.CODIGO_DIRECTOR_GESTION_INMOBILIARIA);
			comitesResolucionComiteCodigos.add(DDComiteSancion.CODIGO_COMITE_INVERSION_INMOBILIARIA);
			comitesResolucionComiteCodigos.add(DDComiteSancion.CODIGO_COMITE_DIRECCION);
		}
		
		if(listaComites != null && !listaComites.isEmpty()) {
			for (int i = listaComites.size() -1; i >= 0 ; i--) {
				if(!comitesResolucionComiteCodigos.contains(listaComites.get(i).getCodigo())){
					listaComites.remove(i);
				}
			}
		}
		
		return listaComites;
	}
	
	@Override
	public List<ConfiguracionSubpartidasPresupuestarias> getComboSubpartidaPresupuestaria(Long idGasto) {	
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);		
		Filter filtroGpv = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
		GastoLineaDetalle gld = genericDao.get(GastoLineaDetalle.class, filtroGpv, filtroBorrado);
		
		Filter filtroCuentaContable = genericDao.createFilter(FilterType.EQUALS, "cuentaContable", gld.getCccBase());
		return (!Checks.esNulo(gld) && !Checks.esNulo(gld.getCccBase())) ? genericDao.getList(ConfiguracionSubpartidasPresupuestarias.class, filtroCuentaContable, filtroBorrado) : null; 

	}

	@Override
	public String getPartidaPresupuestaria(Long idSubpartida) {
		
		Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "id", idSubpartida);
		ConfiguracionSubpartidasPresupuestarias cps = genericDao.get(ConfiguracionSubpartidasPresupuestarias.class, filtroId);
		return (cps != null) ? cps.getPartidaPresupuestaria() : null;
	}

	
	@Override
	public List<DDEntidadGasto> getComboTipoElementoGasto(Long idGasto, Long idLinea) {
		GastoProveedor gasto = gastoProveedorApi.findOne(idGasto);
		GastoLineaDetalle linea = gastoLineaDetalleApi.getLineaDetalleByIdLinea(idLinea);
		List<DDEntidadGasto> entidades = genericDao.getList(DDEntidadGasto.class);
		DDEntidadGasto sinActivos = genericDao.get(DDEntidadGasto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEntidadGasto.CODIGO_SIN_ACTIVOS));
		if(!linea.getGastoLineaEntidadList().isEmpty() || (gasto.getPropietario() != null &&  gasto.getPropietario().getCartera() != null &&
			(DDCartera.CODIGO_CARTERA_SAREB.equals(gasto.getPropietario().getCartera().getCodigo())
			|| DDCartera.CODIGO_CARTERA_GIANTS.equals(gasto.getPropietario().getCartera().getCodigo())
			|| DDCartera.CODIGO_CARTERA_TANGO.equals(gasto.getPropietario().getCartera().getCodigo()))
		)) {
			if(entidades.contains(sinActivos)) {
				entidades.remove(sinActivos);
			}
		}
		return entidades;
	}
	
	@Override
	public List<ActivoProveedorReducido> getComboActivoProveedorSuministro() {
		List<ActivoProveedorReducido> listaActivoProveedor = new ArrayList<ActivoProveedorReducido>();
		
		Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_SUMINISTRO);
		Filter filtroEstado = genericDao.createFilter(FilterType.EQUALS, "estadoProveedor.codigo", DDEstadoProveedor.ESTADO_BIGENTE);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<ActivoProveedor> listProveedorSuministroVigente = genericDao.getList(ActivoProveedor.class, filtroSubtipo, filtroEstado, filtroBorrado);
		
		for (ActivoProveedor psv : listProveedorSuministroVigente) {
			ActivoProveedorReducido p = new ActivoProveedorReducido();
			p.setId(psv.getId());
			p.setCodigo(psv.getCodigoProveedorRem());
			p.setNombre(psv.getNombre());
			listaActivoProveedor.add(p);
		}
		return listaActivoProveedor;

	}

	@Override
	public List<DDSubestadoAdmision> getcomboSubestadoAdmisionNuevoFiltrado(String codEstadoAdmisionNuevo) {
		
		List<DDSubestadoAdmision> listaSubestados = new ArrayList<DDSubestadoAdmision>();
		if (!Checks.esNulo(codEstadoAdmisionNuevo)) {
			Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "estadoAdmision.codigo", codEstadoAdmisionNuevo);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Order order = new Order(OrderType.ASC, "codigo");
			listaSubestados = genericDao.getListOrdered(DDSubestadoAdmision.class, order, filtroTipo, filtroBorrado);
		}

		return listaSubestados;
	}
	
	@Override
	public List<DDSubtipoAgendaSaneamiento> getSubtipologiaAgendaSaneamiento(String codTipo) {
		
		Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "tipoAgendaSaneamiento.codigo", codTipo);
		return genericDao.getList(DDSubtipoAgendaSaneamiento.class, filtroId);
	}
	
	@Override
	public List<DDTipoAlta> getComboBBVATipoAlta(Long idRecovery) {
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<DDTipoAlta> listaDD = genericDao.getListOrdered(DDTipoAlta.class, order);
		List<DDTipoAlta> listaTiposFiltered = new ArrayList<DDTipoAlta>();
	
		
		for (DDTipoAlta tipo : listaDD) {
			if (!DDTipoAlta.CODIGO_AUT.equals(tipo.getCodigo()) && idRecovery==null){
				listaTiposFiltered.add(tipo);
			} else if(idRecovery!=null && DDTipoAlta.CODIGO_AUT.equals(tipo.getCodigo())){	
					listaTiposFiltered.add(tipo);
			}
		}

		return listaTiposFiltered;
	}


	@Override
	public List<DtoPropietario> getcomboSociedadAnteriorBBVA() {
	
		List<ActivoPropietario> listaDD= activoPropietarioDao.getPropietarioIdDescripcionCodigo();
		List<DtoPropietario> listaDto = new ArrayList<DtoPropietario>();
		
		for (ActivoPropietario activoPropietario : listaDD) {
			DtoPropietario dtop = new DtoPropietario();	
			dtop.setId(activoPropietario.getId());
			dtop.setDescripcion(activoPropietario.getFullName());
			dtop.setCodigo(activoPropietario.getDocIdentificativo());		
			listaDto.add(dtop);
		}
		return listaDto;
	} 


	@Override
	public List<DDEstadoAdmision> getComboEstadoAdmisionFiltrado(Set<String> tipoEstadoAdmisionCodigo) {		
		Order order = new Order(GenericABMDao.OrderType.ASC, "codigo");
		List<DDEstadoAdmision> lista = genericDao.getListOrdered(DDEstadoAdmision.class,order, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		List<DDEstadoAdmision> listaResultado = new ArrayList<DDEstadoAdmision>();
		for (DDEstadoAdmision tipoEstadoAdmision : lista) {
			if (tipoEstadoAdmisionCodigo.contains(tipoEstadoAdmision.getCodigo())) {
				listaResultado.add(tipoEstadoAdmision);
			}
		}
		return listaResultado;
	}
	
	public List<ImagenWebDto> getFichaComercialFotosActivo(Long id, String urlBase) {		
		
	return downloadFotos(activoAdapter.getListFotosActivoById(id),urlBase);
		
	}
	
	public List<ImagenWebDto> getFichaComercialFotosAgrupacion(Long id, String urlBase) {		
		
	return downloadFotos(activoAgrupacionApi.getFotosAgrupacionById(id),urlBase);
	
	}
	
	public List<ImagenWebDto> downloadFotos(List<ActivoFoto> fotos,String urlBase) {
		
		if (fotos != null && fotos.size() > 0) {
			
			InputStream in = null;
			ByteArrayOutputStream out = null;
			ImagenWebDto image;
			
			List<ImagenWebDto> imagenes = new ArrayList<ImagenWebDto>();
			ActivoFoto fotoPrincipal = null;
			
			for (ActivoFoto activoFoto : fotos) {
				if (activoFoto.getPrincipal() != null && activoFoto.getPrincipal() && activoFoto.getTipoFoto() != null && DDTipoFoto.COD_WEB.equals(activoFoto.getTipoFoto().getCodigo())) {
					fotoPrincipal = new ActivoFoto();
					fotoPrincipal = activoFoto;
					break;
				}
					
			}
			
			if (fotoPrincipal != null) {
				fotos.remove(fotoPrincipal);
				fotos.add(0,fotoPrincipal);
			}	
			
			for (int i = 0 ; i < fotos.size() && i < 6; i++) {
				
				try {
					ActivoFoto foto = fotos.get(i);	
					image = new ImagenWebDto();
					URL url = new URL(foto.getUrlThumbnail());
					in = new BufferedInputStream(url.openStream());    
					out = new ByteArrayOutputStream();
					byte[] buf = new byte[1024];
					int n = 0;
					while (-1!=(n=in.read(buf)))
					{
					   out.write(buf, 0, n);
					}
					image.setImage(out.toByteArray());
					image.setImageName(foto.getNombre());
					imagenes.add(image);
					
				} catch (Exception e) {
					logger.info(e.getMessage());	
				}finally {
					try {
						if (in != null) {
							in.close();
						}
						if (out != null) {
							out.close();
						}
							
					} catch (IOException e) {
						logger.info(e.getMessage());
					}
	
				}
			}
			return imagenes;
		}
		return null;
		}

	@Override
	public List<DDTipoDocumentoActivoDto> getDiccionarioTiposDocumentoBySubtipoTrabajo(String subtipoTrabajo , String entidad) {
		Filter filtroSubtipoTrabajo = genericDao.createFilter(FilterType.EQUALS, "subtipoTrabajo.codigo", subtipoTrabajo);
		List<DDTipoDocumentoActivoDto> out = new ArrayList<DDTipoDocumentoActivoDto>();
		List<TipoDocumentoSubtipoTrabajo> subtipoDocumentoSubtipoTrabajoList =  genericDao.getList(TipoDocumentoSubtipoTrabajo.class, filtroSubtipoTrabajo);
		if(subtipoDocumentoSubtipoTrabajoList != null && !subtipoDocumentoSubtipoTrabajoList.isEmpty()) {
			for (TipoDocumentoSubtipoTrabajo tipoDocumentoSubtipoTrabajo : subtipoDocumentoSubtipoTrabajoList) {
				if(tipoDocumentoSubtipoTrabajo.getTipoDocumento() != null) {
					if(DICCIONARIO_TIPO_DOCUMENTO_ENTIDAD_ACTIVO.equals(entidad)){
						if(tipoDocumentoSubtipoTrabajo.getTipoDocumento().getVisible()){
							out.add(new DDTipoDocumentoActivoDto((DDTipoDocumentoActivo) tipoDocumentoSubtipoTrabajo.getTipoDocumento()));
						}
					}else {
						if(!tipoDocumentoSubtipoTrabajo.getTipoDocumento().getVisible()){
							out.add(new DDTipoDocumentoActivoDto((DDTipoDocumentoActivo) tipoDocumentoSubtipoTrabajo.getTipoDocumento()));
						}
					}
				}
			}
		}
		return out;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean traspasoCierreOficinaBankia(List<CierreOficinaBankiaDto>listCierreOficinaBankiaDto,JSONObject jsonFields, ArrayList<Map<String, Object>>listaRespuesta) 
			throws Exception{
		Map<String, Object> map = null;
		CierreOficinaBankiaDto bankiaDto = null;		
		HashMap<String, String> errorsList = new HashMap<String, String>();
		Usuario usuario = adapter.getUsuarioLogado();
		boolean error = false;
		
		
		for (int i = 0; i < listCierreOficinaBankiaDto.size(); i++) {
			map = new HashMap<String, Object>();
			bankiaDto = listCierreOficinaBankiaDto.get(i);
					
			errorsList = llamarSPCambioOficinaBankia(bankiaDto, usuario);
			
			
			if (errorsList != null && !errorsList.isEmpty()) {
				error = true;
				map.put("codProveedorAnterior", bankiaDto.getCodProveedorAnterior());
				map.put("codProveedorNuevo", bankiaDto.getCodProveedorNuevo());
				map.put("masivo", bankiaDto.getMasivo().toString());
				map.put("success", false);

				map.put("invalidFields", errorsList);
				map.put("error", true);
			}else {				
				map.put("codProveedorAnterior", bankiaDto.getCodProveedorAnterior());
				map.put("codProveedorNuevo", bankiaDto.getCodProveedorNuevo());
				map.put("masivo", bankiaDto.getMasivo().toString());
				map.put("success", true);				
			}								
			

			listaRespuesta.add(map);
			
		}		
		List<Long> listaIdsAuxiliar = activoDao.getIdsAuxiliarCierreOficinaBankias();
		
		if (!listaIdsAuxiliar.isEmpty()) {
			/*Thread hilo = new Thread(new EjecutarEnviarHonorariosUvemAsincrono(usuario.getUsername(), listaIdsAuxiliar));
			hilo.start();*/
			actualizaHonorariosUvem(listaIdsAuxiliar);
		}
				
		return error;
		
	}
	
	@Override
	public void actualizaHonorariosUvem (List<Long> listaIdsAuxiliar) {
		for (Long idExpediente : listaIdsAuxiliar) {
			try {
				//PARA ENVIAR LOS HONORARIOS UNA VEZ CAMBIADOS
				expedienteComercialApi.enviarHonorariosUvem(idExpediente);
				//PARA CAMBIAR EN LA TABLA AUXILIAR LOS REGISTROS A ENVIADOS
				expedienteComercialApi.getCierreOficinaBankiaById(idExpediente);
			} catch (Exception e) {
				e.printStackTrace();
			}
					
		}
	}
	
	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> llamarSPCambioOficinaBankia(CierreOficinaBankiaDto bankiaDto, Usuario usuario) throws Exception {

		HashMap<String, String> errorsList = null;
		Boolean correcto = null;

		
		errorsList = validateCierreOficinaPostRequestData(bankiaDto);
		if (errorsList.isEmpty()) {
			if (bankiaDto.getCodProveedorAnterior() != null && bankiaDto.getCodProveedorNuevo() != null 
					&& (bankiaDto.getMasivo() != null && !bankiaDto.getMasivo())) {
				
				correcto = activoDao.cambiarSpOficinaBankia(bankiaDto.getCodProveedorAnterior(),
						bankiaDto.getCodProveedorNuevo(), usuario.getUsername());
				
			}else if(bankiaDto.getCodProveedorAnterior() == null && bankiaDto.getCodProveedorNuevo() == null 
					&& (bankiaDto.getMasivo() != null && bankiaDto.getMasivo())) {

				List<AuxiliarCierreOficinasBankiaMul> listaMasivoAuxiliar = activoDao.getListAprAuxCierreBnK();

				for (AuxiliarCierreOficinasBankiaMul auxiliar : listaMasivoAuxiliar) {
					if (auxiliar.getOficinaSaliente() != null && auxiliar.getOficinaEntrante() != null) {
						correcto = activoDao.cambiarSpOficinaBankia(auxiliar.getOficinaSaliente(),auxiliar.getOficinaEntrante(), usuario.getUsername());
					}
				}			
			}else {
				correcto = false;
			}
		}else {
			correcto = false;
		}
				
		
		if (!correcto) {
			if (errorsList.get("ERROR") != null) {
				errorsList.put("ERROR",errorsList.get("ERROR"));
			}
			
			if (errorsList.get("codProveedorAnterior") != null) {
				errorsList.put("codProveedorAnterior",errorsList.get("codProveedorAnterior"));
			}
			if (errorsList.get("codProveedorNuevo") != null) {
				errorsList.put("codProveedorNuevo", errorsList.get("codProveedorNuevo"));
			}
			if (errorsList.get("masivo") != null) {
				errorsList.put("masivo", errorsList.get("masivo"));
			}
			
			
		}

		return errorsList;
	}
	
	@Override
	public HashMap<String, String> validateCierreOficinaPostRequestData(CierreOficinaBankiaDto cierreOfiDto)
			throws Exception {
		HashMap<String, String> errorsList = null;
		
		ActivoProveedor oficinaAnterior = null;
		ActivoProveedor oficinaNueva = null;
		
		errorsList = restApi.validateRequestObject(cierreOfiDto, TIPO_VALIDACION.INSERT);
		
		if (cierreOfiDto.getCodProveedorAnterior() != null && cierreOfiDto.getCodProveedorNuevo() != null 
				&& (cierreOfiDto.getMasivo() != null && !cierreOfiDto.getMasivo())) {
			
			DDTipoProveedor tipoProveedorBankia = genericDao.get(DDTipoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoProveedor.COD_OFICINA_BANKIA));
			
			oficinaAnterior = genericDao.get(ActivoProveedor.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigoApiProveedor", cierreOfiDto.getCodProveedorAnterior()),
					genericDao.createFilter(FilterType.EQUALS, "tipoProveedor", tipoProveedorBankia));
			
			oficinaNueva = genericDao.get(ActivoProveedor.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigoApiProveedor", cierreOfiDto.getCodProveedorNuevo()),
					genericDao.createFilter(FilterType.EQUALS, "tipoProveedor", tipoProveedorBankia));
			
			if (oficinaAnterior == null) {
				errorsList.put("ERROR", "Los valores de los proveedores no son correctos");
				errorsList.put("codProveedorAnterior", RestApi.REST_MSG_UNKNOWN_KEY);
			}			
			if (oficinaNueva == null) {
				errorsList.put("ERROR", "Los valores de los proveedores no son correctos");
				errorsList.put("codProveedorNuevo", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		} else if(cierreOfiDto.getCodProveedorAnterior() == null && cierreOfiDto.getCodProveedorNuevo() == null && 
				(cierreOfiDto.getMasivo() != null && !cierreOfiDto.getMasivo())) {
			
			errorsList.put("ERROR", "Masivo no puede ser FALSE si los otros campos son NULL");
			errorsList.put("masivo", RestApi.REST_MSG_UNKNOWN_KEY);
		} else if (cierreOfiDto.getCodProveedorAnterior() != null && cierreOfiDto.getCodProveedorNuevo() != null 
				&& (cierreOfiDto.getMasivo() == null)) {
			
			errorsList.put("ERROR", "Masivo no puede ser NULL");
			errorsList.put("masivo", cierreOfiDto.getMasivo().toString());
		} else if(cierreOfiDto.getCodProveedorAnterior() != null && cierreOfiDto.getCodProveedorNuevo() != null 
				&& (cierreOfiDto.getMasivo() != null && cierreOfiDto.getMasivo())) {
			
			errorsList.put("ERROR", "Las oficinas tienen que ser nulas, si masivo es TRUE");
			errorsList.put("codProveedorAnterior", RestApi.REST_MSG_UNKNOWN_KEY);
			errorsList.put("codProveedorNuevo", RestApi.REST_MSG_UNKNOWN_KEY);
			errorsList.put("masivo", RestApi.REST_MSG_UNKNOWN_KEY);
		} else if(cierreOfiDto.getCodProveedorAnterior() == null && cierreOfiDto.getCodProveedorNuevo() == null 
				&& cierreOfiDto.getMasivo() == null) {
			errorsList.put("ERROR", "Los datos introducidos no son correctos");
			errorsList.put("codProveedorAnterior", RestApi.REST_MSG_UNKNOWN_KEY);
			errorsList.put("codProveedorNuevo", RestApi.REST_MSG_UNKNOWN_KEY);
			errorsList.put("masivo", RestApi.REST_MSG_UNKNOWN_KEY);
		}
				
		return errorsList;
	}	
	
	@Override
	public List<DDEstadoOferta> getDiccionarioEstadosOfertas(String cartera, String equipoGestion) {

		List<DDEstadoOferta> estadosOferta = genericDao.getList(DDEstadoOferta.class);
		List<DDEstadoOferta> listaDDEstadoOferta =  new ArrayList<DDEstadoOferta>();
		
		if (DDCartera.CODIGO_CAIXA.equals(cartera)) {
			Filter filtroCongelada = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_CONGELADA);
			Filter filtroPdteDeposito = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PDTE_DEPOSITO);
			for (DDEstadoOferta ddEstadoOferta : estadosOferta) {
				listaDDEstadoOferta.add(ddEstadoOferta);
				if (DDEstadoOferta.CODIGO_CONGELADA.equals(ddEstadoOferta.getCodigo())) {
					listaDDEstadoOferta.remove(genericDao.get(DDEstadoOferta.class, filtroCongelada));
				}
				if (DDEstadoOferta.CODIGO_PDTE_DEPOSITO.equals(ddEstadoOferta.getCodigo())) {
					listaDDEstadoOferta.remove(genericDao.get(DDEstadoOferta.class, filtroPdteDeposito));
				}
			}
		} else {
			listaDDEstadoOferta.addAll(estadosOferta);
		}

		return listaDDEstadoOferta;
	}

	@Override
	public List<DDEstadosCiviles> comboEstadoCivilCustom(String codCartera) {
		
		List<DDEstadosCiviles> estadosCiviles = genericDao.getList(DDEstadosCiviles.class);
		List<DDEstadosCiviles> listaRetorno = new ArrayList<DDEstadosCiviles>();
		
		DDCartera cartera = genericDao.get(DDCartera.class, genericDao.createFilter(FilterType.EQUALS,"codigo", codCartera));
		
		for (DDEstadosCiviles ddEstadosCiviles : estadosCiviles) {
			listaRetorno.add(ddEstadosCiviles);
			if (!DDCartera.isCarteraBk(cartera) && 
					(DDEstadosCiviles.COD_SEPARADO_C4C.equals(ddEstadosCiviles.getCodigoC4C()) 
							|| DDEstadosCiviles.COD_PAREJA_HECHO_C4C.equals(ddEstadosCiviles.getCodigoC4C()))) {
				listaRetorno.remove(ddEstadosCiviles);
			}
		}						
		return listaRetorno;
		
	}
}
