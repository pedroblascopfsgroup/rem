package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.io.FileNotFoundException;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Repositorio de ficheros Excel.
 * @author manuel
 *
 */
public interface ExcelRepoApi {
	
	public final static String TIPO_EXCEL = "application/vnd.ms-excel";
	public static final String MSV_BO_DAME_EXCEL = "es.pfsgroup.plugin.recovery.masivo.api.dameExcel";
	public static final String MSV_BO_DAME_EXCEL_BY_TIPO_OPERACION = "es.pfsgroup.plugin.recovery.masivo.api.dameExcelByTipoOperacion";
	
	/**
	 * Devuelve la plantilla excel asociada a un tipo de plantilla.
	 * @param tipoPlantilla
	 * @return
	 * @throws FileNotFoundException 
	 */
	@BusinessOperationDefinition(MSV_BO_DAME_EXCEL)
	FileItem dameExcel(Long tipoPlantilla) throws FileNotFoundException;

	/**
	 * Devuelve la plantilla excel asociada a un tipo de operaci�n masiva.
	 * @param idTipoOperacion
	 * @return
	 * @throws FileNotFoundException 
	 */
	@BusinessOperationDefinition(MSV_BO_DAME_EXCEL_BY_TIPO_OPERACION)
	FileItem dameExcelByTipoOperacion(Long idTipoOperacion) throws FileNotFoundException;

}
