package es.pfsgroup.plugin.rem.rest.api.impl;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.EntityDefinition;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;

@Service("restManager")
public class RestManagerImpl implements RestApi {

	@Autowired
	BrokerDao brokerDao;

	@Autowired
	PeticionDao peticionDao;

	@Resource
	private Properties appProperties;

	@Autowired
	private GenericABMDao genericDao;

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
	public List<String> validateRequestObject(Serializable obj, TIPO_VALIDCION tipovalidacion) {
		ArrayList<String> error = new ArrayList<String>();
		ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
		Validator validator = factory.getValidator();
		Set<ConstraintViolation<Serializable>> constraintViolations = null;
		if (tipovalidacion != null) {
			if (tipovalidacion.equals(TIPO_VALIDCION.INSERT)) {
				constraintViolations = validator.validate(obj, Insert.class);
			} else if (tipovalidacion.equals(TIPO_VALIDCION.UPDATE)) {
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

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void saveDtoToBbdd(Object dto, Class entity)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException,
			ClassNotFoundException, InstantiationException, NoSuchMethodException, SecurityException {
		Field[] fields = dto.getClass().getDeclaredFields();
		if (fields != null) {
			for (Field f : fields) {
				if (f.getAnnotation(EntityDefinition.class) != null) {
					EntityDefinition annotation = f.getAnnotation(EntityDefinition.class);
					if (annotation.procesar()) {
						Object objetoEntity = entity.newInstance();
						String propertyEntityName = annotation.propertyName().substring(0, 1).toUpperCase()
								+ annotation.propertyName().substring(1);
						String propertyName = f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1);
						if (annotation.classObj().equals(Object.class)) {
							Method metodo = objetoEntity.getClass().getMethod("set".concat(propertyEntityName),
									f.getType());
							metodo.invoke(objetoEntity, this.getValue(dto, dto.getClass(), "get".concat(propertyName)));
						} else {
							Method metodo = objetoEntity.getClass().getMethod("set".concat(propertyEntityName),
									annotation.classObj());
							Object object = genericDao.get(annotation.classObj(),
									genericDao.createFilter(FilterType.EQUALS, annotation.foreingField(),
											(String) this.getValue(dto, dto.getClass(), "get".concat(propertyName))));
							metodo.invoke(objetoEntity, object);
						}
					}
				} else {
					String propertyEntityName = null;
					try {
						Object objetoEntity = entity.newInstance();
						propertyEntityName = f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1);
						String propertyName = f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1);
						Method metodo = objetoEntity.getClass().getMethod("set".concat(propertyEntityName),
								f.getType());
						metodo.invoke(objetoEntity, this.getValue(dto, dto.getClass(), "get".concat(propertyName)));
					} catch (Exception e) {
						System.out.println(propertyEntityName.concat(" no se podido setear en la entidad"));
					}
				}
			}
		}
	}

	@SuppressWarnings("rawtypes")
	private Object getValue(Object dto, Class claseDto, String methodName)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException {
		Object obj = null;
		for (PropertyDescriptor propertyDescriptor : Introspector.getBeanInfo(InformeMediadorDto.class)
				.getPropertyDescriptors()) {
			if (propertyDescriptor.getReadMethod().getName().equals(methodName)) {
				obj = propertyDescriptor.getReadMethod().invoke(dto);
				break;
			}
		}
		return obj;
	}

}
