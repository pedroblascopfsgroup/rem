package es.pfsgroup.commons.utils.web.dto.dynamic;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Map;

class ObjectPropertyScanner {

	private Object src;

	public ObjectPropertyScanner(Object o) {
		src = o;
	}

	public void scanInto(Map<String, Object> map) throws Exception {
		scanInto(null, map);
	}

	private void scanInto(String path, Map<String, Object> map)
			throws Exception {
		if ((src != null) && (map != null)) {
			for (Method m : src.getClass().getDeclaredMethods()) {
				if (isGetter(m)) {
					m.setAccessible(true);
					String name = propertyName(path, m.getName());
					Object value = m.invoke(src);
					if (value != null) {
						if (DynamicDTO.isComplexType(name, map,m.getReturnType())) {
							ObjectPropertyScanner sc = new ObjectPropertyScanner(value);
							sc.scanInto(name, map);
						} else {
							map.put(name, value);
						}
					}
				}
			}
		}

	}

	private String propertyName(String path, String name) {
		String p = null;
		if (name.startsWith("get")) {
			p = name.replaceFirst("get", "");
		} else if (name.startsWith("is")) {
			p = name.replaceFirst("is", "");
		}
		if (p != null) {
			String i = p.substring(0, 1);
			p = p.replaceFirst(i, i.toLowerCase());
			if (path != null) {
				p = path + "." + p;
			}
		}
		return p;
	}

	private boolean isGetter(Method m) {
		if (Modifier.isStatic(m.getModifiers())) {
			return false;
		}
		if (!Modifier.isPublic(m.getModifiers())) {
			return false;
		}
		if (m.getParameterTypes().length > 0) {
			return false;
		}
		String name = m.getName();
		return (name != null)
				&& (name.startsWith("get") || name.startsWith("is"));
	}

}
