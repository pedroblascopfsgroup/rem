package es.pfsgroup.recovery.ext.api.tareas;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface EXTOpcionesBusquedaTareasApi {

	public static final String EXT_OPCIONES_BUSQUEDA_TAREAS_TIENE_OPCION = "es.pfsgroup.recovery.ext.api.tareas.opciones.tieneOpcion";
	public static final String EXT_OPCIONES_BUSQUEDA_TAREAS_TIENE_OPCION_BUZON_OPTIMIZADO = "es.pfsgroup.recovery.ext.api.tareas.opciones.tieneOpcionBuzonOptimizado";

	/**
	 * Nos dice si el usuario logado tiene o no una determinada opción para la búsqueda de tareas
	 * @param opcion
	 * @param u
	 * @return
	 */
	@BusinessOperationDefinition(EXT_OPCIONES_BUSQUEDA_TAREAS_TIENE_OPCION)
	public boolean tieneOpcion(EXTOpcionesBusquedaTareas opcion, Usuario u);
	
	/**
	 * Nos dice si el usuario logado tiene o no utiliza búsqueda de tareas optimizada
	 * @return
	 */
	@BusinessOperationDefinition(EXT_OPCIONES_BUSQUEDA_TAREAS_TIENE_OPCION_BUZON_OPTIMIZADO)
	public boolean tieneOpcionBuzonOptimizado();	

}
