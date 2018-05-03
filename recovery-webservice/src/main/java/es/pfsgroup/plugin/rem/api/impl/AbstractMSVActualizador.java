package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.ResultadoProcesarFila;


@Component
abstract public class AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private MSVFicheroDao ficheroDao;
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());

	public static final int EXCEL_FILA_DEFECTO = 1;
	
	public abstract String getValidOperation();
	
	@Transactional(readOnly = false)
	public abstract ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException, Exception;
	
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
			List<Integer> listaFilas = new ArrayList<Integer>();
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			Long token = null;
			ResultadoProcesarFila resultProcesaFila = null;
			if(!Checks.esNulo(file) && !Checks.esNulo(file.getProcesoMasivo())) {
				token = file.getProcesoMasivo().getToken();
			}
			
			for (int fila = this.getFilaInicial(); fila < numFilas; fila++) {
				try{
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					
					resultProcesaFila = this.procesaFila(exc, fila,token);
					
					transactionManager.commit(transaction);
					processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), true);
					
					
				}catch(Exception e){
					listaFilas.add(fila);
					mapaErrores.put("KO", listaFilas);
					logger.error("error procesando fila "+fila+" del proceso "+file.getProcesoMasivo().getId(),e);
					transactionManager.rollback(transaction);
					processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), false);					
				}
				
				
			}
			if(!mapaErrores.isEmpty()){
				MSVDocumentoMasivo archivo = ficheroDao.findByIdProceso(file.getProcesoMasivo().getId());
				if (!Checks.esNulo(archivo)) {
					exc = excelParser.getExcel(archivo.getContenidoFichero().getFile());
					String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
					FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
					
					processAdapter.setExcelErroresProcesado(archivo, fileItemErrores);
				}
			}
			
			if(!Checks.esNulo(resultProcesaFila) && resultProcesaFila.isHashmapVacio()) {
				
			}
			
			this.postProcesado(exc);

		}
		catch (Exception e) {
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
