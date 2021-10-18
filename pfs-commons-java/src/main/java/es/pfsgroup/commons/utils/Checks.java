package es.pfsgroup.commons.utils;

import java.util.Map;
import java.util.Set;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

/**
 * Clase de ayuda para realizar determinadas comprobaciones rutinarias
 * 
 * @author bruno
 * 
 */
public class Checks {
	
	public static final SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	public static final String FECHA_1970 = "1970-01-01";

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
	
	public static boolean isFechaNula(Object valor) {
		String s = null;
		if (valor instanceof String){
			s = (String) valor;
			return StringUtils.isBlank(s);
		}else if (valor instanceof Date) {
			s = ft.format((Date)valor);
			return (valor == null || FECHA_1970.equals(s));
		}else{
			return (valor == null);
		}
	}

}
