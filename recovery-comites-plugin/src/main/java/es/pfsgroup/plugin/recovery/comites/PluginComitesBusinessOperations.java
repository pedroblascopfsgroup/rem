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
	 * @param id del comit� que queremos seleccionar
	 * @return objeto del tipo CMTComite cuyo id coincide con el par�metro que se le pasa
	 */
	public static final String CMT_MGR_GETCOMITE="plugin.comites.comite.getComite";
	/**
	 * @param dto de b�squeda de comit�s
	 * @return devuelve la lista de todos los comit�s que cumplen los criterios de b�squeda
	 */
	public static final String CMT_MGR_BUSCA="plugin.comites.comite.buscaComites";
	
	/**
	 * @param id del comit�
	 * Borra el comit� cuyo id coincide con el valor que se le pasa como par�metro siempre
	 * que �ste no tenga asuntos activos
	 */
	public static final String CMT_MGR_BORRA="plugin.comites.comite.delete";
	
	public static final String CMT_MGR_GUARDA="plugin.comites.comite.save";
	
	/**
	 * @param un listado de objetos CMTDtoItinerario
	 * Inserta en la lista de itinerarios para el comit� los itinerarios que est�n como compatibles y borra los 	
	 * que est�n como incompatibles
	 */
	public static final String CMT_MGR_GUARDAITINERARIOS="plugin.comites.comite.guardaItinerarios";
	
	/**
	 * @param id del comi�
	 * @return devuelve una lista de objetos dtoItinerario en el que se muestran todos los itinerarios
	 * con un flat de activo o inactivo para ese comit�
	 */
	public static final String CMT_MGR_LISTADTOITINERARIO="plugin.comites.comite.listaDtoItinerarios";
	
	/**
	 * @param id del comit�
	 * @return devuelve una lista de objetos PuestosComite que tiene el comit� que se le pasa como par�metro
	 */
	public static final String PTC_MGR_GETPUESTOSCOMITE="plugin.comites.puestosComite.listaPuestosComite";
	
	/**
	 * @param dto de alta de comite
	 * 
	 */
	public static final String PTC_MGR_GUARDAPUESTOCOMITE="plugin.comites.puestosComite.save";
	
	/**
	 * @param id del puesto
	 * @return delvuelve el objeto PuestosComite cuyo id coincide con el par�metro que se le pasa a la entrada
	 */
	public static final String PTC_MGR_GET = "plugin.comites.puestosComite.get";
	
	/**
	 * @param id del puesto de comit�
	 * elimina el puesto de comit� cuyo id coincide con el parametro que se le pasa como entrada
	 */
	public static final String PTC_MGR_BORRARPUESTO="plugin.comites.puestosComite.delete";
}
