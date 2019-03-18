package es.pfsgroup.plugin.rem.propuestaprecios.service.impl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletContext;

import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.read.biff.BiffException;
import jxl.write.Blank;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.NumberFormat;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.propuestaprecios.service.GenerarPropuestaPreciosService;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad03;

@Component
public class GenerarPropuestaPreciosServiceEntidad03 implements GenerarPropuestaPreciosService {
	
	private Workbook libroExcel; 
	private WritableWorkbook libroEditable;
	private File file;
	private static final int filaInicial = 8;
	
	protected static final Log logger = LogFactory.getLog(GenerarPropuestaPreciosServiceEntidad03.class);
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{GenerarPropuestaPreciosService.EXCEL_BANKIA_CODIGO};
	}
	
	public GenerarPropuestaPreciosServiceEntidad03() {
		super();
	}
	
	@Override
	public File getFile() {
		return file;
	}

	@Override
	public void cargarPlantilla(ServletContext sc) {
		String ruta = sc.getRealPath("plantillas/plugin/propuestaprecios/ACTIVOS_PROPUESTA_PRECIOS_ENTIDAD03.xls");

		try {
			file = new File(ruta);
			WorkbookSettings workbookSettings = new WorkbookSettings();
			workbookSettings.setEncoding( "Cp1252" );
			workbookSettings.setSuppressWarnings(true);
			libroExcel = Workbook.getWorkbook( file, workbookSettings );
			
		} catch (BiffException e) {
			logger.error(e.getMessage());
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
	}


	@SuppressWarnings("hiding")
	@Override
	public <DtoGenerarPropuestaPreciosEntidad03> void rellenarPlantilla(String numPropuesta, String gestor, List<DtoGenerarPropuestaPreciosEntidad03> listDto) {
		try {
			
			this.file = new File(file.getAbsolutePath().replace("_ENTIDAD03",""));
			libroEditable = Workbook.createWorkbook(this.file, libroExcel);

			WritableSheet hojaDetalle = libroEditable.getSheet(1);
			
			//Relenamos las celdas sueltas de Id propuesta, y gestor
			Label valor = new Label(2,1,numPropuesta);
			hojaDetalle.addCell(valor);
			valor = new Label(2,2,gestor);
			hojaDetalle.addCell(valor);
			
			//Settear celdas mergeadas restantes a Blank, para evitar warnings en el log
			this.formateoCeldasMergeadasDetalle(hojaDetalle);
			
			//Bucle para rellenar listado de activos
			int fila = 8;
			for(DtoGenerarPropuestaPreciosEntidad03 dto : listDto) {
			
				rellenarFilaExcelPropuestaPrecio(hojaDetalle, (es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad03) dto,fila);
				fila++;
			}
			
			this.formateoCeldasMergeadasResumen(libroEditable.getSheet(0));
			// Número total de activos
			libroEditable.getSheet(0).addCell(new Number(1,7,fila-filaInicial,libroEditable.getSheet(0).getCell(1, 7).getCellFormat()));
			
			libroEditable.write();
			libroEditable.close();
			
			
			libroExcel.close();
			
		} catch (IOException e) {
			logger.error(e.getMessage());
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
		
	}
	
	/**
	 * Rellena las filas con los datos del dto
	 * @param hoja
	 * @param dto
	 * @param fila
	 */
	private void rellenarFilaExcelPropuestaPrecio(WritableSheet hoja, DtoGenerarPropuestaPreciosEntidad03 dto, Integer fila) {
		
		try {
			
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	        NumberFormat decimalNo = new NumberFormat("#.00"); 
	        WritableCellFormat numberFormat = new WritableCellFormat(decimalNo);

		
			hoja.addCell(new Label(1,fila,dto.getNumAgrupacionRestringida()));
			hoja.addCell(new Label(2,fila,dto.getNumActivo()));
			hoja.addCell(new Label(3,fila,dto.getNumActivoRem()));
			hoja.addCell(new Label(4,fila,dto.getDireccion()));
			hoja.addCell(new Label(5,fila,dto.getMunicipio()));
			hoja.addCell(new Label(6,fila,dto.getProvincia()));

			if(!Checks.esNulo(dto.getFechaEntrada()))
				hoja.addCell(new Label(7,fila,sdf.format(dto.getFechaEntrada())));
			
			if(!Checks.esNulo(dto.getFechaTasacion()))
				hoja.addCell(new Label(8,fila,sdf.format(dto.getFechaTasacion())));
			if(!Checks.esNulo(dto.getValorTasacion()) && dto.getValorTasacion() != 0.0)
				hoja.addCell(new Number(9,fila,dto.getValorTasacion(),numberFormat));
			
			
			if(!Checks.esNulo(dto.getFechaEstimadoVenta()))
				hoja.addCell(new Label(10,fila,sdf.format(dto.getFechaEstimadoVenta())));
			if(!Checks.esNulo(dto.getValorEstimadoVenta()) && dto.getValorEstimadoVenta() != 0.0)
				hoja.addCell(new Number(11,fila,dto.getValorEstimadoVenta(),numberFormat));
			
			if(!Checks.esNulo(dto.getFechaFsv()))
				hoja.addCell(new Label(12,fila,sdf.format(dto.getFechaFsv())));
			if(!Checks.esNulo(dto.getValorFsv()) && dto.getValorFsv() != 0.0)
				hoja.addCell(new Number(13,fila,dto.getValorFsv(),numberFormat));
				
			if(!Checks.esNulo(dto.getFechaValorLiquidativo()))
				hoja.addCell(new Label(14,fila,sdf.format(dto.getFechaValorLiquidativo())));
			if(!Checks.esNulo(dto.getValorLiquidativo()) && dto.getValorLiquidativo() != 0.0) 
				hoja.addCell(new Number(15,fila,dto.getValorLiquidativo(),numberFormat));
			
			if(!Checks.esNulo(dto.getValorVnc()) && dto.getValorVnc() != 0.0)
				hoja.addCell(new Number(16,fila,dto.getValorVnc(),numberFormat));
			if(!Checks.esNulo(dto.getValorVentaWeb()) && dto.getValorVentaWeb() != 0.0)
				hoja.addCell(new Number(17,fila,dto.getValorVentaWeb(),numberFormat));
			if(!Checks.esNulo(dto.getValorPropuesto()) && dto.getValorPropuesto() != 0.0)
				hoja.addCell(new Number(18,fila,dto.getValorPropuesto(),numberFormat));
			
			//Columnas 19 - 26 sin saber de donde sacar dichos valores
			
			//Formulas ----
		/*	Integer numFila = fila +1;
			hoja.addCell(new Formula(27, fila, "IF(ISBLANK(S"+numFila+"),\"\",IF(ISBLANK(Q"+numFila+"),\"\",ROUND(S"+numFila+"-Q"+numFila+",2))"));//PrecioPropuesto - VNC
			//Descuentos - Tasacion y VNC
			hoja.addCell(new Formula(28, fila, "IF(ISBLANK(J"+numFila+"),\"\",IF(ISBLANK(S"+numFila+"),\"\",ROUND(J"+numFila+"-S"+numFila+",2))"));//ValorTasacion - PrecioPropuesto
			hoja.addCell(new Formula(29, fila, "IF(ISBLANK(J"+numFila+"),\"\", IF(ISBLANK(S"+numFila+"), \"\", ROUND(IF(J"+numFila+"-1<>0, ((S"+numFila+"/J"+numFila+"-1)*-1), \"\"), 2)))")); //Porcentaje Tas/Propuesto
			hoja.addCell(new Formula(30, fila, "IF(ISBLANK(S"+numFila+"),\"\",IF(ISBLANK(R"+numFila+"),\"\",ROUND(S"+numFila+"-R"+numFila+",2))"));//Propuesto - publicado
			hoja.addCell(new Formula(31, fila, "IF(R"+numFila+"<>0, ROUND(-AE"+numFila+"/R"+numFila+",2), \"\"))"));//porcentaje (Propuesto - Publciado) sobre Propuesto
			*/
			hoja.addCell(new Label(32,fila,dto.getSociedadPropietaria()));
			if(!Checks.esNulo(dto.getFechaPublicacion()))
				hoja.addCell(new Label(33,fila,sdf.format(dto.getFechaPublicacion())));
			hoja.addCell(new Label(34,fila,dto.getOrigen()));
			hoja.addCell(new Label(35,fila,dto.getTipoActivoDescripcion()));
			//Columna 36 - Incluido ???
			hoja.addCell(new Label(37,fila,dto.getTipoTasacionDescripcion()));
			if(!Checks.esNulo(dto.getTipoActivoCodigo()))
				hoja.addCell(new Label(39,fila,"02".equals(dto.getTipoActivoCodigo()) ? "RES" : "NO RES" )); // Es Vivienda o No
			//Columna 40 - Antiguedad Tasación ???
			
			if(!Checks.esNulo(dto.getMayorValoracion()) && dto.getMayorValoracion() != 0.0)
				hoja.addCell(new Number(41,fila,dto.getMayorValoracion(),numberFormat));
			//Columna 42 - Motivo Precio ???

			
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
		
	}

	@Override
	public void vaciarLibros() {
		this.file = null;
		this.libroEditable = null;
		this.libroExcel = null;
	}
	
	/**
	 * Evita warnings por celdas mergeadas
	 * @param hoja
	 */
	private void formateoCeldasMergeadasResumen(WritableSheet hoja) {

		//(hoja, colIni, colFin, rowIni, rowFin)
		this.setBlankToCells(hoja, 1, null, 4, 6); 		// Rango B5-B7
		this.setBlankToCells(hoja, 2, null, 4, 6);		// Rango C5-C7
		this.setBlankToCells(hoja, 3, null, 4, 6);		// Rango D5-D7
		this.setBlankToCells(hoja, 4, null, 4, 6);		// Rango E5-E7
		this.setBlankToCells(hoja, 5, 6, 4, null);		// Rango F5-G5
		this.setBlankToCells(hoja, 5, null, 5, 6);		// Rango F6-F7
		this.setBlankToCells(hoja, 6, null, 5, 6);		// Rango G6-G7
		this.setBlankToCells(hoja, 7, 10, 4, null);		// Rango H5-K5
		this.setBlankToCells(hoja, 7, 8, 5, null);		// Rango H5-I5
		this.setBlankToCells(hoja, 9, 10, 5, null);		// Rango J5-K5

	}
	
	private void formateoCeldasMergeadasDetalle(WritableSheet hoja) {

		//(hoja, colIni, colFin, rowIni, rowFin)
		this.setBlankToCells(hoja, 1, 7, 5, null); 		// Rango B6-H6
		this.setBlankToCells(hoja, 8, 9, 5, null); 		// Rango I6-J6
		this.setBlankToCells(hoja, 10, 11, 5, null); 	// Rango K6-L6
		this.setBlankToCells(hoja, 12, 13, 5, null); 	// Rango M6-N6
		this.setBlankToCells(hoja, 14, 15, 5, null); 	// Rango O6-P6
		this.setBlankToCells(hoja, 18, 27, 5, null); 	// Rango S6-AB6
		this.setBlankToCells(hoja, 28, 31, 5, null); 	// Rango AC6-AF6
		
		this.setBlankToCells(hoja, 1, null, 6, 7);		// Rango B7-B8
		this.setBlankToCells(hoja, 2, null, 6, 7);		// Rango C7-C8
		this.setBlankToCells(hoja, 3, null, 6, 7);		// Rango D7-D8
		this.setBlankToCells(hoja, 4, null, 6, 7);		// Rango E7-E8
		this.setBlankToCells(hoja, 5, null, 6, 7);		// Rango F7-F8
		this.setBlankToCells(hoja, 6, null, 6, 7);		// Rango G7-G8
		this.setBlankToCells(hoja, 7, null, 6, 7);		// Rango H7-H8
		
		this.setBlankToCells(hoja, 8, null, 6, 7);		// Rango I7-I8
		this.setBlankToCells(hoja, 9, null, 6, 7);		// Rango J7-J8
		this.setBlankToCells(hoja, 10, null, 6, 7);		// Rango K7-K8
		this.setBlankToCells(hoja, 11, null, 6, 7);		// Rango L7-L8
		this.setBlankToCells(hoja, 12, null, 6, 7);		// Rango M7-M8
		this.setBlankToCells(hoja, 13, null, 6, 7);		// Rango N7-N8
		this.setBlankToCells(hoja, 14, null, 6, 7);		// Rango O7-O8
		this.setBlankToCells(hoja, 15, null, 6, 7);		// Rango P7-P8
		
		this.setBlankToCells(hoja, 16, null, 5, 7);		// Rango Q6-Q8
		this.setBlankToCells(hoja, 17, null, 5, 7);		// Rango R6-R8
		
		this.setBlankToCells(hoja, 18, null, 6, 7);		// Rango S7-S8
		this.setBlankToCells(hoja, 19, null, 6, 7);		// Rango T7-T8
		this.setBlankToCells(hoja, 20, null, 6, 7);		// Rango U7-U8
		this.setBlankToCells(hoja, 21, null, 6, 7);		// Rango V7-V8
		this.setBlankToCells(hoja, 22, null, 6, 7);		// Rango W7-W8
		this.setBlankToCells(hoja, 23, null, 6, 7);		// Rango X7-X8
		this.setBlankToCells(hoja, 24, null, 6, 7);		// Rango Y7-Y8
		this.setBlankToCells(hoja, 25, null, 6, 7);		// Rango Z7-Z8
		this.setBlankToCells(hoja, 26, null, 6, 7);		// Rango AA7-AA8
		this.setBlankToCells(hoja, 27, null, 6, 7);		// Rango AB7-AB8
		
		this.setBlankToCells(hoja, 28, 29, 6, null); 	// Rango AC7-AD7
		this.setBlankToCells(hoja, 30, 31, 6, null); 	// Rango AE7-AF7
		
		this.setBlankToCells(hoja, 32, null, 5, 7);		// Rango AG6-AG8
		this.setBlankToCells(hoja, 33, null, 5, 7);		// Rango AH6-AH8
		this.setBlankToCells(hoja, 34, null, 5, 7);		// Rango AI6-AI8
		this.setBlankToCells(hoja, 35, null, 5, 7);		// Rango AJ6-AJ8
		this.setBlankToCells(hoja, 36, null, 5, 7);		// Rango AK6-AK8
		this.setBlankToCells(hoja, 37, null, 5, 7);		// Rango AL6-AL8
		this.setBlankToCells(hoja, 38, null, 5, 7);		// Rango AM6-AM8
		this.setBlankToCells(hoja, 39, null, 5, 7);		// Rango AN6-AN8
		this.setBlankToCells(hoja, 40, null, 5, 7);		// Rango AO6-AO8
		this.setBlankToCells(hoja, 41, null, 5, 7);		// Rango AP6-AP8
		this.setBlankToCells(hoja, 42, null, 5, 7);		// Rango AQ6-AQ8
		
		
	}
	
	/**
	 * Settea las celdas en blanco en los rangos indicados
	 * @param hoja - Hoja excel
	 * @param colIni - Columna inicio
	 * @param colFin - Columna fin
	 * @param rowIni - Fila inicio
	 * @param rowFin - Fila fin
	 */
	private void setBlankToCells(WritableSheet hoja, Integer colIni, Integer colFin, Integer rowIni, Integer rowFin) {
		
		WritableCellFormat formato = new WritableCellFormat(hoja.getCell(colIni, rowIni).getCellFormat());
		
		try {
			
			if(!Checks.esNulo(colFin)) {
				for(int col = colIni+1; col <= colFin; col++) 
					hoja.addCell(new Blank(col,rowIni));
			}
			
			if(!Checks.esNulo(rowFin)) {
				for(int row = rowIni+1; row <= rowFin; row++) 
					hoja.addCell(new Blank(colIni,row));
			}
			
			hoja.getWritableCell(colIni, rowIni).setCellFormat(formato);
		
		} catch (RowsExceededException e) {
			logger.error(e.getMessage());
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
	}
}
