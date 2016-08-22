package es.pfsgroup.framework.paradise.bulkUpload.api.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVFileManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVResolucionApi;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFileItem;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.model.ExcelFileBean;

@Component
public class MSVFileUploadParadise {
	
	public static final String MSV_BO_SUBIR_FCHERO_PROCESAR = "es.pfsgroup.framework.paradise.bulkUpload.uploadParadise.subirFicheroParaProcesar";
	public static final String MSV_BO_SUBIR_FCHERO_RESOLUCIONES = "es.pfsgroup.framework.paradise.bulkUpload.uploadParadise.subirFicheroResoluciones";
	public static final String MSV_BO_SUBIR_FCHERO = "es.pfsgroup.framework.paradise.bulkUpload.uploadParadise.subirFichero";
	public static final String MSV_BO_PARADISE_UPLOAD_AND_VALDIATE = "es.pfsgroup.framework.paradise.bulkUpload.uploadParadise.uploadAndValidate";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@BusinessOperation(MSV_BO_PARADISE_UPLOAD_AND_VALDIATE)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)
	public String uploadAndValidate(WebFileItem uploadForm) {
		try {
			if (uploadForm != null) {

				ExcelFileBean efb = new ExcelFileBean();
				efb.setFileItem(uploadForm.getFileItem());

				MSVExcelFileItemDto dto = new MSVExcelFileItemDto();
				dto.setProcessId(Long.parseLong(uploadForm.getParameter("idProceso")));
				dto.setIdTipoOperacion(Long.parseLong(uploadForm.getParameter("idTipoOperacion")));
				dto.setExcelFile(efb);
				proxyFactory.proxy(ExcelManagerApi.class).uploadAndValidate(dto);

			}
		}catch (Exception e) {
			throw new BusinessOperationException(e);
		}
		return null;
	}
	
	/**
	 * Alamacena un fichero que se ha subido mediante un HTTP/Upload en el repositorio
	 * @param uploadForm
	 * @return
	 */
	@BusinessOperation(MSV_BO_SUBIR_FCHERO_RESOLUCIONES)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)
	public String subirFicheroResoluciones(WebFileItem uploadForm) {
		String resultado = "";
		try {
			if (uploadForm != null) {

				ExcelFileBean efb = new ExcelFileBean();
				efb.setFileItem(uploadForm.getFileItem());

				MSVDtoFileItem dto = new MSVDtoFileItem();
				if (StringUtils.hasText(uploadForm.getParameter("idResolucion")))
					dto.setIdResolucion(Long.parseLong(uploadForm.getParameter("idResolucion")));
				if (StringUtils.hasText(uploadForm.getParameter("idTipoJuicio")))
					dto.setIdTipoJuicio(Long.parseLong(uploadForm.getParameter("idTipoJuicio")));
				if (StringUtils.hasText(uploadForm.getParameter("idTipoResolucion")))
					dto.setIdTipoResolucion(Long.parseLong(uploadForm.getParameter("idTipoResolucion")));
				dto.setPrincipal(Double.parseDouble(uploadForm.getParameter("principal")));
				dto.setPlaza(uploadForm.getParameter("plaza"));
				dto.setAuto(uploadForm.getParameter("auto"));
				dto.setJuzgado(uploadForm.getParameter("juzgado"));
				if (StringUtils.hasText(uploadForm.getParameter("idAsunto")))
					dto.setIdAsunto(Long.parseLong(uploadForm.getParameter("idAsunto")));
				if (StringUtils.hasText(uploadForm.getParameter("idTarea")))
					dto.setIdTarea(Long.parseLong(uploadForm.getParameter("idTarea")));
				MSVDtoResultadoSubidaFicheroMasivo result = proxyFactory.proxy(MSVResolucionApi.class).uploadFile(efb, dto);
				resultado = String.valueOf(result.getIdProceso());
			}
		}catch (Exception e) {
			throw new BusinessOperationException(e);
		}
		return resultado;
	}
	
	/**
	 * Alamacena un fichero que se ha subido mediante un HTTP/Upload en el repositorio. 
	 * El fichero se almacena en una tabla temporal.
	 * 
	 * @param uploadForm objeto que contiene el fichero a almacenar
	 * @return el id del fichero en la tabla temporal.
	 * 
	 * @throws BusinessOperationException Si el par�metro de entrada es nulo devuelve una excepci�n.
	 */
	@BusinessOperation(MSV_BO_SUBIR_FCHERO)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)
	public String subirFichero(WebFileItem uploadForm) throws BusinessOperationException{
		
		if (uploadForm == null)
			throw new BusinessOperationException("El objeto WebFileItem es nulo.");

		// DIANA: cambiamos el m�todo upload file para que se le pase todo el objeto WEBFileItem en lugar de s�lamente el fileItem, para poder guardar el tipo de documento
		MSVDtoResultadoSubidaFicheroMasivo result =  proxyFactory.proxy(MSVFileManagerApi.class).uploadFile(uploadForm);
		return String.valueOf(result.getIdFichero());
		
	}

}
