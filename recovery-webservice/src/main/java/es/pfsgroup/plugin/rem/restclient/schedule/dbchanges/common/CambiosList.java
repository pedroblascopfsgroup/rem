package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;

public class CambiosList extends ArrayList<Object> {

	private static final String ERROR_AL_OBTENER_EL_VALOR_DEL_CAMPO = "Error al obtener el valor del campo";
	private static final long serialVersionUID = 5828089068727603743L;
	private transient final Log logger = LogFactory.getLog(getClass());
	private transient Paginacion paginacion = null;

	public CambiosList(Integer tamanyoBloque){
		setPaginacion(new Paginacion(tamanyoBloque));
	}
	
	public Paginacion getPaginacion() {
		return paginacion;
	}

	public void setPaginacion(Paginacion paginacion) {
		this.paginacion = paginacion;
	}
	
	
	
	@Override
	public boolean equals(Object o) {
		return super.equals(o);
	}

	@Override
	public int hashCode() {
		return super.hashCode();
	}

	@Override
	public int size() {
		int i = super.size();
		return i;
		/*if (! this.isEmpty()) {
			int count = 0;
			for (Object o : this.toArray()) {
				if (o instanceof WebcomRESTDto) {
					count += calculateSize((WebcomRESTDto) o);
				} else {
					count++;
				}
			}
			return count;
		} else {
			return 0;
		}*/
		
	}

	private int calculateSize(WebcomRESTDto dto) {
		List<Collection<Object>> nested = findNestedCollections(dto);
		
		if (!nested.isEmpty()) {
			int count = 1;
			for (Collection<Object> col : nested) {
				count *= col.isEmpty() ? 1 : col.size();
			}
			return count;
		} else {
			return 1;
		}
	}

	@SuppressWarnings("unchecked")
	private List<Collection<Object>> findNestedCollections(WebcomRESTDto dto) {
		ArrayList<Collection<Object>> collections = new ArrayList<Collection<Object>>();
		for (Field field : dto.getClass().getDeclaredFields()) {
			field.setAccessible(true);
			if (field.isAnnotationPresent(NestedDto.class) && (Collection.class.isAssignableFrom(field.getType()))){
				Collection<Object> value = null;
				try {
					value = (Collection<Object>) field.get(dto);
				} catch (RuntimeException e) {
					logger.debug(ERROR_AL_OBTENER_EL_VALOR_DEL_CAMPO, e);
				} catch (IllegalAccessException e) {
					logger.debug(ERROR_AL_OBTENER_EL_VALOR_DEL_CAMPO, e);
				}
				if (value != null) {
					collections.add(value);
				}
			}
		}
		return collections;
	}
}
