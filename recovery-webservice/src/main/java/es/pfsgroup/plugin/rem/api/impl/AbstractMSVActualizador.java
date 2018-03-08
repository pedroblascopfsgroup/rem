package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;


@Component
abstract public class AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());

	public static final int EXCEL_FILA_DEFECTO = 1;
	
	public abstract String getValidOperation();
	
	@Transactional(readOnly = false)
	public abstract void procesaFila(MSVHojaExcel exc, int fila) throws IOException, ParseException, JsonViewerException, SQLException, Exception;
	
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {

		if (!Checks.esNulo(tipoOperacion)) {
			if (this.getValidOperation().equals(tipoOperacion.getCodigo())) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}		
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException, JsonViewerException, SQLException, Exception {
			
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
		
		try {
			
			this.preProcesado(exc);
			TransactionStatus transaction = null;
			Integer numFilas = this.getNumFilas(file, exc);
			for (int fila = this.getFilaInicial(); fila < numFilas; fila++) {
				try{
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					this.procesaFila(exc, fila);
					transactionManager.commit(transaction);
					processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), true);
				}catch(Exception e){
					logger.error("error procesando fila "+fila+" del proceso "+file.getProcesoMasivo().getId(),e);
					transactionManager.rollback(transaction);
					processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), false);
					
				}
			}
			
			this.postProcesado(exc);

		} catch (ParseException e) {
			logger.error("Error procesando fichero",e);
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public Integer getNumFilas(MSVDocumentoMasivo file, MSVHojaExcel exc) throws IOException {
		Integer numFilas = exc.getNumeroFilasByHoja(0,file.getProcesoMasivo().getTipoOperacion());
		return numFilas;
	}
    
	@Transactional(readOnly = false)
	public void preProcesado(MSVHojaExcel exc) throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
	}
	
	@Transactional(readOnly = false)
	public void postProcesado(MSVHojaExcel exc) throws NumberFormatException, IllegalArgumentException, IOException, ParseException{
	}

	@Override
	public int getFilaInicial() {
		return AbstractMSVActualizador.EXCEL_FILA_DEFECTO;
	}

}
