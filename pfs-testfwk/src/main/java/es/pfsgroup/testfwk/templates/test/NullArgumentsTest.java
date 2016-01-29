package es.pfsgroup.testfwk.templates.test;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javax.management.RuntimeErrorException;

import org.junit.Assert;

public class NullArgumentsTest implements TestTemplate {
	private Object testObject;
	private String testMethod;
	private Class<?>[] types;

	public NullArgumentsTest(Object testObject, String testMethod,
			Class<?>... types) {
		if ((types == null) || (types.length == 0)) {
			throw new IllegalArgumentException(testMethod
					.concat(": Debe recibir almenos un argumento"));
		}
		if (testObject == null) {
			throw new IllegalArgumentException("testObject: es null");
		}
		if (testMethod == null) {
			throw new IllegalArgumentException("testMethod:  es null");
		}
		this.testObject = testObject;
		this.testMethod = testMethod;
		this.types = types;

	}

	public void run() {
		try {
			Object[] args = new Object[types.length];
			for (int i = 0; i < types.length; i++) {
				args[i] = null;
			}
			Method m = testObject.getClass().getMethod(testMethod, types);
			m.invoke(testObject, args);
			Assert.fail(m.toString().concat(
					": Se debería haber lanzado una IllegalArgumentException"));
		} catch (IllegalArgumentException iae) {
		} catch (InvocationTargetException e) {
			if (! (e.getCause() instanceof IllegalArgumentException)) {
				throw new RuntimeException(
						"No se ha lanzado la excpeción esperada", e.getCause());
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

}
