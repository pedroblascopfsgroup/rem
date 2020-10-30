package es.pfsgroup.plugin.rem.excel;


import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.SecureRandom;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellReference;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Hyperlink;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFHyperlink;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.rem.model.DtoActivosFichaComercial;
import es.pfsgroup.plugin.rem.model.DtoExcelFichaComercial;
import es.pfsgroup.plugin.rem.model.DtoHcoComercialFichaComercial;
import es.pfsgroup.plugin.rem.model.DtoListFichaAutorizacion;
import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.model.VReportAdvisoryNotes;



@Component
public class ExcelReportGenerator implements ExcelReportGeneratorApi {
	
	protected static final Log logger = LogFactory.getLog(ExcelReportGenerator.class);
	
	private static final int MAX_ROW_LIMIT = 100000;

	private static final String EXPORTAR_EXCEL_LIMITE_ACTIVOS = "exportar.excel.limite.activos";

	private static final int START_REPORT_ROW = 0;
	
	private static final String TOTAL = "TOTAL";
	
	private static final int NUMERO_COLUMNAS = 21;
	
	private static final String TEXTO_NO_PUBLICADO = "Sin Publicar";
	
	private static final int NUMERO_COLUMNAS_APPLE = 11;
	
	private static final String CONSTANTE_RUTA_EXCEL = "email.attachment.folder.src";
	
	
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
		
		FileInputStream fis = null;
		File fileOut = file;
		if("LISTA_OFERTAS_CES.xls".equals(report.getReportName())) {
			
			try {
				fis = new FileInputStream(file.getAbsolutePath());
				HSSFWorkbook myWorkBook = new HSSFWorkbook(fis);
				fileOut = new File(file.getAbsolutePath());
				FileOutputStream fileOutStream = new FileOutputStream(file);
				HSSFSheet mySheet = myWorkBook.getSheetAt(0);
				
				HSSFRow r = mySheet.getRow(0);
				HSSFCell c;
				HSSFCellStyle style = myWorkBook.createCellStyle();
				HSSFFont font = myWorkBook.createFont();
				font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
				style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
				style.setWrapText(true);
				style.setFont(font);
				style.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
				style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
				style.setBorderRight(HSSFCellStyle.BORDER_THIN);
				style.setBorderTop(HSSFCellStyle.BORDER_THIN);
				r.setHeight((short) 1000);
				for(int i = 0; i <= 26; i++ ) {
					c = r.getCell(i);
					c.setCellStyle(style);
					mySheet.setColumnWidth(i, 8000);
				}

				myWorkBook.write(fileOutStream);
				fileOutStream.close();
				
			} catch (FileNotFoundException e) {
				logger.error(e.getMessage(), e);
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}
		}

		return fileOut;
		
	}

	
	@Override
	public File generateBankiaReport(List<DtoPropuestaAlqBankia> lDtoPropuestaAlq, HttpServletRequest request) throws IOException {
		
		ServletContext sc = request.getSession().getServletContext();
		FileOutputStream fileOutStream;
		File poiFile = new File(sc.getRealPath("plantillas/plugin/Propuesta_alquileres_bankia/PROPUESTA_BANKIA.xlsx"));
		File fileOut = new File(poiFile.getAbsolutePath().replace("_BANKIA",""));
		FileInputStream fis = new FileInputStream(poiFile);
		fileOutStream = new FileOutputStream(fileOut);
		
		try {			
			XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);
			
			boolean primero = true; 
			
			XSSFSheet mySheet;
			CellReference cellReference;
			XSSFRow r;
			XSSFCell c;
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
			
			// En el ultimo elemento esta el resumen por eso cogemos todos los DTO menos el ultimo
			for (int i = 0; i < lDtoPropuestaAlq.size()-1; i++) {
				
				DtoPropuestaAlqBankia dtoPAB = lDtoPropuestaAlq.get(i);
				
				
				if (primero) {
					myWorkBook.setSheetName(1, dtoPAB.getNumActivoUvem().toString());
					mySheet = myWorkBook.getSheetAt(1);
					primero = false;
				} else {
					mySheet = myWorkBook.cloneSheet(1);
					myWorkBook.setSheetName(myWorkBook.getSheetIndex(mySheet), dtoPAB.getNumActivoUvem().toString());
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
					c.setCellValue(traducirDiccionarioTipoActivo(dtoPAB.getTipoActivo()));
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
			

			if (lDtoPropuestaAlq.size()-2 > 0) {
				mySheet.shiftRows(currentRow, currentRow+1, lDtoPropuestaAlq.size()-2);
				
				for (int i = currentRow-1; i < currentRow-1 + lDtoPropuestaAlq.size()-1; i++) {
					mySheet.createRow(i);
					r = mySheet.getRow(i);
					for (int j = 0; j < NUMERO_COLUMNAS; j++) {
						r.createCell(j);
						c = r.getCell(j);
						c.setCellStyle(style);
					}
				}
				
			}
				
			
			for (int i = 0; i < lDtoPropuestaAlq.size()-1; i++) {
				
				dtoPAB = lDtoPropuestaAlq.get(i);
				numActivo = dtoPAB.getNumActivoUvem(); // El numero de activo lo necesitamos para referenciar el resto de hojas en las formulas
				String formula;
				

				
				cellReference = new CellReference("B" + Integer.toString(currentRow)); // ACTIVO 
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(numActivo))
					c.setCellValue(numActivo.toString());
				
				cellReference = new CellReference("C" + Integer.toString(currentRow)); // TIPO ACTIVO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTipoActivo()))
					c.setCellValue(traducirDiccionarioTipoActivo(dtoPAB.getTipoActivo()));
				
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
				
			
				formula = "'"+numActivo.toString()+"'!B49";
				cellReference = new CellReference("T" + Integer.toString(currentRow)); // INGRESOS NETOS
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
				c.setCellFormula(formula);
				
				// RESOLUCION NO RELLENO
  				++currentRow; // Siguiente fila
					
			}
			int fila = 6 + lDtoPropuestaAlq.size()-2; 
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS; j++) {
				r.createCell(j);
				c = r.getCell(j);
			}
			
			dtoPAB = lDtoPropuestaAlq.get(lDtoPropuestaAlq.size()-1);
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
			
			cellReference = new CellReference("S" + Integer.toString(currentRow)); // RENTA BONIFICADA
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellStyle(style);
			

			
			myWorkBook.write(fileOutStream);
			fileOutStream.close();
			
			return fileOut;
			
		}finally {
			fileOutStream.close();
		}
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
		return MAX_ROW_LIMIT;
	}
	
	@Override
	public File generateBbvaReportPrueba(DtoExcelFichaComercial dtoExcelFichaComercial, HttpServletRequest request) throws IOException {
		ServletContext sc = request.getSession().getServletContext();
		FileOutputStream fileOutStream;
		SecureRandom random = new SecureRandom();
		long n = random.nextLong();
        if (n == Long.MIN_VALUE) {
            n = 0;
        } else {
            n = Math.abs(n);
        }
        String aleatorio = Long.toString(n);
        if(aleatorio.length() > 5){
        	aleatorio = aleatorio.substring(0, 5);
        }
		String nombreFichero = "FichaComercial_" + aleatorio +".xlsx";
		
		File poiFile = new File(sc.getRealPath("/plantillas/plugin/GenerarFichaComercialBbva/FichaComercialReport.xlsx"));
		File fileOut = new File(poiFile.getAbsolutePath().replace("Report",""));
		FileInputStream fis = new FileInputStream(poiFile);
		fileOutStream = new FileOutputStream(fileOut);
		
		try {			
			XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);

			XSSFSheet mySheet;
			XSSFSheet mySheetDesglose;
			XSSFSheet mySheetDepuracion;
			mySheet = myWorkBook.getSheetAt(0);
			mySheetDesglose = myWorkBook.getSheetAt(1);
			mySheetDepuracion= myWorkBook.getSheetAt(2);
			CellReference cellReference;
			XSSFRow r;
			XSSFCell c;
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
			
			//Rellenamos la primera hoja
			//TODO
			
			cellReference = new CellReference("K2");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getNumOferta())) {
				c.setCellValue(dtoExcelFichaComercial.getNumOferta());
			} else {
				c.setCellValue("");
			}

			cellReference = new CellReference("K3");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getDireccionComercial())) {
				c.setCellValue(dtoExcelFichaComercial.getDireccionComercial());
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("K4");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaAlta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaAlta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("D13");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getProvincia() != null) {
			c.setCellValue(dtoExcelFichaComercial.getProvincia());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("D14");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getLocalidad() != null) {
			c.setCellValue(dtoExcelFichaComercial.getLocalidad());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("D15");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCodigoPostal() != null) {
			c.setCellValue(dtoExcelFichaComercial.getCodigoPostal());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("F13");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getComite() != null) {
			c.setCellValue(dtoExcelFichaComercial.getComite());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E15");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getLinkHaya() != null) {
			c.setCellValue(dtoExcelFichaComercial.getLinkHaya());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaActualOferta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaActualOferta()));
			}else {
				c.setCellValue("");

			}
			cellReference = new CellReference("F31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaSeisMesesOferta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaSeisMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("G31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaDoceMesesOferta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaDoceMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("H31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaDieciochoMesesOferta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaDieciochoMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteActual() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioComiteActual());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("F32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteSeisMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioComiteSeisMesesOferta());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("G32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteDoceMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioComiteDoceMesesOferta());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("H32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteDieciochoMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioComiteDieciochoMesesOferta());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebActual() != null) {
				c.setCellValue(dtoExcelFichaComercial.getPrecioWebActual());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("F33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebSeisMesesOferta()!=null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioWebSeisMesesOferta());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("G33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebDoceMesesOferta()!=null) {
				c.setCellValue(dtoExcelFichaComercial.getPrecioWebDoceMesesOferta());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("H33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebDieciochoMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioWebDieciochoMesesOferta());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("J31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaUltimoPrecioAprobado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getFechaUltimoPrecioAprobado());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("K31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getComite() != null) {
			c.setCellValue(dtoExcelFichaComercial.getComite());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("L31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDtoComite() != null) {
			c.setCellValue(dtoExcelFichaComercial.getDtoComite());
			}else {
			c.setCellValue("");	
			}

			cellReference = new CellReference("E34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionActual() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTasacionActual());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("F34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionSeisMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTasacionSeisMesesOferta());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("G34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionDoceMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTasacionDoceMesesOferta());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("H34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionDieciochoMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTasacionDieciochoMesesOferta());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("E37");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getImporteAdjuducacion() != null) {
			c.setCellValue(dtoExcelFichaComercial.getImporteAdjuducacion().doubleValue());
			}else {
			c.setCellValue("");		
			}
			
			cellReference = new CellReference("E38");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getRentaMensual()!= null) {
				c.setCellValue(dtoExcelFichaComercial.getRentaMensual());	
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("E40");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTotalSuperficie() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTotalSuperficie().doubleValue());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("E41");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getComisionHayaDivarian() != null) {
			c.setCellValue(dtoExcelFichaComercial.getComisionHayaDivarian());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("E42");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getGastosPendientes() != null) {
			c.setCellValue(dtoExcelFichaComercial.getGastosPendientes());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("E43");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCostesLegales() != null) {
			c.setCellValue(dtoExcelFichaComercial.getCostesLegales());
			}else {
				c.setCellValue("");			
			}
			
			cellReference = new CellReference("E49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getVisitas() != null) {
			c.setCellValue(dtoExcelFichaComercial.getVisitas());
			}else {
				c.setCellValue("");		
			}
			
			cellReference = new CellReference("F49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getLeads() != null) {
			c.setCellValue(dtoExcelFichaComercial.getLeads());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("G49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTotalOfertas() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTotalOfertas());
			}else {
				c.setCellValue("");				
			}
			
			cellReference = new CellReference("H49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPublicado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPublicado());
			}else {
				c.setCellValue("");				
			}
			
			cellReference = new CellReference("I49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaPublicado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getFechaPublicado());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("J49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getMesesEnVenta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getMesesEnVenta());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("K49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDiasPublicado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getDiasPublicado());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("L49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDiasPVP() != null) {
			c.setCellValue(dtoExcelFichaComercial.getDiasPVP());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("D60");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNombreYApellidosOfertante() != null) {
			c.setCellValue(dtoExcelFichaComercial.getNombreYApellidosOfertante());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("D61");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDniOfertante() != null) {
			c.setCellValue(dtoExcelFichaComercial.getDniOfertante());
			}else {
				c.setCellValue("");
			}
			cellReference = new CellReference("J60");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNombreYApellidosComercial() != null) {
				c.setCellValue(dtoExcelFichaComercial.getNombreYApellidosComercial());	
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("J61");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTelefonoComercial() != null) {
				c.setCellValue(dtoExcelFichaComercial.getTelefonoComercial());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("J62");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCorreoComercial()!= null) {
			c.setCellValue(dtoExcelFichaComercial.getCorreoComercial());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("J63");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNombreYApellidosPrescriptor() != null) {
			c.setCellValue(dtoExcelFichaComercial.getNombreYApellidosPrescriptor());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("J64");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTelefonoPrescriptor() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTelefonoPrescriptor());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("J65");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCorreoPrescriptor()!=null){
			c.setCellValue(dtoExcelFichaComercial.getCorreoPrescriptor());
			}else {
				c.setCellValue("");	
			}
			
			/*cellReference = new CellReference("J75");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.viviendasTotales() != 0){
			c.setCellValue(dtoExcelFichaComercial.viviendasTotales());
			}else {
				c.setCellValue("0");	
			}*/
				
			
			
			int currentRowDesglose = 8;
			for(DtoActivosFichaComercial activoFichaComercial : dtoExcelFichaComercial.getListaActivosFichaComercial()) {

				cellReference = new CellReference("B" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getIdActivo())) {
					c.setCellValue(activoFichaComercial.getIdActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getIdActivo())) {
					c.setCellValue(activoFichaComercial.getIdActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("C" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumFincaRegistral())) {
					c.setCellValue(activoFichaComercial.getNumFincaRegistral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("C" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumFincaRegistral())) {
					c.setCellValue(activoFichaComercial.getNumFincaRegistral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("D" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getGaraje())) {
					c.setCellValue(activoFichaComercial.getGaraje());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("D" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getGaraje())) {
					c.setCellValue(activoFichaComercial.getGaraje());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTrastero())) {
					c.setCellValue(activoFichaComercial.getTrastero());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTrastero())) {
					c.setCellValue(activoFichaComercial.getTrastero());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumRegProp())) {
					c.setCellValue(activoFichaComercial.getNumRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumRegProp())) {
					c.setCellValue(activoFichaComercial.getNumRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getLocalidadRegProp())) {
					c.setCellValue(activoFichaComercial.getLocalidadRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getLocalidadRegProp())) {
					c.setCellValue(activoFichaComercial.getLocalidadRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("H" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumRefCatastral())) {
					c.setCellValue(activoFichaComercial.getNumRefCatastral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("H" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTipoEntrada())) {
					c.setCellValue(activoFichaComercial.getTipoEntrada());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getEstadoFisicoActivo())) {
					c.setCellValue(activoFichaComercial.getEstadoFisicoActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getDepuracionJuridica())) {
					c.setCellValue(activoFichaComercial.getDepuracionJuridica());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("J" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTipologia())) {
					c.setCellValue(activoFichaComercial.getTipologia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("J" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getInscritoRegistro())) {
					c.setCellValue(activoFichaComercial.getInscritoRegistro());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("K" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getSubtipologia())) {
					c.setCellValue(activoFichaComercial.getSubtipologia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("K" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTituloPropiedad())) {
					c.setCellValue(activoFichaComercial.getTituloPropiedad());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("L" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getM2Edificable())) {
					c.setCellValue(activoFichaComercial.getM2Edificable().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("L" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getCargas())) {
					c.setCellValue(activoFichaComercial.getCargas());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("M" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getSituacionComercial())) {
					c.setCellValue(activoFichaComercial.getSituacionComercial());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("M" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getPosesion())) {
					c.setCellValue(activoFichaComercial.getPosesion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("N" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getEpa())) {
					c.setCellValue(activoFichaComercial.getEpa());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("N" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getOcupado())) {
					c.setCellValue(activoFichaComercial.getOcupado());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("O" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getDireccion())) {
					c.setCellValue(activoFichaComercial.getDireccion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("O" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getColectivo())) {
					c.setCellValue(activoFichaComercial.getColectivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("P" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getCodPostal())) {
					c.setCellValue(activoFichaComercial.getCodPostal());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("P" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getDireccion())) {
					c.setCellValue(activoFichaComercial.getDireccion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Q" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getMunicipio())) {
					c.setCellValue(activoFichaComercial.getMunicipio());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Q" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getCodPostal())) {
					c.setCellValue(activoFichaComercial.getCodPostal());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("R" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getProvincia())) {
					c.setCellValue(activoFichaComercial.getProvincia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("R" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getMunicipio())) {
					c.setCellValue(activoFichaComercial.getMunicipio());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("S" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getSociedadTitular())) {
					c.setCellValue(activoFichaComercial.getSociedadTitular());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("S" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getProvincia())) {
					c.setCellValue(activoFichaComercial.getProvincia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("T" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getPrecioComite())) {
					c.setCellValue(activoFichaComercial.getPrecioComite());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("T" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getSociedadTitular())) {
					c.setCellValue(activoFichaComercial.getSociedadTitular());
				} else {
					c.setCellValue("");
				}
				
				
				cellReference = new CellReference("U" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getPrecioPublicacion())) {
					c.setCellValue(activoFichaComercial.getPrecioPublicacion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("V" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getPrecioSueloEpa())) {
					c.setCellValue(activoFichaComercial.getPrecioSueloEpa().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("W" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTasacion())) {
					c.setCellValue(activoFichaComercial.getTasacion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("X" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getVnc())) {
					c.setCellValue(activoFichaComercial.getVnc().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Y" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getImporteAdj())) {
					c.setCellValue(activoFichaComercial.getImporteAdj().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Z" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getRenta())) {
					c.setCellValue(activoFichaComercial.getRenta());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AA" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getOferta())) {
					c.setCellValue(activoFichaComercial.getOferta());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AB" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getEurosM2())) {
					c.setCellValue(activoFichaComercial.getEurosM2().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AC" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getComisionHaya())) {
					c.setCellValue(activoFichaComercial.getComisionHaya().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AD" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getGastosPendientes())) {
					c.setCellValue(activoFichaComercial.getGastosPendientes().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AE" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getCostesLegales())) {
					c.setCellValue(activoFichaComercial.getCostesLegales().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AF" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getOfertaNeta())) {
					c.setCellValue(activoFichaComercial.getOfertaNeta().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AG" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getLink())) {
					c.setCellValue(activoFichaComercial.getLink());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AH" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getActivoBbva())) {
					c.setCellValue(activoFichaComercial.getActivoBbva());
				} else {
					c.setCellValue("");
				}
				
				currentRowDesglose++;
			}
			
			

			
			myWorkBook.write(fileOutStream);
			fileOutStream.close();
			
			return fileOut;
			
		}finally {
			fileOutStream.close();
		}
	}
	
	@Override
	public String generateBbvaReport(DtoExcelFichaComercial dtoExcelFichaComercial, HttpServletRequest request) throws IOException {
		ServletContext sc = request.getSession().getServletContext();
		FileOutputStream fileOutStream;
		SecureRandom random = new SecureRandom();
		long n = random.nextLong();
        if (n == Long.MIN_VALUE) {
            n = 0;
        } else {
            n = Math.abs(n);
        }
        String aleatorio = Long.toString(n);
        if(aleatorio.length() > 5){
        	aleatorio = aleatorio.substring(0, 5);
        }
		String nombreFichero = "FichaComercial_" + aleatorio +".xlsx";
		String ruta = appProperties.getProperty(CONSTANTE_RUTA_EXCEL);
		
		File poiFile = new File(sc.getRealPath("/plantillas/plugin/GenerarFichaComercialBbva/FichaComercialReport.xlsx"));
		File fileOut = new File(ruta + "/" + nombreFichero);
		FileInputStream fis = new FileInputStream(poiFile);
		fileOutStream = new FileOutputStream(fileOut);
		
		try {			
			XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);

			XSSFSheet mySheet;
			XSSFSheet mySheetDesglose;
			XSSFSheet mySheetDepuracion;
			XSSFSheet mySheetHistorico;
			XSSFSheet mySheetAutorizacion;
			mySheet = myWorkBook.getSheetAt(0);
			mySheetDesglose = myWorkBook.getSheetAt(1);
			mySheetDepuracion= myWorkBook.getSheetAt(2);
			mySheetHistorico= myWorkBook.getSheetAt(3);
			mySheetAutorizacion = myWorkBook.getSheetAt(5);
			CellReference cellReference;
			XSSFRow r;
			XSSFCell c;
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
			XSSFHyperlink link = myWorkBook.getCreationHelper().createHyperlink(Hyperlink.LINK_URL);
			
			
			// Estilos celdas
			XSSFFont  font = myWorkBook.createFont();
		    
			//Celda con Bordes
			XSSFCellStyle styleBordesCompletos= myWorkBook.createCellStyle();
			styleBordesCompletos.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			font = styleBordesCompletos.getFont();
			font.setFontHeightInPoints((short)8);
			styleBordesCompletos.setFont(font);
			styleBordesCompletos.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			//Celda con Borde inferior
			XSSFCellStyle styleBordesInferior= myWorkBook.createCellStyle();
			font = styleBordesInferior.getFont();
			font.setFontHeightInPoints((short)8);
			styleBordesInferior.setFont(font);
			styleBordesInferior.setBottomBorderColor(new XSSFColor(new java.awt.Color(192, 192, 192)));
			styleBordesInferior.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesInferior.setAlignment(XSSFCellStyle.ALIGN_CENTER);

			//Celda fondo amarillo claro
			XSSFCellStyle styleFondoAmarillo = myWorkBook.createCellStyle();
			font = styleFondoAmarillo.getFont();
			font.setFontHeightInPoints((short)8);
			styleFondoAmarillo.setFont(font);
			styleFondoAmarillo.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleFondoAmarillo.setBottomBorderColor(new XSSFColor(new java.awt.Color(192, 192, 192)));
			styleFondoAmarillo.setFillForegroundColor(new XSSFColor(new java.awt.Color(255, 255, 224)));
			styleFondoAmarillo.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			styleFondoAmarillo.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			//Celda fondo azul claro
			XSSFCellStyle styleFondoAzul = myWorkBook.createCellStyle();
			font = styleFondoAzul.getFont();
			font.setFontHeightInPoints((short)8);
			styleFondoAzul.setFont(font);
			styleFondoAzul.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleFondoAzul.setBottomBorderColor(new XSSFColor(new java.awt.Color(192, 192, 192)));
			styleFondoAzul.setFillForegroundColor(new XSSFColor(new java.awt.Color(176, 196, 222)));
		    styleFondoAzul.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		    styleFondoAzul.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			
			//Rellenamos la primera hoja
			//TODO
			
			cellReference = new CellReference("K2");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getNumOferta())) {
				c.setCellValue(dtoExcelFichaComercial.getNumOferta());
			} else {
				c.setCellValue("");
			}

			cellReference = new CellReference("K3");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getDireccionComercial())) {
				c.setCellValue(dtoExcelFichaComercial.getDireccionComercial());
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("K4");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaAlta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaAlta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("D13");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getProvincia() != null) {
			c.setCellValue(dtoExcelFichaComercial.getProvincia());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("D14");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getLocalidad() != null) {
			c.setCellValue(dtoExcelFichaComercial.getLocalidad());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("D15");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCodigoPostal() != null) {
			c.setCellValue(dtoExcelFichaComercial.getCodigoPostal());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("F13");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getComite() != null) {
			c.setCellValue(dtoExcelFichaComercial.getComite());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E15");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getLinkHaya() != null) {
				c.setCellValue("Link web Haya");
				link.setAddress(dtoExcelFichaComercial.getLinkHaya());
				c.setHyperlink(link);
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaActualOferta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaActualOferta()));
			}else {
				c.setCellValue("");

			}
			cellReference = new CellReference("F31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaSeisMesesOferta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaSeisMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("G31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaDoceMesesOferta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaDoceMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("H31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaDieciochoMesesOferta() != null) {
			c.setCellValue(format.format(dtoExcelFichaComercial.getFechaDieciochoMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteActual() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioComiteActual());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("F32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteSeisMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioComiteSeisMesesOferta());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("G32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteDoceMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioComiteDoceMesesOferta());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("H32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteDieciochoMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioComiteDieciochoMesesOferta());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebActual() != null) {
				c.setCellValue(dtoExcelFichaComercial.getPrecioWebActual());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("F33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebSeisMesesOferta()!=null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioWebSeisMesesOferta());
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("G33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebDoceMesesOferta()!=null) {
				c.setCellValue(dtoExcelFichaComercial.getPrecioWebDoceMesesOferta());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("H33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebDieciochoMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPrecioWebDieciochoMesesOferta());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("J31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaUltimoPrecioAprobado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getFechaUltimoPrecioAprobado());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("K31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getComite() != null) {
			c.setCellValue(dtoExcelFichaComercial.getComite());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("L31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDtoComite() != null) {
			c.setCellValue(dtoExcelFichaComercial.getDtoComite());
			}else {
			c.setCellValue("");	
			}

			cellReference = new CellReference("E34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionActual() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTasacionActual());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("F34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionSeisMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTasacionSeisMesesOferta());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("G34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionDoceMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTasacionDoceMesesOferta());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("H34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionDieciochoMesesOferta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTasacionDieciochoMesesOferta());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("E37");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getImporteAdjuducacion() != null) {
			c.setCellValue(dtoExcelFichaComercial.getImporteAdjuducacion().doubleValue());
			}else {
			c.setCellValue("");		
			}
			
			cellReference = new CellReference("E38");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getRentaMensual()!= null) {
				c.setCellValue(dtoExcelFichaComercial.getRentaMensual());	
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("E40");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTotalSuperficie() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTotalSuperficie().doubleValue());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("E41");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getComisionHayaDivarian() != null) {
			c.setCellValue(dtoExcelFichaComercial.getComisionHayaDivarian());
			}else {
			c.setCellValue("");	
			}
			
			cellReference = new CellReference("E42");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getGastosPendientes() != null) {
			c.setCellValue(dtoExcelFichaComercial.getGastosPendientes());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("E43");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCostesLegales() != null) {
			c.setCellValue(dtoExcelFichaComercial.getCostesLegales());
			}else {
				c.setCellValue("");			
			}
			
			cellReference = new CellReference("E49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getVisitas() != null) {
			c.setCellValue(dtoExcelFichaComercial.getVisitas());
			}else {
				c.setCellValue("");		
			}
			
			cellReference = new CellReference("F49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getLeads() != null) {
			c.setCellValue(dtoExcelFichaComercial.getLeads());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("G49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTotalOfertas() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTotalOfertas());
			}else {
				c.setCellValue("");				
			}
			
			cellReference = new CellReference("H49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPublicado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getPublicado());
			}else {
				c.setCellValue("");				
			}
			
			cellReference = new CellReference("I49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaPublicado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getFechaPublicado());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("J49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getMesesEnVenta() != null) {
			c.setCellValue(dtoExcelFichaComercial.getMesesEnVenta());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("K49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDiasPublicado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getDiasPublicado());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("L49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDiasPVP() != null) {
			c.setCellValue(dtoExcelFichaComercial.getDiasPVP());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("D60");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNombreYApellidosOfertante() != null) {
			c.setCellValue(dtoExcelFichaComercial.getNombreYApellidosOfertante());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("D61");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDniOfertante() != null) {
			c.setCellValue(dtoExcelFichaComercial.getDniOfertante());
			}else {
				c.setCellValue("");
			}
			cellReference = new CellReference("J60");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNombreYApellidosComercial() != null) {
				c.setCellValue(dtoExcelFichaComercial.getNombreYApellidosComercial());	
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("J61");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTelefonoComercial() != null) {
				c.setCellValue(dtoExcelFichaComercial.getTelefonoComercial());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("J62");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCorreoComercial()!= null) {
			c.setCellValue(dtoExcelFichaComercial.getCorreoComercial());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("J63");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNombreYApellidosPrescriptor() != null) {
			c.setCellValue(dtoExcelFichaComercial.getNombreYApellidosPrescriptor());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("J64");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTelefonoPrescriptor() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTelefonoPrescriptor());
			}else {
				c.setCellValue("");	
			}
			
			cellReference = new CellReference("J65");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCorreoPrescriptor()!=null){
			c.setCellValue(dtoExcelFichaComercial.getCorreoPrescriptor());
			}else {
				c.setCellValue("");	
			}
				
			
			//Rellenamos seguda y tercera hoja
			
			int currentRowDesglose = 8;
			for(DtoActivosFichaComercial activoFichaComercial : dtoExcelFichaComercial.getListaActivosFichaComercial()) {

				cellReference = new CellReference("B" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getIdActivo())) {
					c.setCellValue(activoFichaComercial.getIdActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getIdActivo())) {
					c.setCellValue(activoFichaComercial.getIdActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("C" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getNumFincaRegistral())) {
					c.setCellValue(activoFichaComercial.getNumFincaRegistral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("C" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getNumFincaRegistral())) {
					c.setCellValue(activoFichaComercial.getNumFincaRegistral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("D" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getGaraje())) {
					c.setCellValue(activoFichaComercial.getGaraje());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("D" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getGaraje())) {
					c.setCellValue(activoFichaComercial.getGaraje());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getTrastero())) {
					c.setCellValue(activoFichaComercial.getTrastero());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getTrastero())) {
					c.setCellValue(activoFichaComercial.getTrastero());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getNumRegProp())) {
					c.setCellValue(activoFichaComercial.getNumRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getNumRegProp())) {
					c.setCellValue(activoFichaComercial.getNumRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getLocalidadRegProp())) {
					c.setCellValue(activoFichaComercial.getLocalidadRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getLocalidadRegProp())) {
					c.setCellValue(activoFichaComercial.getLocalidadRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("H" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getNumRefCatastral())) {
					c.setCellValue(activoFichaComercial.getNumRefCatastral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("H" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getTipoEntrada())) {
					c.setCellValue(activoFichaComercial.getTipoEntrada());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getEstadoFisicoActivo())) {
					c.setCellValue(activoFichaComercial.getEstadoFisicoActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getDepuracionJuridica())) {
					c.setCellValue(activoFichaComercial.getDepuracionJuridica());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("J" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getTipologia())) {
					c.setCellValue(activoFichaComercial.getTipologia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("J" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getInscritoRegistro())) {
					c.setCellValue(activoFichaComercial.getInscritoRegistro());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("K" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getSubtipologia())) {
					c.setCellValue(activoFichaComercial.getSubtipologia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("K" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getTituloPropiedad())) {
					c.setCellValue(activoFichaComercial.getTituloPropiedad());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("L" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getM2Edificable())) {
					c.setCellValue(activoFichaComercial.getM2Edificable().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("L" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getCargas())) {
					c.setCellValue(activoFichaComercial.getCargas());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("M" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getSituacionComercial())) {
					c.setCellValue(activoFichaComercial.getSituacionComercial());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("M" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getPosesion())) {
					c.setCellValue(activoFichaComercial.getPosesion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("N" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getEpa())) {
					c.setCellValue(activoFichaComercial.getEpa());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("N" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getOcupado())) {
					c.setCellValue(activoFichaComercial.getOcupado());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("O" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getDireccion())) {
					c.setCellValue(activoFichaComercial.getDireccion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("O" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getColectivo())) {
					c.setCellValue(activoFichaComercial.getColectivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("P" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getCodPostal())) {
					c.setCellValue(activoFichaComercial.getCodPostal());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("P" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getDireccion())) {
					c.setCellValue(activoFichaComercial.getDireccion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Q" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getMunicipio())) {
					c.setCellValue(activoFichaComercial.getMunicipio());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Q" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getCodPostal())) {
					c.setCellValue(activoFichaComercial.getCodPostal());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("R" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getProvincia())) {
					c.setCellValue(activoFichaComercial.getProvincia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("R" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getMunicipio())) {
					c.setCellValue(activoFichaComercial.getMunicipio());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("S" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getSociedadTitular())) {
					c.setCellValue(activoFichaComercial.getSociedadTitular());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("S" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getProvincia())) {
					c.setCellValue(activoFichaComercial.getProvincia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("T" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getPrecioComite())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getPrecioComite()));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("T" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getSociedadTitular())) {
					c.setCellValue(activoFichaComercial.getSociedadTitular());
				} else {
					c.setCellValue("");
				}
				
				
				cellReference = new CellReference("U" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getPrecioPublicacion())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getPrecioPublicacion()));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("V" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
			    c.setCellStyle(styleFondoAmarillo);
				if (!Checks.esNulo(activoFichaComercial.getPrecioSueloEpa())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getPrecioSueloEpa()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("W" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getTasacion())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getTasacion()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("X" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
			    c.setCellStyle(styleFondoAzul);
				if (!Checks.esNulo(activoFichaComercial.getVnc())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getVnc()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Y" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getImporteAdj())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getImporteAdj()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Z" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getRenta())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getRenta()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AA" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getOferta())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getOferta()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AB" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getEurosM2())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getEurosM2()));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AC" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getComisionHaya())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getComisionHaya()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AD" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
			    c.setCellStyle(styleFondoAmarillo);
				if (!Checks.esNulo(activoFichaComercial.getGastosPendientes())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getGastosPendientes()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AE" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
			    c.setCellStyle(styleFondoAmarillo);
				if (!Checks.esNulo(activoFichaComercial.getCostesLegales())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getCostesLegales()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AF" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getOfertaNeta())) {
					c.setCellValue(formatearImportes(activoFichaComercial.getOfertaNeta()).concat("€"));
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AG" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getLink())) {
					c.setCellValue("Link web Haya");
					link.setAddress(activoFichaComercial.getLink());
					c.setHyperlink(link);

				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AH" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellStyle(styleBordesInferior);
				if (!Checks.esNulo(activoFichaComercial.getActivoBbva())) {
					c.setCellValue(activoFichaComercial.getActivoBbva());
				} else {
					c.setCellValue("");
				}
				
				currentRowDesglose++;
				
			}
			
			//Rellenamos hoja historico ofertas
			
			//TODO
			int currentRowHistorico = 7;
			for( DtoHcoComercialFichaComercial historico : dtoExcelFichaComercial.getListaHistoricoOfertas()) {
				
				
			/*	cellReference = new CellReference("B" +Integer.toString(currentRowHistorico)); 
				r = mySheetHistorico.getRow(cellReference.getRow()); 
				c = r.getCell(cellReference.getCol()); 
				if(!Checks.esNulo(historico.getNumActivo())) {
				  c.setCellValue(historico.getNumActivo()); 
				} else { 
					  c.setCellValue(""); 
				}
				 

				
				cellReference = new CellReference("C" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getFecha())) {
					c.setCellValue(historico.getFecha());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("D" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getNumOferta())) {
					c.setCellValue(historico.getNumOferta());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getFechaSancion())) {
					c.setCellValue(historico.getFechaSancion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getOfertante())) {
					c.setCellValue(historico.getOfertante());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getEstado())) {
					c.setCellValue(historico.getEstado());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("H" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getDesestimado())) {
					c.setCellValue(historico.getDesestimado());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getMotivoDesestimiento())) {
					c.setCellValue(historico.getMotivoDesestimiento());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("J" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getFfrr())) {
					c.setCellValue(historico.getFfrr());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("K" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getOferta())) {
					c.setCellValue(historico.getOferta());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getPvpComite())) {
					c.setCellValue(historico.getPvpComite());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("L" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(historico.getTasacion())) {
					c.setCellValue(historico.getTasacion());
				} else {
					c.setCellValue("");
				}
				
				currentRowHistorico++;*/
				
			}
			
			
			//rellenamos la quinta hoja
			
			int currentRowComercial = 27;
			for( DtoListFichaAutorizacion autorizacion : dtoExcelFichaComercial.getListaFichaAutorizacion()) {
				
				if(currentRowComercial!= 27) {
					r = mySheetAutorizacion.createRow(currentRowComercial);
					c = r.createCell(1);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(2);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(3);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(4);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(5);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(6);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(7);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(8);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(9);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(10);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(11);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(12);
				    c.setCellStyle(styleBordesCompletos);
				    c = r.createCell(13);
				    c.setCellStyle(styleBordesCompletos);
				}
			
				cellReference = new CellReference("B" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getIdActivo())) {
					c.setCellValue(autorizacion.getIdActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("C" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getFinca())) {
					c.setCellValue(autorizacion.getFinca());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("D" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getRegPropiedad())) {
					c.setCellValue(autorizacion.getRegPropiedad());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getLocalidadRegProp())) {
					c.setCellValue(autorizacion.getLocalidadRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getPrecioVenta())) {
					c.setCellValue(autorizacion.getPrecioVenta());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getDireccion())) {
					c.setCellValue(autorizacion.getDireccion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getLocalidad())) {
					c.setCellValue(autorizacion.getLocalidad());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("L" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getProvincia())) {
					c.setCellValue(autorizacion.getProvincia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("N" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(autorizacion.getCondicionesVenta())) {
					c.setCellValue(autorizacion.getCondicionesVenta());
				} else {
					c.setCellValue("");
				}
				
				currentRowComercial++;

			}
			
			myWorkBook.write(fileOutStream);
			fileOutStream.close();
			
			return nombreFichero;
			
		}finally {
			fileOutStream.close();
		}
	}	
	
	@Override
	public File getAdvisoryNoteReport(List<VReportAdvisoryNotes> listaAN, HttpServletRequest request) throws IOException {
		
		ServletContext sc = request.getSession().getServletContext();		
		FileOutputStream fileOutStream = null;
		
		try {

			File poiFile = new File(sc.getRealPath("plantillas/plugin/AdvisoryNoteApple/AdvisoryNoteReport.xlsx"));
			
			File fileOut = new File(poiFile.getAbsolutePath().replace("Report",""));
			FileInputStream fis = new FileInputStream(poiFile);
			fileOutStream = new FileOutputStream(fileOut);
			XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);
		
			XSSFSheet mySheet;
			CellReference cellReference;
			XSSFRow r;
			XSSFCell c;
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat anyo = new SimpleDateFormat("yyyy");
			DecimalFormat df = new DecimalFormat("#.##");
			String descripcionDelActivo= "- ";
			int inicioBucleInterno = 0;
			String textoAmarillo = "Asset Listed in the market since 26/07/2019  on the following channels:\r\n";
			textoAmarillo = textoAmarillo + "1. Websites (Number) : Haya, Idealista, Fotocasa, etc.\r\n";
			textoAmarillo = textoAmarillo + "2. Offline media: Radio, TV, etc. \r\n";
			textoAmarillo = textoAmarillo + "3. In-place MKT: Flyers, Banners,etc. \r\n";
			textoAmarillo = textoAmarillo + "4. Open Day: Description.\r\n";
			textoAmarillo = textoAmarillo + "Explanation of number of leads and offers and oppinion on effectiveness of the MKT actions. ";
		
			
			XSSFFont font = myWorkBook.createFont();
		    font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		    
		    XSSFFont fontCursivaP= myWorkBook.createFont();
		    fontCursivaP.setItalic(true);
		    fontCursivaP.setFontHeightInPoints((short) 8);
		   
		    XSSFFont fuentePequenyaAzul= myWorkBook.createFont();
		    fuentePequenyaAzul.setFontHeightInPoints((short) 10);
		    fuentePequenyaAzul.setColor(new XSSFColor(new java.awt.Color(102, 190, 237))); 
		    
		    XSSFFont fuenteAzul= myWorkBook.createFont();
		    fuenteAzul.setColor(new XSSFColor(new java.awt.Color(102, 190, 237))); 
		    
		    XSSFFont fontSubr = myWorkBook.createFont();
		    fontSubr.setBoldweight(Font.BOLDWEIGHT_BOLD);
		    fontSubr.setUnderline(HSSFFont.U_SINGLE);
		    
		    XSSFFont fontSubSinNegrita = myWorkBook.createFont();	  
		    fontSubSinNegrita.setUnderline(HSSFFont.U_SINGLE);
			
			XSSFCellStyle style= myWorkBook.createCellStyle();
			style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setBorderTop(XSSFCellStyle.BORDER_THIN);
			style.setBorderRight(XSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(true);
			
			DataFormat df2 = myWorkBook.createDataFormat();
			//CELDA COMPLETA CELDAS
			XSSFCellStyle styleBordesCompletosCeldaEuro= myWorkBook.createCellStyle();
			styleBordesCompletosCeldaEuro.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaEuro.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaEuro.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaEuro.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaEuro.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCeldaEuro.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCeldaEuro.setWrapText(true);
			
			styleBordesCompletosCeldaEuro.setDataFormat(df2.getFormat("#0.00,€#"));
			
			//ESTILOS
				//LETRA AZUL PEQUEÑA
			XSSFCellStyle styleAzulPeque= myWorkBook.createCellStyle();
			styleAzulPeque.setFont(fuentePequenyaAzul);
				//LETRA AZUL NORMAL
			XSSFCellStyle styleAzul= myWorkBook.createCellStyle();
			styleAzul.setFont(fuenteAzul);
				//CURSIVA PEQUEÑA
			XSSFCellStyle styleCursiva= myWorkBook.createCellStyle();
			styleCursiva.setFont(fontCursivaP);
				//CURSIVA PEQUEÑA DERECHA
				XSSFCellStyle styleCursivaDerecha= myWorkBook.createCellStyle();
			styleCursivaDerecha.setFont(fontCursivaP);
			styleCursivaDerecha.setAlignment(XSSFCellStyle.ALIGN_RIGHT);
			
				//SUBSINNEGRITA
			XSSFCellStyle fontSubSinNegritaE= myWorkBook.createCellStyle();
			fontSubSinNegritaE.setFont(fontSubSinNegrita);
				//SUBNEGRITA
			XSSFCellStyle subNegrita= myWorkBook.createCellStyle();
			subNegrita.setFont(fontSubr);
				//SOLO NEGRITA
			XSSFCellStyle negrita= myWorkBook.createCellStyle();
			negrita.setFont(font);
				//SIN ESTILO
			XSSFCellStyle sinEstilo= myWorkBook.createCellStyle();
			sinEstilo.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			sinEstilo.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			
				//ALINEADO DERECHA
			XSSFCellStyle alineadoDerecha= myWorkBook.createCellStyle();
			alineadoDerecha.setAlignment(XSSFCellStyle.ALIGN_RIGHT);
			alineadoDerecha.setFont(font);
			
				//CELDA COMPLETA
			XSSFCellStyle styleBordesCompletos= myWorkBook.createCellStyle();
			styleBordesCompletos.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletos.setVerticalAlignment(XSSFCellStyle.VERTICAL_TOP);
			styleBordesCompletos.setWrapText(true);
			styleBordesCompletos.setFont(font);
			styleBordesCompletos.setFillForegroundColor(new XSSFColor(new java.awt.Color(211, 211, 211)));
			styleBordesCompletos.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
				//CELDA COMPLETA
			XSSFCellStyle styleBordesCompletosNoAlin= myWorkBook.createCellStyle();
			styleBordesCompletosNoAlin.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNoAlin.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNoAlin.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNoAlin.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setAlignment(XSSFCellStyle.ALIGN_JUSTIFY);
			styleBordesCompletosNoAlin.setWrapText(true);
			
			//CELDA COMPLETA
			XSSFCellStyle styleBordesCompletosNegritaBlanco= myWorkBook.createCellStyle();
			styleBordesCompletosNegritaBlanco.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNegritaBlanco.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNegritaBlanco.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNegritaBlanco.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNegritaBlanco.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosNegritaBlanco.setWrapText(true);
			styleBordesCompletosNegritaBlanco.setFont(font);
			
			
			//CELDA COMPLETA CELDAS
			XSSFCellStyle styleBordesCompletosCelda= myWorkBook.createCellStyle();
			styleBordesCompletosCelda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCelda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCelda.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCelda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCelda.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCelda.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCelda.setWrapText(true);
			
			//CELDA COMPLETA CELDAS ALINEADAS IZQUIERDA ALINEAR
			XSSFCellStyle styleBordesCompletosCeldaAlineadasIzquierda= myWorkBook.createCellStyle();
			styleBordesCompletosCeldaAlineadasIzquierda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaAlineadasIzquierda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaAlineadasIzquierda.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaAlineadasIzquierda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaAlineadasIzquierda.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCeldaAlineadasIzquierda.setAlignment(XSSFCellStyle.ALIGN_LEFT);
			styleBordesCompletosCeldaAlineadasIzquierda.setWrapText(true);
			
			//CELDA COMPLETA CELDAS
			XSSFCellStyle styleBordesCompletosCeldaTamanyoCelda= myWorkBook.createCellStyle();
			styleBordesCompletosCeldaTamanyoCelda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaTamanyoCelda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaTamanyoCelda.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaTamanyoCelda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaTamanyoCelda.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCeldaTamanyoCelda.setWrapText(true);
				
				//BORDES ARRIBA Y ABAJO
			XSSFCellStyle styleBordesArribaYAbajo= myWorkBook.createCellStyle();
			styleBordesArribaYAbajo.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaYAbajo.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaYAbajo.setBorderRight(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaYAbajo.setBorderLeft(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaYAbajo.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaYAbajo.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaYAbajo.setWrapText(true);
			
			//BORDES ARRIBA Y ABAJO DERECHA
			XSSFCellStyle styleBordesArribaAbajoDerecha= myWorkBook.createCellStyle();
			styleBordesArribaAbajoDerecha.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderLeft(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaAbajoDerecha.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaAbajoDerecha.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaAbajoDerecha.setWrapText(true);
			
			//BORDES ARRIBA Y ABAJO IZQUIERDA
			XSSFCellStyle styleBordesArribaAbajoIzquierda= myWorkBook.createCellStyle();
			styleBordesArribaAbajoIzquierda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setBorderRight(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaAbajoIzquierda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaAbajoIzquierda.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaAbajoIzquierda.setWrapText(true);
			
			//BORDES SOLO DERECHA
			XSSFCellStyle styleBordesSoloDerecha= myWorkBook.createCellStyle();		
			styleBordesSoloDerecha.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesSoloDerecha.setWrapText(true);
			
			//BORDES SOLO ABAJO
			XSSFCellStyle styleBordesSoloAbajo= myWorkBook.createCellStyle();		
			styleBordesSoloAbajo.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesSoloAbajo.setWrapText(true);
			
			//BORDES ABAJO DERECHA
			styleBordesArribaAbajoIzquierda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesSoloDerecha.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesSoloDerecha.setWrapText(true);
			
			
			
			//NEGRITA Y FONDO GRIS
			XSSFCellStyle styleNegritaFondoGris= myWorkBook.createCellStyle();
			styleNegritaFondoGris.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setFont(font);
			
			// En el ultimo elemento esta el resumen por eso cogemos todos los DTO menos el ultimo
				
				
			myWorkBook.setSheetName(0, "AN S0XXX-" + anyo.format(new Date()));
			mySheet = myWorkBook.getSheetAt(0);		// <----- NÚMERO DE LA PÁGINA
			
			cellReference = new CellReference("G2");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(!Checks.esNulo(listaAN.get(0)) && !Checks.esNulo(listaAN.get(0).getNumOferta())) {
				c.setCellValue(listaAN.get(0).getNumOferta().toString());
				c.setCellStyle(negrita);
			}else {
				c.setCellValue("");
				c.setCellStyle(negrita);
			}
			
			
			cellReference = new CellReference("B3");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue(format.format(new Date()));
			
			int currentRow = 6;
			int iniciobucle = currentRow;
			for (int i = 0; i < listaAN.size(); i++) {
					
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
				
					mySheet.createRow(currentRow);
					r = mySheet.getRow(currentRow);
					r.setHeightInPoints((2 * mySheet.getDefaultRowHeightInPoints()));
					for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
						r.createCell(j);
						c = r.getCell(j);
						if(j==1) {
							c.setCellValue("PROMONTORIA \n MANZANA");
							c.setCellStyle(styleBordesCompletos);
						}else
						if(j==2) {
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
							c.setCellStyle(styleBordesCompletosCelda);
						}else if(j==4) {
							if (!Checks.esNulo(dtoPAB.getIdSantander())) {
								c.setCellValue(dtoPAB.getIdSantander());
							} else {
								c.setCellValue("");
							}
							c.setCellStyle(styleBordesCompletosCelda);
						}else if(j==6){
							if (!Checks.esNulo(dtoPAB.getDireccion())) {
								c.setCellValue(dtoPAB.getDireccion());
							} else {
								c.setCellValue("");
							}	
							c.setCellStyle(styleBordesCompletosCelda);
						}else if(j==9) {
							c.setCellStyle(styleBordesArribaAbajoDerecha);
						}
					}
					CellRangeAddress cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
					mySheet.addMergedRegion(cellRangeAddress);
					cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
					mySheet.addMergedRegion(cellRangeAddress);
					cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,9);
					mySheet.addMergedRegion(cellRangeAddress);
					cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
					mySheet.addMergedRegion(cellRangeAddress);
				
				
				currentRow++;
			}
			
		
			
			mySheet.createRow(currentRow); //creamos la fila de:Connection Status
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==1) {
					c.setCellValue("Connection Status");
					c.setCellStyle(styleBordesCompletos);
				}else if(j==2) {
					c.setCellValue("REO");
					c.setCellStyle(styleBordesCompletosCeldaAlineadasIzquierda);
				}else if(j==9) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			CellRangeAddress cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			
			mySheet.createRow(currentRow); //creamos la fila de:Property Details
			r = mySheet.getRow(currentRow);
			r.setHeight((short)-1);
			for (int j = 0; j < 10; j++) {
				
				r.createCell(j);
				r.setHeightInPoints(((listaAN.size()+1) * mySheet.getDefaultRowHeightInPoints()));
				c = r.getCell(j);
				if(j==1) {
					c.setCellValue("Property Details");
					c.setCellStyle(styleBordesCompletos);
				}else if(j==2) {
					//bucle por activo
					String descripcionLocalidadActivo = "";
					for (int i = 0; i < listaAN.size(); i++) {
						VReportAdvisoryNotes dtoPAB = listaAN.get(i);
						/*if(i>0) {
							descripcionLocalidadActivo = "\r\n"+descripcionLocalidadActivo ;
						}*/
						
						if (!Checks.esNulo(dtoPAB.getNumActivo())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + "\r\n"+dtoPAB.getNumActivo().toString() + " ";
						}
			
						if (!Checks.esNulo(dtoPAB.getSubtipoActivo())) {							
							descripcionLocalidadActivo = descripcionLocalidadActivo + traducirDiccionarioTipoActivo(dtoPAB.getSubtipoActivo());
						}
						if(!Checks.esNulo(dtoPAB.getMunicipio())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + " located in " + dtoPAB.getMunicipio();
						}
						if(!Checks.esNulo(dtoPAB.getProvincia())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + "(" + dtoPAB.getProvincia() + ")";
						}
					}
					c.setCellValue(descripcionLocalidadActivo);
					c.setCellStyle(styleBordesCompletosCeldaAlineadasIzquierda);

				}else if(j==9) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			
			iniciobucle = currentRow;
			
			mySheet.createRow(currentRow); //creamos la fila de:Background information
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==1) {
					c.setCellValue("Background information");
					c.setCellStyle(styleBordesCompletos);
				}
				if(j==9) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			currentRow++;

			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==9) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				r.setHeightInPoints((2 * mySheet.getDefaultRowHeightInPoints()));
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosNegritaBlanco);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
						break;
					case 2:
						c.setCellValue("Unit ID");
						break;
					case 4:
						c.setCellValue("Type of property");
						break;
					case 6:
						c.setCellValue("Surface area (sqm)");
						break;
					case 7:
						c.setCellValue("Asking Price");
						break;
					case 8:
						c.setCellValue("Rental income € (monthly)");
						break;
					default:
						break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
		
			
			currentRow++;

			Long aumulacionSuperficie = 0L;
			Double acumulacionAskingPrice = (double) 0;
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
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					c.setCellStyle(styleBordesCompletosCelda);
					switch (j) {
						case 0:
							c.setCellStyle(null);
						break;
						case 1:
							c.setCellStyle(null);
						break;
						case 2:
							if (total) {
								c.setCellValue("Total");
								c.setCellStyle(styleBordesCompletosNegritaBlanco);
							} else {
								if (!Checks.esNulo(dtoPAB.getNumActivo())) {
									c.setCellValue(dtoPAB.getNumActivo().toString());
								} else {
									c.setCellValue("");
								}
							}
							break;
						case 4:
							if (total) {
								c.setCellValue("");
							} else {
								if (!Checks.esNulo(dtoPAB.getSubtipoActivo())) {
									c.setCellValue(traducirDiccionarioTipoActivo(dtoPAB.getSubtipoActivo()));
								} else {
									c.setCellValue("");
								}
							}
							break;
						case 6:
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
						case 7:
							c.setCellStyle(styleBordesCompletosCeldaEuro);
							if (total) {
								c.setCellValue(acumulacionAskingPrice);	
								
							} else {
								if (!Checks.esNulo(dtoPAB.getImporte())) {
									acumulacionAskingPrice = acumulacionAskingPrice + dtoPAB.getImporte();
									c.setCellValue(dtoPAB.getImporte());
								} else {
									c.setCellValue("0€");
								}
							}
							break;
						case 8:
							c.setCellValue("0 €");
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
			}
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==9) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}

			mySheet.createRow(currentRow); // creamos fila bloque amarillo
			r = mySheet.getRow(currentRow);

			for (int i = 0; i < listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Marketing Overview");
							c.setCellStyle(subNegrita);
							break;
						case 4:
							c.setCellValue(dtoPAB.getNumActivo());
							c.setCellStyle(sinEstilo);
							break;
						case 6:
							c.setCellValue("Marketing comments (Manual Modified over given text):");
							c.setCellStyle(subNegrita);
							break;
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,8);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				
				inicioBucleInterno = currentRow;
				
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Web Publishing:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getPublicado())) {
								c.setCellValue(dtoPAB.getPublicado());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							c.setCellValue(textoAmarillo);
							c.setCellStyle(styleAzulPeque);
							break;
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,9);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
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
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,9);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
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
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,9);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
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
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,9);
				mySheet.addMergedRegion(cellRangeAddress);

				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,9);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,9);
				mySheet.addMergedRegion(cellRangeAddress);
				
				cellRangeAddress = new CellRangeAddress(inicioBucleInterno, currentRow, 6,9);	
				mySheet.addMergedRegion(cellRangeAddress); 
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				

				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Construction date:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getAnyoConstruccion())) {
								c.setCellValue(dtoPAB.getAnyoConstruccion());
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
							}
							break;
						case 6:
							c.setCellValue("Occupancy status:");
							break;
						case 8:
							if (!Checks.esNulo(dtoPAB.getOcupado())) {
								c.setCellValue(dtoPAB.getOcupado());
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
								
							}
							break;
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {

						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
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
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {

						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				r.setHeightInPoints((6 * mySheet.getDefaultRowHeightInPoints()));
				descripcionDelActivo = "\r\n\n" +descripcionDelActivo;
				if (!Checks.esNulo(dtoPAB.getSubtipoActivo())) {
					descripcionDelActivo = descripcionDelActivo + traducirDiccionarioTipoActivo(dtoPAB.getSubtipoActivo());
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
					descripcionDelActivo = descripcionDelActivo + "- Considered to be in " + traducirDiccionarioCondicion(dtoPAB.getEstadoConservacion()) + " condition \r\n"; // DESCRIPCION linea3

				}

				if (!Checks.esNulo(dtoPAB.getEstadoAqluiler())) {
					descripcionDelActivo = descripcionDelActivo + "- Details if " + dtoPAB.getEstadoAqluiler() + " condition."; // DESCRIPCION linea 4
					if (!Checks.esNulo(dtoPAB.getTipoAlquiler())) {
						descripcionDelActivo = descripcionDelActivo + " If tenanted include details of lease " + traducirDiccionarioTipoActivo(dtoPAB.getSubtipoActivo());
					}
				}

				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue(descripcionDelActivo);
							c.setCellStyle(styleBordesCompletosNoAlin);
							break;
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				descripcionDelActivo = "-";
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
				mySheet.addMergedRegion(cellRangeAddress);
				
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Mode of transmission:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getSegundaMano())) { // ¿?¿¿
								c.setCellValue(dtoPAB.getSegundaMano());
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
							}
							break;
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Asset maintenance status:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getEstadoConservacion())) {
								c.setCellValue(traducirDiccionarioCondicion(dtoPAB.getEstadoConservacion()));
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
							}
							break;
						case 6:
							c.setCellValue("Average € per sqm in the area:");
							break;
						case 8:
							if (!Checks.esNulo(dtoPAB.getImporte()) && !Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								Double precioMetro = dtoPAB.getImporte() / dtoPAB.getSuperficieConstruida();
								c.setCellValue((df.format(precioMetro)).toString() + " €");
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
							}
							break;
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
				mySheet.addMergedRegion(cellRangeAddress);
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 9:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 2:
					c.setCellValue("Proposal Background");
					c.setCellStyle(subNegrita);
					break;
				case 9:
					c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			StringBuilder rellenarNumerosActivoConcatenados = new StringBuilder();
					
			for (int i = 0; i < listaAN.size(); i++) {
				if(!Checks.esNulo(listaAN.get(i).getNumActivo())) {
					if(rellenarNumerosActivoConcatenados.length() < 1) {
						rellenarNumerosActivoConcatenados.append(listaAN.get(i).getNumActivo());
					}else {
						rellenarNumerosActivoConcatenados.append("," + listaAN.get(i).getNumActivo());
					}
				}
			}
			String numerosActivoConcatenados = rellenarNumerosActivoConcatenados.toString();
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 2:
					c.setCellValue("One offer has been negotiated to acquire "+ numerosActivoConcatenados +"  asset as follows:");
					break;
				case 9:
					c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosNegritaBlanco);
				switch (j) {
				case 0:
					c.setCellStyle(null);
					break;
				case 1:
					c.setCellStyle(null);
					break;
				case 2:
					c.setCellValue("UV ID");
					break;
				case 4:
					c.setCellValue("Gross offer");
					break;
				case 6:
					c.setCellValue("Surface area \n (sqm)");
					break;
				case 8:
					c.setCellValue("Offer(€/sqm)");
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
				
			for (int i = 0; i < listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = null;
				if(i<listaAN.size()) {
					dtoPAB = listaAN.get(i);
				}
				
				
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					c.setCellStyle(styleBordesCompletosCelda);
					switch (j) {
					case 0:
						c.setCellStyle(null);
						break;
					case 1:
						c.setCellStyle(null);
						break;
					case 2:
					
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
						
						break;
					case 4:
							c.setCellStyle(styleBordesCompletosCeldaEuro);
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo())) {
								c.setCellValue(dtoPAB.getImporteParticipacionActivo());
							} else {
								c.setCellValue("0 €");
							}
						
						break;
					case 6:
						
							if (!Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								c.setCellValue(dtoPAB.getSuperficieConstruida().toString() + " m2");
								
							} else {
								c.setCellValue("0 m2");
							}
						
						break;
					case 8:
						c.setCellStyle(styleBordesCompletosCeldaEuro);
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo()) && !Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								Double importepormetro = (dtoPAB.getImporteParticipacionActivo()) / (dtoPAB.getSuperficieConstruida());
								c.setCellValue(importepormetro);
							} else {
								c.setCellValue("0€");
							}
						
						break;
					default:
						break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
				mySheet.addMergedRegion(cellRangeAddress);
				currentRow++;
			}
			
			cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
			mySheet.addMergedRegion(cellRangeAddress);
		
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {

					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
					default:
						break;
				}
			}
			currentRow++;
			

			
			mySheet.createRow(currentRow); //creamos la fila de:Proposal
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Proposal");
						c.setCellStyle(styleBordesCompletos);
					break;
					case 2:
						c.setCellValue("It is recommended to accept the offer");
						c.setCellStyle(styleBordesCompletosNoAlin);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			iniciobucle = currentRow;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 1:
					c.setCellValue("Details / Terms of contracts / Current rent arrears\n");
					c.setCellStyle(styleBordesCompletos);
					break;
				case 9:
					c.setCellStyle(styleBordesSoloDerecha);
				break;
				default:
					break;
				}
			}
			currentRow++;
						
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosNegritaBlanco);
				switch (j) {
				case 0:
					c.setCellStyle(null);
					break;
				case 1:
					c.setCellStyle(null);
					break;
				case 2:
					c.setCellValue("Asset ID");
					break;
				case 4:
					c.setCellValue("Gross offer");
					break;
				case 6:
					c.setCellValue("Offer Costs");
					break;
				case 8:
					c.setCellValue("Net for Promontoria Manzana SA");
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			Double importeParticipacionSumatorio = (double) 0;
			for (int i = 0; i <= listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = null;
				if(i<listaAN.size()) {
					dtoPAB = listaAN.get(i);
				}

				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					c.setCellStyle(styleBordesCompletosCelda);
					if(i==listaAN.size()) {
						total=true;
					}else {
						total = false;
					}
					switch (j) {
					case 0:
						c.setCellStyle(null);
						break;
					case 1:
						c.setCellStyle(null);
						break;
					case 2:	
						if(total) {
							c.setCellValue("Total");
							c.setCellStyle(styleBordesCompletosNegritaBlanco);
						}else {
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
						}
						break;
					case 4:
						c.setCellStyle(styleBordesCompletosCeldaEuro);
						if(total) {
							c.setCellValue(importeParticipacionSumatorio);
						}else {
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo())) {
								importeParticipacionSumatorio = importeParticipacionSumatorio + dtoPAB.getImporteParticipacionActivo();
								c.setCellValue(importeParticipacionSumatorio);
							} else {
								c.setCellValue("");
							}
						}
						break;
					
					default:
						break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
				mySheet.addMergedRegion(cellRangeAddress);
				currentRow++;
				
			}
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {

					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
					default:
						break;
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow); //Financing needs
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Financing needs (Yes/No):");
					break;
					case 4:
						c.setCellValue("                 ");
						c.setCellStyle(fontSubSinNegritaE);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {

					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
					default:
						break;
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow); //Estimated time to closing
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Estimated time to closing:");
					break;
					case 4:
						c.setCellValue("                 ");
						c.setCellStyle(fontSubSinNegritaE);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
				default:
					break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);

			currentRow++;
			
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesSoloAbajo);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellStyle(null);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
				default:
					break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
			mySheet.addMergedRegion(cellRangeAddress);
			
			iniciobucle = currentRow;
			
			currentRow++;
			
			iniciobucle = currentRow;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:
						c.setCellValue("Costs (net +VAT+ eventual additional costs)\n");
						c.setCellStyle(styleBordesCompletos);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
				
			
			currentRow++;
			mySheet.createRow(currentRow); //Tax (Plusvalia)*
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Tax (Plusvalia)*  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //Backlog expenses (please detail type)
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Backlog expenses (please detail type)  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //Broker fee 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Broker fee  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //Notary
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Notary  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //∑(MD)
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 5:				
						c.setCellValue("∑(MD)");
						c.setCellStyle(sinEstilo);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			currentRow++;
			mySheet.createRow(currentRow); //*Estimated amounts until final liquidation based on the type of asset
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("*Estimated amounts until final liquidation based on the type of asset");
						c.setCellStyle(styleCursiva);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {

					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
					default:
						break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
			mySheet.addMergedRegion(cellRangeAddress);
			
			
			currentRow++;
			
			iniciobucle = currentRow;
			
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletos);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellValue("Business Plan Metrics");
						break;
					case 2:
						c.setCellStyle(styleBordesCompletosNegritaBlanco);
					break;
					case 4:				
						c.setCellValue("UW");	
					break;
					case 6:				
						c.setCellValue("Rev - BP");
					break;
					case 8:				
						c.setCellValue("DELTA");
					break;
					
					default:
						break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
					break;
					case 2:				
						c.setCellValue("Gross Collections");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
					break;
					case 2:				
						c.setCellValue("Multiple");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
					break;
					case 2:				
						c.setCellValue("IRR");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
					break;
					case 2:				
						c.setCellValue("WAL");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
			mySheet.addMergedRegion(cellRangeAddress);
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			String prostexto ="";
			prostexto = "(Manualy Modified over given text)\r\n We recommend approving the offer considering:\r\n(1) is concurs with / higher than asking price\r\n";
			prostexto = prostexto +"(2) market fundamentals (eg. supply, demand, are of high/low commercial activity etc.)\r\n";
			prostexto = prostexto + "(3) condition of the asset\r\n";
			prostexto = prostexto + "(4) Sales comparisons support offer (if comparsions / average price per sq m in area are higher than recommended offer please explain";
			prostexto = prostexto + "- ie subject asset has; inferior location/condtion/configuration/aspect etc)\r\n";
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				r.setHeightInPoints((10 * mySheet.getDefaultRowHeightInPoints()));
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Pro's");
						c.setCellStyle(styleBordesCompletos);
					break;
					case 2:				
						c.setCellValue(prostexto);
						c.setCellStyle(styleAzul);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((2 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Recommendation");
						c.setCellStyle(styleBordesCompletos);
					break;
					case 2:				
						c.setCellValue("Haya Real Estate department recommends approval as outlined ");
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 9:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletos);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Authorisation");		
					break;
					case 2:				
						c.setCellValue("Name");
					break;
					case 6:				
						c.setCellValue("Signature");
					break;
					case 8:				
						c.setCellValue("Date");
					break;
					default:
					break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
		
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((3 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Advisor recommendation \n(CES)");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((3 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Asset Manager \n(Haya RE)");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((3 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Owner: \nPROMONTORIA MANZANA");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((4 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Comments,\nadditional requirements");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < 10; j++) {
				r.createCell(j);
				c = r.getCell(j);

				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("This advisory note is subject to KYC clearance through the Cerberus US office via the CES KYC team in London");
						c.setCellStyle(styleCursivaDerecha);
					break;
					case 9:				
						c.setCellStyle(styleCursivaDerecha);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 1,9);
			mySheet.addMergedRegion(cellRangeAddress);
			for(int i = 0;i<=3;i++) {
				currentRow++;
				mySheet.createRow(currentRow); 
				r = mySheet.getRow(currentRow);
				
				for (int j = 0; j < 10; j++) {
					r.createCell(j);
					c = r.getCell(j);
					c.setCellValue(" ");
				}
			}
			
			myWorkBook.write(fileOutStream);
			
			return fileOut;
			
		} catch (IOException e) {
			logger.error(e.getMessage());
		}finally {
			if(fileOutStream != null) {
				fileOutStream.close();
			}
			
		}
		
		
		return null;
	}

	private String traducirDiccionarioTipoActivo(String tipoActivo) {
		if(!Checks.esNulo(tipoActivo) || !"".equals(tipoActivo)) {
			if ("suelo".equalsIgnoreCase(tipoActivo)) {
				return "Ground";
			} else if ("vivienda".equalsIgnoreCase(tipoActivo)) {
				return "Apartment";
			} else if ("comercial y terciario".equalsIgnoreCase(tipoActivo)) {
				return "Commercial and tertiary";
			} else if ("industrial".equalsIgnoreCase(tipoActivo)) {
				return "Industrial";
			} else if ("edificio completo".equalsIgnoreCase(tipoActivo)) {
				return "Complete building";
			} else if ("en construcción".equalsIgnoreCase(tipoActivo)) {
				return "In construction";
			} else if ("otros".equalsIgnoreCase(tipoActivo)) {
				return "Others";
			} else {
				return tipoActivo;
			}
		}
		return null;
	}
	private String traducirDiccionarioCondicion(String condicion) {
		if(!Checks.esNulo(condicion) || !"".equals(condicion)) {
			if ("bueno".equalsIgnoreCase(condicion)) {
				return "Good";
			} else if ("malo".equalsIgnoreCase(condicion)) {
				return "Bad";
			} else if ("muy bueno".equalsIgnoreCase(condicion)) {
				return "Very good";
			} else if ("muy malo".equalsIgnoreCase(condicion)) {
				return "Very bad";
			} else {
				return condicion;
			}
		}
		return null;
	}
	
	
	@Override
	public File getAdvisoryNoteReportArrow(List<VReportAdvisoryNotes> listaAN, HttpServletRequest request) throws IOException {
		
		ServletContext sc = request.getSession().getServletContext();		
		FileOutputStream fileOutStream = null;
		
		try {
			File poiFile = new File(sc.getRealPath("plantillas/plugin/AdvisoryNoteArrow/AdvisoryNoteReport.xlsx"));
			
			File fileOut = new File(poiFile.getAbsolutePath().replace("Report",""));
			FileInputStream fis = new FileInputStream(poiFile);
			fileOutStream = new FileOutputStream(fileOut);
			XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);
		
			XSSFSheet mySheet;
			CellReference cellReference;
			XSSFRow r;
			XSSFCell c;
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat anyo = new SimpleDateFormat("yyyy");
			DecimalFormat df = new DecimalFormat("#.##");
			String descripcionDelActivo= "- ";
			int inicioBucleInterno = 0;
			String textoAmarillo = "Asset Listed in the market since 26/07/2019  on the following channels:\r\n";
			textoAmarillo = textoAmarillo + "1. Websites (Number) : Haya, Idealista, Fotocasa, etc.\r\n";
			textoAmarillo = textoAmarillo + "2. Offline media: Radio, TV, etc. \r\n";
			textoAmarillo = textoAmarillo + "3. In-place MKT: Flyers, Banners,etc. \r\n";
			textoAmarillo = textoAmarillo + "4. Open Day: Description.\r\n";
			textoAmarillo = textoAmarillo + "Explanation of number of leads and offers and oppinion on effectiveness of the MKT actions. ";
		
			
			XSSFFont font = myWorkBook.createFont();
		    font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		    
		    XSSFFont fontCursivaP= myWorkBook.createFont();
		    fontCursivaP.setItalic(true);
		    fontCursivaP.setFontHeightInPoints((short) 8);
		   
		    XSSFFont fuentePequenyaAzul= myWorkBook.createFont();
		    fuentePequenyaAzul.setFontHeightInPoints((short) 10);
		    fuentePequenyaAzul.setColor(new XSSFColor(new java.awt.Color(102, 190, 237))); 
		    
		    XSSFFont fuenteAzul= myWorkBook.createFont();
		    fuenteAzul.setColor(new XSSFColor(new java.awt.Color(102, 190, 237))); 
		    
		    XSSFFont fontSubr = myWorkBook.createFont();
		    fontSubr.setBoldweight(Font.BOLDWEIGHT_BOLD);
		    fontSubr.setUnderline(HSSFFont.U_SINGLE);
		    
		    XSSFFont fontSubSinNegrita = myWorkBook.createFont();	  
		    fontSubSinNegrita.setUnderline(HSSFFont.U_SINGLE);
			
			XSSFCellStyle style= myWorkBook.createCellStyle();
			style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setBorderTop(XSSFCellStyle.BORDER_THIN);
			style.setBorderRight(XSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(true);
			
			DataFormat df2 = myWorkBook.createDataFormat();
			
			//CELDA COMPLETA CELDAS
			XSSFCellStyle styleBordesCompletosCeldaEuro= myWorkBook.createCellStyle();
			styleBordesCompletosCeldaEuro.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaEuro.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaEuro.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaEuro.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaEuro.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCeldaEuro.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCeldaEuro.setWrapText(true);
			
			styleBordesCompletosCeldaEuro.setDataFormat(df2.getFormat("#0.00,€#"));
			
			//ESTILOS
			//LETRA AZUL PEQUEÑA
			XSSFCellStyle styleAzulPeque= myWorkBook.createCellStyle();
			styleAzulPeque.setFont(fuentePequenyaAzul);
			
			//LETRA AZUL NORMAL
			XSSFCellStyle styleAzul= myWorkBook.createCellStyle();
			styleAzul.setFont(fuenteAzul);
			
			//CURSIVA PEQUEÑA
			XSSFCellStyle styleCursiva= myWorkBook.createCellStyle();
			styleCursiva.setFont(fontCursivaP);
			
			//CURSIVA PEQUEÑA DERECHA
			XSSFCellStyle styleCursivaDerecha= myWorkBook.createCellStyle();
			styleCursivaDerecha.setFont(fontCursivaP);
			styleCursivaDerecha.setAlignment(XSSFCellStyle.ALIGN_RIGHT);
			
			//SUBSINNEGRITA
			XSSFCellStyle fontSubSinNegritaE= myWorkBook.createCellStyle();
			fontSubSinNegritaE.setFont(fontSubSinNegrita);
				
			//SUBNEGRITA
			XSSFCellStyle subNegrita= myWorkBook.createCellStyle();
			subNegrita.setFont(fontSubr);
			
			//SOLO NEGRITA
			XSSFCellStyle negrita= myWorkBook.createCellStyle();
			negrita.setFont(font);
			
			//SIN ESTILO
			XSSFCellStyle sinEstilo= myWorkBook.createCellStyle();
			sinEstilo.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			sinEstilo.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			//ALINEADO DERECHA
			XSSFCellStyle alineadoDerecha= myWorkBook.createCellStyle();
			alineadoDerecha.setAlignment(XSSFCellStyle.ALIGN_RIGHT);
			alineadoDerecha.setFont(font);
			
			//CELDA COMPLETA
			XSSFCellStyle styleBordesCompletos= myWorkBook.createCellStyle();
			styleBordesCompletos.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletos.setVerticalAlignment(XSSFCellStyle.VERTICAL_TOP);
			styleBordesCompletos.setWrapText(true);
			styleBordesCompletos.setFont(font);
			styleBordesCompletos.setFillForegroundColor(new XSSFColor(new java.awt.Color(211, 211, 211)));
			styleBordesCompletos.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
			//CELDA COMPLETA
			XSSFCellStyle styleBordesCompletosNoAlin= myWorkBook.createCellStyle();
			styleBordesCompletosNoAlin.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNoAlin.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNoAlin.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNoAlin.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setAlignment(XSSFCellStyle.ALIGN_JUSTIFY);
			styleBordesCompletosNoAlin.setWrapText(true);
			
			//CELDA COMPLETA
			XSSFCellStyle styleBordesCompletosNegritaBlanco= myWorkBook.createCellStyle();
			styleBordesCompletosNegritaBlanco.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNegritaBlanco.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNegritaBlanco.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNegritaBlanco.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosNegritaBlanco.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosNegritaBlanco.setWrapText(true);
			styleBordesCompletosNegritaBlanco.setFont(font);
			
			
			//CELDA COMPLETA CELDAS
			XSSFCellStyle styleBordesCompletosCelda= myWorkBook.createCellStyle();
			styleBordesCompletosCelda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCelda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCelda.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCelda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCelda.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCelda.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCelda.setWrapText(true);
			
			//CELDA COMPLETA CELDAS ALINEADAS IZQUIERDA ALINEAR
			XSSFCellStyle styleBordesCompletosCeldaAlineadasIzquierda= myWorkBook.createCellStyle();
			styleBordesCompletosCeldaAlineadasIzquierda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaAlineadasIzquierda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaAlineadasIzquierda.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaAlineadasIzquierda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaAlineadasIzquierda.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCeldaAlineadasIzquierda.setAlignment(XSSFCellStyle.ALIGN_LEFT);
			styleBordesCompletosCeldaAlineadasIzquierda.setWrapText(true);
			
			//CELDA COMPLETA CELDAS
			XSSFCellStyle styleBordesCompletosCeldaTamanyoCelda= myWorkBook.createCellStyle();
			styleBordesCompletosCeldaTamanyoCelda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaTamanyoCelda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaTamanyoCelda.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaTamanyoCelda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletosCeldaTamanyoCelda.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesCompletosCeldaTamanyoCelda.setWrapText(true);
				
			//BORDES ARRIBA Y ABAJO
			XSSFCellStyle styleBordesArribaYAbajo= myWorkBook.createCellStyle();
			styleBordesArribaYAbajo.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaYAbajo.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaYAbajo.setBorderRight(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaYAbajo.setBorderLeft(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaYAbajo.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaYAbajo.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaYAbajo.setWrapText(true);
			
			//BORDES ARRIBA Y ABAJO DERECHA
			XSSFCellStyle styleBordesArribaAbajoDerecha= myWorkBook.createCellStyle();
			styleBordesArribaAbajoDerecha.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoDerecha.setBorderLeft(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaAbajoDerecha.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaAbajoDerecha.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaAbajoDerecha.setWrapText(true);
			
			//BORDES ARRIBA Y ABAJO IZQUIERDA
			XSSFCellStyle styleBordesArribaAbajoIzquierda= myWorkBook.createCellStyle();
			styleBordesArribaAbajoIzquierda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setBorderRight(XSSFCellStyle.BORDER_NONE);
			styleBordesArribaAbajoIzquierda.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			styleBordesArribaAbajoIzquierda.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaAbajoIzquierda.setVerticalAlignment(XSSFCellStyle.ALIGN_CENTER);
			styleBordesArribaAbajoIzquierda.setWrapText(true);
			
			//BORDES SOLO DERECHA
			XSSFCellStyle styleBordesSoloDerecha= myWorkBook.createCellStyle();		
			styleBordesSoloDerecha.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesSoloDerecha.setWrapText(true);
			
			//BORDES SOLO ABAJO
			XSSFCellStyle styleBordesSoloAbajo= myWorkBook.createCellStyle();		
			styleBordesSoloAbajo.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesSoloAbajo.setWrapText(true);
			
			//BORDES ABAJO DERECHA
			styleBordesArribaAbajoIzquierda.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesSoloDerecha.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesSoloDerecha.setWrapText(true);
			
			//NEGRITA Y FONDO GRIS
			XSSFCellStyle styleNegritaFondoGris= myWorkBook.createCellStyle();
			styleNegritaFondoGris.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setFont(font);
			
			
			myWorkBook.setSheetName(0, "AN S0XXX-" + anyo.format(new Date()));
			mySheet = myWorkBook.getSheetAt(0);		// <----- NÚMERO DE LA PÁGINA

			cellReference = new CellReference("B3");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			c.setCellValue("Industrial REO Sale Advisory Note (AN)");
			c.setCellStyle(negrita);
			
			// creamos la fila de: Entity
			int currentRow = 8;
			int iniciobucle = currentRow;
			for (int i = 0; i < listaAN.size(); i++) {
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
					mySheet.createRow(currentRow);
					r = mySheet.getRow(currentRow);
					r.setHeightInPoints((2 * mySheet.getDefaultRowHeightInPoints()));
					for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
						r.createCell(j);
						c = r.getCell(j);
						if(j==1) {
							c.setCellValue("PROMONTORIA \n ARROW");
							c.setCellStyle(styleBordesCompletos);
						}else
						if(j==2) {
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
							c.setCellStyle(styleBordesCompletosCelda);
						}else if(j==4) {
							if (!Checks.esNulo(dtoPAB.getIdSantander())) {
								c.setCellValue(dtoPAB.getIdSantander());
							} else {
								c.setCellValue("");
							}
							c.setCellStyle(styleBordesCompletosCelda);
						}else if(j==6){
							if (!Checks.esNulo(dtoPAB.getDireccion())) {
								c.setCellValue(dtoPAB.getDireccion());
							} else {
								c.setCellValue("");
							}	
							c.setCellStyle(styleBordesCompletosCelda);
						}else if(j==10) {
							c.setCellStyle(styleBordesArribaAbajoDerecha);
						}
					}
					CellRangeAddress cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
					mySheet.addMergedRegion(cellRangeAddress);
					cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
					mySheet.addMergedRegion(cellRangeAddress);
					cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,10);
					mySheet.addMergedRegion(cellRangeAddress);
					cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
					mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
			}
			
			//creamos la fila de:Connection Status
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==1) {
					c.setCellValue("Connection Status");
					c.setCellStyle(styleBordesCompletos);
				}else if(j==2) {
					c.setCellValue("REO");
					c.setCellStyle(styleBordesCompletosCeldaAlineadasIzquierda);
				}else if(j==10) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			CellRangeAddress cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			//creamos la fila de:Property Details
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			r.setHeight((short)-1);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				r.setHeightInPoints(((listaAN.size()+1) * mySheet.getDefaultRowHeightInPoints()));
				c = r.getCell(j);
				if(j==1) {
					c.setCellValue("Property Details");
					c.setCellStyle(styleBordesCompletos);
				}else if(j==2) {
					//bucle por activo
					String descripcionLocalidadActivo = "";
					for (int i = 0; i < listaAN.size(); i++) {
						VReportAdvisoryNotes dtoPAB = listaAN.get(i);
												
						if (!Checks.esNulo(dtoPAB.getNumActivo())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + "\r\n"+dtoPAB.getNumActivo().toString() + " ";
						}
						if (!Checks.esNulo(dtoPAB.getSubtipoActivo())) {							
							descripcionLocalidadActivo = descripcionLocalidadActivo + traducirDiccionarioTipoActivo(dtoPAB.getSubtipoActivo());
						}
						if(!Checks.esNulo(dtoPAB.getMunicipio())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + " located in " + dtoPAB.getMunicipio();
						}
						if(!Checks.esNulo(dtoPAB.getProvincia())) {
							descripcionLocalidadActivo = descripcionLocalidadActivo + "(" + dtoPAB.getProvincia() + ")";
						}
					}
					c.setCellValue(descripcionLocalidadActivo);
					c.setCellStyle(styleBordesCompletosCeldaAlineadasIzquierda);

				}else if(j==10) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			iniciobucle = currentRow;
			
			//creamos la fila de:Background information
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==1) {
					c.setCellValue("Background information");
					c.setCellStyle(styleBordesCompletos);
				}
				if(j==10) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==10) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				r.setHeightInPoints((2 * mySheet.getDefaultRowHeightInPoints()));
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosNegritaBlanco);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
						break;
					case 2:
						c.setCellValue("Asset ID");
						break;
					case 4:
						c.setCellValue("Type of asset");
						break;
					case 6:
						c.setCellValue("Surface area (sqm)");
						break;
					case 7:
						c.setCellValue("Asking Price");
						break;
					case 8:
						c.setCellValue("Eur psqm");
						break;
					case 9:
						c.setCellValue("Rental income € (monthly)");
						break;
					default:
						break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 9,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			Long aumulacionSuperficie = 0L;
			Double acumulacionAskingPrice = (double) 0;
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
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					c.setCellStyle(styleBordesCompletosCelda);
					switch (j) {
						case 0:
							c.setCellStyle(null);
						break;
						case 1:
							c.setCellStyle(null);
						break;
						case 2:
							if (total) {
								c.setCellValue("Total");
								c.setCellStyle(styleBordesCompletosNegritaBlanco);
							} else {
								if (!Checks.esNulo(dtoPAB.getNumActivo())) {
									c.setCellValue(dtoPAB.getNumActivo().toString());
								} else {
									c.setCellValue("");
								}
							}
							break;
						case 4:
							if (total) {
								c.setCellValue("");
							} else {
								if (!Checks.esNulo(dtoPAB.getSubtipoActivo())) {
									c.setCellValue(traducirDiccionarioTipoActivo(dtoPAB.getSubtipoActivo()));
								} else {
									c.setCellValue("");
								}
							}
							break;
						case 6:
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
						case 7:
							c.setCellStyle(styleBordesCompletosCeldaEuro);
							if (total) {
								c.setCellValue(acumulacionAskingPrice);		
							} else {
								if (!Checks.esNulo(dtoPAB.getImporte())) {
									acumulacionAskingPrice = acumulacionAskingPrice + dtoPAB.getImporte();
									c.setCellValue(dtoPAB.getImporte());
								} else {
									c.setCellValue("0€");
								}
							}
							break;
						case 8:
							c.setCellValue("0 €");
							break;
						case 9:
							c.setCellValue("0 €");
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 9,10);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
			}
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				if(j==10) {
					c.setCellStyle(styleBordesArribaAbajoDerecha);
				}
			}
			
			// creamos fila Marketing
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);

			for (int i = 0; i < listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = listaAN.get(i);
				
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Marketing Overview");
							c.setCellStyle(subNegrita);
							break;
						case 4:
							c.setCellValue(dtoPAB.getNumActivo());
							c.setCellStyle(sinEstilo);
							break;
						case 6:
							c.setCellValue("Marketing comments:");
							c.setCellStyle(subNegrita);
							break;
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,8);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				
				inicioBucleInterno = currentRow;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Web Publishing:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getPublicado())) {
								c.setCellValue(dtoPAB.getPublicado());
							} else {
								c.setCellValue("");
							}
							break;
						case 6:
							c.setCellValue(textoAmarillo);
							c.setCellStyle(styleAzulPeque);
							break;
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,10);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
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
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,10);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
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
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,10);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
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
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,10);
				mySheet.addMergedRegion(cellRangeAddress);

				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,10);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,10);
				mySheet.addMergedRegion(cellRangeAddress);
			
				cellRangeAddress = new CellRangeAddress(inicioBucleInterno, currentRow, 6,10);	
				mySheet.addMergedRegion(cellRangeAddress); 
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Asset Overview:");
							c.setCellStyle(subNegrita);
							break;
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}

				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Construction date:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getAnyoConstruccion())) {
								c.setCellValue(dtoPAB.getAnyoConstruccion());
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
							}
							break;
						case 6:
							c.setCellValue("Occupancy status:");
							break;
						case 8:
							if (!Checks.esNulo(dtoPAB.getOcupado())) {
								c.setCellValue(dtoPAB.getOcupado());
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);	
							}
							break;
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
				mySheet.addMergedRegion(cellRangeAddress);
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
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
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				r.setHeightInPoints((6 * mySheet.getDefaultRowHeightInPoints()));
				descripcionDelActivo = "\r\n\n" +descripcionDelActivo;
				if (!Checks.esNulo(dtoPAB.getSubtipoActivo())) {
					descripcionDelActivo = descripcionDelActivo + traducirDiccionarioTipoActivo(dtoPAB.getSubtipoActivo());
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
					descripcionDelActivo = descripcionDelActivo + "- Considered to be in " + traducirDiccionarioCondicion(dtoPAB.getEstadoConservacion()) + " condition \r\n"; // DESCRIPCION linea3
				}
				if (!Checks.esNulo(dtoPAB.getEstadoAqluiler())) {
					descripcionDelActivo = descripcionDelActivo + "- Details if " + dtoPAB.getEstadoAqluiler() + " condition."; // DESCRIPCION linea 4
					if (!Checks.esNulo(dtoPAB.getTipoAlquiler())) {
						descripcionDelActivo = descripcionDelActivo + " If tenanted include details of lease " + traducirDiccionarioTipoActivo(dtoPAB.getSubtipoActivo());
					}
				}

				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue(descripcionDelActivo);
							c.setCellStyle(styleBordesCompletosNoAlin);
							break;
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				descripcionDelActivo = "-";
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,10);
				mySheet.addMergedRegion(cellRangeAddress);
				
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Mode of transmission:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getSegundaMano())) {
								c.setCellValue(dtoPAB.getSegundaMano());
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
							}
							break;
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 2:
							c.setCellValue("Asset maintenance status:");
							break;
						case 4:
							if (!Checks.esNulo(dtoPAB.getEstadoConservacion())) {
								c.setCellValue(traducirDiccionarioCondicion(dtoPAB.getEstadoConservacion()));
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
							}
							break;
						case 6:
							c.setCellValue("Average € per sqm in the area:");
							break;
						case 8:
							if (!Checks.esNulo(dtoPAB.getImporte()) && !Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								Double precioMetro = dtoPAB.getImporte() / dtoPAB.getSuperficieConstruida();
								c.setCellValue((df.format(precioMetro)).toString() + " €");
								c.setCellStyle(fontSubSinNegritaE);
							} else {
								c.setCellValue("");
								c.setCellStyle(fontSubSinNegritaE);
							}
							break;
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
				mySheet.addMergedRegion(cellRangeAddress);
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
				currentRow++;
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					switch (j) {
						case 10:
							c.setCellStyle(styleBordesSoloDerecha);
							break;
						default:
							break;
					}
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 2:
					c.setCellValue("Proposal Background");
					c.setCellStyle(subNegrita);
					break;
				case 10:
					c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
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
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 2:
					c.setCellValue("One offer has been negotiated to acquire "+ numerosActivoConcatenados +"  asset as follows:");
					break;
				case 10:
					c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosNegritaBlanco);
				switch (j) {
				case 0:
					c.setCellStyle(null);
					break;
				case 1:
					c.setCellStyle(null);
					break;
				case 2:
					c.setCellValue("UV ID");
					break;
				case 4:
					c.setCellValue("Gross offer");
					break;
				case 6:
					c.setCellValue("Surface area \n (sqm)");
					break;
				case 8:
					c.setCellValue("Price PSM");
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			for (int i = 0; i < listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = null;
				if(i<listaAN.size()) {
					dtoPAB = listaAN.get(i);
				}
				
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					c.setCellStyle(styleBordesCompletosCelda);
					switch (j) {
					case 0:
						c.setCellStyle(null);
						break;
					case 1:
						c.setCellStyle(null);
						break;
					case 2:
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
						
						break;
					case 4:
							c.setCellStyle(styleBordesCompletosCeldaEuro);
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo())) {
								c.setCellValue(dtoPAB.getImporteParticipacionActivo());
							} else {
								c.setCellValue("0 €");
							}
						
						break;
					case 6:
							if (!Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								c.setCellValue(dtoPAB.getSuperficieConstruida().toString() + " m2");	
							} else {
								c.setCellValue("0 m2");
							}
						
						break;
					case 8:
						c.setCellStyle(styleBordesCompletosCeldaEuro);
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo()) && !Checks.esNulo(dtoPAB.getSuperficieConstruida())) {
								Double importepormetro = (dtoPAB.getImporteParticipacionActivo()) / (dtoPAB.getSuperficieConstruida());
								c.setCellValue(importepormetro);
							} else {
								c.setCellValue("0€");
							}
				
						break;
					default:
						break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
				mySheet.addMergedRegion(cellRangeAddress);
				currentRow++;
			}
			
			cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
			mySheet.addMergedRegion(cellRangeAddress);
		
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
					default:
						break;
				}
			}
			currentRow++;
			
			
			//creamos la fila de:Proposal
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Proposal");
						c.setCellStyle(styleBordesCompletos);
					break;
					case 2:
						c.setCellValue("It is recommended to accept the offer");
						c.setCellStyle(styleBordesCompletosNoAlin);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			
			//creamos la fila de: Details
			iniciobucle = currentRow;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
				case 1:
					c.setCellValue("Details / Terms of contracts / Current rent arrears\n");
					c.setCellStyle(styleBordesCompletos);
					break;
				case 10:
					c.setCellStyle(styleBordesSoloDerecha);
				break;
				default:
					break;
				}
			}
			currentRow++;
			// posible cambio  ******************
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosNegritaBlanco);
				switch (j) {
				case 0:
					c.setCellStyle(null);
					break;
				case 1:
					c.setCellStyle(null);
					break;
				case 2:
					c.setCellValue("Asset ID");
					break;
				case 4:
					c.setCellValue("Gross offer");
					break;
				case 6:
					c.setCellValue("Offer Costs");
					break;
				case 8:
					c.setCellValue("Net for Divarian Propiedad SA");
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			Double importeParticipacionSumatorio = (double) 0;
			for (int i = 0; i <= listaAN.size(); i++) {
				mySheet.createRow(currentRow);
				r = mySheet.getRow(currentRow);
				VReportAdvisoryNotes dtoPAB = null;
				if(i<listaAN.size()) {
					dtoPAB = listaAN.get(i);
				}

				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					c.setCellStyle(styleBordesCompletosCelda);
					if(i==listaAN.size()) {
						total=true;
					}else {
						total = false;
					}
					switch (j) {
					case 0:
						c.setCellStyle(null);
						break;
					case 1:
						c.setCellStyle(null);
						break;
					case 2:	
						if(total) {
							c.setCellValue("Total");
							c.setCellStyle(styleBordesCompletosNegritaBlanco);
						}else {
							if (!Checks.esNulo(dtoPAB.getNumActivo())) {
								c.setCellValue(dtoPAB.getNumActivo().toString());
							} else {
								c.setCellValue("");
							}
						}
						break;
					case 4:
						c.setCellStyle(styleBordesCompletosCeldaEuro);
						if(total) {
							c.setCellValue(importeParticipacionSumatorio);
						}else {
							if (!Checks.esNulo(dtoPAB.getImporteParticipacionActivo())) {
								importeParticipacionSumatorio = importeParticipacionSumatorio + dtoPAB.getImporteParticipacionActivo();
								c.setCellValue(importeParticipacionSumatorio);
							} else {
								c.setCellValue("");
							}
						}
						break;
					
					default:
						break;
					}
				}
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
				mySheet.addMergedRegion(cellRangeAddress);
				cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
				mySheet.addMergedRegion(cellRangeAddress);
				currentRow++;
				
			}
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
					default:
						break;
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow); //Financing needs
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Financing needs (Yes/No):");
					break;
					case 4:
						c.setCellValue("                 ");
						c.setCellStyle(fontSubSinNegritaE);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
					default:
						break;
				}
			}
			
			currentRow++;
			
			mySheet.createRow(currentRow); //Estimated time to closing
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Estimated time to closing:");
					break;
					case 4:
						c.setCellValue("                 ");
						c.setCellStyle(fontSubSinNegritaE);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
				default:
					break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);

			currentRow++;
			
			
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesSoloAbajo);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellStyle(null);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
				default:
					break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,10);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
			mySheet.addMergedRegion(cellRangeAddress);
			
			iniciobucle = currentRow;
			
			currentRow++;
			
			
			//creamos la fila de: Cost
			iniciobucle = currentRow;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:
						c.setCellValue("Costs (net +VAT+ eventual additional costs)\n");
						c.setCellStyle(styleBordesCompletos);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			
			currentRow++;
			mySheet.createRow(currentRow); //Legal cost (Plusvalia)*
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Legal cost (Plusvalia)*  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //Backlog expenses (please detail type)
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Backlog expenses (please detail type)  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //Broker fee 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Broker fee  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //Notary
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Notary  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //Arrow's Fees
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("Arrow's Fees  ");
						c.setCellStyle(alineadoDerecha);
					break;
					case 5:				
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 6:
						c.setCellStyle(styleBordesArribaAbajoDerecha);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,4);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 5,6);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); //*Estimated amounts until final liquidation based on the type of asset
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 2:				
						c.setCellValue("*Estimated amounts until final liquidation based on the type of asset");
						c.setCellStyle(styleCursiva);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
				default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow);
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
						break;
					default:
						break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			
			
			//creamos la fila de: Business Plan Metrics
			iniciobucle = currentRow;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletos);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellValue("Business Plan Metrics");
						break;
					case 2:
						c.setCellStyle(styleBordesCompletosNegritaBlanco);
					break;
					case 4:				
						c.setCellValue("PP (ON -  Board)");	
					break;
					case 6:				
						c.setCellValue("UW");
					break;
					case 8:				
						c.setCellValue("REV - BP");
					break;
					
					default:
						break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			currentRow++;
			
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
					break;
					case 2:				
						c.setCellValue("Gross Collections");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
					break;
					case 2:				
						c.setCellValue("Multiple");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
					break;
					case 2:				
						c.setCellValue("IRR");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:
						c.setCellStyle(null);
					break;
					case 1:
						c.setCellStyle(null);
					break;
					case 2:				
						c.setCellValue("WAL");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,3);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 4,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			cellRangeAddress = new CellRangeAddress(iniciobucle, currentRow, 1,1);
			mySheet.addMergedRegion(cellRangeAddress);
			currentRow++;
			
			
			//creamos la fila de: Pro's
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			String prostexto ="";
//			prostexto = "(Manualy Modified over given text)\r\n We recommend approving the offer considering:\r\n(1) is concurs with / higher than asking price\r\n";
//			prostexto = prostexto +"(2) market fundamentals (eg. supply, demand, are of high/low commercial activity etc.)\r\n";
//			prostexto = prostexto + "(3) condition of the asset\r\n";
//			prostexto = prostexto + "(4) Sales comparisons support offer (if comparsions / average price per sq m in area are higher than recommended offer please explain";
//			prostexto = prostexto + "- ie subject asset has; inferior location/condtion/configuration/aspect etc)\r\n";
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				r.setHeightInPoints((10 * mySheet.getDefaultRowHeightInPoints()));
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Pro's");
						c.setCellStyle(styleBordesCompletos);
					break;
					case 2:				
						c.setCellValue(prostexto);
						c.setCellStyle(styleAzul);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,9);
			mySheet.addMergedRegion(cellRangeAddress);
			
			
			//creamos la fila de: Recomendation
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((2 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				switch (j) {
					case 1:				
						c.setCellValue("Recommendation");
						c.setCellStyle(styleBordesCompletos);
					break;
					case 2:				
						c.setCellValue("Haya Real Estate department recommends approval as outlined ");
						c.setCellStyle(styleBordesCompletosCelda);
					break;
					case 10:
						c.setCellStyle(styleBordesSoloDerecha);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			
			//creamos la fila de: Authorisation
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletos);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Authorisation");		
					break;
					case 2:				
						c.setCellValue("Name");
					break;
					case 6:				
						c.setCellValue("Signature");
					break;
					case 8:				
						c.setCellValue("Date");
					break;
					default:
					break;
				}
			}
			
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((3 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Advisor recommendation");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((3 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Asset Manager");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((3 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Owner: ");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,5);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 6,7);
			mySheet.addMergedRegion(cellRangeAddress);
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 8,10);
			mySheet.addMergedRegion(cellRangeAddress);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			r.setHeightInPoints((4 * mySheet.getDefaultRowHeightInPoints()));
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);
				c.setCellStyle(styleBordesCompletosCelda);
				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("Comments,\nadditional requirements");
						c.setCellStyle(styleBordesCompletos);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 2,10);
			mySheet.addMergedRegion(cellRangeAddress);

			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
			
			currentRow++;
			mySheet.createRow(currentRow); 
			r = mySheet.getRow(currentRow);
		
			for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
				r.createCell(j);
				c = r.getCell(j);

				switch (j) {
					case 0:				
						c.setCellStyle(null);
					break;
					case 1:				
						c.setCellValue("This advisory note is subject to KYC clearance through the Cerberus US office via the CES KYC team in London");
						c.setCellStyle(styleCursivaDerecha);
					break;
					case 9:				
						c.setCellStyle(styleCursivaDerecha);
					break;
					default:
					break;
				}
			}
			cellRangeAddress = new CellRangeAddress(currentRow, currentRow, 1,9);
			mySheet.addMergedRegion(cellRangeAddress);
			for(int i = 0;i<=3;i++) {
				currentRow++;
				mySheet.createRow(currentRow); 
				r = mySheet.getRow(currentRow);
				
				for (int j = 0; j < NUMERO_COLUMNAS_APPLE; j++) {
					r.createCell(j);
					c = r.getCell(j);
					c.setCellValue(" ");
				}
			}
			
			myWorkBook.write(fileOutStream);
			
			return fileOut;
			
		} catch (IOException e) {
			logger.error(e.getMessage());
		}finally {
			if(fileOutStream != null) {
				fileOutStream.close();
			}	
		}	
		
		return null;
	}
	
	private String formatearImportes(Double importe) {
		Locale currentLocale = new Locale ("es","ES");
		NumberFormat numberFormatter = NumberFormat.getNumberInstance(currentLocale);
		numberFormatter.setMaximumFractionDigits(2);
		numberFormatter.setMinimumFractionDigits(2);
		String importeFormateado =  numberFormatter.format(importe);
		return importeFormateado;//.concat("€");
		
	}
	
}
