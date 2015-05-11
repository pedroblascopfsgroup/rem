package es.pfsgroup.commons.utils.bo;

import java.lang.reflect.Method;
import java.util.Map;

import net.sf.cglib.proxy.Callback;
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;
import net.sf.cglib.transform.impl.InterceptFieldCallback;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * Sobreescritor de BusinessOperations.
 * 
 * @author bruno
 * 
 * @param <T>Parent Manager Api. Interfaz que define las BO del Parent Manager
 */
public abstract class BusinessOperationOverrider<T> implements
		ApplicationContextAware {

	public class APIInterceptor implements Callback, MethodInterceptor{
		Object manager;

		public APIInterceptor(Object bean) {
			manager = bean;
		}

		@Override
		public Object intercept(Object obj, Method method, Object[] parameters,
				MethodProxy arg3) throws Throwable {
			Method m = manager.getClass().getDeclaredMethod(method.getName(),
					method.getParameterTypes());

			return m.invoke(manager, parameters);
		}

	}

	private ApplicationContext applicationContext;

	private Class<T> clazz;

	@SuppressWarnings("unchecked")
	public BusinessOperationOverrider() {
		clazz = (Class<T>) this.getClass();
	}

	@Override
	public void setApplicationContext(ApplicationContext ctx)
			throws BeansException {
		this.applicationContext = ctx;
	}

	/**
	 * Nombre del Spring Bean correspondiente al Parent Manager
	 * 
	 * @return
	 */
	public abstract String managerName();

	/**
	 * Parent Manager.
	 * <p>
	 * A través de este método podemos acceder al Parent Manger
	 * </p>
	 * 
	 * @return
	 */
	protected final T parent() {
		Object bean = applicationContext.getBean(managerName());
		
		
		
		return (T) Enhancer.create(clazz, new APIInterceptor(bean));
	}
	
}
