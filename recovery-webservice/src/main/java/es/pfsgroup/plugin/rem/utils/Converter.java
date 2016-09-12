package es.pfsgroup.plugin.rem.utils;

import java.lang.reflect.Field;
import java.util.Map;

public class Converter {

	/**
	 * 
	 * @param values
	 * @param objectToUpdate
	 * @param equivalence (KEY campo del json - VALUE campo de la clase)
	 * @return
	 */
	public static Object updateObjectFromHashMap(Map<String, Object> values, Object objectToUpdate, Map<String, String> equivalence) {

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

	private static Field getFieldToUpdate(Map<String, String> equivalence, Class<? extends Object> clazz, String field) throws NoSuchFieldException {
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
