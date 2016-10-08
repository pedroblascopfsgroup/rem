package es.pfsgroup.plugin.rem.rest.api.impl;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
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
	public List<String> validateRequestObject(Serializable obj) {
		return validateRequestObject(obj, null);
	}

	@Override
	public List<String> validateRequestObject(Serializable obj, TIPO_VALIDACION tipovalidacion) {
		ArrayList<String> error = new ArrayList<String>();
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
				error.add((visitaFailure.getPropertyPath() + " " + visitaFailure.getMessage()));

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

	@SuppressWarnings("rawtypes")
	@Override
	public void sendResponse(HttpServletResponse response, ModelMap model) {
		JSONObject jsonResp = new JSONObject();
		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		Iterator it = model.keySet().iterator();
		while (it.hasNext()) {
			String key =(String)it.next();
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
	private Object transformObject(Object value){
		if(value instanceof Integer || value instanceof Long || value instanceof Float){
			value = String.valueOf(value);
		}
		if(value instanceof String && ((String)value).equals("null")){
			value=null;
		}
		if(value instanceof ArrayList){
			for(Object v : (ArrayList)value){
				transformObject(v);
				
			}
		}
		if(value instanceof Map){
			//((Map)value).
			Iterator it = ((Map)value).entrySet().iterator();
			 
		    while (it.hasNext()) {
		        Map.Entry e = (Map.Entry)it.next();
		        Object valueTrans = transformObject(e.getValue());
		        ((Map)value).put(e.getKey(), valueTrans);
		   }
		}
		
		return value;
	}
}
