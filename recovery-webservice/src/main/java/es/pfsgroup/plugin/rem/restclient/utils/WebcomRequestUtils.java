package es.pfsgroup.plugin.rem.restclient.utils;

import java.lang.reflect.Field;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import net.sf.json.JSONArray;
import net.sf.json.JSONNull;
import net.sf.json.JSONObject;

public class WebcomRequestUtils {

	public static final String JSON_PROPERTY_DATA = "data";

	public static final String JSON_PROPERTY_ID = "id";

	private static final Log logger = LogFactory
			.getLog(WebcomRequestUtils.class);

	private static final String DATETIME_FORMAT = "yyyy-MM-dd'T'hh:mm:ss";

	public static JSONObject createRequestJson(ParamsList paramsList) {
		JSONArray dataArray = new JSONArray();

		for (Map<String, Object> params : paramsList) {
			JSONObject data = createJSONData(params);
			dataArray.add(data);
		}

		JSONObject json = new JSONObject();
		json.put(JSON_PROPERTY_ID, computeRequestId());
		json.put(JSON_PROPERTY_DATA, dataArray);
		return json;
	}

	public static JSONObject createJSONData(Map<String, Object> params) {
		JSONObject data = new JSONObject();
		if (params != null) {
			for (Entry<String, Object> e : params.entrySet()) {
				if (e.getValue() != null) {
					if (!Collection.class.isAssignableFrom(e.getValue()
							.getClass())) {
						// Añadimos un valor simple
						data.put(e.getKey(),
								convertToStringIfNecessary(e.getValue()));
					} else {
						// Añadimos un list de datas
						JSONArray array = new JSONArray();
						for (Object o : ((Collection) e.getValue())) {
							if (Map.class.isAssignableFrom(o.getClass())) {
								JSONObject json = createJSONData((Map) o);
								if (!array.contains(json)) {
									array.add(json);
								}
							}
						}
						data.put(e.getKey(), array);
					}
				}
			}
		}
		return data;
	}

	private static String computeRequestId() {
		long timestamp = ((Date) new Date()).getTime();
		int threadId = Math.abs(Thread.currentThread().getName().hashCode());
		int rnd = ((Random) new Random()).nextInt(100);
		return timestamp + "" + threadId + "" + rnd;
	}

	public static String formatDate(Date date) {
		SimpleDateFormat f = new SimpleDateFormat(DATETIME_FORMAT);
		return f.format(date);
	}

	public static Date parseDate(String string) throws ParseException {
		SimpleDateFormat f = new SimpleDateFormat(DATETIME_FORMAT);
		return f.parse(string);
	}

	/**
	 * Busca un elemento en un Array devolviendo su posición. De un modo
	 * ineficiente pero sirve para arrays pequeños porque no hace falta que
	 * estén ordenados.
	 * <p>
	 * <strong>Si no encuentra el valor devuelve un número negativo</strong>
	 * </p>
	 * 
	 * <p>
	 * <i>La ineficiencia me la pela</i>
	 * </p>
	 * 
	 * @param array
	 * @param valor
	 * @return
	 */
	public static int buscarEnArray(String[] array, String valor) {
		String c = valor.trim();
		for (int i = 0; i < array.length; i++) {
			if (c.equals(array[i])) {
				return i;
			}
		}
		return -1;
	}

	/**
	 * Devuelve una lista de campos marcados como obligatorios mediante la
	 * anotacion @WebcomRequired en el DTO.
	 * 
	 * <p>
	 * Este método soporta DTO's anidados siempre y cuando usemos la anotación @NestedDto
	 * en la referencia al SubDto.
	 * </p>
	 * 
	 * @param dto
	 * @return
	 */
	public static String[] camposObligatorios(Class dtoClass) {
		ArrayList<String> result = new ArrayList<String>();
		Field[] fields = dtoClass.getDeclaredFields();
		if (fields != null) {
			for (Field f : fields) {

				NestedDto nested = f.getAnnotation(NestedDto.class);
				if (nested == null) {
					if (f.getAnnotation(WebcomRequired.class) != null) {
						result.add(f.getName());
					}
				} else {
					String[] nestedFields = camposObligatorios(nested.type());
					if (nestedFields != null) {
						for (String nf : nestedFields) {
							result.add(f.getName() + "." + nf);
						}
					}
				}
			}
		}

		return result.toArray(new String[] {});
	}

	private static Object convertToStringIfNecessary(Object value) {
		if (value != null) {

			Object valueOf = WebcomDataType.valueOf(value);
			if (valueOf != null) {
				if (valueOf instanceof Date) {
					return formatDate((Date) valueOf);
				} else if (valueOf instanceof Boolean) {
					return valueOf;
				} else {
					return valueOf.toString();
				}
			} else {
				return JSONNull.getInstance();
			}

		}
		return null;
	}

}
