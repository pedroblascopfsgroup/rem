package es.pfsgroup.plugin.rem.restclient.utils;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.UnknownWebcomDataTypeException;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataTypeParseException;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;

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
							
							DecimalDataTypeFormat format = f.getAnnotation(DecimalDataTypeFormat.class);
							if (format != null) {
								
								val = WebcomDataType.valueOf(val, format);
							}
							map.put(f.getName(), val);
						}

					}
				} catch (IllegalArgumentException e) {
					logger.error("No se puede transformar el Dto a un Map: [" + dto.toString() + "]", e);
					throw new ConverterError(dto, e);
				} catch (IllegalAccessException e) {
					logger.error("No se puede transformar el Dto a un Map: [" + dto.toString() + "]", e);
					throw new ConverterError(dto, e);
				} catch (WebcomDataTypeParseException e) {
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
				f.setAccessible(true);
				Class type = f.getType();
				if (WebcomDataType.class.isAssignableFrom(type)) {
					f.set(objectToUpdate, WebcomDataType.parse(type, data));
				} else {
					f.set(objectToUpdate, data);
				}

				// checked exception to unchecked exceptions -> JOKE
			} catch (IllegalArgumentException e) {
				throw new RuntimeException(e);
			} catch (SecurityException e) {
				throw new RuntimeException(e);
			} catch (NoSuchFieldException e) {
				throw new RuntimeException(e);
			} catch (IllegalAccessException e) {
				throw new RuntimeException(e);
			} catch (WebcomDataTypeParseException e) {
				throw new RuntimeException(e);
			} catch (UnknownWebcomDataTypeException e) {
				throw new RuntimeException(e);
			}
		}

		return objectToUpdate;
	}

	private static Field getFieldToUpdate(Map<String, String> equivalence, Class<? extends Object> clazz, String field)
			throws NoSuchFieldException {
		Field f = null;

		if (equivalence != null && equivalence.containsKey(field)) {
			f = clazz.getDeclaredField(equivalence.get(field));
		} else {
			f = clazz.getDeclaredField(field);
		}

		if (f == null) {
			throw new RuntimeException("No found field: " + field + " on class: " + clazz);
		}

		return f;
	}
}
