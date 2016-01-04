package es.pfsgroup.recovery.common.api;

import java.util.Map;


public interface CommonProjectContext {

	/**
     * Devuelve el código añadiendo espacios según el formato indicado 
     * @param formato Se debe indicar los caracteres en los que habrá
     * espacio separados por ",".<br><br><u>Ejemplo: 5,5,17,15</u> <br>indicará que el código se compone de 42 dígitos, 
     * en caso de no alcanzar la longitud de 42 d�gitos se rellenar�n con ceros por la izquierda. <br><br> 
     * Y el formato devuelto sería el siguiente:<br>
     * 12345 12345 12345678901234567 123456789012345  
     * @param formatoSubstringEnd hace un substring desde este caracter inicio, si es null será el primero
     * @param formatoSubstringStart hasta este caracter fin, si es null será el último
     * @return
     */
	public String getNroContratoFormateado(String nroContrato);

	/**
	 * Devuelve el mapa con el formato del número de contrato definido en el projectContext
	 * 
	 * @return Map<String, String>
	 */
	Map<String, String> getFormatoNroContrato();
	
	/**
	 * Devuelve un mapa con el tipo de gestores definido en el projectContext
	 * @return Map<String, String>
	 */
	public Map<String, String> getTipoGestores();

	/**
	 * Recupera el tipo de gestor definido en el mapa de gestores
	 * @param tipoGestor: clave del tipo de gestor
	 * @return String
	 */
	public String getTipoGestor(String tipoGestor);
}
