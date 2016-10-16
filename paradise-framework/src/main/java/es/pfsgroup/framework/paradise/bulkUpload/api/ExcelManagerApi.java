package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.io.FileNotFoundException;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFileItem;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.model.ExcelFileBean;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;


/**
 * @author manuel
 * 
 */
@SuppressWarnings("deprecation")
public interface ExcelManagerApi {

	public static final String MSV_BO_GENERA_EXCEL_VACIA = "es.pfsgroup.plugin.recovery.masivo.api.generaExcelVacia";
	public static final String MSV_BO_GENERA_EXCEL_VACIA_TIPO_OPERACION = "es.pfsgroup.plugin.recovery.masivo.api.generaExcelVaciaPorTipoOperacion";
	public static final String MSV_BO_UPLOAD_FICHERO = "es.pfsgroup.plugin.recovery.masivo.api.upload";
	public static final String MSV_BO_DESCARGA_FICHERO = "es.pfsgroup.plugin.recovery.masivo.api.download";
	public static final String MSV_BO_ELIMINAR_ARCHIVO = "es.pfsgroup.plugin.recovery.masivo.api.eliminarArchivo";
	public static final String MSV_BO_VALIDAR_ARCHIVO = "es.pfsgroup.plugin.recovery.masivo.api.validarArchivo";
	public static final String MSV_BO_UPDATE_FICHERO_ERRORES = "es.pfsgroup.plugin.recovery.masivo.api.updateErrores";
	public static final String MSV_BO_GET_HOJA_EXCEL = "es.pfsgroup.plugin.recovery.masivo.api.getHojaExcel";
	public static final String MSV_BO_UPLOAD_AND_VALDIATE = "es.pfsgroup.framework.paradise.bulkUpload.api.impl.uploadAndValidate";
	public static final String MSV_BO_IS_VALID_PROCESS = "es.pfsgroup.framework.paradise.bulkUpload.api.impl.isValidProcess";
	
	public static final String MSV_PROCESS_CODE_PROPUESTA_PRECIOS_ACTIVO = "CPPA"; 
	/**
	 * Devuelve una plantilla excel en funci�n del tipo de plantilla que se le
	 * indique.
	 * 
	 * @param tipoPlantilla
	 * @return
	 * @throws FileNotFoundException
	 */
	@BusinessOperationDefinition(MSV_BO_GENERA_EXCEL_VACIA)
	ExcelFileBean generaExcelVacia(Long tipoPlantilla)
			throws FileNotFoundException;

//	@BusinessOperationDefinition(MSV_BO_UPLOAD_FICHERO)
//	MSVDtoResultadoSubidaFicheroMasivo uploadFile(ExcelFileBean uploadForm,
//			MSVDtoFileItem dto) throws Exception;

	@BusinessOperationDefinition(MSV_BO_DESCARGA_FICHERO)
	ExcelFileBean descargarErrores(Long idFichero) throws Exception;

//  No se utiliza.
//	@BusinessOperationDefinition(MSV_BO_ELIMINAR_ARCHIVO)
//	String eliminarArchivo(Long idProceso);

//	@BusinessOperationDefinition(MSV_BO_VALIDAR_ARCHIVO)
//	Boolean validarArchivo(Long idProceso);

	/**
	 * Devuelve una plantilla excel vac�a en funci�n del tipo de operaci�n.
	 * 
	 * @param idTipoOperacion
	 * @return
	 * @throws FileNotFoundException
	 */
	@BusinessOperationDefinition(MSV_BO_GENERA_EXCEL_VACIA_TIPO_OPERACION)
	ExcelFileBean generaExcelVaciaPorTipoOperacion(Long idTipoOperacion)
			throws FileNotFoundException;

	/**
	 * Actualiza el fichero de errores de MSVDocumentoMasivo con los errores
	 * producidos en el procesamiento
	 */
	@BusinessOperationDefinition(MSV_BO_UPDATE_FICHERO_ERRORES)
	public void updateErrores(Long idProceso, FileItem ficheroErrores)
			throws Exception;
	
	/**
	 * Crea una hoja excel a partir de un documento masivo
	 * @param fichero
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_GET_HOJA_EXCEL)
	public MSVHojaExcel getHojaExcel(MSVDocumentoMasivo fichero);
	
	@BusinessOperationDefinition(MSV_BO_UPLOAD_AND_VALDIATE)
	Boolean uploadAndValidate(MSVExcelFileItemDto uploadForm) throws Exception;

	MSVDocumentoMasivo upload(MSVExcelFileItemDto uploadForm) throws Exception;

	MSVProcesoMasivo validateFormat(MSVDocumentoMasivo document) throws Exception;

	@BusinessOperationDefinition(MSV_BO_IS_VALID_PROCESS)
	Boolean isValidProcess(Long idProceso);

}
