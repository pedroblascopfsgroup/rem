package es.pfsgroup.framework.paradise.bulkUpload.adapter;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVDiccionarioApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.impl.MSVFileUploadParadise;
import es.pfsgroup.framework.paradise.bulkUpload.api.impl.MSVProcesoManager;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVProcesoDao;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoAltaProceso;
import es.pfsgroup.framework.paradise.bulkUpload.model.ExcelFileBean;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDEstadoProceso;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;

@Service
@Transactional(readOnly = false)
public class ProcessAdapter {

	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
	@Autowired
	private MSVProcesoManager procesoManager;
	
	@Autowired
	private MSVFileUploadParadise fileUploadParadise; 
	
	@Autowired
	private MSVFicheroDao ficheroDao;
	
	@Autowired
	private MSVProcesoDao procesoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	public Long initProcess(MSVDtoAltaProceso dto) throws Exception {
		return apiProxyFactory.proxy(MSVProcesoApi.class).iniciarProcesoMasivo(dto);
	}
	
	public List<MSVProcesoMasivo> mostrarProcesos() {
		return procesoManager.mostrarProcesos();
	}
	
	public MSVProcesoMasivo liberarFichero(Long idProceso) throws Exception {
		return procesoManager.liberarFichero(idProceso);
	}

	public String subirFicheroParaProcesar(WebFileItem fileItem) {
		
		return fileUploadParadise.uploadAndValidate(fileItem);
		
	}

	public List<MSVDDOperacionMasiva> getTiposOperacion() {
		
		List<MSVDDOperacionMasiva> tiposOperacion = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameListaOperacionesDeUsuario();
		
		return tiposOperacion;
	}

	public FileItem downloadTemplate(Long idTipoOperacion) throws Exception {
		
		ExcelFileBean excelFileBean = apiProxyFactory.proxy(ExcelManagerApi.class).generaExcelVaciaPorTipoOperacion(idTipoOperacion);
		FileItem fileItem = null;
		
		if(excelFileBean != null) {
			fileItem = excelFileBean.getFileItem();
		}	
		
		return fileItem;
	}
	
	public FileItem downloadErrors(Long idProcess) throws Exception {
		
		MSVDocumentoMasivo document = ficheroDao.findByIdProceso(idProcess);
		FileItem fileItem = null;
		
		//Si el fichero original y el fichero de errores son iguales entonces NO hay errores.
		if(document != null) {
			fileItem = document.getErroresFichero();
			fileItem.setFileName("ERROR_"+document.getNombre());
			fileItem.setContentType(ExcelRepoApi.TIPO_EXCEL);
		}	
		
		return fileItem;
	}
	
	public void setStateProcessing(Long idProcess) {
		MSVProcesoMasivo document = procesoDao.get(idProcess);
		MSVDDEstadoProceso processing = genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_EN_PROCESO));
		document.setEstadoProceso(processing);
		procesoDao.mergeAndUpdate(document);
	}
	
	public void setStateProcessed(Long idProcess) {
		MSVProcesoMasivo document = procesoDao.get(idProcess);
		MSVDDEstadoProceso processed = genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_PROCESADO));
		document.setEstadoProceso(processed);
		procesoDao.mergeAndUpdate(document);
	}
	
	public void setStateError(Long idProcess) {
		MSVProcesoMasivo document = procesoDao.get(idProcess);
		MSVDDEstadoProceso errorProcess = genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_ERROR));
		document.setEstadoProceso(errorProcess);
		procesoDao.mergeAndUpdate(document);
	}
	
	public MSVDocumentoMasivo getMSVDocumento(Long idProcess){
		return procesoManager.getMSVDocumento(idProcess);
	}
	
	public MSVProcesoMasivo get(Long idProcess){
		return procesoManager.get(idProcess);
	}
		
	
}
