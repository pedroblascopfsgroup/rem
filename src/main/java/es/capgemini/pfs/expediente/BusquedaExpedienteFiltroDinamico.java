package es.capgemini.pfs.expediente;

/**
 * Interfaz que define los manejadores de los filtros dinamicos para la busqueda de Expedientes
 * 
 * **/

public interface BusquedaExpedienteFiltroDinamico {

	/***
	 * Devuelve una cadena de texto que indica el plugin donde está el filtro
	 * 
	 * Este parámetro se utiliza luego en la funcioin isValid, para saber si el manejador es el adecuado
	 * para tratar los filtros dinámicos
	 * 
	 * */
	public String getOrigenFiltros();
	
	
	/***
	 * Funcioni que indica si es el manejador correcto para tratar el filtro dinámico
	 * 
	 * @param paramsDinamicos Es un string con una lista de parámetro-valor definida de la siguiente manera:
	 * origen:valor;parametroDinamico1:valor1;parametroDinamico2:valor2;
	 * 
	 * El primer campo, origen, es el que se utiliza para comprobar si es válido
	 * 
	 * **/
	public boolean isValid(String paramsDinamicos);
	
	
	
	/***
	 * Devuelve un string con una subconsulta con los filtros dinámicos.
	 * La subconsulta debe devolver una lista de ids de asuntos que cumplan las condiciones de los parámetros
	 * 
	 * @param paramsDinamicos Es un string con una lista de parámetro-valor definida de la siguiente manera:
	 * parámetroDinamico1:valor1;parámetroDinamico2:valor2;
	 * 
	 * **/
	public String obtenerFiltro(String paramsDinamicos);
	
	
}
