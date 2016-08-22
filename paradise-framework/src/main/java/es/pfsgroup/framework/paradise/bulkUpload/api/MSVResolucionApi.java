package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.util.List;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFileItem;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVResolucionesDto;
import es.pfsgroup.framework.paradise.bulkUpload.model.ExcelFileBean;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDTipoResolucion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVResolucion;

/**
 * Manager encargado de la gesti�n de las operaciones relacionadas con las resoluciones.
 * @author manuel
 *
 */
public interface MSVResolucionApi {
	
	public static final String MSV_BO_MOSTRAR_RESOLUCIONES = "es.pfsgroup.plugin.recovery.masivo.api.mostrarResoluciones";
	public static final String MSV_BO_MOSTRAR_RESOLUCIONES_PAGINATED = "es.pfsgroup.plugin.recovery.masivo.api.mostrarResolucionesPaginated";
	public static final String MSV_BO_UPLOAD_FICHERO_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.api.uploadFile";
	public static final String MSV_BO_GUARDAR_DATOS_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.api.guardarDatos";
	public static final String MSV_BO_GET_DATOS_RESOLUCION =  "es.pfsgroup.plugin.recovery.masivo.api.getDatos";
	public static final String MSV_BO_DAME_AYUDA_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.api.dameAyuda";
	public static final String MSV_BO_PROCESA_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.api.procesaResolucion";
	public static final String MSV_BO_GET_TIPOS_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.api.getTiposDeResolucion";
	public static final String MSV_BO_GET_TIPO_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.api.getTipoResolucion";
	public static final String MSV_BO_GUARDAR_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.api.guardarResolucion";

	public static final String MSV_BO_GET_TIPO_RESOLUCION_POR_CODIGO = "es.pfsgroup.plugin.recovery.masivo.api.getTipoResolucionPorCodigo";
	public static final String MSV_BO_GET_TIPO_RESOLUCION_POR_TAREA_RESOLUCION = "es.pfsgroup.plugin.recovery.masivo.api.getResolucionByTareaNotificacion";
	
	/**
	 * Devuelve el listado de resoluciones.
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_MOSTRAR_RESOLUCIONES)
	List<MSVResolucion> mostrarResoluciones();
	
	/**
	 * Devuelve el listado de resoluciones paginado
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_MOSTRAR_RESOLUCIONES_PAGINATED)
	public Page mostrarResoluciones(MSVDtoFiltroProcesos dto);
	/**
	 * Sube un fichero a una resolucion. Si no recibe el id de resoluci�n crea una resoluci�n nueva.
	 * @param uploadForm
	 * @param dto
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition(MSV_BO_UPLOAD_FICHERO_RESOLUCION)
	public MSVDtoResultadoSubidaFicheroMasivo uploadFile(ExcelFileBean uploadForm, MSVDtoFileItem dto) throws BusinessOperationException;

	/**
	 * Guarda los datos de una resoluci�n. Adem�s, guarda el adjunto en el asunto, si existe. 
	 * @param dtoResolucion
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(MSV_BO_GUARDAR_DATOS_RESOLUCION)
	public MSVResolucion guardarDatos(MSVResolucionesDto dtoResolucion);

	/**
	 * Guarda los datos de una resoluci�n. No guarda el adjunto en el asunto
	 * @param dtoResolucion
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_GUARDAR_RESOLUCION)
	public MSVResolucion guardarResolucion(MSVResolucionesDto dtoResolucion);
	
	/**
	 * Recupera una resoluci�n.
	 * @param idResolucion
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(MSV_BO_GET_DATOS_RESOLUCION)
	MSVResolucion getResolucion(Long idResolucion) throws Exception;

	/**
	 * Recupera la ayuda de un tipo de resoluci�n.
	 * @param idTipoResolucion
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_DAME_AYUDA_RESOLUCION)
	String dameAyuda(Long idTipoResolucion);

	/**
	 * Procesa una resoluci�n.
	 * @param idResolucion
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_PROCESA_RESOLUCION)
	MSVResolucion procesaResolucion(Long idResolucion);

	
	/**
	 * Devuelve el listado de tipos de resoluci�n en funci�n del procedimiento.
	 * @param idProcedimiento (Long) identificadir del procedimiento.
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_GET_TIPOS_RESOLUCION)
	List<MSVDDTipoResolucion> getTiposDeResolucion(Long idProcedimiento);
	
	/**
	 * Devuelve un tipo de resoluci�n en funci�n de su id
	 * @param idTipoResolucion (Long) identificadir del tipo de resoluci�n.
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_GET_TIPO_RESOLUCION)
	MSVDDTipoResolucion getTipoResolucion(Long idTipoResolucion);

	@BusinessOperationDefinition(MSV_BO_GET_TIPO_RESOLUCION_POR_CODIGO)
	public	MSVDDTipoResolucion getTipoResolucionPorCodigo(String codigoTipoResolucion);
	
	@BusinessOperationDefinition(MSV_BO_GET_TIPO_RESOLUCION_POR_TAREA_RESOLUCION)
	public MSVResolucion getResolucionByTareaNotificacion(Long idTareaNotificacion);

}