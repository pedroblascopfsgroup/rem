package es.pfsgroup.plugin.recovery.comites;

public class PluginComitesBusinessOperations {
	
	/**
	 * Devuelve una lista de todos los itinerarios dados de alta en la base de datos
	 * 
	 */
	public static final String ITI_MGR_GETLIST="plugin.comites.itinerario.listaItinerarios";

	/**
	 * Devuelve una lista de todos los perfiles existentes
	 */
	public static final String 	PEF_MGR_GETLIST="plugin.comites.perfil.listaPerfiles";
	
	/**
	 * Devuelve una lista de todos lo
	 */
	public static final String ZON_MGR_GETLIST="plugin.comites.zona.listaZonas";
	
	/**
	 * @param id del comité que queremos seleccionar
	 * @return objeto del tipo CMTComite cuyo id coincide con el parámetro que se le pasa
	 */
	public static final String CMT_MGR_GETCOMITE="plugin.comites.comite.getComite";
	/**
	 * @param dto de búsqueda de comités
	 * @return devuelve la lista de todos los comités que cumplen los criterios de búsqueda
	 */
	public static final String CMT_MGR_BUSCA="plugin.comites.comite.buscaComites";
	
	/**
	 * @param id del comité
	 * Borra el comité cuyo id coincide con el valor que se le pasa como parámetro siempre
	 * que éste no tenga asuntos activos
	 */
	public static final String CMT_MGR_BORRA="plugin.comites.comite.delete";
	
	public static final String CMT_MGR_GUARDA="plugin.comites.comite.save";
	
	/**
	 * @param un listado de objetos CMTDtoItinerario
	 * Inserta en la lista de itinerarios para el comité los itinerarios que están como compatibles y borra los 	
	 * que están como incompatibles
	 */
	public static final String CMT_MGR_GUARDAITINERARIOS="plugin.comites.comite.guardaItinerarios";
	
	/**
	 * @param id del comié
	 * @return devuelve una lista de objetos dtoItinerario en el que se muestran todos los itinerarios
	 * con un flat de activo o inactivo para ese comité
	 */
	public static final String CMT_MGR_LISTADTOITINERARIO="plugin.comites.comite.listaDtoItinerarios";
	
	/**
	 * @param id del comité
	 * @return devuelve una lista de objetos PuestosComite que tiene el comité que se le pasa como parámetro
	 */
	public static final String PTC_MGR_GETPUESTOSCOMITE="plugin.comites.puestosComite.listaPuestosComite";
	
	/**
	 * @param dto de alta de comite
	 * 
	 */
	public static final String PTC_MGR_GUARDAPUESTOCOMITE="plugin.comites.puestosComite.save";
	
	/**
	 * @param id del puesto
	 * @return delvuelve el objeto PuestosComite cuyo id coincide con el parámetro que se le pasa a la entrada
	 */
	public static final String PTC_MGR_GET = "plugin.comites.puestosComite.get";
	
	/**
	 * @param id del puesto de comité
	 * elimina el puesto de comité cuyo id coincide con el parametro que se le pasa como entrada
	 */
	public static final String PTC_MGR_BORRARPUESTO="plugin.comites.puestosComite.delete";
}
