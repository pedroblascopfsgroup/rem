package es.pfsgroup.commons.utils;

import java.util.Map;
import java.util.Set;

import java.util.Collection;

import org.apache.commons.lang.StringUtils;

/**
 * Clase de ayuda para realizar determinadas comprobaciones rutinarias
 * 
 * @author bruno
 * 
 */
public class Checks {


	/**
	 * Comprueba si la colección está vacia o es nula
	 * 
	 * @param codsEntidad
	 * @return Devuelve verdadero si lo está.
	 */
	public static boolean estaVacio(Collection collection) {
		return (collection == null) || (collection.size() <= 0);
	}
	
	/**
	 * Comprueba si el mapa está vació o es nulo
	 * 
	 * @param codsEntidad
	 * @return Devuelve verdadero si lo está.
	 */
	public static boolean estaVacio(Map<?, ?> map) {
		return (map == null) || (map.isEmpty());
	}
	
	

	/**
	 * Comprueba si un valor es nulo.
	 * @param valor Valor a comprobar
	 * @return
	 */
	public static boolean esNulo(Object valor) {
		if (valor instanceof String){
			String s = (String) valor;
			return StringUtils.isBlank(s);
		}else{
			return (valor == null);
		}
		
	}

}
