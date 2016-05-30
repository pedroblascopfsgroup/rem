package es.pfsgroup.plugin.recovery.masivo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVFileManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;

@Component
public class MSVFileUploadFacade {
	
	public static final String MSV_BO_SUBIR_FCHERO_PROCESAR = "es.pfsgroup.plugin.recovery.masivo.uploadFacade.subirFicheroParaProcesar";
	public static final String MSV_BO_SUBIR_FCHERO_RESOLUCIONES = "es.pfsgroup.plugin.recovery.masivo.uploadFacade.subirFicheroResoluciones";
	public static final String MSV_BO_SUBIR_FCHERO = "es.pfsgroup.plugin.recovery.masivo.uploadFacade.subirFichero";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
    @Autowired
    private Executor executor;
	
	/**
	 * Alamacena un fichero que se ha subido mediante un HTTP/Upload en el repositorio
	 * @param uploadForm
	 * @return
	 */
	@BusinessOperation(MSV_BO_SUBIR_FCHERO_PROCESAR)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)
	public String subirFicheroParaProcesar(WebFileItem uploadForm) {
		try {
			if (uploadForm != null) {

				ExcelFileBean efb = new ExcelFileBean();
				efb.setFileItem(uploadForm.getFileItem());

				MSVDtoFileItem dto = new MSVDtoFileItem();
				dto.setIdProceso(Long.parseLong(uploadForm.getParameter("idProceso")));
				dto.setIdTipoOperacion(Long.parseLong(uploadForm.getParameter("idTipoOperacion")));

				proxyFactory.proxy(ExcelManagerApi.class).uploadFile(efb, dto);

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
	 * @throws BusinessOperationException Si el parámetro de entrada es nulo devuelve una excepción.
	 */
	@BusinessOperation(MSV_BO_SUBIR_FCHERO)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)
	public String subirFichero(WebFileItem uploadForm) throws BusinessOperationException{
		
		if (uploadForm == null)
			throw new BusinessOperationException("El objeto WebFileItem es nulo.");
		
		FileItem fileItem = uploadForm.getFileItem();
		Integer max = getLimiteFichero(Parametrizacion.LIMITE_FICHERO_ASUNTO);

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
            
        }

		// DIANA: cambiamos el método upload file para que se le pase todo el objeto WEBFileItem en lugar de sólamente el fileItem, para poder guardar el tipo de documento
		MSVDtoResultadoSubidaFicheroMasivo result =  proxyFactory.proxy(MSVFileManagerApi.class).uploadFile(uploadForm);
		return String.valueOf(result.getIdFichero());
		
	}
	
	

	 private Integer getLimiteFichero(String limite) {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, limite);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            //logger.warn("No esta parametrizado el lï¿½mite mï¿½ximo del fichero en bytes para asuntos, se toma un valor por defecto (2Mb)");
            return new Integer(2 * 1024 * 1024);
        }
	 }

}
