package es.pfsgroup.testfwk;

import java.lang.reflect.Field;

import es.pfsgroup.commons.utils.Assertions;


/**
 * Inyecta dependencias a un Objeto.
 * 
 * Es capaz de inyectar un objeto dentro de una variable privada de otro.
 * @author bruno
 *
 */
public class DInjector {

	private Object theObject;
	/**
	 * Crea un inyector capaz de inyectar objetos en variables privadas de otro.
	 * @param object Objeto al que queremos inyectar.
	 */
	public DInjector(Object object){
		Assertions.assertNotNull(object, "El objeto no puede ser NULL");
		theObject = object;
	}
	
	/**
	 * Inyecta un objeto dentro de otro.
	 * 
	 * @param property Propiedad en la que debe ser inyectado el objeto
	 * @param object Objeto a inyectar.
	 * 
	 * @throws RuntimeException Si se produce cualquier error al inyectar el objeto
	 */
	public void inject(String property, Object object){
		Assertions.assertNotNull(property, "El nombre de la propiedad no puede ser nulo");
		Assertions.assertNotNull(object, "El objeto a inyectar no puede ser nulo");
		
		Class clazz = theObject.getClass();
		try {
			Field f = clazz.getDeclaredField(property);
			boolean a = f.isAccessible();
			f.setAccessible(true);
			f.set(theObject, object);
			f.setAccessible(a);
		} catch (Exception e) {
			throw new RuntimeException(theObject.getClass().getName().concat(": No se ha podido inyectar el objeto"), e);
		}
	}
}
