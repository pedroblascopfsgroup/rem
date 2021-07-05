package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.bulkUpload.dto.DtoMSVProcesoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoAltaProceso;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;

/**
 * @author manuel
 * Capa de negocio de los objetos Proceso Masivo.
 *
 */
public interface MSVProcesoApi {
	
	public static final String MSV_BO_ALTA_PROCESO_MASIVO = "es.pfsgroup.plugin.recovery.masivo.api.iniciarProcesoMasivo";
	public static final String MSV_BO_MODIFICACION_PROCESO_MASIVO = "es.pfsgroup.plugin.recovery.masivo.api.modificarProcesoMasivo";
	public static final String MSV_BO_CAMBIO_ESTADO_PROCESO_MASIVO = "es.pfsgroup.plugin.recovery.masivo.api.cambioEstado";
	public static final String MSV_BO_ELIMINAR_PROCESO = "es.pfsgroup.plugin.recovery.masivo.api.eliminarProceso";
	public static final String MSV_BO_MOSTRAR_PROCESOS = "es.pfsgroup.plugin.recovery.masivo.api.mostrarProcesos";
	public static final String MSV_BO_ELIMINAR_ARCHIVO = "es.pfsgroup.plugin.recovery.masivo.api.eliminarArchivo";
	public static final String MSV_BO_LIBERAR_FICHERO = "es.pfsgroup.plugin.recovery.masivo.api.liberarFichero";
	public static final String MSV_BO_GETBYTOKEN = "es.pfsgroup.plugin.recovery.masivo.api.getByToken";
	public static final String MSV_BO_MOSTRAR_PROCESOS_PAGINATED = "es.pfsgroup.plugin.recovery.masivo.api.mostrarProcesosPaginated";
	
	@BusinessOperationDefinition(MSV_BO_ALTA_PROCESO_MASIVO)
	Long iniciarProcesoMasivo(MSVDtoAltaProceso dto) throws Exception;
	
	@BusinessOperationDefinition(MSV_BO_MODIFICACION_PROCESO_MASIVO)
	MSVProcesoMasivo modificarProcesoMasivo (MSVDtoAltaProceso dto) throws Exception;
	
	@BusinessOperationDefinition(MSV_BO_ELIMINAR_PROCESO)
	String eliminarProceso(long idProceso) throws Exception;
	
	@BusinessOperationDefinition(MSV_BO_MOSTRAR_PROCESOS)
	List<DtoMSVProcesoMasivo> mostrarProcesos();

    /**
     * Esta operación de negocio devuelve una lista de procesos de operaciones masivas.
     * 
     * @param dto
     * @return Devuelve un objeto Page 
     */
    @BusinessOperationDefinition(MSV_BO_MOSTRAR_PROCESOS_PAGINATED)
    Page mostrarProcesosPaginated(MSVDtoFiltroProcesos dto);
	
	/**
	 * Libera un fichero para su procesado.
	 * Modifica el estado del proceso a Pendiente de Procesar.
	 * 
	 * @param idProceso id del proceso a liberar
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(MSV_BO_LIBERAR_FICHERO)
	MSVProcesoMasivo liberarFichero(Long idProceso) throws Exception;
	
	
	/**
	 * Obtiene el id del proceso por medio del token
	 * @param tokenProceso token para el proceso batch
	 * @return Id del proceso
	 */
	@BusinessOperationDefinition(MSV_BO_GETBYTOKEN)
	MSVProcesoMasivo getByToken(Long tokenProceso);
		
	/**
	 * Devuelve el Documento Masivo a partir de un id de proceso
	 * @param idProcess
	 * @return MSVDocumentoMasivo
	 */
	public MSVDocumentoMasivo getMSVDocumento(Long idProcess);
	
	/**
	 * Devuelve el proceso masivo a partir de un id de proceso
	 * @param idProcess
	 * @return MSVProcesoMasivo
	 */
	public MSVProcesoMasivo get(Long idProcess);
	
	/**
	 * Devuelve la operacion masiva en base a su id
	 * @param idTipoOperacion
	 * @return MSVDDOperacionMasiva
	 */
	public MSVDDOperacionMasiva getOperacionMasiva(Long idTipoOperacion);

	String getUsername();
	
	/**
	 * Comprueba si un usuario tiene un perfil determinado.
	 * @param código de perfil.
	 * @param u usuario
	 * @return
	 */
	public Boolean tienePerfilPorCodigo(String pefCodigo, Usuario usuario);
	
}
