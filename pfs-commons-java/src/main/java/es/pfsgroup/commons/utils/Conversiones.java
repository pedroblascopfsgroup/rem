package es.pfsgroup.commons.utils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.StringTokenizer;

import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;

/**
 * Clase auxiliar que engloba las distintas conversiones de tipos de datos que
 * queramos hacer
 * 
 * @author bruno
 * 
 */
@Service("pfsconverter")
public class Conversiones {

	/**
	 * Extrae los valores de una cadena de caracteres y los almacena en una
	 * coleccion de Long
	 * 
	 * @param string
	 *            Cadena que contiene los valores
	 * @param separador
	 *            Separador entre los valores
	 * @return
	 */
	@BusinessOperation
	public static Collection<Long> createLongCollection(String string,
			String separador) {
		ArrayList<Long> result = new ArrayList<Long>();
		if (Checks.esNulo(string)) {
			return result;
		}

		StringTokenizer tk = new StringTokenizer(string, separador);
		while (tk.hasMoreTokens()) {
			result.add(Long.parseLong(tk.nextToken()));
		}
		return result;
	}
	
	/**
	 * Extrae los valores de una colección de cadenas y los almacena en una
	 * coleccion de Integer
	 * 
	 * @param strings
	 *            Colección de cadenas
	 * @return
	 */
	@BusinessOperation
	public static Collection<Integer> createIntegerCollection(Collection<String> strings) {
		ArrayList<Integer> result = new ArrayList<Integer>();
		if (Checks.estaVacio(strings)) {
			return result;
		}

		
		for(String s : strings) {
			result.add(Integer.parseInt(s));
		}
		return result;
	}

	/**
	 * Convierte una cadena a un entero Long. Si la cadena es null o está vacía
	 * devuelve null. Si la cadena no se puede parsear lanza una
	 * BusinessOperationException
	 * 
	 * @param s
	 * @return
	 */
	@BusinessOperation
	public static Long convierteLong(String s) {
		try {
			if (Checks.esNulo(s))
				return null;
			return Long.parseLong(s);
		} catch (NumberFormatException e) {
			throw new BusinessOperationException(s
					.concat(": No se puede convertir a Long"));
		}
	}
	
	

	/**
	 * Convierte una cadena a un entero Integer. Si la cadena es null o está vacía
	 * devuelve null. Si la cadena no se puede parsear lanza una
	 * BusinessOperationException
	 * 
	 * @param s
	 * @return
	 */
	@BusinessOperation
	public static Integer convierteInteger(String s) {
		try {
			if (Checks.esNulo(s))
				return null;
			return Integer.parseInt(s);
		} catch (NumberFormatException e) {
			throw new BusinessOperationException(s
					.concat(": No se puede convertir a Integer"));
		}
		
	}
	
	/**
	 * Quita los separadores entre valores sobrantes, que intentan dividir
	 * información que no se ha conseguido,
	 * tanto al inicio, fin y en medias<br/><br/>
	 * 
	 * Ej.: delSeparadoresSobrantes("/Valor2//Valor4/","/")<br/>
	 * 		devolvería:  "Valor2/Valor4"<br/>
	 * 
	 * @param valor String que posee la cadena de valores
	 * @param separador String que representa el separador
	 * @return String con la cadena de valores sin separadores sobrantes
	 * 
	 * 
	 * @since 2.7.1
	 */
	@BusinessOperation
	public static String delSeparadoresSobrantes(String valor, String separador) {
		String vaciado = valor;
		
		if (vaciado!=null) {
			// Primero se quitán los separadores de información intermedia
			// reemplazando una doble separación por una simple
			vaciado = vaciado.replaceAll(separador + separador, separador);
			// A continuación eliminamos los separadores que se hayan quedado al inicio y fin
			if (vaciado.trim().startsWith(separador)) vaciado = vaciado.substring(1);
			if (vaciado.trim().endsWith(separador)) vaciado = vaciado.substring(0,vaciado.length()-1);
		}
		
		return vaciado;
	}	

}
