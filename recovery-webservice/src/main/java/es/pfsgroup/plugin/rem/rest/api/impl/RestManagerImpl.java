package es.pfsgroup.plugin.rem.rest.api.impl;

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
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;
import javax.validation.constraints.NotNull;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.preauth.PreAuthenticatedAuthenticationProvider;
import org.springframework.security.providers.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
import es.pfsgroup.plugin.rem.rest.filter.AuthenticationRestService;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;
import net.sf.json.JSONObject;

@Service("restManager")
public class RestManagerImpl implements RestApi {

	@Autowired
	BrokerDao brokerDao;

	@Autowired
	PeticionDao peticionDao;

	@Resource
	private Properties appProperties;

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public boolean validateSignature(Broker broker, String signature, String peticion)
			throws NoSuchAlgorithmException, UnsupportedEncodingException {
		boolean resultado = false;
		if (broker == null || signature == null || signature.isEmpty() || peticion == null) {
			resultado = false;
		} else {
			String firma = WebcomSignatureUtils.computeSignatue(broker.getKey(), broker.getIp(), peticion);

			if (firma.equals(signature) || broker.getValidarFirma().equals(new Long(0))) {
				resultado = true;
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

	public String getClientIpAddr(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_CLIENT_IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_X_FORWARDED_FOR");
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
		peticionDao.saveOrUpdate(peticion);
	}

	@Override
	public HashMap<String, List<String>> validateRequestObject(Serializable obj) {
		return validateRequestObject(obj, null);
	}

	@Override
	public HashMap<String, List<String>> validateRequestObject(Serializable obj, TIPO_VALIDACION tipovalidacion) {
		HashMap<String, List<String>> error = new HashMap<String, List<String>>();
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

				List<String> listaError = obtenerMapaErrores(error, visitaFailure.getPropertyPath().toString());
				if (visitaFailure.getConstraintDescriptor().getAnnotation().annotationType().equals(NotNull.class)) {
					listaError.add(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				} else if (visitaFailure.getConstraintDescriptor().getAnnotation().annotationType()
						.equals(Diccionary.class)) {
					listaError.add(RestApi.REST_MSG_UNKNOWN_KEY);
				} else {
					listaError.add("DEFAULT");
				}
			}
		}
		return error;
	}

	@Override
	public List<String> obtenerMapaErrores(HashMap<String, List<String>> errores, String propiedad) {
		List<String> mapaErrores = null;
		if (errores.containsKey(propiedad)) {
			mapaErrores = errores.get(propiedad);
		} else {
			mapaErrores = new ArrayList<String>();
			errores.put(propiedad, mapaErrores);
		}

		return mapaErrores;
	}

	@Override
	public PeticionRest getPeticionById(Long id) {
		return peticionDao.get(id);
	}

	@Override
	public PeticionRest getLastPeticionByToken(String token) {
		return peticionDao.getLastPeticionByToken(token);
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void sendResponse(HttpServletResponse response, ModelMap model) {
		JSONObject jsonResp = new JSONObject();
		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		Iterator it = model.keySet().iterator();
		while (it.hasNext()) {
			String key = (String) it.next();
			Object value = model.get(key);
			value = transformObject(value);
			jsonResp.accumulate(key, value);
		}

		PrintWriter out;
		try {
			out = response.getWriter();
			out.print(jsonResp);
			out.flush();
		} catch (IOException e) {
			logger.error(e.getMessage());
		}

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private Object transformObject(Object value) {
		if (value instanceof Integer || value instanceof Long || value instanceof Float) {
			value = String.valueOf(value);
		}
		if (value instanceof String && ((String) value).equals("null")) {
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
	public UsuarioSecurity loadUserRest(Entidad entidad) {
		UsuarioSecurity user = new UsuarioSecurity();
		user.setId(-1L);
		user.setUsername(RestApi.REST_LOGGED_USER_USERNAME);
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
	public PeticionRest crearPeticionObj(ServletRequest req) {
		HttpServletRequest request = (HttpServletRequest) req;
		PeticionRest peticion = new PeticionRest();
		peticion.setMetodo(request.getMethod());
		peticion.setQuery(request.getPathInfo());
		peticion.setData(request.getParameter("data"));
		peticion.setIp(request.getRemoteAddr());

		return peticion;
	}
}
