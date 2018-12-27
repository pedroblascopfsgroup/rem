package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVPlantillaOperacion;

/**
 * @author manuel
 * Manager de la clase MSVDiccionario
 */
public interface MSVDiccionarioApi {
	
	
	public final static String MSV_BO_OBTENER_RUTA_EXCEL = "es.pfsgroup.plugin.recovery.masivo.api.obtenerRutaxcel";
	public static final String MSV_BO_DAME_LISTA_OPERACIONES = "es.pfsgroup.plugin.recovery.masivo.api.dameListaOperacionesDeUsuario";
	public static final String MSV_BO_DAME_LISTA_PLANTILLAS = "es.pfsgroup.plugin.recovery.masivo.api.dameListaPlantillasUsuario";
	public static final String MSV_BO_DAME_VALORES_DICCIONARIO = "es.pfsgroup.plugin.recovery.masivo.api.dameValoresDiccionario";

	/**
	 * Devuelve el listado completo de objetos de un diccionario que no han sido borrados.
	 * @param clase
	 * @return listado de objetos de tipo clase
	 */
	@SuppressWarnings("rawtypes")
	@BusinessOperationDefinition(MSV_BO_DAME_VALORES_DICCIONARIO)	
	List dameValoresDiccionario(Class clase);
	
	@BusinessOperationDefinition(MSV_BO_DAME_LISTA_OPERACIONES)
	List<MSVDDOperacionMasiva> dameListaOperacionesDeUsuario();

	@BusinessOperationDefinition(MSV_BO_DAME_LISTA_PLANTILLAS)
	List<MSVPlantillaOperacion> dameListaPlantillasUsuario();
	
	/**
	 * Devuelve la ruta de una plantilla excel en función del tipo de operación.
	 * Incluye el nombre de la plantilla.
	 * @param tipoPlantilla
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_OBTENER_RUTA_EXCEL)
	String obtenerRutaExcel(Long tipoPlantilla);

	


}

