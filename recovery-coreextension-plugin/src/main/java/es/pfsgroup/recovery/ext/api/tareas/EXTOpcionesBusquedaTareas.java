package es.pfsgroup.recovery.ext.api.tareas;

/**
 * Opciones que puede tener la búsqueda de tareas en función de las funciones que tenga el usuario
 * @author bruno
 *
 */
public class EXTOpcionesBusquedaTareas{

	public interface Tipos {
		int TIPO_BUSQUEDA_TAREAS_CARTERIZADA = 0;
		int TIPO_BUSQUEDA_CLIENTES_CARACTERIZADA  = 1;
		int TIPO_BUZONES_OPTIMIZADOS  = 2;
	}

	/**
	 * Esa es la función que deben tener los usuarios para poder acceder a la búsqueda de tareas
	 */
	private static final String FUNCION_OPCION_BUSQUEDA_CARTERIZADA = "BUSQEDA_TAREAS_CARTERIZADA";

	
	/***
	 * Función que habilita la busqueda de clientes caracterizada
	 * 
	 * */
	private static final String FUNCION_BUSCADOR_CLIENTES_CARTERIZADO = "BUSCADOR_CLIENTES_CARTERIZADO";
	
	/***
	 * Función que habilita la optimización de los buzones de tareas
	 * 
	 * */
	private static final String FUNCION_OPCION_BUZONES_OPTIMIZADOS = "OPTIMIZACION_BUZON_TAREAS";
	
	
	

	/**
	 * Factoría para obtener las  opciones disponibles
	 * @return
	 */
	public static EXTOpcionesBusquedaTareas getBusquedaCarterizadaTareas() {
		EXTOpcionesBusquedaTareas o = new  EXTOpcionesBusquedaTareas(FUNCION_OPCION_BUSQUEDA_CARTERIZADA);
		o.tipoOpcion = Tipos.TIPO_BUSQUEDA_TAREAS_CARTERIZADA;
		return o;
	}
	
	/**
	 * Factoría para obtener las  opciones disponibles
	 * @return
	 */
	public static EXTOpcionesBusquedaTareas getBuzonesTareasOptimizados() {
		EXTOpcionesBusquedaTareas o = new  EXTOpcionesBusquedaTareas(FUNCION_OPCION_BUZONES_OPTIMIZADOS);
		o.tipoOpcion = Tipos.TIPO_BUZONES_OPTIMIZADOS;
		return o;
	}
	
	/**
	 * Factoría para obtener las  opciones disponibles
	 * @return
	 */
	public static EXTOpcionesBusquedaTareas getBusquedaCarterizadaClientes() {
		EXTOpcionesBusquedaTareas o = new  EXTOpcionesBusquedaTareas(FUNCION_BUSCADOR_CLIENTES_CARTERIZADO);
		o.tipoOpcion = Tipos.TIPO_BUSQUEDA_CLIENTES_CARACTERIZADA;
		return o;
	}

	private String funcionRequerida;
	private int tipoOpcion;
	
	/**
	 * Crea una opcíón de búsqueda con la función requerida
	 * @param funciónRequerida
	 */
	private EXTOpcionesBusquedaTareas(String funcionRequerida) {
		this.funcionRequerida = funcionRequerida;
	}

	/**
	 * Devuelve la función que requiere que tenga el usuario para tener activada esta opción
	 * @return the funcionRequerida
	 */
	public String getFuncionRequerida() {
		return funcionRequerida;
	}

	/**
	 * Devuelve un valor que representa un tipo de opción. Los valores están representados por las constantes en la interfaz EXTOpcionesBusquedaTareas.Tipos
	 * @return
	 */
	public int getTipoOpcion() {
		return this.tipoOpcion;
	}
}