package es.pfsgroup.plugin.recovery.procuradores.procesado.api;

import java.util.List;
import java.util.Set;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;

/**
 * Manager encargado de la gestión de las operaciones relacionadas con las resoluciones.
 * @author manuel
 *
 */
@SuppressWarnings("unused")
public interface PCDResolucionProcuradorApi {
	
	public static final String PCD_MSV_BO_MOSTRAR_RESOLUCIONES = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.mostrarResoluciones";
	public static final String PCD_MSV_BO_MOSTRAR_RESOLUCIONES_PAGINATED = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.mostrarResolucionesPaginated";
	public static final String PCD_MSV_BO_UPLOAD_FICHERO_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.uploadFile";
	public static final String PCD_MSV_BO_GUARDAR_DATOS_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.guardarDatos";
	public static final String PCD_MSV_BO_GUARDAR_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.guardarResolucion";
	public static final String PCD_MSV_BO_GET_DATOS_RESOLUCION =  "es.pfsgroup.plugin.recovery.procuradores.procesado.api.getDatos";
	public static final String PCD_MSV_BO_DAME_AYUDA_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.dameAyuda";
	public static final String PCD_MSV_BO_PROCESA_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.procesaResolucion";
	public static final String PCD_MSV_BO_GET_TIPOS_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.getTiposDeResolucion";
	public static final String PCD_MSV_BO_GET_TIPO_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.getTipoResolucion";

	public static final String PCD_MSV_BO_GET_TIPO_RESOLUCION_POR_CODIGO = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.getTipoResolucionPorCodigo";
	public static final String PCD_MSV_BO_GET_RESOLUCION_BY_TAREA = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.getResolucionByTarea";
	public static final String PCD_MSV_BO_GET_TIPO_RESOLUCIONES_ESPECIALES = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.getTipoResolucionesEspeciales";
	public static final String PCD_MSV_BO_ES_TIPO_ESPECIAL = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.esTipoEspecial";
	
//	public static final String PCD_MSV_BO_OBTENER_TIPOS_RESOLUCIONES_SIN_TAREA = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.obtenerTiposResolucionesSinTarea";
//	public static final String PCD_MSV_BO_OBTENER_TIPOS_RESOLUCIONES_TAREA = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.obtenerTiposResolucionesTareas";

	public static final String PCD_MSV_BO_OBTENER_RESOLUCIONES = "es.plugin.recovery.procuradores.procesado.api.obtenerTiposResoluciones";
	public static final String PCD_MSV_BO_BORRAR_ADJUNTO = "es.plugin.recovery.procuradores.procesado.api.borrarAdjunto";
	public static final String PCD_MSV_BO_DAME_VALIDACION_RESOLUCION = "es.plugin.recovery.procuradores.procesado.api.dameResolucion";
	public static final String PCD_MSV_BO_DAME_VALIDACION_RESOLUCION_JBPM = "es.plugin.recovery.procuradores.procesado.api.dameResolucionJBPM";
	public static final String PCD_MSV_GUARDAR_DATOS_HISTORICO = "es.plugin.recovery.procuradores.procesado.api.guardarDatosHistorico";
	
	public static final String PCD_MSV_GET_RESOLUCIONES_PENDIENTES_VALIDAR = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.getResolucionesPendientesValidar";
	
	public static final String PCD_MSV_BO_ADJUNTAR_FICHERO_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.adjuntarFicheroResolucion";
		
	/**
	 * Devuelve el listado de resoluciones.
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_MOSTRAR_RESOLUCIONES)
	List<MSVResolucion> mostrarResoluciones();
	
	/**
	 * Devuelve el listado de resoluciones paginado
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_MOSTRAR_RESOLUCIONES_PAGINATED)
	public Page mostrarResoluciones(MSVDtoFiltroProcesos dto);
	/**
	 * Sube un fichero a una resolucion. Si no recibe el id de resolución crea una resolución nueva.
	 * @param uploadForm
	 * @param dto
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_UPLOAD_FICHERO_RESOLUCION)
	public MSVDtoResultadoSubidaFicheroMasivo uploadFile(ExcelFileBean uploadForm, MSVDtoFileItem dto) throws BusinessOperationException;

	/**
	 * Guarda los datos de una resolución adjuntando el fichero al asunto.
	 * @param dtoResolucion
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_GUARDAR_DATOS_RESOLUCION)
	public MSVResolucion guardarDatos(MSVResolucionesDto dtoResolucion);
	
	
	/**
	 * Guarda los datos de una resolución.
	 * @param dtoResolucion
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_GUARDAR_RESOLUCION)
	public MSVResolucion guardarResolucion(MSVResolucionesDto dtoResolucion);

	/**
	 * Recupera una resolución.
	 * @param idResolucion
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_GET_DATOS_RESOLUCION)
	MSVResolucion getResolucion(Long idResolucion) throws Exception;

	/**
	 * Recupera la ayuda de un tipo de resolución.
	 * @param idTipoResolucion
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_DAME_AYUDA_RESOLUCION)
	String dameAyuda(Long idTipoResolucion);

	/**
	 * Procesa una resolución.
	 * @param idResolucion
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_PROCESA_RESOLUCION)
	MSVResolucion procesaResolucion(Long idResolucion);

	
	/**
	 * Devuelve el listado de tipos de resolución en función del procedimiento.
	 * @param idProcedimiento (Long) identificadir del procedimiento.
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_GET_TIPOS_RESOLUCION)
	List<MSVDDTipoResolucion> getTiposDeResolucion(Long idProcedimiento);
	
	/**
	 * Devuelve un tipo de resolución en función de su id
	 * @param idTipoResolucion (Long) identificadir del tipo de resolución.
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_GET_TIPO_RESOLUCION)
	MSVDDTipoResolucion getTipoResolucion(Long idTipoResolucion);

	@BusinessOperationDefinition(PCD_MSV_BO_GET_TIPO_RESOLUCION_POR_CODIGO)
	public	MSVDDTipoResolucion getTipoResolucionPorCodigo(String codigoTipoResolucion);

	/**
	 * Devuelve la resolución asociada a una Tarea
	 * @param idResolucion (Long) identificador de la resolución.
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_GET_RESOLUCION_BY_TAREA)
	public MSVResolucion getResolucionByTarea(Long idTareaExterna);

	@BusinessOperationDefinition(PCD_MSV_BO_GET_TIPO_RESOLUCIONES_ESPECIALES)
	public List<MSVTipoResolucionDto> getTiposResolucionesEspeciales(String prefijoResEspeciales, Long idTarea);
	
	@BusinessOperationDefinition(PCD_MSV_BO_ES_TIPO_ESPECIAL)
	public boolean esTipoEspecial(Long idTipo, String PrefijoResEspeciales);

//	@BusinessOperationDefinition(PCD_MSV_BO_OBTENER_TIPOS_RESOLUCIONES_SIN_TAREA)
//	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesSinTarea(Long idProcedimiento);
//	
//	@BusinessOperationDefinition(PCD_MSV_BO_OBTENER_TIPOS_RESOLUCIONES_TAREA)
//	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesTareas(Long idProcedimiento);
		
	@BusinessOperationDefinition(PCD_MSV_BO_OBTENER_RESOLUCIONES)
	public Set<MSVTipoResolucionDto> obtenerTiposResoluciones(Long idProcedimiento, Long idTarea);
	
	@BusinessOperationDefinition(PCD_MSV_BO_BORRAR_ADJUNTO)
	public void borrarAdjunto(MSVResolucion msvResolucion);
	
	@BusinessOperationDefinition(PCD_MSV_BO_DAME_VALIDACION_RESOLUCION)
	public String dameValidacion(Long idTarea);
	
	@BusinessOperationDefinition(PCD_MSV_BO_DAME_VALIDACION_RESOLUCION_JBPM)
	public String dameValidacionJBPM(Long idTarea);
	
	@BusinessOperationDefinition(PCD_MSV_GUARDAR_DATOS_HISTORICO)
	public void guardarDatosHistorico(MSVResolucionesDto dtoResolucion, MSVResolucion msvResolucion);
	
	@BusinessOperationDefinition(PCD_MSV_GET_RESOLUCIONES_PENDIENTES_VALIDAR)
	public List<MSVResolucion> getResolucionesPendientesValidar(Long idTarea, List<String> tipoResolucionAccionBaned);
	
	/**
	 * Guarda el fichero adjunto en la resolucion.
	 * @param dtoResolucion
	 * @return
	 */
	@BusinessOperationDefinition(PCD_MSV_BO_ADJUNTAR_FICHERO_RESOLUCION)
	public MSVResolucion adjuntaFicheroResolucuion(MSVResolucionesDto dtoResolucion);
	
}