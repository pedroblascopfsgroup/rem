package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;

/**
 * Fusionador de {@link CambioBD}
 * <p>
 * Si usamos DTO's anidados (que contienen la anotación @NestedDto), estos deben
 * poblarse a partir de un Map(String, Object) que contenga una estructura
 * anidada. Esta clase es capaz de producir esos Maps
 * </p>
 * 
 * @author bruno
 *
 */
public class FusionCambios implements Iterable<Map<String, Object>>{

	private String groupByField;
	
	private String containerFieldName;

	private Map<Integer, Map<String, Object>> data = new HashMap<Integer, Map<String, Object>>();

	/**
	 * Crea una instancia del fusionador
	 * 
	 * @param groupContainer
	 *            Field que espera contener los DTOs anidados.
	 *            <p>
	 *            <strong>Debe ser una instancia de java.util.List</strong>
	 *            <p>
	 */
	public FusionCambios(Field groupContainer) {
		if (groupContainer == null){
			throw new IllegalArgumentException("'groupContainer' no puede se NULL");
		}
		this.containerFieldName = groupContainer.getName();
		
		NestedDto annotation = groupContainer.getAnnotation(NestedDto.class);
		if (annotation == null) {
			throw new IllegalArgumentException("Debe estar anotado con @NestedDto: " + groupContainer.toString());
		}

		this.groupByField = annotation.groupBy();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void addDataMap(Map<String, Object> datos) {
		if (datos != null) {
			Object groupValue = datos.get(groupByField);
			if (groupValue == null) {
				throw new FusionCambiosError("No se ha encontrado la clave '" + groupByField + "' en " + datos);
			}
			// Obtenemos o creamos el map principal
			Map<String, Object> mainMap = this.data.get(groupValue.hashCode());
			if (mainMap == null) {
				mainMap = new HashMap<String, Object>();
				mainMap.put(containerFieldName, new ArrayList<Map<String, Object>>());
				this.data.put(groupValue.hashCode(), mainMap);
			}

			// Creamos el mapa anidado
			Map<String, Object> nestedMap = new HashMap<String, Object>();

			// Poblamos el map principal y el anidado
			for (Entry<String, Object> e : datos.entrySet()) {
				String[] split = e.getKey().split("\\.");
				if (split.length == 1) {
					mainMap.put(e.getKey(), e.getValue());
				} else {
					nestedMap.put(split[1], e.getValue());
				}
			}

			// Anidamos los maps
			((List) mainMap.get(containerFieldName)).add(nestedMap);
		}
	}

	@Override
	public Iterator<Map<String, Object>> iterator() {
		return this.data.values().iterator();
	}

	public boolean contieneDatos() {
		return ! this.data.isEmpty();
	}

}
