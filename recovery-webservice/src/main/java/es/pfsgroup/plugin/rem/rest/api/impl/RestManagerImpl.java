package es.pfsgroup.plugin.rem.rest.api.impl;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
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
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.EntityDefinition;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
import es.pfsgroup.plugin.rem.rest.dao.impl.GenericaRestDaoImp;
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

	@Autowired
	private GenericaRestDaoImp genericaRestDaoImp;

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
	@Transactional(readOnly = false)
	public Serializable saveDtoToBbdd(Object dto, ArrayList<Serializable> objetoEntitys)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException,
			ClassNotFoundException, InstantiationException, NoSuchMethodException, SecurityException {

		if (dto.getClass().getDeclaredFields() != null) {
			for (Field f : dto.getClass().getDeclaredFields()) {
				if (f.getAnnotation(EntityDefinition.class) != null
						&& f.getAnnotation(EntityDefinition.class).propertyName() != null
						&& !f.getAnnotation(EntityDefinition.class).propertyName().isEmpty()) {
					EntityDefinition annotation = f.getAnnotation(EntityDefinition.class);
					String propertyEntityName = annotation.propertyName().substring(0, 1).toUpperCase()
							+ annotation.propertyName().substring(1);
					String propertyName = f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1);
					if (annotation.classObj().equals(Object.class)) {
						Class claseObjeto = f.getType();
						claseObjeto = transformClass(annotation, claseObjeto);
						Object object = this.getValue(dto, dto.getClass(), "get".concat(propertyName));
						this.setProperty(propertyEntityName, claseObjeto, annotation, null, object, objetoEntitys);
					} else {
						Class claseObjeto = annotation.classObj();
						claseObjeto = transformClass(annotation, claseObjeto);
						Object oFiltro = this.getValue(dto, dto.getClass(), "get".concat(propertyName));
						this.setProperty(propertyEntityName, claseObjeto, annotation, oFiltro, null, objetoEntitys);
					}
				} else {
					EntityDefinition annotation = f.getAnnotation(EntityDefinition.class);
					String propertyEntityName = null;
					propertyEntityName = f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1);
					this.setProperty(propertyEntityName, f.getType(), annotation, null,
							this.getValue(dto, dto.getClass(), "get".concat(propertyEntityName)), objetoEntitys);

				}
			}
		}
		guardarEntity(objetoEntitys);
		return objetoEntitys.get(0);
	}

	@SuppressWarnings("rawtypes")
	private Class transformClass(EntityDefinition annotation, Class claseObjeto) {
		if (annotation.transform().equals(TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)) {
			claseObjeto = Integer.class;
		} else if (annotation.transform().equals(TRANSFORM_TYPE.FLOAT_TO_BIGDECIMAL)) {
			claseObjeto = BigDecimal.class;
		}
		return claseObjeto;
	}

	@SuppressWarnings({ "rawtypes" })
	private boolean setProperty(String propertyEntityName, Class claseObjeto, EntityDefinition annotation,
			Object oFiltro, Object object, Serializable objetoEntity) {
		ArrayList<Serializable> objetoEntitys = new ArrayList<Serializable>();
		objetoEntitys.add(objetoEntity);
		return this.setProperty(propertyEntityName, claseObjeto, annotation, oFiltro, object, objetoEntitys);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private boolean setProperty(String propertyEntityName, Class claseObjeto, EntityDefinition annotation,
			Object oFiltro, Object object, ArrayList<Serializable> objetoEntitys) {
		boolean resultado = false;
		if ((annotation != null && annotation.procesar()) || annotation == null) {
			if (oFiltro != null && annotation != null) {
				object = genericDao.get(annotation.classObj(),
						genericDao.createFilter(FilterType.EQUALS, annotation.foreingField(), oFiltro));
			}

			if (object != null) {
				if (annotation != null && annotation.transform().equals(TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)) {
					if ((Boolean) object) {
						object = 1;
					} else {
						object = 0;
					}
				} else if (annotation != null && annotation.transform().equals(TRANSFORM_TYPE.FLOAT_TO_BIGDECIMAL)) {
					object = new BigDecimal((Float) object);
				}

				for (Serializable objetoEntity : objetoEntitys) {
					try {
						Method metodo = this.getMethod(objetoEntity, "set".concat(propertyEntityName), claseObjeto);
						if (metodo != null) {
							metodo.invoke(objetoEntity, object);
							resultado = true;
						}
					} catch (Exception e) {
						System.out.println("FAIL --------------->" + propertyEntityName + " no se ha podido setear");
					}
				}
				if (!resultado && annotation == null) {
					System.out.println("FAIL --------------->" + propertyEntityName + " no se ha podido setear");
				}
			}
		} else if (annotation != null && !annotation.procesar()) {
			resultado = true;
			if (!annotation.motivo().isEmpty()) {
				System.out.println("SKIP  --------------->"
						.concat(propertyEntityName.concat(" motivo: ").concat(annotation.motivo())));
			}
		}
		return resultado;

	}

	private Method getMethod(Serializable clase, String nombreMetodo, Class<?> parametro) {
		Method metodo = null;
		try {
			metodo = clase.getClass().getMethod(nombreMetodo, parametro);
		} catch (NoSuchMethodException e) {
		} catch (SecurityException e) {
		}
		if (metodo == null) {
			Method[] allMethods = clase.getClass().getDeclaredMethods();
			for (Method met : allMethods) {
				if (met.getName().equals(nombreMetodo)) {
					metodo = met;
					break;
				}

			}
		}
		return metodo;
	}

	private void guardarEntity(ArrayList<Serializable> objetoEntitys) throws NoSuchMethodException, SecurityException,
			IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException {
		for (Serializable objetoEntity : objetoEntitys) {
			System.out.println("Guardando..." + objetoEntity.getClass().getName());
			Serializable primaryKey = genericaRestDaoImp.save(objetoEntity);
			System.out.println("Exito..." + primaryKey.getClass().getName());
			String primaryKeFieldName = this.findPrimaryKey(objetoEntity);
			this.setProperty(primaryKeFieldName, primaryKey.getClass(), null, null, primaryKey, objetoEntity);
			this.setFk(objetoEntity, objetoEntitys);
		}

	}

	private void setFk(Serializable objetoEntityFK, ArrayList<Serializable> objetoEntitys) {
		for (Serializable objetoEntity : objetoEntitys) {
			if (!objetoEntityFK.getClass().equals(objetoEntity.getClass())) {
				String fieldFk = this.findFieldFk(objetoEntity, objetoEntityFK.getClass());
				if (fieldFk != null) {
					this.setProperty(fieldFk, objetoEntityFK.getClass(), null, null, objetoEntityFK, objetoEntity);
				}
			}
		}
	}

	private List<Field> getAllFields(List<Field> fields, Class<?> type) {
		fields.addAll(Arrays.asList(type.getDeclaredFields()));

		if (type.getSuperclass() != null) {
			fields = this.getAllFields(fields, type.getSuperclass());
		}

		return fields;
	}

	private String findFieldFk(Serializable objetoEntity, Class<?> claseFK) {
		String result = null;
		List<Field> fields = new ArrayList<Field>();
		fields = this.getAllFields(fields, objetoEntity.getClass());
		for (Field f : fields) {
			if (f.getType().isAssignableFrom(claseFK)) {
				String propertyEntityName = null;
				propertyEntityName = f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1);
				// result = "get".concat(propertyEntityName);
				result = propertyEntityName;
				break;
			}

		}

		return result;
	}

	private String findPrimaryKey(Serializable objetoEntity) throws NoSuchMethodException, SecurityException,
			IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException {
		String result = null;
		List<Field> fields = new ArrayList<Field>();
		fields = this.getAllFields(fields, objetoEntity.getClass());
		for (Field f : fields) {
			if (f.getAnnotation(javax.persistence.Id.class) != null) {
				String propertyEntityName = null;
				propertyEntityName = f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1);
				// result = "get".concat(propertyEntityName);
				result = propertyEntityName;
				break;
			}

		}

		return result;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Serializable obtenerObjetoEntity(Long activoId, Class entity, String fieldActivo)
			throws InstantiationException, IllegalAccessException {
		Serializable objetoEntity;
		if (activoId != null) {
			objetoEntity = genericDao.get(entity, genericDao.createFilter(FilterType.EQUALS, fieldActivo, activoId));
		} else {
			objetoEntity = (Serializable) entity.newInstance();
		}
		if (objetoEntity == null) {
			objetoEntity = (Serializable) entity.newInstance();
		}
		return objetoEntity;
	}

	@SuppressWarnings("rawtypes")
	private Object getValue(Object dto, Class claseDto, String methodName)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException {
		Object obj = null;
		for (PropertyDescriptor propertyDescriptor : Introspector.getBeanInfo(InformeMediadorDto.class)
				.getPropertyDescriptors()) {
			if (propertyDescriptor.getReadMethod() != null
					&& propertyDescriptor.getReadMethod().getName().equals(methodName)) {
				obj = propertyDescriptor.getReadMethod().invoke(dto);
				break;
			}
		}
		return obj;
	}

}
