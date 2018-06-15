package es.pfsgroup.framework.paradise.bulkUpload.adapter;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
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
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
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
		Boolean resultado = false;
		TransactionStatus transaction = null;
		try{
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			resultado =  excelManagerApi.validateContentOnly(idProceso);
			transactionManager.commit(transaction);
		}catch(Exception e){
			transactionManager.rollback(transaction);
			throw e;
		}
		
		return resultado;
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
			
			if(!Checks.esNulo(document.getProcesoMasivo()) && !Checks.esNulo(document.getProcesoMasivo().getTotalFilasKo()) && 
					document.getProcesoMasivo().getTotalFilasKo()>0){
				fileItem = document.getErroresFicheroProcesar();
				fileItem.setFileName("ERROR_PROCESAR_"+document.getNombre());
				fileItem.setContentType(ExcelRepoApi.TIPO_EXCEL);
			}
			else{
				fileItem = document.getErroresFichero();
				fileItem.setFileName("ERROR_"+document.getNombre());
				fileItem.setContentType(ExcelRepoApi.TIPO_EXCEL);
			}
		}	
		
		return fileItem;
	}
	
	public FileItem downloadResultados(Long idProcess) throws Exception{
		MSVDocumentoMasivo document = ficheroDao.findByIdProceso(idProcess);
		FileItem fileItem = null;
		
		if(document != null) {
			
			fileItem = document.getResultadoFich();
			fileItem.setFileName("RESULTADO_"+document.getNombre());
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
		String estadoProceso = MSVDDEstadoProceso.CODIGO_PROCESADO;
		
		if (!Checks.esNulo(document) && document.getTotalFilasKo() != 0) {
			estadoProceso = MSVDDEstadoProceso.CODIGO_PROCESADO_CON_ERRORES;
		}
		
		MSVDDEstadoProceso processed = genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoProceso));
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
	
	@Transactional
	public void setExcelErroresProcesado(MSVDocumentoMasivo document, FileItem fileItemErrores)	{	
		document.setErroresFicheroProcesar(fileItemErrores);
		ficheroDao.saveOrUpdate(document);
	}
	
	@Transactional
	public void setExcelResultadosProcesado(MSVDocumentoMasivo document, FileItem fileItemResultados)	{	
		document.setResultadoFich(fileItemResultados);
		ficheroDao.saveOrUpdate(document);
	}

	/**
	 * @param page
	 * @param listProcesosmasivos
	 */
	public void addListProcesosMasivo(Page page, List<DtoMSVProcesoMasivo> listProcesosmasivos) {
		for (int i = 0; i < page.getResults().size(); i++) {
			boolean sePuedeProcesar = false;
			boolean conErrores = false;
			boolean validable = false;
			boolean conResultados = false;
			MSVProcesoMasivo procesomasivo = (MSVProcesoMasivo) page.getResults().get(i);
			DtoMSVProcesoMasivo masivoDto = new DtoMSVProcesoMasivo();
			if (procesomasivo.getEstadoProceso() != null) {
				masivoDto.setEstadoProceso(procesomasivo.getEstadoProceso().getDescripcion());
			} else {
				masivoDto.setEstadoProceso("Validando");
			}
			masivoDto.setUsuario(procesomasivo.getAuditoria().getUsuarioCrear());
			masivoDto.setTipoOperacionId(procesomasivo.getTipoOperacion().getId());
			masivoDto.setId(procesomasivo.getId().toString());
			masivoDto.setNombre(procesomasivo.getDescripcion());
			if (procesomasivo.getEstadoProceso() != null) {
				if (MSVDDEstadoProceso.CODIGO_VALIDADO.equals(procesomasivo.getEstadoProceso().getCodigo())) {
					sePuedeProcesar = true;
				} else if (!procesomasivo.getTipoOperacion().getResultado() && (MSVDDEstadoProceso.CODIGO_PROCESADO.equals(procesomasivo.getEstadoProceso().getCodigo()) || 
						MSVDDEstadoProceso.CODIGO_PROCESADO_CON_ERRORES.equals(procesomasivo.getEstadoProceso().getCodigo()))) {
					conResultados = true;
				} else  if (MSVDDEstadoProceso.CODIGO_ERROR.equals(procesomasivo.getEstadoProceso().getCodigo()) || 
						MSVDDEstadoProceso.CODIGO_PROCESADO_CON_ERRORES.equals(procesomasivo.getEstadoProceso().getCodigo())) {
					conErrores = true;
				} else if (MSVDDEstadoProceso.CODIGO_PTE_VALIDAR
						.equals(procesomasivo.getEstadoProceso().getCodigo())) {
					validable = true;
				} 
			}
			masivoDto.setSePuedeProcesar(sePuedeProcesar);
			masivoDto.setConErrores(conErrores);
			masivoDto.setValidable(validable);
			masivoDto.setConResultados(conResultados);
			masivoDto.setTipoOperacion(procesomasivo.getTipoOperacion().getDescripcion());
			masivoDto.setFechaCrear(procesomasivo.getAuditoria().getFechaCrear());
			masivoDto.setTotalFilas(procesomasivo.getTotalFilas());
			masivoDto.setTotalFilasOk(procesomasivo.getTotalFilasOk());
			masivoDto.setTotalFilasKo(procesomasivo.getTotalFilasKo());
	
			listProcesosmasivos.add(masivoDto);
		}
	}	
	
}
