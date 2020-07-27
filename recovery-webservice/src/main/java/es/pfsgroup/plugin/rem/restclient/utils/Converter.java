package es.pfsgroup.plugin.rem.restclient.utils;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataTypeParseException;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.rest.dto.CodigoCarterasDto;

public class Converter {

	private static final Log logger = LogFactory.getLog(Converter.class);

	/**
	 * Inserta todos los valores de un determinado DTO en un MAP
	 * 
	 * @param dto
	 * @return Siempre devuelve un MAP, aunque el DTO sea NULL
	 */
	@SuppressWarnings("rawtypes")
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
							NestedDto nested = f.getAnnotation(NestedDto.class);
							if (nested == null) {
								DecimalDataTypeFormat format = f.getAnnotation(DecimalDataTypeFormat.class);
								if (format != null) {

									val = WebcomDataType.valueOf(val, format);
								}
								map.put(f.getName(), val);
							} else {
								if (Iterable.class.isAssignableFrom(val.getClass())) {
									// Si val es algo iterable.
									if(f.getName().equals("arrCodCarteraAmbito") && ((CodigoCarterasDto)((ArrayList) val).get(0)).getCodCartera().getValue() == null) {
										map.put(f.getName(), ((CodigoCarterasDto)((ArrayList) val).get(0)).getCodCartera());
									}else {
										ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
										for (Object o : ((Iterable) val)) {
											list.add(dtoToMap(o));
										}
										map.put(f.getName(), list);
									}
								} else {
									// Si val es un único objeto
									map.put(f.getName(), dtoToMap(val));
								}
							}
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
	@SuppressWarnings({ "rawtypes", "unchecked" })
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
					try{
						f.set(objectToUpdate, WebcomDataType.parse(type, data));
					}catch(Exception e){
						e.printStackTrace();
					}
				} else {
					NestedDto nested = f.getAnnotation(NestedDto.class);
					if (nested == null) {
						f.set(objectToUpdate, data);
					} else {
						Class subDtoClass = nested.type();
						if (data != null) {
							// Si el DTO espera un DTO anidado
							if (List.class.isAssignableFrom(type)) {
								// Si el campo del DTO es una List, nos
								// aseguramos que el data también lo sea.
								
								
								if (Iterable.class.isAssignableFrom(data.getClass())) {

									Iterable iterable = (Iterable) data;
									List<Object> list = createList(iterable, subDtoClass,
											equivalence);
									f.set(objectToUpdate, list);

								} else {
									throw new ConverterError(
											"No se ha podido setear la colección: tipos incompatibles [esperado: "
													+ type + ", actual: " + data.getClass());
								}
								
								
							} else {
								// Si el campo del DTO es un simple objeto.
								
								if (Map.class.isAssignableFrom(data.getClass())) {
									Object dto = type.newInstance();
									updateObjectFromHashMap((Map) data, dto, equivalence);
									f.set(objectToUpdate, dto);
								} else {
									throw new ConverterError("No se ha podido poblar el sub-dto. Se esperaba un map: "
											+ data.getClass());
								}

							}
						} // fin check data is null

					}
				}

				// checked exception to unchecked exceptions -> JOKE
				// (Jorge Martín nos explicará esta broma algún día)
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
				throw new ConverterError("Error en updateObjectFromHashMap", e);
			} catch (SecurityException e) {
				e.printStackTrace();
				throw new ConverterError("Error en updateObjectFromHashMap", e);
			} catch (NoSuchFieldException e) {
				e.printStackTrace();
				throw new ConverterError("Error en updateObjectFromHashMap", e);
			} catch (IllegalAccessException e) {
				e.printStackTrace();
				throw new ConverterError("Error en updateObjectFromHashMap", e);
			} catch (InstantiationException e) {
				e.printStackTrace();
				throw new ConverterError("Error al poblar un DTO anidado", e);
			}
		}

		return objectToUpdate;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private static List<Object> createList(Iterable data, Class subDtoClass,
			Map<String, String> equivalence) throws InstantiationException, IllegalAccessException {
		ArrayList<Object> list = new ArrayList<Object>();
		for (Object o : data) {
			if (Map.class.isAssignableFrom(o.getClass())) {
				Object dto = subDtoClass.newInstance();
				Map map = (Map) o;
				updateObjectFromHashMap(map, dto, equivalence);
				list.add(dto);
			} else {
				throw new ConverterError("No se pa podido poblar el DTO: se esperaba un Map [" + o.getClass() + "]");
			}
		}
		return list;
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
			throw new ConverterError("No found field: " + field + " on class: " + clazz);
		}

		return f;
	}
}
