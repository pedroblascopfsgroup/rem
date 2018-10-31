package es.pfsgroup.plugin.rem.controller;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.controller.ActivoControllerDispachableMethods.DispachableMethod;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ActivoControllerDispatcher {
	
	private static final Log logger = LogFactory.getLog(ActivoControllerDispatcher.class);
	
	private ActivoController controller;

	public ActivoControllerDispatcher(ActivoController c) {
		if (c == null) {
			throw new IllegalArgumentException("NULL controller");
		}
		this.controller = c;
	}

	/*
	 * Testeado en es.pfsgroup.plugin.rem.test.controller.activoControllerDispatcher.DispatchSaveTests
	 */
	public void dispatchSave(JSONObject json) {
		if ((json != null) && !json.isEmpty()) {
			if (json.containsKey("id") && json.containsKey("models")) {
				Long id = json.getLong("id");
				JSONArray modelsArray = json.getJSONArray("models");
				if (!modelsArray.isEmpty()) {
					saveModels(id, modelsArray);
				}
				
			} else {
				throw new IllegalArgumentException("missing properties in json ('id' and 'models' are requiered)");
			}
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void saveModels(Long id, JSONArray modelsArray) {
		for (Object o : modelsArray) {
			JSONObject model = (JSONObject) o;
			if (o != null) {
				String modelName = model.getString("name");
				JSONObject modelData = model.getJSONObject("data");
				if (!Checks.esNulo(modelName) && !Checks.esNulo(modelData)) {
					ActivoControllerDispachableMethods methods = new ActivoControllerDispachableMethods(controller);
					DispachableMethod method = methods.findDispachableMethod(modelName);
					if (method != null) {
						method.execute(id, createFromJson(method.getArgumentType(), modelData));
					}
				}
			}
			
		}
	}

	/*
	 * Testeado en es.pfsgroup.plugin.rem.test.controller.activoControllerDispatcher.CreateFromJsonTests
	 */
	public static <T> T createFromJson(Class<T> clazz, JSONObject json) {
		T dto;
		try {
			dto = clazz.newInstance();
			for (Field f : getAllFields(new LinkedList<Field>(), clazz)) {
				if (json.containsKey(f.getName())) {
					f.setAccessible(true);
					f.set(dto, convertToType(f.getType(), json.get(f.getName())));
				}
			}
		} catch (Exception e) {
			logger.error("Cannot create " + clazz.getSimpleName() + " from JSON", e);
			throw new RuntimeException(e);
		}
		return dto;
	}

	private static Object convertToType(Class<?> type, Object object) {
		Object value = null;
		if (!Checks.esNulo(object)) {
			try {
				if (String.class.isAssignableFrom(type)) {
					value = object.toString();
				} else if (Date.class.isAssignableFrom(type)) {
					SimpleDateFormat formatter = new  SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
					if(!Checks.esNulo(object) && !Checks.esNulo(object.toString())) {
						value = (object instanceof Date) ? (Date) object : formatter.parse(object.toString());
					}
				}  else if (Integer.class.isAssignableFrom(type)) {
					value = Integer.parseInt(object.toString());
				} else if (Long.class.isAssignableFrom(type)) {
					value = Long.parseLong(object.toString());
				} else if (Boolean.class.isAssignableFrom(type)) {
					value = Boolean.parseBoolean(object.toString());
				} else if (Double.class.isAssignableFrom(type)) {
					value = Double.parseDouble(object.toString());
				}
			} catch (Exception e) {
				logger.warn("No se va a setear el valor", e);
			}
		}
		return value;
	}
	
	private static List<Field> getAllFields(List<Field> fields, Class<?> type) {
	    fields.addAll(Arrays.asList(type.getDeclaredFields()));

	    if (type.getSuperclass() != null) {
	        getAllFields(fields, type.getSuperclass());
	    }

	    return fields;
	}

}
