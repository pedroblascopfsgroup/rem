package es.pfsgroup.plugin.rem.restclient.utils;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataType;

public class Converter {

	private static final Log logger = LogFactory.getLog(Converter.class);

	/**
	 * Inserta todos los valores de un determinado DTO en un MAP
	 * 
	 * @param dto
	 * @return Siempre devuelve un MAP, aunque el DTO sea NULL
	 */
	public static Map<String, Object> dtoToMap(Object dto) {

		HashMap<String, Object> map = new HashMap<String, Object>();
		if (dto != null) {
			Field[] fields = dto.getClass().getDeclaredFields();
			if (fields != null) {
				try {
					for (Field f : fields) {
						f.setAccessible(true);

						Object val = f.get(dto);
						if (val != null) {
							map.put(f.getName(), val);
						}

					}
				} catch (IllegalArgumentException e) {
					logger.error("No se puede transformar el Dto a un Map: [" + dto.toString() + "]", e);
					throw new ConverterError(dto, e);
				} catch (IllegalAccessException e) {
					logger.error("No se puede transformar el Dto a un Map: [" + dto.toString() + "]", e);
					throw new ConverterError(dto, e);
				}
			}
		}
		return map;
	}

	/**
	 * 
	 * @param values
	 * @param objectToUpdate
	 * @param equivalence
	 *            (KEY campo del json - VALUE campo de la clase)
	 * @return
	 */
	public static Object updateObjectFromHashMap(Map<String, Object> values, Object objectToUpdate,
			Map<String, String> equivalence) {

		Class<? extends Object> clazz = objectToUpdate.getClass();

		for (String field : values.keySet()) {
			try {
				Object data = values.get(field);

				Field f = getFieldToUpdate(equivalence, clazz, field);
				f.set(objectToUpdate, data);

				// checked exception to unchecked exceptions -> JOKE
			} catch (IllegalArgumentException e) {
				throw new RuntimeException(e);
			} catch (SecurityException e) {
				throw new RuntimeException(e);
			} catch (NoSuchFieldException e) {
				throw new RuntimeException(e);
			} catch (IllegalAccessException e) {
				throw new RuntimeException(e);
			}
		}

		return objectToUpdate;
	}

	private static Field getFieldToUpdate(Map<String, String> equivalence, Class<? extends Object> clazz, String field)
			throws NoSuchFieldException {
		Field f = null;

		if (equivalence != null && equivalence.containsKey(field)) {
			f = clazz.getField(equivalence.get(field));
		} else {
			f = clazz.getField(field);
		}

		if (f == null) {
			throw new RuntimeException("No found field: " + field + " on class: " + clazz);
		}

		return f;
	}
}
