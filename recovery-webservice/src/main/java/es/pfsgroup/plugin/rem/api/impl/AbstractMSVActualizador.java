package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
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
import es.pfsgroup.framework.paradise.bulkUpload.model.ProcesoMasivoContext;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;

@Component
public abstract  class AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private ProcessAdapter processAdapter;

	@Autowired
	private MSVFicheroDao ficheroDao;

	@Autowired
	private MSVExcelParser excelParser;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	private final Log logger = LogFactory.getLog(getClass());

	private static final int EXCEL_FILA_DEFECTO = 1;
	private static final String CONFIG_EXISTENTE = "Ya existe una configuración";

	public abstract String getValidOperation();

	public abstract ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException, Exception;

	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken, ProcesoMasivoContext context) throws IOException, ParseException, JsonViewerException, SQLException,
			Exception {
		return this.procesaFila(exc, fila, prmToken);
	}
	
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken,Object[] extraArgs)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception{
			return this.procesaFila(exc, fila, prmToken);
	}

	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {

		if (!Checks.esNulo(tipoOperacion)) {
			return this.getValidOperation().equals(tipoOperacion.getCodigo());
		} else {
			return false;
		}
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException, JsonViewerException, SQLException, Exception {

		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
		ArrayList<ResultadoProcesarFila> resultados = new ArrayList<ResultadoProcesarFila>();
		//Map<Long,String> promociones = null;
		try {
			ProcesoMasivoContext context = new ProcesoMasivoContext();
			this.preProcesado(exc, context);
			TransactionStatus transaction = null;
			Integer numFilas = this.getNumFilas(file, exc);
			Long token = null;
			if (!Checks.esNulo(file) && !Checks.esNulo(file.getProcesoMasivo())) {
				token = file.getProcesoMasivo().getToken();
			}
//			if (file.getProcesoMasivo().getTipoOperacion().getCodigo().equals(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ALTA_ACTIVOS_BBVA)) {
//				promociones = new HashMap<Long,String>();
//				for(int fila = this.getFilaInicial(); fila < numFilas; fila++) {
//					if(exc.dameCelda(fila, 1) != null && !exc.dameCelda(fila, 1).isEmpty()) 
//						promociones.put(Long.valueOf(exc.dameCelda(fila, 0)), exc.dameCelda(fila, 1));
//				}
//			}
			for (int fila = this.getFilaInicial(); fila < numFilas; fila++) {
				ResultadoProcesarFila resultProcesaFila = null;
				try {
					if (file.getProcesoMasivo().getTipoOperacion().getCodigo().equals(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA)) {
						resultProcesaFila = this.procesaFila(exc, fila, token, context);
					} else {
						transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
						if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO.equals(file.getProcesoMasivo().getTipoOperacion().getCodigo())) {
							resultProcesaFila = this.procesaFila(exc, fila, token, file.getExtraArgs());
						}
						else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_UNICA_GASTOS.equals(file.getProcesoMasivo().getTipoOperacion().getCodigo())) {
							resultProcesaFila = this.procesaFila(exc, fila, token, context);
						} else {
							resultProcesaFila = this.procesaFila(exc, fila, token);
						}
						
						transactionManager.commit(transaction);
					}
					if(resultProcesaFila.getErrorDesc() != null && !resultProcesaFila.getErrorDesc().isEmpty()) {
						resultProcesaFila.setFila(fila);
						resultados.add(resultProcesaFila);
						processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), false);
					} else {
						resultProcesaFila.setCorrecto(true);
						resultProcesaFila.setFila(fila);
						resultados.add(resultProcesaFila);
						processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), true);
					}

				} catch (Exception e) {
					logger.error("error procesando fila " + fila + " del proceso " + file.getProcesoMasivo().getId(), e);
					if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CONFIGURACION_RECOMENDACION.equals(file.getProcesoMasivo().getTipoOperacion().getCodigo())
							&& e.getMessage().contains("ConstraintViolationException")) {
						resultProcesaFila = new ResultadoProcesarFila();
						resultProcesaFila.setCorrecto(false);
						resultProcesaFila.setFila(fila);
						resultProcesaFila.setErrorDesc(CONFIG_EXISTENTE);
						resultados.add(resultProcesaFila);
						processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), false);
					} else {
						if (!file.getProcesoMasivo().getTipoOperacion().getCodigo().equals(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA)) {
							try {
								transactionManager.rollback(transaction);
							} catch (Exception ex) {
								logger.error("error rollback proceso masivo");
							}
						}
						resultProcesaFila = new ResultadoProcesarFila();
						resultProcesaFila.setCorrecto(false);
						resultProcesaFila.setFila(fila);
						resultProcesaFila.setErrorDesc(e.getMessage());
						resultados.add(resultProcesaFila);
						processAdapter.addFilaProcesada(file.getProcesoMasivo().getId(), false);
					}
				} 
			}

			MSVDocumentoMasivo archivo = ficheroDao.findByIdProceso(file.getProcesoMasivo().getId());
			exc = excelParser.getExcel(archivo.getContenidoFichero().getFile());
			String nomFicheroResultados = null;
			if(file.getProcesoMasivo().getTipoOperacion().getCodigo().equals(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_INFO_DETALLE_PRINEX_LBK)) {
				nomFicheroResultados = exc.crearExcelResultado(resultados, 0, this.getFilaInicial(), true);
			}else {
				nomFicheroResultados = exc.crearExcelResultado(resultados, 0, this.getFilaInicial());
			}
			FileItem fileItemResultados = new FileItem(new File(nomFicheroResultados));

			processAdapter.setExcelResultadosProcesado(archivo, fileItemResultados);

		} catch (Exception e) {
			logger.error("Error procesando fichero", e);
			return false;
		}

		return true;
	}

	public Integer getNumFilas(MSVDocumentoMasivo file, MSVHojaExcel exc) throws IOException {
		return exc.getNumeroFilasByHoja(0, file.getProcesoMasivo().getTipoOperacion());
	}

	public void preProcesado(MSVHojaExcel exc) throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		this.preProcesado(exc, null);
	}

	public void preProcesado(MSVHojaExcel exc, ProcesoMasivoContext context) throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
	}

	public void postProcesado(MSVHojaExcel exc) throws Exception {
	}

	@Override
	public int getFilaInicial() {
		return AbstractMSVActualizador.EXCEL_FILA_DEFECTO;
	}

}
