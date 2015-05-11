package es.pfsgroup.commons.utils.web.dto.dynamic;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import net.sf.cglib.proxy.Callback;
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.Checks;

public class DynamicDTO<T> implements Callback, MethodInterceptor {

	public class ObjectMapper implements Callback, MethodInterceptor {

		private final Object src;

		public ObjectMapper(Object src, Class<?> returnType) {
			super();
			this.src = src;
		}

		@Override
		public Object intercept(Object proxy, Method method, Object[] args,
				MethodProxy arg3) throws Throwable {
			try {
				Method m = src.getClass().getDeclaredMethod(method.getName(),
						method.getParameterTypes());
				if (m == null)
					return null;
				Object o = m.invoke(src, args);
				if (o == null) {
					return null;
				} else if ((!isComplexType(o.getClass()))
						|| o.getClass()
								.isAssignableFrom(method.getReturnType())) {
					return o;
				} else {
					return createObjectMapper(method.getReturnType(), o);
				}
			} catch (NoSuchMethodException e) {
				return null;
			}
		}

	}

	public class MapSearch implements Callback, MethodInterceptor {
		private final String name;

		public MapSearch(String name, Class<?> returnType) {
			this.name = name;
		}

		@Override
		public Object intercept(Object proxy, Method method, Object[] args,
				MethodProxy arg3) throws Throwable {
			String property = name + "." + propertyName(method);
			Object value = getValue(property);
			if (value != null) {
				return value;
			}
			if (isComplexType(property, getMap(), method.getReturnType())) {
				return createMapSearch(property, method.getReturnType());
			} else {
				return null;
			}
		}

	}

	private enum SType {
		MAP, REQUEST
	}

	private Class<T> type;
	private SType stype = SType.MAP;
	private Map<String, Object> map = new HashMap<String, Object>();
	private WebRequest request;

	public DynamicDTO(Class<T> type) {
		this.type = type;
	}

	public DynamicDTO<T> put(String key, Object value) {
		this.map.put(key, value);
		return this;
	}

	public DynamicDTO<T> putAll(Object o) {

		ObjectPropertyScanner ops = new ObjectPropertyScanner(o);
		try {
			ops.scanInto(getMap());
		} catch (Exception e) {
			throw new DynamicDTOException("ERROR", e);
		}
		return this;
	}

	public T create(final WebRequest request) {
		if (request != null) {
			this.stype = SType.REQUEST;
			this.request = request;
		}
		return this.create();
	}

	public T create(Map<String, Object> map) {
		this.map = map;
		return this.create();
	}

	@SuppressWarnings("unchecked")
	public T create() {
		if (type.isInterface()) {
			Class<T>[] interfaces = new Class[] { type };
			return (T) Enhancer.create(null, interfaces, this);
		} else {
			return (T) Enhancer.create(type, type.getInterfaces(), this);
		}
	}

	@Override
	public Object intercept(Object proxy, Method method, Object[] args,
			MethodProxy arg3) throws Throwable {
		String name = propertyName(method);
		Object value = this.getValue(name);
		if (value != null) {
			return convertValue(method.getReturnType(), this.getValue(name));
		}

		if (isComplexType(name, getMap(), method.getReturnType())) {
			return createMapSearch(name, method.getReturnType());
		} else {
			return null;
		}
	}

	private String propertyName(Method method) {
		String name = method.getName();
		if (name.startsWith("get")) {
			name = name.replaceFirst("get", "");
		} else if (name.startsWith("is")) {
			name = name.replaceFirst("is", "");
		} else {
			return null;
		}

		String i = name.substring(0, 1);
		name = name.replaceFirst(i, i.toLowerCase());
		return name;
	}

	@SuppressWarnings("unchecked")
	private Object createMapSearch(String name, Class<?> returnType) {
		if (returnType.isInterface()) {
			Class<T>[] interfaces = new Class[] { returnType };
			return (T) Enhancer.create(null, interfaces, new MapSearch(name,
					returnType));
		} else {
			return (T) Enhancer.create(returnType, returnType.getInterfaces(),
					new MapSearch(name, returnType));
		}
	}

	@SuppressWarnings("unchecked")
	private Object createObjectMapper(Class<?> returnType, Object object) {
		if (returnType.isInterface()) {
			Class<T>[] interfaces = new Class[] { returnType };
			return (T) Enhancer.create(null, interfaces, new ObjectMapper(
					object, returnType));
		} else {
			return (T) Enhancer.create(returnType, returnType.getInterfaces(),
					new ObjectMapper(object, returnType));
		}
	}

	private Object convertValue(Class<?> returnType, Object object) {
		if (object == null) {
			return null;
		}

		Class<?> objectType = object.getClass();
		try {
			if (returnType.equals(objectType)) {
				return object;
			} else if (String.class.equals(returnType)) {
				return object.toString();
			} else if (Integer.class.equals(returnType)
					|| (Integer.TYPE.equals(returnType))) {
				return Integer.parseInt(object.toString());
			} else if (Long.class.equals(returnType)
					|| (Long.TYPE.equals(returnType))) {
				return Long.parseLong(object.toString());
			} else if (Float.class.equals(returnType)
					|| Float.TYPE.equals(returnType)) {
				return Float.parseFloat(object.toString());
			} else if (Double.class.equals(returnType)
					|| Double.TYPE.equals(returnType)) {
				return Double.parseDouble(object.toString());
			} else if (Boolean.class.equals(returnType)
					|| Boolean.TYPE.equals(returnType)) {
				return Boolean.parseBoolean(object.toString());
			} else if (BigDecimal.class.equals(returnType)) {
				return new BigDecimal(object.toString());
			} else {
				return valueObject(returnType, object);
			}
		} catch (DynamicDTOException e) {
			throw e;
		} catch (Exception e) {
			throw new DynamicDTOException("Error converting "
					+ object.getClass().getName() + " to "
					+ returnType.getClass().getName(), e);
		}
	}

	private Object valueObject(Class<?> returnType, Object object) {
		if (object == null)
			return null;
		if (object.getClass().isAssignableFrom(returnType)) {
			return object;
		} else {
			return createObjectMapper(returnType, object);
		}
	}

	static boolean isComplexType(Class<?> returnType) {
		return isComplexType(null, null, returnType, true);
	}

	static boolean isComplexType(String name, Map<String, Object> map,
			Class<?> returnType) {
		return isComplexType(name, map, returnType, false);
	}

	private static boolean isComplexType(String name, Map<String, Object> map,
			Class<?> returnType, boolean defaultValue) {
		boolean simpleType = returnType.isPrimitive()
				|| returnType.getName().startsWith("java.lang")
				|| returnType.getName().startsWith("java.util")
				|| BigDecimal.class.equals(returnType);
		return !simpleType && containValues(name, map, defaultValue);
	}

	private static boolean containValues(String name, Map<String, Object> map,
			boolean defaultValue) {
		if (Checks.esNulo(name) || Checks.estaVacio(map))
			return defaultValue;
		for (String key : map.keySet()) {
			if (key.startsWith(name))
				return true;
		}
		return false;
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getMap() {
		switch (this.stype) {
		case REQUEST:
			return this.request.getParameterMap();
		default:
			return this.map;
		}
	}

	private Object getValue(String key) {
		switch (this.stype) {
		case REQUEST:
			return this.request.getParameter(key);
		default:
			return this.map.get(key);
		}
	}

}
