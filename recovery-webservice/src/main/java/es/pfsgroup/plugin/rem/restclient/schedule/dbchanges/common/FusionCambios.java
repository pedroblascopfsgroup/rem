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
public class FusionCambios implements Iterable<Map<String, Object>> {

	private List<String> containers = new ArrayList<String>();

	private Map<Integer, Map<String, Object>> data = new HashMap<Integer, Map<String, Object>>();

	private String groupByField;

	/**
	 * Crea una instancia del fusionador
	 * 
	 * @param containers
	 *            Colección de objetos {@link Field} que esperan contener los
	 *            DTOs anidados.
	 *            <p>
	 *            <strong>Deben ser instancias de java.util.List</strong>
	 *            <p>
	 */
	public FusionCambios(List<Field> containers) {
		if (containers == null) {
			throw new IllegalArgumentException("'containers' no puede se NULL");
		}
		for (Field container : containers) {
			NestedDto annotation = container.getAnnotation(NestedDto.class);
			if (annotation == null) {
				throw new IllegalArgumentException("Debe estar anotado con @NestedDto: " + container.toString());
			}
			if (groupByField == null) {
				groupByField = annotation.groupBy();
			}

			this.containers.add(container.getName());
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void addDataMap(Map<String, Object> datos) {
		if (datos != null) {
			Object groupValue = datos.get(groupByField);
			if (groupValue == null) {
				throw new FusionCambiosError("No se ha encontrado la clave '" + groupByField + "' en " + datos);
			}
			// Obtenemos o creamos el map principal
			Map<String, Object> globalMainMap = this.data.get(groupValue.hashCode());

			// Contenedor de nestedMaps locales. Añadiremos los nestedMaps a
			// this.data al final, si no están vacíos..
			Map<String, Map<String, Object>> localNestedMaps = new HashMap<String, Map<String, Object>>();
			if (globalMainMap == null) {
				globalMainMap = new HashMap<String, Object>();
				for (String container : containers) {
					globalMainMap.put(container, new ArrayList<Map<String, Object>>());
				}
				this.data.put(groupValue.hashCode(), globalMainMap);
			}

			// Poblamos el map principal y los anidados
			for (Entry<String, Object> e : datos.entrySet()) {
				String[] split = e.getKey().split("\\.");
				if (split.length == 1) {
					globalMainMap.put(e.getKey(), e.getValue());
				} else {
					// Guardamos el valor localmente. Obtenemos o creamos el
					// nestedMap local
					Map<String, Object> localMap = localNestedMaps.get(split[0]);
					if (localMap == null) {
						localMap = new HashMap<String, Object>();
						localNestedMaps.put(split[0], localMap);
					}
					localMap.put(split[1], e.getValue());
				}
			}

			// Guardamos los nestedMaps locales en el mainMap global, si no
			// están vacíos
			for (Entry<String, Map<String, Object>> e : localNestedMaps.entrySet()) {
				Map<String, Object> localNestedMap = e.getValue();
				if (!localNestedMap.isEmpty()) {
					((List) globalMainMap.get(e.getKey())).add(localNestedMap);
				}
			}
		}
	}

	@Override
	public Iterator<Map<String, Object>> iterator() {
		return this.data.values().iterator();
	}

	public boolean contieneDatos() {
		return !this.data.isEmpty();
	}
}
