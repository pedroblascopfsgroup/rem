package es.pfsgroup.plugin.rem.rest.api.impl;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.EntityDefinition;
import es.pfsgroup.plugin.rem.rest.api.DtoToEntityApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TRANSFORM_TYPE;
import es.pfsgroup.plugin.rem.rest.dao.impl.GenericaRestDaoImp;

@Service("dtoToEntity")
public class DtoToEntityImpl implements DtoToEntityApi {

	@Autowired
	private GenericaRestDaoImp genericaRestDaoImp;

	@Autowired
	private GenericABMDao genericDao;

	private final Log logger = LogFactory.getLog(getClass());

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

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Serializable obtenerObjetoEntity(Long idValue, Class entity, String fieldActivo)
			throws InstantiationException, IllegalAccessException {
		Serializable objetoEntity;
		if (idValue != null) {
			objetoEntity = genericDao.get(entity, genericDao.createFilter(FilterType.EQUALS, fieldActivo, idValue));
			if (objetoEntity == null) {
				objetoEntity = (Serializable) entity.newInstance();
			}
		} else {
			objetoEntity = (Serializable) entity.newInstance();
		}
		return objetoEntity;
	}

	/**
	 * Transforma la clase al tipo anotado
	 * 
	 * @param annotation
	 * @param claseObjeto
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	private Class transformClass(EntityDefinition annotation, Class claseObjeto) {
		if (annotation.transform().equals(TRANSFORM_TYPE.BOOLEAN_TO_INTEGER)) {
			claseObjeto = Integer.class;
		} else if (annotation.transform().equals(TRANSFORM_TYPE.FLOAT_TO_BIGDECIMAL)) {
			claseObjeto = BigDecimal.class;
		}else if(annotation.transform().equals(TRANSFORM_TYPE.DATE_TO_YEAR_INTEGER)){
			claseObjeto = Integer.class;
		}
		return claseObjeto;
	}

	/**
	 * Guarda un valor en el entity
	 * 
	 * @param propertyEntityName
	 * @param claseObjeto
	 * @param annotation
	 * @param oFiltro
	 * @param object
	 * @param objetoEntity
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	private boolean setProperty(String propertyEntityName, Class claseObjeto, EntityDefinition annotation,
			Object oFiltro, Object object, Serializable objetoEntity) {
		ArrayList<Serializable> objetoEntitys = new ArrayList<Serializable>();
		objetoEntitys.add(objetoEntity);
		return this.setProperty(propertyEntityName, claseObjeto, annotation, oFiltro, object, objetoEntitys);
	}

	/**
	 * Guarda un valor en el entity
	 * 
	 * @param propertyEntityName
	 * @param claseObjeto
	 * @param annotation
	 * @param oFiltro
	 * @param object
	 * @param objetoEntitys
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
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
					if (object instanceof Boolean) {
						if ((Boolean) object) {
							object = 1;
						} else {
							object = 0;
						}
					}else{
						logger.error("FAIL --------------->" + propertyEntityName + " no se puede pasar de Integer a Boolean");
					}
				} else if (annotation != null && annotation.transform().equals(TRANSFORM_TYPE.FLOAT_TO_BIGDECIMAL)) {
					object = new BigDecimal((Float) object);
				} else if (annotation != null && annotation.transform().equals(TRANSFORM_TYPE.DATE_TO_YEAR_INTEGER)) {
					object = Integer.valueOf(((Date)object).getYear());
				}

				int contador = 0;
				for (Serializable objetoEntity : objetoEntitys) {
					try {
						Method metodo = this.getMethod(objetoEntity, "set".concat(propertyEntityName), claseObjeto);
						if (metodo != null) {
							metodo.invoke(objetoEntity, object);
							resultado = true;
							contador++;
						}
					} catch (Exception e) {
						logger.error("FAIL --------------->" + propertyEntityName + " no se ha podido setear");
					}
				}
				if (!resultado && annotation == null) {
					logger.error("FAIL --------------->" + propertyEntityName + " no se ha podido setear");
				}
				if (contador > 1) {
					logger.error("WARN --------------->" + propertyEntityName + " seteada " + contador + " veces");
				}
			}
		} else if (annotation != null && !annotation.procesar()) {
			resultado = true;
			if (!annotation.motivo().isEmpty()) {
				logger.error("SKIP  --------------->"
						.concat(propertyEntityName.concat(" motivo: ").concat(annotation.motivo())));
			}
		}
		return resultado;

	}

	/**
	 * Obtiene un método ejecutable dado su nombre y su interface
	 * 
	 * @param clase
	 * @param nombreMetodo
	 * @param parametro
	 * @return
	 */
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

	/**
	 * Persiste una entidad
	 * 
	 * @param objetoEntitys
	 * @throws NoSuchMethodException
	 * @throws SecurityException
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 * @throws IntrospectionException
	 */
	private void guardarEntity(ArrayList<Serializable> objetoEntitys) throws NoSuchMethodException, SecurityException,
			IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException {
		for (Serializable objetoEntity : objetoEntitys) {
			logger.debug("Guardando..." + objetoEntity.getClass().getName());
			Serializable primaryKey = genericaRestDaoImp.save(objetoEntity);
			logger.debug("Exito..." + primaryKey.getClass().getName());
			String primaryKeFieldName = this.findPrimaryKey(objetoEntity);
			this.setProperty(primaryKeFieldName, primaryKey.getClass(), null, null, primaryKey, objetoEntity);
			this.setFk(objetoEntity, objetoEntitys);
		}

	}

	/**
	 * Setea los campos anatados como FK
	 * 
	 * @param objetoEntityFK
	 * @param objetoEntitys
	 */
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

	/**
	 * Obtiene todos los campos de una clase y sus superclases
	 * 
	 * @param fields
	 * @param type
	 * @return
	 */
	private List<Field> getAllFields(List<Field> fields, Class<?> type) {
		fields.addAll(Arrays.asList(type.getDeclaredFields()));

		if (type.getSuperclass() != null) {
			fields = this.getAllFields(fields, type.getSuperclass());
		}

		return fields;
	}

	/**
	 * Obtiene las FK
	 * 
	 * @param objetoEntity
	 * @param claseFK
	 * @return
	 */
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

	/**
	 * Obtiene la clave primaria de una entidad
	 * 
	 * @param objetoEntity
	 * @return
	 * @throws NoSuchMethodException
	 * @throws SecurityException
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 * @throws IntrospectionException
	 */
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

	/**
	 * Obtiene el valor de un campo de un dto
	 * 
	 * @param dto
	 * @param claseDto
	 * @param methodName
	 * @return
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 * @throws IntrospectionException
	 */
	@SuppressWarnings("rawtypes")
	private Object getValue(Object dto, Class claseDto, String methodName)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException {
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
