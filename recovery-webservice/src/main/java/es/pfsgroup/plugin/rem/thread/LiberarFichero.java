package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberatorsFactory;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class LiberarFichero implements Runnable{
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private MSVFicheroDao ficheroDao;
	
	@Autowired
	private MSVLiberatorsFactory factoriaLiberators;
	
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private String userName = null;
	private Long idOperation;
	private Long idProcess;
	private Object[] extraArgs;
	
	public LiberarFichero(Long idProcess, Long idOperation,String userName, Object[] extraArgs) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idOperation = idOperation;
		this.idProcess = idProcess;
		this.extraArgs = extraArgs;
	}

	@Override
	public void run() {
		try {
			Boolean resultado = false;
			restApi.doSessionConfig(this.userName);
			MSVDocumentoMasivo document = ficheroDao.findByIdProceso(idProcess);
			MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(document);
			
			MSVDDOperacionMasiva tipoOperacion = msvProcesoApi.getOperacionMasiva(idOperation);
			
			MSVLiberator lib = factoriaLiberators.dameLiberator(tipoOperacion);
			if (!Checks.esNulo(lib)) {
				
				document.setExtraArgs(this.extraArgs);
				
				resultado = lib.liberaFichero(document);
			}
				
			if(resultado){
				processAdapter.setStateProcessed(idProcess);
				lib.postProcesado(exc);
			}else{
				processAdapter.setStateError(idProcess);
			}
			
		} catch (Exception e) {
			logger.error("error liberando fichero", e);
			processAdapter.setStateError(idProcess);
		}
		
	}

}
