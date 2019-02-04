package es.pfsgroup.plugin.rem.rest.api.impl;

import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.Authentication;
import org.springframework.security.AuthorizationServiceException;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.preauth.PreAuthenticatedAuthenticationProvider;
import org.springframework.security.providers.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.UniqueKey;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dao.ActivosModificadosDao;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.dao.InformesModificadosDao;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
import es.pfsgroup.plugin.rem.rest.filter.AuthenticationRestService;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.rest.model.ActivosModificados;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.InformesModificados;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;
import es.pfsgroup.recovery.api.UsuarioApi;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Service("restManager")
public class RestManagerImpl implements RestApi {

	@Autowired
	private BrokerDao brokerDao;

	@Autowired
	private PeticionDao peticionDao;

	@Autowired
	private EntidadDao entidadDao;

	@Resource
	private Properties appProperties;

	private final Log logger = LogFactory.getLog(getClass());

	private String NOMBRE_SERVICIO_WEBHOOK = "fotos";

	@Autowired
	private ActivosModificadosDao activosModificadosDao;
	
	@Autowired
	private InformesModificadosDao informesModificadosDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private LogTrustWebService trustMe;
	
	@Autowired
	private UsuarioManager usuarioManager;

	
	@Override
	public boolean validateSignature(Broker broker, String signature, RestRequestWrapper restRequest)
			throws NoSuchAlgorithmException, UnsupportedEncodingException {
		boolean resultado = false;
		if (broker.getValidarFirma().equals(new Long(0))) {
			resultado = true;
		} else {
			String peticion = restRequest.getBody();
			ALGORITMO_FIRMA algoritmoFirma = this.obtenerAlgoritmoFirma(restRequest);
			if (broker == null || signature == null || signature.isEmpty() || peticion == null) {
				resultado = false;
			} else {
				String firma = "";
				if (algoritmoFirma.equals(ALGORITMO_FIRMA.DEFAULT)) {
					firma = WebcomSignatureUtils.computeSignatue(broker.getKey(), broker.getIp(), peticion);
				} else if (algoritmoFirma.equals(ALGORITMO_FIRMA.NO_IP)) {
					firma = WebcomSignatureUtils.computeSignatue(broker.getKey(), null, peticion);
				}

				if (firma.equals(signature)) {
					resultado = true;
				}
			}
		}
		return resultado;
	}

	@Override
	public boolean validateId(Broker broker, String id) {
		boolean resultado = false;
		if (id == null || id.isEmpty() || broker == null) {
			resultado = false;
		} else {
			if (broker.getValidarToken().equals(new Long(1))) {
				if (peticionDao.existePeticionToken(id, broker.getBrokerId())) {
					resultado = false;
				} else {
					resultado = true;
				}
			} else {
				resultado = true;
			}
		}
		return resultado;
	}

	@Override
	public Broker getBrokerByIp(String ip) {
		Broker broker = brokerDao.getBrokerByIp(ip);
		return broker;
	}

	public String getClientIpAddr(ServletRequest request) {

		HttpServletRequest requestServlet = (HttpServletRequest) request;
		String ip = requestServlet.getHeader("X-Forwarded-For");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = requestServlet.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = requestServlet.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = requestServlet.getHeader("HTTP_CLIENT_IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = requestServlet.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}

	@Override
	public Broker getBrokerDefault(String queryString) {
		String DEFAULT_KEY = !Checks.esNulo(appProperties.getProperty("rest.server.rem.api.key"))
				? appProperties.getProperty("rest.server.rem.api.key") : "";
		Broker broker = new Broker();
		broker.setBrokerId(new Long(-1));
		broker.setValidarFirma(new Long(1));
		broker.setValidarToken(new Long(1));
		broker.setKey(DEFAULT_KEY);
		return broker;
	}

	@Override
	public void guardarPeticionRest(PeticionRest peticion) {
		if (peticion != null) {
			peticionDao.saveOrUpdate(peticion);
			trustMe.registrarPeticionServicioWeb(peticion);
		}
	}

	@Override
	public HashMap<String, String> validateRequestObject(Serializable obj) {
		return validateRequestObject(obj, null);
	}

	@Override
	public HashMap<String, String> validateRequestObject(Serializable obj, TIPO_VALIDACION tipovalidacion) {
		HashMap<String, String> error = new HashMap<String, String>();
		ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
		Validator validator = factory.getValidator();
		Set<ConstraintViolation<Serializable>> constraintViolations = null;
		if (tipovalidacion != null) {
			if (tipovalidacion.equals(TIPO_VALIDACION.INSERT)) {
				constraintViolations = validator.validate(obj, Insert.class);
			} else if (tipovalidacion.equals(TIPO_VALIDACION.UPDATE)) {
				constraintViolations = validator.validate(obj, Update.class);
			} else {
				constraintViolations = validator.validate(obj);
			}

		} else {
			constraintViolations = validator.validate(obj);
		}
		if (!constraintViolations.isEmpty()) {
			for (ConstraintViolation<Serializable> visitaFailure : constraintViolations) {
				logger.error("Error en el dto: " + visitaFailure.getMessage());
				if (visitaFailure.getConstraintDescriptor().getAnnotation().annotationType().equals(NotNull.class)) {
					error.put(visitaFailure.getPropertyPath().toString(), RestApi.REST_MSG_MISSING_REQUIRED);
				} else if (visitaFailure.getConstraintDescriptor().getAnnotation().annotationType()
						.equals(Diccionary.class)) {
					error.put(visitaFailure.getPropertyPath().toString(), RestApi.REST_MSG_UNKNOWN_KEY);
				} else if (visitaFailure.getConstraintDescriptor().getAnnotation().annotationType()
						.equals(Size.class)) {
					error.put(visitaFailure.getPropertyPath().toString(), RestApi.REST_MSG_OVERFLOW);
				} else if (visitaFailure.getConstraintDescriptor().getAnnotation().annotationType()
						.equals(UniqueKey.class)) {
					error.put(visitaFailure.getPropertyPath().toString(), RestApi.REST_UNIQUE_VIOLATED);
				} else {
					error.put(visitaFailure.getPropertyPath().toString(), "DEFAULT");
				}
			}
		}
		return error;
	}

	@Override
	public PeticionRest getPeticionById(Long id) {
		return peticionDao.get(id);
	}

	@Override
	public PeticionRest getLastPeticionByToken(String token) {
		return peticionDao.getLastPeticionByToken(token);
	}

	@SuppressWarnings({ "rawtypes" })
	public void sendResponse(HttpServletResponse response, ModelMap model, RestRequestWrapper request) {
		JSONObject jsonResp = new JSONObject();
		Iterator it = model.keySet().iterator();
		String result = RestApi.CODE_OK;
		while (it.hasNext()) {
			String key = (String) it.next();
			Object value = model.get(key);
			value = transformObject(value);
			if (key.equals("error") && value != null && value instanceof String
					&& (!((String) value).isEmpty() && !((String) value).equals("null"))) {
				result = RestApi.CODE_ERROR;
			}
			jsonResp.accumulate(key, value);
		}
		this.sendResponse(response, request, jsonResp, result);
	}

	@Override
	public void sendResponse(HttpServletResponse response, RestRequestWrapper request, JSONObject jsonResp,
			String result) {
		logger.debug("[REST API] Respuesta:");
		logger.debug(jsonResp.toString());
		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		PrintWriter out;
		try {
			if (request != null && request.getPeticionRest() != null) {
				request.getPeticionRest().setResult(result);
				request.getPeticionRest().setResponse(jsonResp.toString());
				request.setTiempoFin(System.currentTimeMillis());
				request.getPeticionRest().setTiempoEjecucion(request.getTiempoFin() - request.getTiempoInicio());
			}
			out = response.getWriter();
			out.print(jsonResp);
			out.flush();
		} catch (Exception e) {
			logger.error(e);
		}

	}

	@Override
	public void sendResponse(HttpServletResponse response, String jsonResp) {
		response.reset();
		PrintWriter out;
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		try {
			out = response.getWriter();
			out.print(jsonResp);
			out.flush();
		} catch (Exception e) {
			logger.error(e);
		}

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private Object transformObject(Object value) {
		if (value instanceof Integer || value instanceof Long || value instanceof Float) {
			value = String.valueOf(value);
		}
		if (value instanceof String && (((String) value).equals("null") || ((String) value).isEmpty())) {
			value = null;
		}
		if (value instanceof Date) {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

			value = df.format(value);
		}
		if (value instanceof ArrayList) {
			for (Object v : (ArrayList) value) {
				transformObject(v);

			}
		}
		if (value instanceof Map) {
			// ((Map)value).
			Iterator it = ((Map) value).entrySet().iterator();

			while (it.hasNext()) {
				Map.Entry e = (Map.Entry) it.next();
				Object valueTrans = transformObject(e.getValue());
				((Map) value).put(e.getKey(), valueTrans);
			}
		}

		return value;
	}

	@Override
	public UsuarioSecurity loadUser(Entidad entidad, String userName) {
		Usuario usuario = usuarioManager.getByUsername(userName);
		UsuarioSecurity user = new UsuarioSecurity();
		user.setId(usuario.getId());
		user.setUsername(userName);
		user.setAccountNonExpired(true);
		user.setAccountNonLocked(true);
		user.setEnabled(true);
		user.setEntidad(entidad);
		return user;
	}

	@Override
	public void doLogin(UsuarioSecurity user) {
		if (user != null) {
			SecurityContext securityContext = SecurityContextHolder.getContext();
			PreAuthenticatedAuthenticationToken authToken = new PreAuthenticatedAuthenticationToken(user.getUsername(),
					RestApi.REST_LOGGED_USER_EMPTY_PASSWORD);
			authToken.setDetails(user);

			AuthenticationRestService authRestService = new AuthenticationRestService();
			// authRestService.setUserNameprefix("REST-");

			PreAuthenticatedAuthenticationProvider preAuthenticatedProvider = new PreAuthenticatedAuthenticationProvider();
			preAuthenticatedProvider.setPreAuthenticatedUserDetailsService(authRestService);
			Authentication authentication = preAuthenticatedProvider.authenticate(authToken);
			securityContext.setAuthentication(authentication);
		}

	}

	@Override
	public PeticionRest crearPeticionObj(RestRequestWrapper req) {
		HttpServletRequest request = (HttpServletRequest) req;
		PeticionRest peticion = new PeticionRest();
		peticion.setMetodo(request.getMethod());
		peticion.setQuery(request.getPathInfo());
		peticion.setData(req.getBody());
		peticion.setIp(this.getClientIpAddr(req));

		return peticion;
	}

	@Override
	public String obtenerNombreServicio(ServletRequest req) {
		String servicename = "";
		String requestUri = ((HttpServletRequest) req).getRequestURI();
		requestUri = requestUri.toLowerCase();
		Boolean encontrado = false;
		for (String token : requestUri.split("/")) {
			if (token.equals("rest") || token.equals("webhook")) {
				encontrado = true;
			} else {
				if (encontrado) {
					if (!servicename.isEmpty()) {
						servicename = servicename.concat("/");
					}
					servicename = servicename.concat(token);
				} else {
					continue;
				}
			}
		}

		return servicename;
	}

	@Override
	public ALGORITMO_FIRMA obtenerAlgoritmoFirma(String nombreServicio, String ipClient) {
		ALGORITMO_FIRMA resultado = ALGORITMO_FIRMA.DEFAULT;
		nombreServicio = nombreServicio.toLowerCase().trim();
		String SERVICIOS_NO_IP = !Checks.esNulo(appProperties.getProperty("rest.server.rem.protocolo.noip.servicios"))
				? appProperties.getProperty("rest.server.rem.protocolo.noip.servicios") : "reserva,reintegro";

		String RANGO_IP_NO_IP = !Checks.esNulo(appProperties.getProperty("rest.server.rem.protocolo.noip.ip"))
				? appProperties.getProperty("rest.server.rem.protocolo.noip.ip") : "*.*.*.*";
		if (SERVICIOS_NO_IP != null && !SERVICIOS_NO_IP.isEmpty()) {
			SERVICIOS_NO_IP = SERVICIOS_NO_IP.toLowerCase();
			Boolean esBankia = false;
			if (compararIps(ipClient, RANGO_IP_NO_IP)) {
				for (String servicioAux : SERVICIOS_NO_IP.split(",")) {
					servicioAux = servicioAux.trim();
					if (servicioAux.equals(nombreServicio)) {
						esBankia = true;
						break;
					}
				}
			}
			if (esBankia) {
				resultado = ALGORITMO_FIRMA.NO_IP;
			}
		}
		return resultado;
	}

	private boolean compararIps(String ipClient, String rangoIP) {
		boolean resultado = false;
		if (ipClient != null && rangoIP != null) {
			String[] ipclientTokens = ipClient.split("\\.");
			String[] rangoIpTokens = rangoIP.split("\\.");
			if (ipclientTokens.length == rangoIpTokens.length) {
				resultado = true;
				for (int i = 0; i < ipclientTokens.length; i++) {
					if (!ipclientTokens[i].equals(rangoIpTokens[i]) && !rangoIpTokens[i].equals("*")) {
						resultado = false;
					}
				}
			}
		}
		return resultado;
	}

	@Override
	public ALGORITMO_FIRMA obtenerAlgoritmoFirma(ServletRequest req) {
		return obtenerAlgoritmoFirma(obtenerNombreServicio(req), getClientIpAddr(req));
	}

	public void throwRestException(ServletResponse res, String errorCode, JSONObject jsonFields,
			RestRequestWrapper req) {
		try {
			JSONObject jsonResp = null;

			HttpServletResponse response = (HttpServletResponse) res;

			jsonResp = buildJsonResponse(errorCode, jsonFields);

			this.sendResponse(response, req, jsonResp, RestApi.CODE_ERROR);
		} catch (Exception e) {
			logger.error(e);
		}

	}

	/**
	 * Genera el formato de una respuesta de un servicio REST
	 * 
	 * @param errorCode
	 * @param jsonFields
	 * @throws IOException
	 */
	private JSONObject buildJsonResponse(String errorCode, JSONObject jsonFields) throws IOException {
		JSONObject jsonResp = new JSONObject();
		Object jsonLine = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

		if (!Checks.esNulo(jsonFields)) {

			if (jsonFields.has("id")) {
				jsonResp.accumulate("id", jsonFields.get("id"));
			}
			if (!Checks.esNulo(errorCode)) {
				jsonResp.accumulate("error", errorCode);
			}

			if (jsonFields.has("data") && jsonFields.get("data") instanceof JSONArray) {
				if (!Checks.esNulo(jsonFields.getJSONArray("data")) && jsonFields.getJSONArray("data").size() > 0) {

					// Construimos mapa de ids a retornar
					for (int i = 0; i < jsonFields.getJSONArray("data").size(); i++) {
						map = new HashMap<String, Object>();
						jsonLine = jsonFields.getJSONArray("data").get(i);
						if (((JSONObject) jsonLine).containsKey("idInformeMediadorWebcom")) {
							map.put("idInformeMediadorWebcom", ((JSONObject) jsonLine).get("idInformeMediadorWebcom"));
							map.put("idActivoHaya", ((JSONObject) jsonLine).get("idActivoHaya"));
						}
						if (((JSONObject) jsonLine).containsKey("idClienteWebcom")) {
							map.put("idClienteWebcom", ((JSONObject) jsonLine).get("idClienteWebcom"));
							map.put("idClienteRem", ((JSONObject) jsonLine).get("idClienteRem"));
						}
						if (((JSONObject) jsonLine).containsKey("idVisitaWebcom")) {
							map.put("idVisitaWebcom", ((JSONObject) jsonLine).get("idVisitaWebcom"));
							map.put("idVisitaRem", ((JSONObject) jsonLine).get("idVisitaRem"));
						}
						if (((JSONObject) jsonLine).containsKey("idOfertaWebcom")) {
							map.put("idOfertaWebcom", ((JSONObject) jsonLine).get("idOfertaWebcom"));
							map.put("idOfertaRem", ((JSONObject) jsonLine).get("idOfertaRem"));
						}
						if (((JSONObject) jsonLine).containsKey("idActivoHaya")) {
							map.put("idActivoHaya", ((JSONObject) jsonLine).get("idActivoHaya"));
						}
						if (((JSONObject) jsonLine).containsKey("idTrabajoWebcom")) {
							map.put("idTrabajoWebcom", ((JSONObject) jsonLine).get("idTrabajoWebcom"));
							map.put("idTrabajoRem", ((JSONObject) jsonLine).get("idTrabajoRem"));
						}
						if (((JSONObject) jsonLine).containsKey("idNotificacionWebcom")) {
							map.put("idNotificacionWebcom", ((JSONObject) jsonLine).get("idNotificacionWebcom"));
							map.put("idNotificacionRem", ((JSONObject) jsonLine).get("idNotificacionRem"));
						}
						map.put("success", false);

						listaRespuesta.add(map);
					}
					jsonResp.accumulate("data", listaRespuesta);

				} else {
					jsonResp.accumulate("data", jsonFields.getJSONArray("data"));
				}
			}
		} else {
			// json inválido
			jsonResp.accumulate("id", null);
			jsonResp.accumulate("error", errorCode);

		}

		return jsonResp;
	}
	
	public void doSessionConfig(String userName) throws Exception {
		Entidad entidad =this.loadEntidad();
		this.doLogin(this.loadUser(entidad, userName));
	}

	public void doSessionConfig() throws Exception {
		this.doSessionConfig(RestApi.REST_LOGGED_USER_USERNAME);
	}
	
	private Entidad loadEntidad() throws Exception{
		String workingCode = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.REST_WORKINGCODE, "2038");
		// Obtenemos la entidad partiendo del working code y establecemos el
		// contextholder
		// necesario para acceder al esquema de la entidad
		Entidad entidad = null;
		try {
			entidad = entidadDao.findByWorkingCode(workingCode);
		} catch (Exception e) {
			logger.error("Error obteniendo la entidad: ");
		}

		if (entidad != null) {
			DbIdContextHolder.setDbId(entidad.getId());
		} else {
			throw new Exception(RestApi.REST_MSG_INVALID_WORKINGCODE);
		}
		return entidad;
	}
	
	

	@Override
	@Deprecated
	public RestLlamada getLlamadaByToken(String token) {
		return null;
	}

	@Override
	public boolean validateWebhookSignature(ServletRequest req, String signature) throws RestConfigurationException {
		boolean resultado = true;
		String nombreSevicio = this.obtenerNombreServicio(req);
		if (nombreSevicio.equals(NOMBRE_SERVICIO_WEBHOOK)) {
			String appId = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
					WebcomRESTDevonProperties.APP_ID_GESTOR_DOCUMENTAL, null);
			String secret = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
					WebcomRESTDevonProperties.APP_SECRET_GESTOR_DOCUMENTAL, null);

			String urlBase = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
					WebcomRESTDevonProperties.BASE_URL_WEBHOOK, null);

			String ip = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
					WebcomRESTDevonProperties.SERVER_PUBLIC_ADDRESS, null);

			if (appId == null || appId.isEmpty() || secret == null || secret.isEmpty() || urlBase == null
					|| urlBase.isEmpty() || ip == null || ip.isEmpty()) {
				throw new RestConfigurationException(
						"configure al app_id, el app_secret, url base y la ip del servidor");
			}
			try {
				String generatedSignature = WebcomSignatureUtils.computeSignatureWebhook(appId, secret, ip, urlBase);
				if (!generatedSignature.equals(signature)) {
					resultado = false;
				}
			} catch (NoSuchAlgorithmException e) {
				logger.error(e);
				resultado = false;
			} catch (UnsupportedEncodingException e) {
				logger.error(e);
				resultado = false;
			}
		}
		return resultado;
	}

	@Override
	public void simulateRestFilter(ServletRequest req) throws Exception {
		this.doSessionConfig();
		RestRequestWrapper restRequest = new RestRequestWrapper((HttpServletRequest) req);
		String ipClient = this.getClientIpAddr(req);
		String signature = ((HttpServletRequest) req).getHeader("signature");
		Broker broker = this.getBrokerByIp(ipClient);
		if (broker == null) {
			broker = this.getBrokerDefault("");
			broker.setIp(ipClient);
		}
		if (!this.validateSignature(broker, signature, restRequest)) {
			throw new AuthorizationServiceException("No tiene permisos para ejecutar este servicio");
		}

	}

	@Override
	public void marcarRegistroParaEnvio(ENTIDADES entidad, Object instanciaEntidad) {
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (entidad.equals(ENTIDADES.ACTIVO)) {
			if (instanciaEntidad != null && instanciaEntidad instanceof Activo) {
				ActivosModificados actMod = activosModificadosDao.getByActivo((Activo) instanciaEntidad);
				if (Checks.esNulo(actMod)) {
					actMod = new ActivosModificados();
					Auditoria auditoria = new Auditoria();
					auditoria.setFechaModificar(new Date());

					auditoria.setUsuarioModificar(usu.getUsername());
					auditoria.setFechaCrear(new Date());
					auditoria.setUsuarioCrear(usu.getUsername());
					actMod.setAuditoria(auditoria);
					actMod.setActivo((Activo) instanciaEntidad);
				} else {
					actMod.getAuditoria().setFechaModificar(new Date());
					actMod.getAuditoria().setUsuarioModificar(usu.getUsername());
				}
				activosModificadosDao.saveOrUpdate(actMod);
			}
		}else if(entidad.equals(ENTIDADES.INFORME)){
			if (instanciaEntidad != null && instanciaEntidad instanceof ActivoInfoComercial) {
				InformesModificados informeMod = informesModificadosDao.getByInforme((ActivoInfoComercial)instanciaEntidad);
				if (Checks.esNulo(informeMod)) {
					informeMod = new InformesModificados();
					Auditoria auditoria = new Auditoria();
					auditoria.setFechaModificar(new Date());

					auditoria.setUsuarioModificar(usu.getUsername());
					auditoria.setFechaCrear(new Date());
					auditoria.setUsuarioCrear(usu.getUsername());
					informeMod.setAuditoria(auditoria);
					informeMod.setInforme((ActivoInfoComercial)instanciaEntidad);
				}else{
					informeMod.getAuditoria().setFechaModificar(new Date());
					informeMod.getAuditoria().setUsuarioModificar(usu.getUsername());
				}
				informesModificadosDao.saveOrUpdate(informeMod);
			}
		}

	}

	@SuppressWarnings("rawtypes")
	public Object getValue(Object dto, Class claseDto, String methodName) throws Exception {
		Object obj = null;
		for (PropertyDescriptor propertyDescriptor : Introspector.getBeanInfo(claseDto).getPropertyDescriptors()) {
			if (propertyDescriptor.getReadMethod() != null
					&& propertyDescriptor.getReadMethod().getName().equals(methodName)) {
				obj = propertyDescriptor.getReadMethod().invoke(dto);
				break;
			}
		}
		return obj;
	}
}
