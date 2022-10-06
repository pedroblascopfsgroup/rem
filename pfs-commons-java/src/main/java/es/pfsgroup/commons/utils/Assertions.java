package es.pfsgroup.commons.utils;

import java.util.List;

/**
 * Comprobaciones estándares que lanzan excepciones estándares.
 * @author bruno
 *
 */
public class Assertions {
	
	/**
	 * Lanza una IllegalArgumentException si el objeto es NULL.
	 * 
	 * @param o Objeto a testear
	 * @param msg Mensaje de error de la excepción. Si es NULL el mensaje será el estándar.
	 */
	public static void assertNotNull(Object o, String msg) throws IllegalArgumentException{
		if (Checks.esNulo(o)){
			if (msg != null){
				throw new IllegalArgumentException(msg);	
			}else{
				throw new IllegalArgumentException("El parámetro no puede ser NULL");
			}
			
		}
	}
	
	/**
	 * Lanza una IllegalArgumentException si la List<T> esta VACÍA.
	 * 
	 * @param oList List<T> a testear
	 * @param msg Mensaje de error de la excepción. Si es NULL el mensaje será el estándar.
	 */
	public static <T> void assertNotEmptyList(List<T> oList, String msg) throws IllegalArgumentException {
		if (Checks.estaVacio(oList)) {
			if (msg != null) {
				throw new IllegalArgumentException(msg);	
			} else {
				throw new IllegalArgumentException("El parámetro no puede estar VACÍO");
			}
			
		}
	}

}
