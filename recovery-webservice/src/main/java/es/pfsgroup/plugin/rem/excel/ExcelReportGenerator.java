package es.pfsgroup.plugin.rem.excel;


import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
//import java.time.LocalDateTime;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.util.CellReference;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.model.VReportAdvisoryNotes;


@Component
public class ExcelReportGenerator implements ExcelReportGeneratorApi {
	
	protected static final Log logger = LogFactory.getLog(ExcelReportGenerator.class);
	
	private static final int MAX_ROW_LIMIT = 50000;

	private static final String EXPORTAR_EXCEL_LIMITE_ACTIVOS = "exportar.excel.limite.activos";

	private static final int START_REPORT_ROW = 0;
	
	private static final String TOTAL = "TOTAL";
	
	private static final int NUMERO_COLUMNAS = 21;
	
	private static final String TEXTO_NO_PUBLICADO = "Sin Publicar";
	
	private static final int NUMERO_COLUMNAS_APPLE = 11;
	
	@Resource
	Properties appProperties;
	
	@Override
	public void sendReport(File reportFile, HttpServletResponse response) throws IOException {
		String fileName = reportFile.getName();
		this.sendReport(fileName,reportFile, response);
		
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi#sendReport(java.io.File, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	public void sendReport(String fileName,File reportFile, HttpServletResponse response) throws IOException{
		
		ServletOutputStream salida = response.getOutputStream();
		String extension = "";
		int i = fileName.lastIndexOf('.');
		if (i > 0) {
		    extension = fileName.substring(i+1);
		}
		
		response.setHeader("Content-disposition", "attachment; filename="+ fileName);
		response.setHeader("Cache-Control","must-revalidate, post-check=0,pre-check=0");
		response.setHeader("Cache-Control", "max-age=0");
		response.setHeader("Expires", "0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", 0);
		if (extension.equals("pdf")) {
			response.setContentType("application/pdf");
		} else {
			response.setContentType("application/vnd.ms-excel");
		}

		InputStream in;
		in = new BufferedInputStream(new FileInputStream(reportFile));

		FileUtils.copy(in, salida);
		salida.flush();
		salida.close();
		
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi#generateReport(es.pfsgroup.plugin.rem.excel.ExcelReport)
	 */
	@Override
	public File generateReport(ExcelReport report){
		
		String rutaFichero = appProperties.getProperty("files.temporaryPath","/tmp")+"/";
				
		HojaExcel hojaExcel = new HojaExcel();
		hojaExcel.crearNuevoExcel(rutaFichero+report.getReportName(), report.getCabeceras(), report.getData());
		File file = hojaExcel.getFile();
		
		return file;
		
	}
	
	@Override
	public File generateBankiaReport(List<DtoPropuestaAlqBankia> l_DtoPropuestaAlq, HttpServletRequest request) {
		
		ServletContext sc = request.getSession().getServletContext();		
		
		try {

			File poiFile = new File(sc.getRealPath("plantillas/plugin/Propuesta_alquileres_bankia/PROPUESTA_BANKIA.xlsx"));
			File fileOut = new File(poiFile.getAbsolutePath().replace("_BANKIA",""));
			FileInputStream fis = new FileInputStream(poiFile);
			FileOutputStream fileOutStream = new FileOutputStream(fileOut);
			XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);
			
			boolean primero = true; 
			int currentIndex = 2;
			////// 𝕺𝕶
			
			XSSFSheet mySheet;
			CellReference cellReference;
			XSSFRow r;
			XSSFCell c;
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
			
			// En el ultimo elemento esta el resumen por eso cogemos todos los DTO menos el ultimo
			for (int i = 0; i < l_DtoPropuestaAlq.size()-1; i++) {
				
				DtoPropuestaAlqBankia dtoPAB = l_DtoPropuestaAlq.get(i);
				
				
				if (primero) {
					myWorkBook.setSheetName(1, dtoPAB.getNumActivoUvem().toString());
					mySheet = myWorkBook.getSheetAt(1);
					primero = false;
				} else {
					mySheet = myWorkBook.cloneSheet(1);
					myWorkBook.setSheetName(myWorkBook.getSheetIndex(mySheet), dtoPAB.getNumActivoUvem().toString());
					++currentIndex;
				}
				
				cellReference = new CellReference("B4");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTipoAlquiler())) {
					c.setCellValue(dtoPAB.getTipoAlquiler());
				} else {
					c.setCellValue("");
				}
					
				cellReference = new CellReference("B7");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNumActivoUvem())) {
					c.setCellValue(dtoPAB.getNumActivoUvem().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B9");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellValue(format.format(new Date()));
				
				cellReference = new CellReference("B10");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaAltaOferta())) {
					c.setCellValue(format.format(dtoPAB.getFechaAltaOferta()));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B11");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaPublicacionWeb())) {
					c.setCellValue(format.format(dtoPAB.getFechaPublicacionWeb())); 
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B18");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTipoActivo())) {
					c.setCellValue(dtoPAB.getTipoActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B20");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getDireccionCompleta())) {
					c.setCellValue(dtoPAB.getDireccionCompleta());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B21");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCodPostMunicipio())) {
					c.setCellValue(dtoPAB.getCodPostMunicipio());
				} else {
					c.setCellValue("");
				}
				
				//B22 CARACTERISTICAS ????
				
				cellReference = new CellReference("B24");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNombrePropietario())) {
					c.setCellValue(dtoPAB.getNombrePropietario());
				} else {
					c.setCellValue("");
				}

//					
				
				//B38 VALOR DE FONDO TOTAL ????
				//B39 VALOR DE NETO CONTABLE ????
				
				
				cellReference = new CellReference("B40");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteTasacionFinal())) {
					c.setCellValue(dtoPAB.getImporteTasacionFinal().floatValue());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B41");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaUltimaTasacion())) { 
					c.setCellValue(format.format(dtoPAB.getFechaUltimaTasacion()));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B47");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNombreCompleto())) { 
					c.setCellValue(dtoPAB.getNombreCompleto());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B48");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCompradorDocumento())) { 
					c.setCellValue(dtoPAB.getCompradorDocumento());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B57");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteOferta())) { 
					c.setCellValue(dtoPAB.getImporteOferta().floatValue());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B60");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCarenciaALquiler())) { 
					c.setCellValue(Integer.toString(dtoPAB.getCarenciaALquiler()*30));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("A81");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTextoOferta())) { 
					c.setCellValue(dtoPAB.getTextoOferta());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("A96");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteFianza()) && !Checks.esNulo(dtoPAB.getMesesFianza())) { 
					c.setCellValue("2. Fianza de "+ dtoPAB.getMesesFianza() + " mes ("+dtoPAB.getImporteFianza()+"€)");
				} else {
					c.setCellValue("Sin valores de fianza");
				}
					
			}
			
			
			mySheet = myWorkBook.getSheetAt(0);
			int currentRow = 6;
			DtoPropuestaAlqBankia dtoPAB;
			Long numActivo;
			
			
			XSSFCellStyle style= myWorkBook.createCellStyle();
			XSSFCellStyle styleTitulo= myWorkBook.createCellStyle();
			style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setBorderTop(XSSFCellStyle.BORDER_THIN);
			style.setBorderRight(XSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			

			if (l_DtoPropuestaAlq.size()-2 > 0) {
				mySheet.shiftRows(currentRow, currentRow+1, l_DtoPropuestaAlq.size()-2);
				
				for (int i = currentRow-1; i < currentRow-1 + l_DtoPropuestaAlq.size()-1; i++) {
					mySheet.createRow(i);
					r = mySheet.getRow(i);
					for (int j = 0; j < NUMERO_COLUMNAS; j++) {
						r.createCell(j);
						c = r.getCell(j);
						c.setCellStyle(style);
					}
				}
				
			}
				
			
			for (int i = 0; i < l_DtoPropuestaAlq.size()-1; i++) {
				
				dtoPAB = l_DtoPropuestaAlq.get(i);
				numActivo = dtoPAB.getNumActivoUvem(); // El numero de activo lo necesitamos para referenciar el resto de hojas en las formulas
				String formula;
				
//				cellReference = new CellReference("A" + Integer.toString(currentRow)); // LOTE SE DEJA EN BLANCO
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				if (!Checks.esNulo(dtoPAB.getNumeroAgrupacion())) { 
//					c.setCellValue(dtoPAB.getNumeroAgrupacion().toString());
//				}
				
				cellReference = new CellReference("B" + Integer.toString(currentRow)); // ACTIVO 
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(numActivo))
					c.setCellValue(numActivo.toString());
				
				cellReference = new CellReference("C" + Integer.toString(currentRow)); // TIPO ACTIVO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTipoActivo()))
					c.setCellValue(dtoPAB.getTipoActivo());
				
				cellReference = new CellReference("D" + Integer.toString(currentRow)); // TIPO OPERACION
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getDescripcionEstadoPatrimonio()))
					c.setCellValue(dtoPAB.getDescripcionEstadoPatrimonio());
				
				cellReference = new CellReference("E" + Integer.toString(currentRow)); // NOMBRE CLIENTE ?? 
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNombreCompleto()))
					c.setCellValue(dtoPAB.getNombreCompleto());
				
				cellReference = new CellReference("F" + Integer.toString(currentRow)); // DIRECCION
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getDireccionCompleta()))
					c.setCellValue(dtoPAB.getDireccionCompleta());
				
				cellReference = new CellReference("G" + Integer.toString(currentRow)); // MUNICIPIO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCodPostMunicipio()))
					c.setCellValue(dtoPAB.getCodPostMunicipio());
				
				
				formula = "'"+numActivo.toString()+"'!B12";
				cellReference = new CellReference("H" + Integer.toString(currentRow)); // Antiguedad Cartera
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA); 
				c.setCellFormula(formula);

				cellReference = new CellReference("I" + Integer.toString(currentRow)); // FECHA PUBLICACION WEB
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaPublicacionWeb()))
					c.setCellValue(format.format(dtoPAB.getFechaPublicacionWeb()));  
				else
					c.setCellValue(TEXTO_NO_PUBLICADO);
				
				formula = "'"+numActivo.toString()+"'!B37";
				cellReference = new CellReference("J" + Integer.toString(currentRow)); // VALOR ORIENTATIVO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA); 
				c.setCellFormula(formula);
				
				formula = "'"+numActivo.toString()+"'!B39";
				cellReference = new CellReference("K" + Integer.toString(currentRow)); // VALOR CONTABLE NETO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
				c.setCellFormula(formula);
				
				//VALOR ORIENTATIVO NO RELLENO
				
				cellReference = new CellReference("M" + Integer.toString(currentRow)); // FECHA TASACION
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaUltimaTasacion()))
					c.setCellValue(format.format(dtoPAB.getFechaUltimaTasacion()));
		
				cellReference = new CellReference("N" + Integer.toString(currentRow)); // RENTA OFERTADA
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteOferta()))
					c.setCellValue(dtoPAB.getImporteOferta().toString());
				
				formula = "'"+numActivo.toString()+"'!B58";
				cellReference = new CellReference("O" + Integer.toString(currentRow)); // RENTA BONIFICADA
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
				c.setCellFormula(formula);

				cellReference = new CellReference("P" + Integer.toString(currentRow)); // FECHA OFERTA
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellValue(format.format(new Date()));

				formula = "'"+numActivo.toString()+"'!B61";
				cellReference = new CellReference("Q" + Integer.toString(currentRow)); // RENTABILIDAD 1 AÑO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
				c.setCellFormula(formula);

				formula = "'"+numActivo.toString()+"'!B62";
				cellReference = new CellReference("R" + Integer.toString(currentRow)); // EURIBOR
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
				c.setCellFormula(formula);
				
//				formula = "'"+numActivo.toString()+"'!B50";
//				cellReference = new CellReference("S" + Integer.toString(currentRow)); // PAX SE DEJA EN BLANCO 
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
			
				formula = "'"+numActivo.toString()+"'!B49";
				cellReference = new CellReference("T" + Integer.toString(currentRow)); // INGRESOS NETOS
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
				c.setCellFormula(formula);
				
				// RESOLUCION NO RELLENO
  				++currentRow; // Siguiente fila
					
			}
			int fila = 6 + l_DtoPropuestaAlq.size()-2; 
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS; j++) {
				r.createCell(j);
				c = r.getCell(j);
			}
			
			dtoPAB = l_DtoPropuestaAlq.get(l_DtoPropuestaAlq.size()-1);
			numActivo = dtoPAB.getNumActivoUvem();
			
			
			cellReference = new CellReference("D2"); // TITULO
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue("PROPUESTAS DE ALQUILER PRESENTADAS AL COMITÉ DE DOBLE FIRMA DE FECHA " + format.format(new Date())); 
			XSSFFont font = myWorkBook.createFont();
			font.setFontHeight(14);
			font.setBold(true);
			styleTitulo.setFont(font);
			c.setCellStyle(styleTitulo); 
			
			
			cellReference = new CellReference("A" + Integer.toString(currentRow)); // LOTE ??
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
				c.setCellValue(TOTAL);
				c.setCellStyle(style);
				
				
			cellReference = new CellReference("B" + Integer.toString(currentRow)); // ACTIVO
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if (!Checks.esNulo(numActivo)) {
				c.setCellValue(numActivo.toString());
				c.setCellStyle(style);
			}
			
			
			String formula = "SUM(J6:J"+fila+")";
			cellReference = new CellReference("J" + Integer.toString(currentRow)); // VALOR ORIENTATIVO
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
			c.setCellFormula(formula);
			c.setCellStyle(style);
			
			formula = "SUM(K6:K"+fila+")";
			cellReference = new CellReference("K" + Integer.toString(currentRow)); // VALOR CONTABLE NETO
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
			c.setCellFormula(formula);
			c.setCellStyle(style);
			
			cellReference = new CellReference("N" + Integer.toString(currentRow)); // RENTA OFERTADA
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if (!Checks.esNulo(dtoPAB.getImporteOferta())) {
				c.setCellValue(dtoPAB.getImporteOferta().toString());
				c.setCellStyle(style);
			}
			
			formula = "SUM(O6:O"+fila+")";
			cellReference = new CellReference("O" + Integer.toString(currentRow)); // RENTA BONIFICADA
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
			c.setCellFormula(formula);
			c.setCellStyle(style);
			
//			formula = "SUM(O6:O"+fila+")";
			cellReference = new CellReference("S" + Integer.toString(currentRow)); // RENTA BONIFICADA
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
//			c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//			c.setCellFormula(formula);
			c.setCellStyle(style);
			

			
			myWorkBook.write(fileOutStream);
			fileOutStream.close();
			
			return fileOut;
			
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
		
		
		return null;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi#generateAndSend(es.pfsgroup.plugin.rem.excel.ExcelReport, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	public void generateAndSend(ExcelReport report, HttpServletResponse response) throws IOException {
		this.sendReport(this.generateReport(report), response);
		
	}

	@Override
	public int getStart() {
		return START_REPORT_ROW;
	}

	@Override
	public int getLimit() {
		String limite = appProperties.getProperty(EXPORTAR_EXCEL_LIMITE_ACTIVOS);
		return (!(Checks.esNulo(limite)) ? Integer.parseInt(limite) : MAX_ROW_LIMIT);
	}
	
	
	
	@Override
	public File getAdvisoryNoteReport(List<VReportAdvisoryNotes> listaAN, HttpServletRequest request) {
		
		ServletContext sc = request.getSession().getServletContext();		
		
		
		try {

			File poiFile = new File(sc.getRealPath("plantillas/plugin/AdvisoryNoteApple/AdvisoryNoteReport.xlsx"));
			
			File fileOut = new File(poiFile.getAbsolutePath().replace("Report",""));
			FileInputStream fis = new FileInputStream(poiFile);
			FileOutputStream fileOutStream = new FileOutputStream(fileOut);
			XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);
		
			XSSFSheet mySheet;
			CellReference cellReference;
			XSSFRow r;
			XSSFCell c;
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat anyo = new SimpleDateFormat("yyyy");
			DecimalFormat df = new DecimalFormat("#.##");
			String descripcionDelActivo= "- ";
			
			XSSFCellStyle style= myWorkBook.createCellStyle();
			XSSFCellStyle styleTitulo= myWorkBook.createCellStyle();
			style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setBorderTop(XSSFCellStyle.BORDER_THIN);
			style.setBorderRight(XSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			style.setWrapText(true);
			
			
			//ESTILOS
				//CELDA COMPLETA
			XSSFCellStyle styleBordesCompletos= myWorkBook.createCellStyle();
			styleBordesCompletos.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setWrapText(true);
				
				//BORDES ARRIBA Y ABAJO
			XSSFCellStyle styleBordesArribaYAbajo= myWorkBook.createCellStyle();
			styleBordesArribaYAbajo.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaYAbajo.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaYAbajo.setBorderRight(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaYAbajo.setBorderLeft(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaYAbajo.setWrapText(true);
			
			//BORDES ARRIBA Y ABAJO DERECHA
			XSSFCellStyle styleBordesArribaAbajoDerecha= myWorkBook.createCellStyle();
			styleBordesArribaAbajoDerecha.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderLeft(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaAbajoDerecha.setWrapText(true);
			
			//BORDES ARRIBA Y ABAJO IZQUIERDA
			XSSFCellStyle styleBordesArribaAbajoIzquierda= myWorkBook.createCellStyle();
			styleBordesArribaAbajoIzquierda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setBorderRight(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaAbajoIzquierda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setWrapText(true);
	
			
			// En el ultimo elemento esta el resumen por eso cogemos todos los DTO menos el ultimo
				
				
			myWorkBook.setSheetName(0, "AN S0XXX-" + anyo.format(new Date()));
			mySheet = myWorkBook.getSheetAt(0);		// <----- NÚMERO DE LA PÁGINA
			
			cellReference = new CellReference("G2");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(!Checks.esNulo(listaAN.get(0)) && !Checks.esNulo(listaAN.get(0).getNumOferta())) {
				c.setCellValue(listaAN.get(0).getNumOferta().toString());
			}else {
				c.setCellValue("");
			}
			
			
			cellReference = new CellReference("B3");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue(format.format(new Date()));
			
			int currentRow = 7;
			for (int i = 0; i < listaAN.size(); i++) {
					
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
				
				cellReference = new CellReference("C" + currentRow); // UNIT ID
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNumActivo())) {
					c.setCellValue(dtoPAB.getNumActivo().toString());
				} else {
					c.setCellValue("");
				}
				
				//TODO PROPERTY ID
				
				cellReference = new CellReference("G" + currentRow); // PROPERTY NAME
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getDireccion())) {
					c.setCellValue(dtoPAB.getDireccion());
				} else {
					c.setCellValue("");
				}
			
				
				if(i<listaAN.size()-1) {
					mySheet.createRow(currentRow);
					r = mySheet.getRow(currentRow);
					for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
						r.createCell(j);
					}
				}
					
				currentRow++;
			}
			
			mySheet.createRow(currentRow); //creamos la fila de:Connection Status
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==0) {}else
				if(j==1) {
					c.setCellValue("Connection Status");
					c.setCellStyle(styleBordesCompletos);
				}else if(j==2) {
					c.setCellValue("REO");
					c.setCellStyle(styleBordesArribaYAbajo);
				}else if(j==9){
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}else {
					c.setCellStyle(styleBordesArribaYAbajo);
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow); //creamos la fila de:Property Details
			r = mySheet.getRow(currentRow);
			r.setHeight((short)-1);
			for (int j = 0; j < 3; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==1) {
					c.setCellValue("Property Details");
				}else if(j==2) {
					//bucle por activo
					String descripcionLocalidadActivo = "";
					for (int i = 0; i < listaAN.size(); i++) {
						VReportAdvisoryNotes dtoPAB = listaAN.get(i);
						if(i>0) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + "\n";
						}
						
						if (!Checks.esNulo(dtoPAB.getNumActivo())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + dtoPAB.getNumActivo().toString() + " ";
						}
			
						if (!Checks.esNulo(dtoPAB.getTipoActivo())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + dtoPAB.getTipoActivo();
						}
						if(!Checks.esNulo(dtoPAB.getMunicipio())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + " located in " + dtoPAB.getMunicipio();
						}
						if(!Checks.esNulo(dtoPAB.getProvincia())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + "(" + dtoPAB.getProvincia() + ")";
						}
					}
					c.setCellValue(descripcionLocalidadActivo);
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow); //creamos la fila de:Background information
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 2; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==1) {
					c.setCellValue("Background information");
				}
			}
			currentRow++;

			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:
						c.setCellValue("Unit ID");
						break;
					case 3:
						c.setCellValue("Type of property	");
						break;
					case 4:
						c.setCellValue("Surface area \n (sqm)");
						break;
					case 5:
						c.setCellValue("Asking Price");
						break;
					case 6:
						c.setCellValue("Rental income € (monthly)");
						break;
					default:
						break;
				}
			}

			currentRow++;

			Long aumulacionSuperficie = 0L;
			Double acumulacionAskingPrice = (double) 0;
			Long acumulacionRentaMensual = 0L;
			Boolean total = false;
			for (int i = 0; i <= listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = null;
				if (i < listaAN.size()) {
					dtoPAB = listaAN.get(i);
				}

				if (i == listaAN.size()) {
					total = true;
				}
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							if (total) {
								c.setCellValue("Total");
							} else {
								if (!Checks.esNulo(dtoPAB.getNumActivo())) {
									c.setCellValue(dtoPAB.getNumActivo().toString());
								} else {
									c.setCellValue("");
								}
							}
							break;
						case 3:
							if (total) {
								c.setCellValue("");
							} else {
								if (!Checks.esNulo(dtoPAB.getTipoActivo())) {
									c.setCellValue(dtoPAB.getTipoActivo());
								} else {
									c.setCellValue("");
								}
							}
							break;
						case 4:
							if (total) {
								c.setCellValue(aumulacionSuperficie.toString() + " m2");
							} else {
								if (!Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
									c.setCellValue(dtoPAB.getSuperficieConstruida().toString() + " m2");
									aumulacionSuperficie = aumulacionSuperficie + dtoPAB.getSuperficieConstruida();
								} else {
									c.setCellValue("0 m2");
								}
							}
							break;
						case 5:
							if (total) {
								c.setCellValue(acumulacionAskingPrice.toString() + " €");
							} else {
								if (!Checks.esNulo(dtoPAB.getImporte())) {
									c.setCellValue(dtoPAB.getImporte().toString() + " €");
									acumulacionAskingPrice = acumulacionAskingPrice + dtoPAB.getImporte();
								} else {
									c.setCellValue("0€");
								}
							}
							break;
						case 6:
							c.setCellValue("0 €");
							break;
						default:
							break;
					}
				}
				currentRow++;
			}
			
			mySheet.createRow(currentRow); // creamos la fila en blanco
			r = mySheet.getRow(currentRow);
			currentRow++;

			mySheet.createRow(currentRow); // creamos fila bloque amarillo
			r = mySheet.getRow(currentRow);

			for (int i = 0; i < listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);

				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Marketing Overview");
							break;
						case 4:
							c.setCellValue(dtoPAB.getNumActivo());
							break;
						case 6:
							c.setCellValue("Marketing comments (Manual Modified over given text):");
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Web Publishing");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getPublicado())) {
								c.setCellValue(dtoPAB.getPublicado());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Marketing starting date:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getFechaEmision())) {
								c.setCellValue(format.format(dtoPAB.getFechaEmision()));
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Number of Leads:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getNumOfertasActivo())) {
								c.setCellValue(dtoPAB.getNumOfertasActivo().toString());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Broker Name:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getNombrePrescriptor())) {
								c.setCellValue(dtoPAB.getNombrePrescriptor());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							break;
						default:
							break;
					}
				}

				currentRow++;
				mySheet.createRow(currentRow);
				currentRow++;
				mySheet.createRow(currentRow);
				currentRow++;
				mySheet.createRow(currentRow);

				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Construction date");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getAnyoConstruccion())) {
								c.setCellValue(dtoPAB.getAnyoConstruccion());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							break;
						default:
							break;
					}
				}

				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Asset description:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							break;
						default:
							break;
					}
				}

				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				if (!Checks.esNulo(dtoPAB.getTipoActivo())) {
					descripcionDelActivo = descripcionDelActivo + dtoPAB.getTipoActivo();
				}
				if (!Checks.esNulo(dtoPAB.getDireccion())) {
					descripcionDelActivo = descripcionDelActivo + " located in " + dtoPAB.getDireccion();
				}
				if (!Checks.esNulo(dtoPAB.getLatitud()) && !Checks.esNulo(dtoPAB.getLongitud())) {
					descripcionDelActivo = descripcionDelActivo + "( " + dtoPAB.getLatitud().toString() + ", " + dtoPAB.getLongitud().toString() + " )";
					descripcionDelActivo = descripcionDelActivo + "XXkm (AD) from X (AD)(nearest city/town) \r\n"; // DESCRIPCION Linea1
				}

				if (!Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
					descripcionDelActivo = descripcionDelActivo + "- The asset has a total surface area of " + dtoPAB.getSuperficieConstruida().toString() + " m2 \r\n"; // DESCRIPCION linea2

				}

				if (!Checks.esNulo(dtoPAB.getEstadoConservacion())) {
					descripcionDelActivo = descripcionDelActivo + "- Considered to be in " + dtoPAB.getEstadoConservacion() + " condition \r\n"; // DESCRIPCION linea3

				}

				if (!Checks.esNulo(dtoPAB.getEstadoAqluiler())) {
					descripcionDelActivo = descripcionDelActivo + "- Details if " + dtoPAB.getEstadoAqluiler() + " condition."; // DESCRIPCION linea 4
					if (!Checks.esNulo(dtoPAB.getTipoAlquiler())) {
						descripcionDelActivo = descripcionDelActivo + " If tenanted include details of lease " + dtoPAB.getTipoActivo();
					}
				}

				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue(descripcionDelActivo);
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Mode of transmission:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getSegundaMano())) { // ¿?¿¿
								c.setCellValue(dtoPAB.getSegundaMano());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Asset maintenance status:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getEstadoConservacion())) {
								c.setCellValue(dtoPAB.getEstadoConservacion());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							if (!Checks.esNulo(dtoPAB.getImporte()) && !Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								Double precioMetro = dtoPAB.getImporte() / dtoPAB.getSuperficieConstruida();
								c.setCellValue((df.format(precioMetro)).toString() + " €");
							} else {
								c.setCellValue("");
							}
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				currentRow++;
				mySheet.createRow(currentRow);
			}

			/////////////Lara
			
			
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 2:
					c.setCellValue("Proposal Background");
					break;
				default:
					break;
				}
			}
			
			String numerosActivoConcatenados = "";
					
			for (int i = 0; i < listaAN.size(); i++) {
				if(!Checks.esNulo(listaAN.get(i).getNumActivo())) {
					if(numerosActivoConcatenados =="") {
						numerosActivoConcatenados = numerosActivoConcatenados + listaAN.get(i).getNumActivo().toString();
					}else {
						numerosActivoConcatenados = numerosActivoConcatenados + "," + listaAN.get(i).getNumActivo().toString();
					}
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 2:
					c.setCellValue("One offer has been negotiated to acquire "+ numerosActivoConcatenados +"  asset as follows:");
					break;
				default:
					break;
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 2:
					c.setCellValue("UV ID");
					break;
				case 3:
					c.setCellValue("Gross offer");
					break;
				case 4:
					c.setCellValue("Surface area \n (sqm)");
					break;
				case 5:
					c.setCellValue("Offer(€/sqm)");
					break;
				default:
					break;
				}
			}
			
			currentRow++;
				
			for (int i = 0; i < listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = null;
				if(i<listaAN.size()) {
					dtoPAB = listaAN.get(i);
				}
				
				
				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
					case 2:
					
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
						
						break;
					case 3:
						
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo())) {
								c.setCellValue(dtoPAB.getImporteParticipacionActivo().toString());
							} else {
								c.setCellValue("");
							}
						
						break;
					case 4:
						
							if (!Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								c.setCellValue(dtoPAB.getSuperficieConstruida().toString() + " m2");
								
							} else {
								c.setCellValue("0 m2");
							}
						
						break;
					case 5:
						
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo()) && !Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								Double importepormetro = (dtoPAB.getImporteParticipacionActivo()) / (dtoPAB.getSuperficieConstruida());
								c.setCellValue((df.format(importepormetro)).toString() + " €");
							} else {
								c.setCellValue("0€");
							}
						
						break;
					default:
						break;
					}
				}
				currentRow++;
			}
			
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			currentRow++;
			

			
			mySheet.createRow(currentRow); //creamos la fila de:Proposal
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 3; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Proposal");
					break;
					case 3:
						c.setCellValue("It is recommended to accept the offer");
					break;
				default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); //creamos la fila de:Proposal
			r = mySheet.getRow(currentRow);
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 2:
					c.setCellValue("Asset ID");
					break;
				case 3:
					c.setCellValue("Gross offer");
					break;
				case 4:
					c.setCellValue("Offer Costs");
					break;
				case 5:
					c.setCellValue("Net for Promontoria Manzana SA");
					break;
				default:
					break;
				}
			}
			
			currentRow++;
			
			Double importeParticipacionSumatorio = (double) 0;
			for (int i = 0; i <= listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = null;
				if(i<listaAN.size()) {
					dtoPAB = listaAN.get(i);
				}

				for (int j = 0; j < 7; j++) {
					r.createCell(j);
					c = r.getCell(j);
					if(i==listaAN.size()) {
						total=true;
					}else {
						total = false;
					}
					switch (j) {
					case 2:	
						if(total) {
							c.setCellValue("Total");
						}else {
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
						}
						break;
					case 3:
						if(total) {
							c.setCellValue(importeParticipacionSumatorio + " €");
						}else {
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo())) {
								importeParticipacionSumatorio = importeParticipacionSumatorio + dtoPAB.getImporteParticipacionActivo();
								c.setCellValue(dtoPAB.getImporteParticipacionActivo()+ " €");
							} else {
								c.setCellValue("");
							}
						}
						break;
					
					default:
						break;
					}
				}
				currentRow++;
			}
			
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			
			currentRow++;
			
			mySheet.createRow(currentRow); //Financing needs
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 5; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Financing needs (Yes/No):");
					break;
					
				default:
					break;
				}
			}
			currentRow++;
			
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			currentRow++;
			
			mySheet.createRow(currentRow); //Estimated time to closing
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 5; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Estimated time to closing:");
					break;
					
				default:
					break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			currentRow++;
			mySheet.createRow(currentRow); //Tax (Plusvalia)*
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 4; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 3:				
						c.setCellValue("Tax (Plusvalia)*");
					break;
					
				default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); //Backlog expenses (please detail type)
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 4; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 3:				
						c.setCellValue("Backlog expenses (please detail type)");
					break;
					
				default:
					break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); //Broker fee 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 4; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 3:				
						c.setCellValue("Broker fee");
					break;
					
				default:
					break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); //Notary
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 4; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 3:				
						c.setCellValue("Notary");
					break;
					
				default:
					break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); //∑(MD)
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 4; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 4:				
						c.setCellValue("∑(MD)");
					break;
					
				default:
					break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); //*Estimated amounts until final liquidation based on the type of asset
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 3; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("*Estimated amounts until final liquidation based on the type of asset");
					break;
					
				default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 4:				
						c.setCellValue("UW");
					break;
					case 5:				
						c.setCellValue("Rev - BP");
					break;
					case 6:				
						c.setCellValue("DELTA");
					break;
					
					default:
						break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Gross Collections");
					break;
					default:
					break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Multiple");
					break;
					default:
					break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("IRR");
					break;
					default:
					break;
				}
			}
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("WAL");
					break;
					default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			String prostexto ="";
			prostexto = "(Manualy Modified over given text)\r\n We recommend approving the offer considering:\r\n(1) is concurs with / higher than asking price\r\n";
			prostexto = prostexto +"(2) market fundamentals (eg. supply, demand, are of high/low commercial activity etc.)\r\n";
			prostexto = prostexto + "(3) condition of the asset\r\n";
			prostexto = prostexto + "(4) Sales comparisons support offer (if comparsions / average price per sq m in area are higher than recommended offer please explain";
			prostexto = prostexto + "- ie subject asset has; inferior location/condtion/configuration/aspect etc)";
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Pro's");
					break;
					case 2:				
						c.setCellValue(prostexto);
					break;
					default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Recommendation");
					break;
					case 2:				
						c.setCellValue("Haya Real Estate department recommends approval as outlined ");
					break;
					default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Authorisation");
					break;
					case 2:				
						c.setCellValue("Name");
					break;
					case 4:				
						c.setCellValue("Signature");
					break;
					case 6:				
						c.setCellValue("Date");
					break;
					default:
					break;
				}
			}
			
		
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Advisor recommendation \n(CES)");
					break;
					default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Asset Manager \n(Haya RE)");
					break;
					default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Owner: \nPROMONTORIA MANZANA");
					break;
					default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Comments,\nadditional requirements");
					break;
					default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 7; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 4:				
						c.setCellValue("This advisory note is subject to KYC clearance through the Cerberus US office via the CES KYC team in London");
					break;
					default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			
			
/*			
			Long aumulacionSuperficie = 0L;
			Double acumulacionAskingPrice = (double) 0;
			Long acumulacionRentaMensual = 0L;
			
			for (int i = 0; i < listaAN.size(); i++) {
				
				if(i > 0) {
					mySheet.createRow(currentRow);
					r = mySheet.getRow(currentRow);
					
					for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
						r.createCell(j);
						c = r.getCell(j);
					}
					
				}
							
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
				cellReference = new CellReference("C" + currentRow); // UNIT ID
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNumActivo())) {
					c.setCellValue(dtoPAB.getNumActivo().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + currentRow); // SUBTIPO PROPIEDAD
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTipoActivo())) {
					c.setCellValue(dtoPAB.getTipoActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + currentRow); // SUPERFICIE
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
					c.setCellValue(dtoPAB.getSuperficieConstruida().toString() + " m2");
					aumulacionSuperficie = aumulacionSuperficie + dtoPAB.getSuperficieConstruida();
				} else {
					c.setCellValue("0 m2");
				}
				
				cellReference = new CellReference("H" + currentRow); // PRECIOWEB
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporte())) {
					c.setCellValue(dtoPAB.getImporte().toString() + " €");
					acumulacionAskingPrice = acumulacionAskingPrice + dtoPAB.getImporte();
				} else {
					c.setCellValue("0€");
				}
				
				cellReference = new CellReference("I" + currentRow); // RENTAMENSUAL
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				//¿?
					c.setCellValue("0 €");
				
				
				currentRow++;
			}
			*///-----
			/*--------
			cellReference = new CellReference("G" + currentRow); // SUPERFICIE
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue(aumulacionSuperficie.toString() + " m2");

			
			cellReference = new CellReference("H" + currentRow); // PrecioWeb
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue(acumulacionAskingPrice.toString() + " €");
			
			cellReference = new CellReference("D" + currentRow); // RENTAMENSUAL
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue(acumulacionRentaMensual.toString()+" €");
			
			currentRow = currentRow + 3;
			
			
			for (int i = 0; i < listaAN.size(); i++) {
				
				if(i > 0) {
					mySheet.createRow(currentRow);
					r = mySheet.getRow(currentRow);
					
					for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
						r.createCell(j);
						c = r.getCell(j);
					}
					
				}
				
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
				cellReference = new CellReference("E" + currentRow); // PUBLICADO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getPublicado())) {
					c.setCellValue(dtoPAB.getPublicado());
				} else {
					c.setCellValue("");
				}
				*///---------------
				
				/*------------
				currentRow++;
				
				cellReference = new CellReference("E" + currentRow); //FECHA DE EMISION
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaEmision())) {
					c.setCellValue(format.format(dtoPAB.getFechaEmision()));
				} else {
					c.setCellValue("");
				}
				
				currentRow = currentRow + 2;
				
				cellReference = new CellReference("E" + currentRow); // Nº DE OFERTAS
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNumOfertasActivo())) {
					c.setCellValue(dtoPAB.getNumOfertasActivo().toString());
				} else {
					c.setCellValue("");
				}
				
				currentRow++;
				
				cellReference = new CellReference("D" + currentRow); // NOMBRE PRESCRIPTOR
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNombrePrescriptor())) {
					c.setCellValue(dtoPAB.getNombrePrescriptor());
				} else {
					c.setCellValue("");
				}
				
				currentRow = currentRow + 3;
				
				cellReference = new CellReference("E" + currentRow); // AÑO CONSTRUCCIÓN
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getAnyoConstruccion())) {
					c.setCellValue(dtoPAB.getAnyoConstruccion());
				} else {
					c.setCellValue("");
				}
				
				
				cellReference = new CellReference("H" + currentRow); // AÑO CONSTRUCCIÓN
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getOcupado())) {
					c.setCellValue(dtoPAB.getOcupado());
				} else {
					c.setCellValue("");
				}
				
				currentRow = currentRow + 2;
				
				cellReference = new CellReference("E" + currentRow); // AÑO CONSTRUCCIÓN
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNumActivo())) {
					c.setCellValue(dtoPAB.getNumActivo().toString());
				} else {
					c.setCellValue("");
				}
				
				currentRow++;
				
				cellReference = new CellReference("C" + currentRow); 
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				
				if (!Checks.esNulo(dtoPAB.getTipoActivo())) {
					descripcionDelActivo = descripcionDelActivo + dtoPAB.getTipoActivo();
				}
				if (!Checks.esNulo(dtoPAB.getDireccion())) {
					descripcionDelActivo = descripcionDelActivo + " located in " + dtoPAB.getDireccion();
				} 
				if(!Checks.esNulo(dtoPAB.getLatitud()) && !Checks.esNulo(dtoPAB.getLongitud())) {
					descripcionDelActivo = descripcionDelActivo + "( " + dtoPAB.getLatitud().toString() + ", " + dtoPAB.getLongitud().toString() + " )";
					descripcionDelActivo = descripcionDelActivo + "XXkm (AD) from X (AD)(nearest city/town) \r\n"; // DESCRIPCION DEL ACTIVO LINEA1
				}
				
				if (!Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
					descripcionDelActivo = descripcionDelActivo + "- The asset has a total surface area of "+ dtoPAB.getSuperficieConstruida().toString() + " m2 \r\n" ; // DESCRIPCION DEL ACTIVO LINEA2
				} 
				
				if (!Checks.esNulo(dtoPAB.getEstadoConservacion())) {
					descripcionDelActivo = descripcionDelActivo + "- Considered to be in " + dtoPAB.getEstadoConservacion() +" condition \r\n"; // DESCRIPCION DEL ACTIVO LINEA3
				}
				
				if (!Checks.esNulo(dtoPAB.getEstadoAqluiler())) {
					descripcionDelActivo = descripcionDelActivo + "- Details if " + dtoPAB.getEstadoAqluiler() +" condition.";	// DESCRIPCION DEL ACTIVO LINEA4
					if(!Checks.esNulo(dtoPAB.getTipoAlquiler())) {
						descripcionDelActivo = descripcionDelActivo + " If tenanted include details of lease "+ dtoPAB.getTipoActivo();
					}
				}
				c.setCellValue(descripcionDelActivo);
				
				descripcionDelActivo = "- ";
				
				currentRow = currentRow + 4;
				
				cellReference = new CellReference("E" + currentRow); //MODO DE TRANSMISION
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getSegundaMano())) {	// ¿?¿¿
					c.setCellValue(dtoPAB.getSegundaMano());
				}else {
					c.setCellValue("");
				}
				
				currentRow = currentRow + 2;
				
				cellReference = new CellReference("E" + currentRow); //ESTADO CONSERVACIÓN 
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getEstadoConservacion())) {
					c.setCellValue(dtoPAB.getEstadoConservacion());
				}else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + currentRow); //PRECIO/M2
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporte()) && !Checks.esNulo(dtoPAB.getSuperficieConstruida())){
					Double precioMetro = dtoPAB.getImporte() / dtoPAB.getSuperficieConstruida();
					c.setCellValue((df.format(precioMetro)).toString() + " €");
				}else {
					c.setCellValue("");
				}

				currentRow++;
			}
			String numerosActivoConcatenados = "";
			
			for (int i = 0; i < listaAN.size(); i++) {
				if(!Checks.esNulo(listaAN.get(i).getNumActivo())) {
					if(numerosActivoConcatenados =="") {
						numerosActivoConcatenados = numerosActivoConcatenados + listaAN.get(i).getNumActivo().toString();
					}else {
						numerosActivoConcatenados = numerosActivoConcatenados + "," + listaAN.get(i).getNumActivo().toString();
					}
				}
			}
			
			
			currentRow = currentRow +2;
			cellReference = new CellReference("C" + currentRow); // NUMEROS DE OFERTA CONCATENADOS 
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue("One offer has been negotiated to acquire "+ numerosActivoConcatenados +" asset as follows:");
			
			currentRow = currentRow +2;
			
			for (int i = 0; i < listaAN.size(); i++) {
				
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
				cellReference = new CellReference("C" + currentRow); //NÚMERO ACTIVO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNumActivo())) {
				//	c.setCellValue(dtoPAB.getNumActivo().toString());
				}else {
					c.setCellValue("");
				}
				
				
				cellReference = new CellReference("E" + currentRow); //IMPORTE OFERTA
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo())) {
					c.setCellValue(dtoPAB.getImporteParticipacionActivo().toString() + " €");
				}else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + currentRow); // SUPERFICIE
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
					c.setCellValue(dtoPAB.getSuperficieConstruida().toString() + " m2");
					aumulacionSuperficie = aumulacionSuperficie + dtoPAB.getSuperficieConstruida();
				} else {
					c.setCellValue("0 m2");
				}
				
				cellReference = new CellReference("I" + currentRow); //PRECIO/M2
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo()) && !Checks.esNulo(dtoPAB.getSuperficieConstruida())){
					Double precioMetro = dtoPAB.getImporteParticipacionActivo() / dtoPAB.getSuperficieConstruida();
					c.setCellValue((df.format(precioMetro)).toString() + " €");
				}else {
					c.setCellValue("");
				}
				
				currentRow++;
			}
			
			currentRow = currentRow + 4;
			
			Double precioTotal = (double) 0;
			for (int i = 0; i < listaAN.size(); i++) {

				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
				cellReference = new CellReference("C" + currentRow); //NÚMERO ACTIVO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNumActivo())) {
					c.setCellValue(dtoPAB.getNumActivo().toString());
				}else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + currentRow); // IMPORTE DE LA OFERTA CAMBIAR
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo())) {
					c.setCellValue(dtoPAB.getImporteParticipacionActivo().toString() + " €");
					precioTotal = precioTotal + dtoPAB.getImporteParticipacionActivo();
				}else {
					c.setCellValue("");
				}
				
				currentRow++;
				
			}
			
			cellReference = new CellReference("F" + currentRow); // IMPORTE TOTAL
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue(precioTotal + " €");
			
			
			
			*/
			myWorkBook.write(fileOutStream);
			fileOutStream.close();
			
			return fileOut;
			
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
		
		
		return null;
	}

	

}
