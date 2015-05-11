package es.pfsgroup.plugin.recovery.config;

public class PluginConfigBusinessOperations {

	/**
	 * Devuelve todas las zonas.
	 * @return
	 */
	public static final String ZONA_MGR_GET_LIST = "plugin.config.zona.buscaZonas";
	
	/**
	 * Devuelve las zonas de un determinado nivel
	 * @param idNivel ID Nivel
	 * @return DDZona
	 */
	public static final String ZONA_MGR_GET_LIST_BY_NIVEL = "plugin.config.zona.buscaZonasPorNivel";
	
	/**
	 * Devuelve una zona por su ID
	 * @param idZona ID de la zona
	 * @return DDZona
	 */
	public static final String ZONA_MGR_GET = "plugin.config.zona.getZona";
	
	
	
	/**
	 * Asigna una zona a un despacho
	 * @param idDespacho ID del despacho
	 * @param idZona ID de la zona a asignar.
	 */
	public static final String DESPACHOEXTERNO_MGR_ZONIFICA = "plugin.config.despachoExterno.zonifica";

	/**
	 * Obtiene los despachos externos de un determinado tipo. 
	 * @param tipoDespacho Tipo de despacho. Debe ser distinto de NULL.
	 * @return Devuelve una lista vacía si no existen despachos del tipo especificado, o si no existe el  tipo.
	 */
	public static final String DESPACHOEXTERNO_MGR_GET_BY_TIPO = "plugin.config.despachoExterno.getByTipo";



	

}
