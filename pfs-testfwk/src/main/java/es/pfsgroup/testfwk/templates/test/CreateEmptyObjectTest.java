package es.pfsgroup.testfwk.templates.test;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

import org.junit.Assert;

public class CreateEmptyObjectTest<T> implements TestTemplate {

	private Object factoryObject;

	private Method factoryMethod;

	public CreateEmptyObjectTest(Object factoryObject, String factoryMethod) {
		if (factoryObject == null) {
			throw new IllegalArgumentException(
					"factoryObject: no puede ser null");
		}
		if (factoryMethod == null) {
			throw new IllegalArgumentException(
					"factoryMethod: no puede ser null");
		}
		
		this.factoryObject = factoryObject;

		try {
			this.factoryMethod = factoryObject.getClass().getMethod(
					factoryMethod, null);
		} catch (Exception e) {
			throw new IllegalArgumentException(factoryObject.getClass()
					.getName().concat(".").concat(factoryMethod).concat("()")
					.concat(": No se ha podido acceder al método"));
		}
	}

	public void run() {
		try {
			T object = (T) factoryMethod.invoke(factoryObject, null);
			Assert.assertNotNull(factoryMethod.toString().concat(": ha devuelto NULL"),object);
			for (Field f : object.getClass().getDeclaredFields()) {
				f.setAccessible(true);
				if (!Modifier.isStatic(f.getModifiers())) {
					Assert
							.assertNull(object.toString().concat("[").concat(
									f.getName().concat("]: no es NULL")), f
									.get(object));
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

}
