package es.pfsgroup.framework.paradise.bulkUpload.adapter;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
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
import es.pfsgroup.framework.paradise.bulkUpload.dto.DtoMSVProcesoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoAltaProceso;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.framework.paradise.bulkUpload.model.ExcelFileBean;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDEstadoProceso;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;
import es.pfsgroup.framework.paradise.utils.JsonViewer;


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
	
	@Autowired
	private ExcelManagerApi excelManagerApi;
	
	public Long initProcess(MSVDtoAltaProceso dto) throws Exception {
		return apiProxyFactory.proxy(MSVProcesoApi.class).iniciarProcesoMasivo(dto);
	}
	
	public List<DtoMSVProcesoMasivo> mostrarProcesos() {
		return procesoManager.mostrarProcesos();
	}
	
	public Page mostrarProcesosPaginados(MSVDtoFiltroProcesos dto) {
		return apiProxyFactory.proxy(MSVProcesoApi.class).mostrarProcesosPaginated(dto);
	}
	
	public MSVProcesoMasivo liberarFichero(Long idProceso) throws Exception {
		return procesoManager.liberarFichero(idProceso);
	}

	public String subirFicheroParaProcesar(WebFileItem fileItem) {
		
		return fileUploadParadise.uploadAndValidate(fileItem);
		
	}
	
	public Boolean subirFichero(WebFileItem fileItem) {
		
		return fileUploadParadise.upload(fileItem);
		
	}
	
	public Boolean validarMasivo(Long idProceso) throws Exception {
		return excelManagerApi.validateContentOnly(idProceso);
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
	
	@Transactional
	public void setStateProcessing(Long idProcess) {
		this.setStateProcessing(idProcess, null);
	}
	
	@Transactional
	public void setStateProcessing(Long idProcess,Long totalFilas) {
		MSVProcesoMasivo document = procesoDao.get(idProcess);
		MSVDDEstadoProceso processing = genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_EN_PROCESO));
		document.setEstadoProceso(processing);
		document.setTotalFilasKo(0L);
		document.setTotalFilasOk(0L);
		document.setTotalFilas(totalFilas);
		procesoDao.mergeAndUpdate(document);
	}
	
	@Transactional(readOnly = false)
	public void setStateValidando(Long idProcess){
		MSVProcesoMasivo document = procesoDao.get(idProcess);
		MSVDDEstadoProceso validando = genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_VALIDANDO));
		document.setEstadoProceso(validando);
		procesoDao.mergeAndUpdate(document);
	}
	
	@Transactional
	public void setStateValidado(Long idProcess){
		MSVProcesoMasivo document = procesoDao.get(idProcess);
		MSVDDEstadoProceso validado = genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_VALIDADO));
		document.setEstadoProceso(validado);
		procesoDao.mergeAndUpdate(document);
	}
	
	@Transactional
	public void addFilaProcesada(Long idProcess, boolean esOk){
		MSVProcesoMasivo document = procesoDao.get(idProcess);
		Long nFilas = 0L;
		if(esOk){
			nFilas = document.getTotalFilasOk();
			if(nFilas != null){
				nFilas = nFilas +1;
			}else{
				nFilas = 1L;
			}
			document.setTotalFilasOk(nFilas);
		}else{
			nFilas = document.getTotalFilasKo();
			if(nFilas != null){
				nFilas = nFilas +1;
			}else{
				nFilas = 1L;
			}
			document.setTotalFilasKo(nFilas);
		}
		procesoDao.mergeAndUpdate(document);
	}
	
	@Transactional
	public void setStateProcessed(Long idProcess) {
		MSVProcesoMasivo document = procesoDao.get(idProcess);
		MSVDDEstadoProceso processed = genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_PROCESADO));
		document.setEstadoProceso(processed);
		procesoDao.mergeAndUpdate(document);
	}
	
	@Transactional
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
