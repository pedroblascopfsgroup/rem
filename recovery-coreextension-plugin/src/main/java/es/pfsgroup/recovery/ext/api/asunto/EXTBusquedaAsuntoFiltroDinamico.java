package es.pfsgroup.recovery.ext.api.asunto;

/**
 * Interfaz que define los manejadores de los filtros d�namicos para la busqueda de Asuntos
 * 
 * **/

public interface EXTBusquedaAsuntoFiltroDinamico {

	/***
	 * Devuelve una cadena de texto que indica el plugin donde est� el filtro
	 * 
	 * Este par�metro se utiliza luego en la funcioin isValid, para saber si el manejador es el adecuado
	 * para tratar los filtros din�micos
	 * 
	 * */
	public String getOrigenFiltros();
	
	
	/***
	 * Funcioni que indica si es el manejador correcto para tratar el filtro din�mico
	 * 
	 * @param paramsDinamicos Es un string con una lista de par�metro-valor definida de la siguiente manera:
	 * origen:valor;par�metroDinamico1:valor1;par�metroDinamico2:valor2;
	 * 
	 * El primer campo, origen, es el que se utiliza para comprobar si es v�lido
	 * 
	 * **/
	public boolean isValid(String paramsDinamicos);
	
	
	
	/***
	 * Devuelve un string con una subconsulta con los filtros din�micos.
	 * La subconsulta debe devolver una lista de ids de asuntos que cumplan las condiciones de los par�metros
	 * 
	 * @param paramsDinamicos Es un string con una lista de par�metro-valor definida de la siguiente manera:
	 * par�metroDinamico1:valor1;par�metroDinamico2:valor2;
	 * 
	 * **/
	public String obtenerFiltro(String paramsDinamicos);
	
	
}
