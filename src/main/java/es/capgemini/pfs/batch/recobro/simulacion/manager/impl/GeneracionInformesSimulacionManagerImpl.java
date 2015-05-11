package es.capgemini.pfs.batch.recobro.simulacion.manager.impl;

import java.io.File;
import java.util.Date;
import java.util.List;

import jxl.Cell;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.CellFormat;
import jxl.write.DateTime;
import jxl.write.Formula;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.WritableCell;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.batch.configuracion.manager.ConfiguracionEntradaManager;
import es.capgemini.pfs.batch.configuracion.model.ConfiguracionEntrada;
import es.capgemini.pfs.batch.recobro.reparto.manager.RecobroRepartoManager;
import es.capgemini.pfs.batch.recobro.simulacion.manager.GeneracionInformesSimulacionManager;
import es.capgemini.pfs.batch.recobro.simulacion.manager.TemporalRepartoManager;
import es.capgemini.pfs.contrato.ContratoManager;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.core.manager.impl.DiccionarioManager;
import es.pfsgroup.recovery.recobroCommon.core.model.RecobroAdjuntos;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroSimulacionEsquemaManager;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoSimulacion;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSimulacionEsquema;

@Service
public class GeneracionInformesSimulacionManagerImpl implements
		GeneracionInformesSimulacionManager {
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ConfiguracionEntradaManager configuracionEntradaManager;
	
	@Autowired
	private TemporalRepartoManager temporalRepartoManager; 
	
	@Autowired
	private RecobroRepartoManager recobroRepartoManager;
	
	@Autowired
	private RecobroSimulacionEsquemaManager recobroSimulacionEsquemaManager;
		
	@Autowired
	private ContratoManager contratoManager;
	
	@Autowired
	private DiccionarioManager diccionarioManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	
	private static final String PlantillaSimulacionExcel = "PlantillaSimulacion2.xls";
	private WritableWorkbook LibroExcel;
	private FileItem file;
	private Workbook plantilla;

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void generarInformeResultadoSimulacion() throws Throwable {
		try {
			CargarPlantilla();
			generarPaginaContenidoDocumento();
			generarPaginaResultadoSimulacion();
			generarPaginaSituacionActual();			
			LibroExcel.write();
			LibroExcel.close();
			guardarRecobroSimulacionEsquema(RecobroDDEstadoSimulacion.RCF_DD_ESI_ESTADO_SIMULACION_PROCESADO);
		} catch (Exception e) {
			logger.error("Error generando el informe de la simulacion", e);
			guardarRecobroSimulacionEsquema(RecobroDDEstadoSimulacion.RCF_DD_ESI_ESTADO_SIMULACION_PROCESADO_ERRORES);			
		}finally{
			plantilla.close();
		}
	}
	
	private void guardarRecobroSimulacionEsquema(String estado) {
		try{
			RecobroSimulacionEsquema esquemaSimulacion = recobroSimulacionEsquemaManager.getProcesoEstadoPendiente();
			if (!RecobroDDEstadoSimulacion.RCF_DD_ESI_ESTADO_SIMULACION_PROCESADO_ERRORES.equals(estado)) {
				RecobroAdjuntos recobroAdjuntos = new RecobroAdjuntos();
				recobroAdjuntos.setFileItem(file);
				genericDao.save(RecobroAdjuntos.class, recobroAdjuntos);		
				esquemaSimulacion.setFichDetalle(recobroAdjuntos);
			}
			esquemaSimulacion.setFechaResultado(new Date());
			RecobroDDEstadoSimulacion estadoSimulacion = (RecobroDDEstadoSimulacion) diccionarioManager.dameValorDiccionarioByCod(RecobroDDEstadoSimulacion.class, estado);
			esquemaSimulacion.setEstado(estadoSimulacion);
			recobroSimulacionEsquemaManager.grabarProceso(esquemaSimulacion);
			RecobroEsquema esquema = esquemaSimulacion.getEsquema();
			esquema.setEstadoEsquema(genericDao.get(RecobroDDEstadoEsquema.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO)));
			genericDao.save(RecobroEsquema.class, esquema);
		}catch(Throwable e){
			logger.error("Error guardando el esquema de la simulacion", e);
		}
		
	}
	
	/**
	 * Inicializamos el Workbook, leyendo el recurso apuntado por la constante PlantillaSimulacionExcel
	 * @throws Throwable 
	 */
	private void CargarPlantilla() throws Throwable  {
		try{
			WorkbookSettings ws =  new WorkbookSettings();
			ws.setEncoding("UTF-8");
			plantilla = Workbook.getWorkbook(ClassLoader.getSystemResourceAsStream(PlantillaSimulacionExcel));			
			file = new FileItem(new File("Simulacion.xls"));
			file.setFileName("Simulacion.xls");
			LibroExcel = Workbook.createWorkbook(file.getOutputStream(), plantilla, ws);	
		}catch(Throwable e){
			logger.error("Error cargando la plantilla de la simulacion", e);
		}
	}
	
	/**
	 * Copia el formato de celdas de la filaOrigen sobre la filaDestino
	 * @param hoja
	 * @param filaOrigen
	 * @param filaDestino
	 */
	private void CopiarFormatoFila(WritableSheet hoja, int filaOrigen, int filaDestino) {
		try{
			int cols = hoja.getColumns();
			for (int c=0;c<cols;c++) {
				Cell celda = hoja.getCell(c, filaOrigen);
				CellFormat formato = celda.getCellFormat();
				if (formato!=null) {
					WritableCellFormat nuevoFormato = new WritableCellFormat(formato);
					
					WritableCell celdaDest = (WritableCell) hoja.getCell(c, filaDestino);
					celdaDest.setCellFormat(nuevoFormato);
				}
			}
		}catch(Throwable e){
			logger.error("Error copiando formato a fila durante la simulacion", e);
		}
	}	
	
	/**
	 * Genera la Pagina de Resultados del libro Excel
	 * @throws Throwable
	 */
	private void generarPaginaResultadoSimulacion() throws Throwable {
		try{
			List<ConfiguracionEntrada> agencias = configuracionEntradaManager.obtenerAgenciasOrdenadosCarSubAgeDeEsquemasPendientesSimular();		
			int filaOrigen = 7;
			int filaAct = filaOrigen;
			WritableSheet paginaResultadoSimulacion= (WritableSheet)LibroExcel.getSheet(1);
			for (ConfiguracionEntrada agencia : agencias) {
				//System.out.println(agencia.getCarteraId() + "\t" + agencia.getSubcarteraId() + "\t" + agencia.getAgenciaId() + "\t" + 
				//temporalRepartoManager.getCountClientes(agencia.getAgenciaId()) + "\t" + temporalRepartoManager.getCountContratos(agencia.getAgenciaId()) + 
				//"\t" + temporalRepartoManager.getSaldoIrregular(agencia.getAgenciaId()) + "\t" + temporalRepartoManager.getSaldoVivo(agencia.getAgenciaId()) );		
				//Agregamos una fila
				filaAct++;
				paginaResultadoSimulacion.insertRow(filaAct);
				//Cartera
				Label celda = new Label(1,filaAct,agencia.getCarteraNombre());
				paginaResultadoSimulacion.addCell(celda);
				//Subcartera
				celda = new Label(2,filaAct,agencia.getSubcarteraNombre());
				paginaResultadoSimulacion.addCell(celda);
				//Proveedor
				celda = new Label(3,filaAct,agencia.getAgenciaNombre());
				paginaResultadoSimulacion.addCell(celda);
				//Clientes
				Number numero = new Number(4,filaAct,temporalRepartoManager.getCountClientes(agencia.getAgenciaId(), agencia.getSubcarteraId()));
				paginaResultadoSimulacion.addCell(numero);
				//Contratos
				numero = new Number(7,filaAct,temporalRepartoManager.getCountContratos(agencia.getAgenciaId(), agencia.getSubcarteraId()));
				paginaResultadoSimulacion.addCell(numero);
				Double saldo;
				//R.Irregular
				saldo = temporalRepartoManager.getSaldoIrregular(agencia.getAgenciaId(), agencia.getSubcarteraId());
				if (saldo==null)
					saldo = 0d;
				numero = new Number(10,filaAct,saldo);
				paginaResultadoSimulacion.addCell(numero);
				//R.Vivo
				saldo = temporalRepartoManager.getSaldoVivo(agencia.getAgenciaId(), agencia.getSubcarteraId());
				if (saldo==null)
					saldo = 0d;
				numero = new Number(13,filaAct,saldo);
				paginaResultadoSimulacion.addCell(numero);
				this.CopiarFormatoFila(paginaResultadoSimulacion, filaOrigen, filaAct);			
			}
			this.prepararFormulas(paginaResultadoSimulacion, filaOrigen+1, filaAct, filaOrigen);
			//Combinamos celdas cartera
			this.combinarCeldas(paginaResultadoSimulacion, 1, filaOrigen+1, filaAct);
			//Combinamos celdas subcartera
			this.combinarCeldas(paginaResultadoSimulacion, 2, filaOrigen+1, filaAct);		
			paginaResultadoSimulacion.removeRow(filaOrigen);
		}catch(Throwable e){
			logger.error("Error generando la pagina de resultados de la simulacion", e);
		}
		
	}
	
	/**
	 * Genera la Pagina de Situacion Actual del libro Excel
	 * @throws Throwable
	 */
	private void generarPaginaSituacionActual() throws Throwable {
		try{
			List<ConfiguracionEntrada> agencias = configuracionEntradaManager.obtenerAgenciasOrdenadosCarSubAgeDeEsquemasLiberados();
			int filaOrigen = 7;
			int filaAct = filaOrigen;
			WritableSheet paginaSituacionActual = (WritableSheet)LibroExcel.getSheet(2);
			Date fechaHistorico = recobroRepartoManager.getFechaUltimoHistoricoReparto();
			for (ConfiguracionEntrada agencia : agencias) {
				//System.out.println(agencia.getCarteraId() + "\t" + agencia.getSubcarteraId() + "\t" + agencia.getAgenciaId() + "\t" + 
				//temporalRepartoManager.getCountClientes(agencia.getAgenciaId()) + "\t" + temporalRepartoManager.getCountContratos(agencia.getAgenciaId()) + "\t" + 
				//temporalRepartoManager.getSaldoIrregular(agencia.getAgenciaId()) + "\t" + temporalRepartoManager.getSaldoVivo(agencia.getAgenciaId()) );			
				//Agregamos una fila
				filaAct++;
				paginaSituacionActual.insertRow(filaAct);
				//Cartera
				Label celda = new Label(1,filaAct, agencia.getCarteraNombre());
				paginaSituacionActual.addCell(celda);
				//Subcartera
				celda = new Label(2,filaAct,agencia.getSubcarteraNombre());
				paginaSituacionActual.addCell(celda);
				//Proveedor
				celda = new Label(3,filaAct,agencia.getAgenciaNombre());
				paginaSituacionActual.addCell(celda);
				//Clientes
				Number numero = new Number(4,filaAct,recobroRepartoManager.getCountClientes(fechaHistorico, agencia.getAgenciaId(), agencia.getSubcarteraId()));
				paginaSituacionActual.addCell(numero);
				//Contratos
				numero = new Number(7,filaAct,recobroRepartoManager.getCountContratos(fechaHistorico, agencia.getAgenciaId(), agencia.getSubcarteraId()));
				paginaSituacionActual.addCell(numero);
				Double saldo;
				//R.Irregular
				saldo = recobroRepartoManager.getSaldoIrregular(fechaHistorico, agencia.getAgenciaId(), agencia.getSubcarteraId());
				if (saldo==null)
					saldo = 0d;
				numero = new Number(10,filaAct,saldo);
				paginaSituacionActual.addCell(numero);
				//R.Vivo
				saldo = recobroRepartoManager.getSaldoVivo(fechaHistorico, agencia.getAgenciaId(), agencia.getSubcarteraId());
				if (saldo==null)
					saldo = 0d;
				numero = new Number(13,filaAct,saldo);
				paginaSituacionActual.addCell(numero);
				this.CopiarFormatoFila(paginaSituacionActual, filaOrigen, filaAct);				
			}
			this.prepararFormulas(paginaSituacionActual, filaOrigen+1, filaAct, filaOrigen);
			//Combinamos celdas cartera
			this.combinarCeldas(paginaSituacionActual, 1, filaOrigen+1, filaAct);
			//Combinamos celdas subcartera
			this.combinarCeldas(paginaSituacionActual, 2, filaOrigen+1, filaAct);		
			paginaSituacionActual.removeRow(filaOrigen);
		}catch(Throwable e){
			logger.error("Error generando la pagina actual de la simulacion", e);
		}
	}
	
	/**
	 * Genera la pagina de Contenido Documento del libro Excel
	 * @throws Throwable
	 */
	private void generarPaginaContenidoDocumento() throws Throwable {
		try{
			WritableSheet paginaContenidoDocumento = (WritableSheet)LibroExcel.getSheet(0);		
			DateTime fechaDatos = new DateTime(4, 12, contratoManager.getUltimaFechaCarga(), paginaContenidoDocumento.getCell(4, 12).getCellFormat());
			paginaContenidoDocumento.addCell(fechaDatos);	
			DateTime fechaSimulacion = new DateTime(4, 14, new java.util.Date(), paginaContenidoDocumento.getCell(4, 12).getCellFormat());
			paginaContenidoDocumento.addCell(fechaSimulacion);
		}catch(Throwable e){
			logger.error("Error generando la pagina de contenido de la simulacion", e);
		}
	}
	
	/**
	 * Combina las celdas con el mismo contenido
	 * @param hoja
	 * @param columna, columna de las celdas a combinar
	 * @param fInicio, fila a partir de la cual se empieza a realizar la combinación
	 * @param fFin, fila hasta la cual se realiza la combinación
	 */
	private void combinarCeldas(WritableSheet hoja, int columna, int fInicio, int fFin) {		
		try {
			String contentAnterior="";
			int inicioCambio = -1;
			for (int r=fInicio;r<=fFin;r++) {
				if (!hoja.getCell(columna, r).getContents().equals(contentAnterior)) {
					if (inicioCambio>-1) {
						hoja.mergeCells(columna, inicioCambio, columna, r-1);
					}
					contentAnterior = hoja.getCell(columna, r).getContents();
					inicioCambio = r;
				}
			}
			if (inicioCambio<fFin) {
				hoja.mergeCells(columna, inicioCambio, columna, fFin);
			}			
		} catch (Exception e) {
			logger.error("Error combinando las celdas de la simulacion", e);
		}
	}
	
	/**
	 * Asigna las formulas de la hoja
	 * @param hoja
	 * @param fInicio
	 * @param fFin
	 * @param fFormato
	 */
	private void prepararFormulas(WritableSheet hoja, int fInicio, int fFin, int fFormato) {
		try {
			String subCarteraAnteriorName = "";
			int fInicioSubCartera = -1;
			int fFinSubCartera = -1;
			//Formularas que se agrupan por subcarteras
			for (int r=fInicio;r<=fFin;r++) {
				//Cuando cambiemos de subcartera
				if (!hoja.getCell(2, r).getContents().equals(subCarteraAnteriorName)) {
					fFinSubCartera = r-1;
					//Clientes subcartera
					this.formulaSubCartera(hoja, fInicioSubCartera, fFinSubCartera, 5, "E", fFormato);
					//Contratos subcartera
					this.formulaSubCartera(hoja, fInicioSubCartera, fFinSubCartera, 8, "H", fFormato);				
					//S.Regular subcartera
					this.formulaSubCartera(hoja, fInicioSubCartera, fFinSubCartera, 11, "K", fFormato);				
					//S.Vivo subcartera
					this.formulaSubCartera(hoja, fInicioSubCartera, fFinSubCartera, 14, "N", fFormato);				
					fInicioSubCartera = r;
					subCarteraAnteriorName = hoja.getCell(2, r).getContents();
				}
			}
			this.formulaSubCartera(hoja, fInicioSubCartera, fFin,5, "E", fFormato);
			this.formulaSubCartera(hoja, fInicioSubCartera, fFin,8, "H", fFormato);
			this.formulaSubCartera(hoja, fInicioSubCartera, fFin,11, "K", fFormato);
			this.formulaSubCartera(hoja, fInicioSubCartera, fFin,14, "N", fFormato);
			
			//Formulas total general
			Formula TotalClientes = new Formula(4, fFin+1, protegerFormulaError("SUMA(E" + (fInicio+1) + ":E" + (fFin+1)) ,hoja.getCell(4,fFin+1).getCellFormat());
			hoja.addCell(TotalClientes);
			TotalClientes = new Formula(6, fFin+1, protegerFormulaError("SUMA(G" + (fInicio+1) + ":G" + (fFin+1)) ,hoja.getCell(6,fFin+1).getCellFormat());
			hoja.addCell(TotalClientes);
			
			Formula TotalContratos = new Formula(7, fFin+1, protegerFormulaError("SUMA(H" + (fInicio+1) + ":H" + (fFin+1)) ,hoja.getCell(7,fFin+1).getCellFormat());
			hoja.addCell(TotalContratos);
			TotalContratos = new Formula(9, fFin+1, protegerFormulaError("SUMA(J" + (fInicio+1) + ":J" + (fFin+1)) ,hoja.getCell(9,fFin+1).getCellFormat());
			hoja.addCell(TotalContratos);			
			
			Formula TotalRIrregular = new Formula(10, fFin+1, protegerFormulaError("SUMA(K" + (fInicio+1) + ":K" + (fFin+1)) ,hoja.getCell(10,fFin+1).getCellFormat());
			hoja.addCell(TotalRIrregular);
			TotalRIrregular = new Formula(12, fFin+1, protegerFormulaError("SUMA(M" + (fInicio+1) + ":M" + (fFin+1)) ,hoja.getCell(12,fFin+1).getCellFormat());
			hoja.addCell(TotalRIrregular);			
			
			Formula TotalRVivo = new Formula(13, fFin+1, protegerFormulaError("SUMA(N" + (fInicio+1) + ":N" + (fFin+1)) ,hoja.getCell(13,fFin+1).getCellFormat());
			hoja.addCell(TotalRVivo);			
			TotalRVivo = new Formula(15, fFin+1, protegerFormulaError("SUMA(P" + (fInicio+1) + ":P" + (fFin+1)) ,hoja.getCell(15,fFin+1).getCellFormat());
			hoja.addCell(TotalRVivo);			
			
			//Formulas totales
			for (int r=fInicio;r<=fFin;r++) {
				//Total de clientes
				Formula formulaTClientes = new Formula(6, r, protegerFormulaError("E" + (r+1) + "/E$" + (fFin+2)) , hoja.getCell(6,fFormato).getCellFormat());
				hoja.addCell(formulaTClientes);
				//Total de contratos
				Formula formulaTContratos = new Formula(9, r, protegerFormulaError("H" + (r+1) + "/H$" + (fFin+2)) , hoja.getCell(9,fFormato).getCellFormat());
				hoja.addCell(formulaTContratos);
				//Total de R.Irregular
				Formula formulaTRIrregular = new Formula(12, r, protegerFormulaError("K" + (r+1) + "/K$" + (fFin+2)) , hoja.getCell(12,fFormato).getCellFormat());
				hoja.addCell(formulaTRIrregular);
				//Total de R.Vivo
				Formula formulaTRVivo = new Formula(15, r, protegerFormulaError("N" + (r+1) + "/N$" + (fFin+2)), hoja.getCell(15,fFormato).getCellFormat());
				hoja.addCell(formulaTRVivo);				
			}
		} catch (Exception e) {
			logger.error("Error preparando las formulas de la simulacion", e);
		}
	}
	
	/**
	 * Realiza las formulas de % con respecto a subcartera
	 * @param hoja
	 * @param fInicio
	 * @param fFin
	 * @param colFormula
	 * @param colValores
	 * @param fFormato
	 */
	private void formulaSubCartera(WritableSheet hoja, int fInicio, int fFin, int colFormula, String colValores, int fFormato) {
		try {
			if (fInicio>0 && fFin>0) {
				for(int r=fInicio;r<=fFin;r++) {
					Formula formula = new Formula(colFormula, r, protegerFormulaError(colValores + (r+1) + "/SUMA(" + colValores + (fInicio+1) + ":" + colValores + (fFin+1) + ")"), hoja.getCell(colFormula, fFormato).getCellFormat());
					hoja.addCell(formula);
				}
			}
		} catch (Exception e) {
			logger.error("Error ralizando la formula de las subcarteras de la simulacion", e);
		}
	}
	
	/**
	 * Antepone si.error a las formulas
	 * @deprecated actualmente no funciona
	 * @param formula
	 * @return
	 */
	private String protegerFormulaError(String formula) {
		//return "SI.ERROR(" + formula + ";0)";
		return formula;
	}

}
