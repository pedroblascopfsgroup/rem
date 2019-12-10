package es.pfsgroup.plugin.rem.masivo.manager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberatorsFactory;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;


public class MSVAsyncProcess implements Runnable {
	

	@Autowired
	private MSVLiberatorsFactory factoriaLiberators;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private RestApi restApi;

	private final Log logger = LogFactory.getLog(getClass());
	
	private Long idProcess;
	
	private Long idOperation;
	
	private String userName;
	
	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			this.startProcess();
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
		}
		
	}
	
	public MSVAsyncProcess(Long idProcess, Long idOperation, String userName) {
		
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.idProcess = idProcess;
		this.idOperation = idOperation;
		this.userName = userName;
	}

	public void startProcess() {
		
		MSVLiberator lib = this.getLiberator(this.idOperation);
		if (!Checks.esNulo(lib)) {
			try {
				MSVDocumentoMasivo document = msvProcesoApi.getMSVDocumento(idProcess);
				lib.liberaFichero(document);
			} catch (Exception e) {
				logger.error("Error en el proceso masivo:" + lib.getClass(),e);
			}
		}		
	}
	
	private MSVLiberator getLiberator(Long idOperation) {
		
		MSVDDOperacionMasiva tipoOperacion = msvProcesoApi.getOperacionMasiva(idOperation);

		return factoriaLiberators.dameLiberator(tipoOperacion);
	}
}
