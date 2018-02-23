package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

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
			
			Integer numFilas = this.getNumFilas(file, exc);
			for (int fila = this.getFilaInicial(); fila < numFilas; fila++) {
				try{
					this.procesaFila(exc, fila);
					processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), true);
				}catch(Exception e){
					logger.error("error procesando fila "+fila+" del proceso "+file.getProcesoMasivo().getId(),e);
					processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), false);
				}
			}
			
			this.postProcesado(exc);

		} catch (ParseException e) {
			e.printStackTrace();
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
