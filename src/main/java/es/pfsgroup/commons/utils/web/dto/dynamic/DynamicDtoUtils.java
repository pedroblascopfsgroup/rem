package es.pfsgroup.commons.utils.web.dto.dynamic;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.Checks;

public class DynamicDtoUtils {
	
	public static <T> T create(final Class<T> clazz, final Object src){
		final DynamicDTO<T> d = new DynamicDTO<T>(clazz);
		d.putAll(src);
		return d.create();
	}
	
	public static <T> T create(final Class<T> clazz, final Map<String,Object> map){
		final DynamicDTO<T> d = new DynamicDTO<T>(clazz);
		return d.create(map);
	}
	
	public static <T> T create(final Class<T> clazz, final WebRequest request){
		final HashMap<String, Object> params = new HashMap<String, Object>();
		if (request != null){
		    @SuppressWarnings("unchecked")
            final Map<String,String[]> parameters = request.getParameterMap();
		    String key;
		    String param;
			for (@SuppressWarnings("rawtypes") Entry e : parameters.entrySet()){
					key = e.getKey().toString();
					String[] value = (String[]) e.getValue();
					param = value[0];
					if (!Checks.esNulo(param)){
						params.put(key, param);
					}
			}
		}
		return create(clazz,params);
	}

}
