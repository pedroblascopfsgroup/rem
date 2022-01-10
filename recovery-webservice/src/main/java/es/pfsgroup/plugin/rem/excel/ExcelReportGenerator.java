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
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
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
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Hyperlink;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFHyperlink;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.http.client.HttpSimplePostRequest;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.DtoActivosFichaComercial;
import es.pfsgroup.plugin.rem.model.DtoExcelFichaComercial;
import es.pfsgroup.plugin.rem.model.DtoHcoComercialFichaComercial;
import es.pfsgroup.plugin.rem.model.DtoListFichaAutorizacion;
import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.VReportAdvisoryNotes;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.rest.dto.ReportGeneratorRequest;
import es.pfsgroup.plugin.rem.rest.dto.ReportGeneratorResponse;



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
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private NotificationOfertaManager notificationOferta;
	
	@Autowired
	private GenericABMDao genericDao;
	
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
		if("LISTA_MANTENIMIENTO_CONFIGURACION.xls".equals(report.getReportName())) {
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
				r.setHeight((short) 350);
				for(int i = 0; i <= 5; i++ ) { //5 sin el id
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
	public File generateBbvaReportGetFile(DtoExcelFichaComercial dtoExcelFichaComercial, HttpServletRequest request) throws IOException {
		return this.generateExcelBbvaReport(dtoExcelFichaComercial, request);
	}
	@Override
	public String generateBbvaReportGetName(DtoExcelFichaComercial dtoExcelFichaComercial, HttpServletRequest request) throws IOException {
			File file = this.generateExcelBbvaReport(dtoExcelFichaComercial, request);
			if ( file == null ) {
				return null;
				
			}
			
			return file.getName();
		
	}
	

	private File generateExcelBbvaReport(DtoExcelFichaComercial dtoExcelFichaComercial, HttpServletRequest request) throws IOException {
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
		Map<String, File> dataFileWithName = new HashMap<String, File>();
		dataFileWithName.put(nombreFichero, fileOut);
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
			SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
			XSSFHyperlink link = myWorkBook.getCreationHelper().createHyperlink(Hyperlink.LINK_URL);
			XSSFDataFormat dataFormat = myWorkBook.createDataFormat();
			final DecimalFormat decimalFormat = new DecimalFormat("0.00");
			
			// Estilos celdas
			XSSFFont  font = myWorkBook.createFont();
		    
			//Celda con Bordes
			XSSFCellStyle styleBordesCompletos= myWorkBook.createCellStyle();
			styleBordesCompletos.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderRight(XSSFCellStyle.BORDER_THIN);
			styleBordesCompletos.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			font = myWorkBook.createFont();
			font.setFontHeight(12);
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
			styleFondoAmarillo.setFillForegroundColor(new XSSFColor(new java.awt.Color(255, 255, 204)));
			styleFondoAmarillo.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			styleFondoAmarillo.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			//Celda fondo azul claro
			XSSFCellStyle styleFondoAzul = myWorkBook.createCellStyle();
			font = styleFondoAzul.getFont();
			font.setFontHeightInPoints((short)8);
			styleFondoAzul.setFont(font);
			styleFondoAzul.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleFondoAzul.setBottomBorderColor(new XSSFColor(new java.awt.Color(192, 192, 192)));
			styleFondoAzul.setFillForegroundColor(new XSSFColor(new java.awt.Color(222, 235, 247)));
		    styleFondoAzul.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		    styleFondoAzul.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		    
		    Locale locale = Locale.GERMANY;
			NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
			
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
			
			cellReference = new CellReference("D18");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNroViviendas() != null && dtoExcelFichaComercial.getNroViviendas() > 0) {
			c.setCellValue(dtoExcelFichaComercial.getNroViviendas());
			}
			
			cellReference = new CellReference("E18");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getOfertaViviendas() != null && dtoExcelFichaComercial.getOfertaViviendas() > 0.0) {
				String ofertaViviendas = numberFormat.format(dtoExcelFichaComercial.getOfertaViviendas());
				c.setCellValue(ofertaViviendas);
			}
			
			cellReference = new CellReference("F18");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPvpComiteViviendas() != null && dtoExcelFichaComercial.getPvpComiteViviendas() > 0.0) {
				String pvpComiteViviendas = numberFormat.format(dtoExcelFichaComercial.getPvpComiteViviendas());
				c.setCellValue(pvpComiteViviendas);
			}
			
			cellReference = new CellReference("D19");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNroPisos() != null && dtoExcelFichaComercial.getNroPisos() > 0) {
			c.setCellValue(dtoExcelFichaComercial.getNroPisos());
			}
			
			cellReference = new CellReference("E19");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getOfertaPisos() != null && dtoExcelFichaComercial.getOfertaPisos() > 0.0) {
				String ofertaPisos = numberFormat.format(dtoExcelFichaComercial.getOfertaPisos());
				c.setCellValue(ofertaPisos);
			}
			
			cellReference = new CellReference("F19");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPvpComitePisos() != null && dtoExcelFichaComercial.getPvpComitePisos() > 0.0) {
				String pvpComitePisos = numberFormat.format(dtoExcelFichaComercial.getPvpComitePisos());
				c.setCellValue(pvpComitePisos);
			}
			
			cellReference = new CellReference("D20");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNroOtros() != null && dtoExcelFichaComercial.getNroOtros() > 0) {
			c.setCellValue(dtoExcelFichaComercial.getNroOtros());
			}
			
			cellReference = new CellReference("E20");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getOfertaOtros() != null && dtoExcelFichaComercial.getOfertaOtros() > 0.0) {
				String ofertaOtros = numberFormat.format(dtoExcelFichaComercial.getOfertaOtros());
				c.setCellValue(ofertaOtros);
			}
			
			cellReference = new CellReference("F20");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPvpComiteOtros() != null && dtoExcelFichaComercial.getPvpComiteOtros() > 0.0) {
				String pvpComiteOtros = numberFormat.format(dtoExcelFichaComercial.getPvpComiteOtros());
				c.setCellValue(pvpComiteOtros);
			}
			
			cellReference = new CellReference("D21");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNroGaraje() != null && dtoExcelFichaComercial.getNroGaraje() > 0) {
			c.setCellValue(dtoExcelFichaComercial.getNroGaraje());
			}
			
			cellReference = new CellReference("E21");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getOfertaGaraje() != null && dtoExcelFichaComercial.getOfertaGaraje() > 0.0) {
				String ofertaGaraje = numberFormat.format(dtoExcelFichaComercial.getOfertaGaraje());
				c.setCellValue(ofertaGaraje);
			}
			
			cellReference = new CellReference("F21");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPvpComiteGaraje() != null && dtoExcelFichaComercial.getPvpComiteGaraje() > 0.0) {
				String pvpComiteGaraje = numberFormat.format(dtoExcelFichaComercial.getPvpComiteGaraje());
				c.setCellValue(pvpComiteGaraje);
			}
			
			cellReference = new CellReference("D22");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getNroTotal() != null) {
			c.setCellValue(dtoExcelFichaComercial.getNroTotal());
			}
			
			cellReference = new CellReference("E22");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getOfertaTotal() != null && dtoExcelFichaComercial.getOfertaTotal() > 0.0) {
				String ofertaTotal = numberFormat.format(dtoExcelFichaComercial.getOfertaTotal());
				c.setCellValue(ofertaTotal);
			}
			
			cellReference = new CellReference("F22");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPvpComiteTotal() != null && dtoExcelFichaComercial.getPvpComiteTotal() > 0.0) {
				String pvpComiteTotal = numberFormat.format(dtoExcelFichaComercial.getPvpComiteTotal());
				c.setCellValue(pvpComiteTotal);
			}
			
			cellReference = new CellReference("E31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaActualOferta() != null) {
			c.setCellValue(dateFormat.format(dtoExcelFichaComercial.getFechaActualOferta()));
			}else {
				c.setCellValue("");

			}
			cellReference = new CellReference("F31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaSeisMesesOferta() != null) {
			c.setCellValue(dateFormat.format(dtoExcelFichaComercial.getFechaSeisMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("G31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaDoceMesesOferta() != null) {
			c.setCellValue(dateFormat.format(dtoExcelFichaComercial.getFechaDoceMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("H31");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaDieciochoMesesOferta() != null) {
			c.setCellValue(dateFormat.format(dtoExcelFichaComercial.getFechaDieciochoMesesOferta()));
			}else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("E32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteActual() != null && dtoExcelFichaComercial.getPrecioComiteActual() > 0.0) {
				String precioComiteActual = numberFormat.format(dtoExcelFichaComercial.getPrecioComiteActual());
				c.setCellValue(precioComiteActual);
			}
			
			cellReference = new CellReference("F32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteSeisMesesOferta() != null && dtoExcelFichaComercial.getPrecioComiteSeisMesesOferta() > 0.0) {
				String precioComiteSeisMesesOferta = numberFormat.format(dtoExcelFichaComercial.getPrecioComiteSeisMesesOferta());
				c.setCellValue(precioComiteSeisMesesOferta);
			}
			
			cellReference = new CellReference("G32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteDoceMesesOferta() != null && dtoExcelFichaComercial.getPrecioComiteDoceMesesOferta() > 0.0) {
				String precioComiteDoceMesesOferta = numberFormat.format(dtoExcelFichaComercial.getPrecioComiteDoceMesesOferta());
				c.setCellValue(precioComiteDoceMesesOferta);
			}
			
			cellReference = new CellReference("H32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioComiteDieciochoMesesOferta() != null && dtoExcelFichaComercial.getPrecioComiteDieciochoMesesOferta() > 0.0) {
				String precioComiteDieciochoMesesOferta = numberFormat.format(dtoExcelFichaComercial.getPrecioComiteDieciochoMesesOferta());
				c.setCellValue(precioComiteDieciochoMesesOferta);
			}
			
			cellReference = new CellReference("E33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebActual() != null && dtoExcelFichaComercial.getPrecioWebActual() > 0.0) {
				String precioWebActual = numberFormat.format(dtoExcelFichaComercial.getPrecioWebActual());
				c.setCellValue(precioWebActual);
			}
			
			cellReference = new CellReference("F33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebSeisMesesOferta()!=null && dtoExcelFichaComercial.getPrecioWebSeisMesesOferta() > 0.0) {
				String precioWebSeisMesesOferta = numberFormat.format(dtoExcelFichaComercial.getPrecioWebSeisMesesOferta());
				c.setCellValue(precioWebSeisMesesOferta);
			}
			
			cellReference = new CellReference("G33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebDoceMesesOferta()!=null && dtoExcelFichaComercial.getPrecioWebDoceMesesOferta() > 0.0) {
				String precioWebDoceMesesOferta = numberFormat.format(dtoExcelFichaComercial.getPrecioWebDoceMesesOferta());
				c.setCellValue(precioWebDoceMesesOferta);
			}
			
			cellReference = new CellReference("H33");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getPrecioWebDieciochoMesesOferta() != null && dtoExcelFichaComercial.getPrecioWebDieciochoMesesOferta() > 0.0) {
				String precioWebDieciochoMesesOferta = numberFormat.format(dtoExcelFichaComercial.getPrecioWebDieciochoMesesOferta());
				c.setCellValue(precioWebDieciochoMesesOferta);
			}
			
			cellReference = new CellReference("J32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getFechaUltimoPrecioAprobado() != null) {
			c.setCellValue(dtoExcelFichaComercial.getFechaUltimoPrecioAprobado());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("K32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getComite() != null) {
			c.setCellValue(dtoExcelFichaComercial.getComite());
			}else {
			c.setCellValue("");
			}
			
			cellReference = new CellReference("L32");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getDtoComite() != null) {
				String dtoComiteString = dtoExcelFichaComercial.getDtoComite().toString();
				c.setCellValue(dtoComiteString + " %");
			}else {
				c.setCellValue("");	
			}

			cellReference = new CellReference("E34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionActual() != null && dtoExcelFichaComercial.getTasacionActual() > 0.0) {
				String tasacionActual = numberFormat.format(dtoExcelFichaComercial.getTasacionActual());
				c.setCellValue(tasacionActual);
			}
			
			cellReference = new CellReference("F34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionSeisMesesOferta() != null && dtoExcelFichaComercial.getTasacionSeisMesesOferta() > 0.0) {
				String tasacionSeisMesesOferta = numberFormat.format(dtoExcelFichaComercial.getTasacionSeisMesesOferta());
				c.setCellValue(tasacionSeisMesesOferta);
			}
			
			cellReference = new CellReference("G34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionDoceMesesOferta() != null && dtoExcelFichaComercial.getTasacionDoceMesesOferta() > 0.0) {
				String tasacionDoceMesesOferta = numberFormat.format(dtoExcelFichaComercial.getTasacionDoceMesesOferta());
				c.setCellValue(tasacionDoceMesesOferta);
			}
			
			cellReference = new CellReference("H34");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTasacionDieciochoMesesOferta() != null && dtoExcelFichaComercial.getTasacionDieciochoMesesOferta() > 0.0) {
				String tasacionDieciochoMesesOferta = numberFormat.format(dtoExcelFichaComercial.getTasacionDieciochoMesesOferta());
				c.setCellValue(tasacionDieciochoMesesOferta);
			}
			
			cellReference = new CellReference("E37");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getImporteAdjuducacion() != null && dtoExcelFichaComercial.getImporteAdjuducacion().doubleValue() > 0.0) {
				String importeAdj = numberFormat.format(dtoExcelFichaComercial.getImporteAdjuducacion().doubleValue());
				c.setCellValue(importeAdj);
			}
			
			cellReference = new CellReference("E38");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getRentaMensual()!= null && dtoExcelFichaComercial.getRentaMensual() > 0.0) {
				String rentaMensual = numberFormat.format(dtoExcelFichaComercial.getRentaMensual());
				c.setCellValue(rentaMensual);	
			}
			
			cellReference = new CellReference("E39");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTotalOferta()!= null && dtoExcelFichaComercial.getTotalOferta() > 0.0) {
				String totalOferta = numberFormat.format(dtoExcelFichaComercial.getTotalOferta());
				c.setCellValue(totalOferta);
			}
			
			cellReference = new CellReference("E40");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTotalSuperficie() != null) {
			c.setCellValue(dtoExcelFichaComercial.getTotalSuperficie().doubleValue());
			}
			
			cellReference = new CellReference("E41");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getComisionHayaDivarian() != null && dtoExcelFichaComercial.getComisionHayaDivarian() > 0.0) {
				String comisionHayaDivarian = numberFormat.format(dtoExcelFichaComercial.getComisionHayaDivarian());
				c.setCellValue(comisionHayaDivarian);
			}
			
			cellReference = new CellReference("E42");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getGastosPendientes() != null && dtoExcelFichaComercial.getGastosPendientes() > 0.0) {
				String gastosPendientes = numberFormat.format(dtoExcelFichaComercial.getGastosPendientes());
				c.setCellValue(gastosPendientes);
			}
			
			cellReference = new CellReference("E43");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getCostesLegales() != null && dtoExcelFichaComercial.getCostesLegales() > 0.0) {
				String costesLegales = numberFormat.format(dtoExcelFichaComercial.getCostesLegales());
				c.setCellValue(costesLegales);
			}
			
			cellReference = new CellReference("E44");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getTotalOfertaNeta() != null && dtoExcelFichaComercial.getTotalOfertaNeta() > 0.0) {
				String ofertaNeta = numberFormat.format(dtoExcelFichaComercial.getTotalOfertaNeta());
				c.setCellValue(ofertaNeta);
			}
			
			cellReference = new CellReference("E49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getVisitas() != null) {
				c.setCellValue(dtoExcelFichaComercial.getVisitas());
			}
			
			cellReference = new CellReference("F49");
			r = mySheet.getRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(dtoExcelFichaComercial.getVisitas() != null) {
				c.setCellValue(dtoExcelFichaComercial.getVisitas());
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
			// TODO: Mini graficos - (Sparklines)
			
			int currentRowDesglose = 8;
			for(DtoActivosFichaComercial activoFichaComercial : dtoExcelFichaComercial.getListaActivosFichaComercial()) {

				cellReference = new CellReference("B" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getIdActivo())) {
					c.setCellValue(activoFichaComercial.getIdActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getIdActivo())) {
					c.setCellValue(activoFichaComercial.getIdActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("C" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumFincaRegistral())) {
					c.setCellValue(activoFichaComercial.getNumFincaRegistral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("C" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumFincaRegistral())) {
					c.setCellValue(activoFichaComercial.getNumFincaRegistral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("D" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getGaraje())) {
					c.setCellValue(activoFichaComercial.getGaraje());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("D" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getGaraje())) {
					c.setCellValue(activoFichaComercial.getGaraje());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTrastero())) {
					c.setCellValue(activoFichaComercial.getTrastero());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("E" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTrastero())) {
					c.setCellValue(activoFichaComercial.getTrastero());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumRegProp())) {
					c.setCellValue(activoFichaComercial.getNumRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("F" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumRegProp())) {
					c.setCellValue(activoFichaComercial.getNumRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getLocalidadRegProp())) {
					c.setCellValue(activoFichaComercial.getLocalidadRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("G" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getLocalidadRegProp())) {
					c.setCellValue(activoFichaComercial.getLocalidadRegProp());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("H" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getNumRefCatastral())) {
					c.setCellValue(activoFichaComercial.getNumRefCatastral());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("H" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTipoEntrada())) {
					c.setCellValue(activoFichaComercial.getTipoEntrada());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getEstadoFisicoActivo())) {
					c.setCellValue(activoFichaComercial.getEstadoFisicoActivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("I" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getDepuracionJuridica())) {
					c.setCellValue(activoFichaComercial.getDepuracionJuridica());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("J" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTipologia())) {
					c.setCellValue(activoFichaComercial.getTipologia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("J" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getInscritoRegistro())) {
					c.setCellValue(activoFichaComercial.getInscritoRegistro());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("K" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getSubtipologia())) {
					c.setCellValue(activoFichaComercial.getSubtipologia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("K" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTituloPropiedad())) {
					c.setCellValue(activoFichaComercial.getTituloPropiedad());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("L" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getM2Edificable())) {
					c.setCellValue(activoFichaComercial.getM2Edificable().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("L" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getCargas())) {
					c.setCellValue(activoFichaComercial.getCargas());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("M" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getSituacionComercial())) {
					c.setCellValue(activoFichaComercial.getSituacionComercial());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("M" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getPosesion())) {
					c.setCellValue(activoFichaComercial.getPosesion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("N" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getEpa())) {
					c.setCellValue(activoFichaComercial.getEpa());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("N" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getOcupadoIlegal())) {
					c.setCellValue(activoFichaComercial.getOcupadoIlegal());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("O" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getDireccion())) {
					c.setCellValue(activoFichaComercial.getDireccion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("O" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getColectivo())) {
					c.setCellValue(activoFichaComercial.getColectivo());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("P" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getCodPostal())) {
					c.setCellValue(activoFichaComercial.getCodPostal());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("P" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getDireccion())) {
					c.setCellValue(activoFichaComercial.getDireccion());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Q" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getMunicipio())) {
					c.setCellValue(activoFichaComercial.getMunicipio());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Q" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getCodPostal())) {
					c.setCellValue(activoFichaComercial.getCodPostal());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("R" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getProvincia())) {
					c.setCellValue(activoFichaComercial.getProvincia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("R" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getMunicipio())) {
					c.setCellValue(activoFichaComercial.getMunicipio());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("S" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getSociedadTitular())) {
					c.setCellValue(activoFichaComercial.getSociedadTitular());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("S" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getProvincia())) {
					c.setCellValue(activoFichaComercial.getProvincia());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("T" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getPrecioComite())) {
					String precioComite = numberFormat.format(activoFichaComercial.getPrecioComite());
					c.setCellValue(precioComite);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("T" + Integer.toString(currentRowDesglose));
				r = mySheetDepuracion.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDepuracion.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getSociedadTitular())) {
					c.setCellValue(activoFichaComercial.getSociedadTitular());
				} else {
					c.setCellValue("");
				}
				
				
				cellReference = new CellReference("U" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getPrecioPublicacion())) {
					String precioPublicacion = numberFormat.format(activoFichaComercial.getPrecioPublicacion());
					c.setCellValue(precioPublicacion);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("V" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				c.setCellStyle(styleFondoAmarillo);
				if (!Checks.esNulo(activoFichaComercial.getPrecioSueloEpa())) {
					String precioSueloEpa = numberFormat.format(activoFichaComercial.getPrecioSueloEpa());
					c.setCellValue(precioSueloEpa);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("W" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getTasacion())) {
					String tasacion = numberFormat.format(activoFichaComercial.getTasacion());
					c.setCellValue(tasacion);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("X" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				c.setCellStyle(styleFondoAzul);
				if (!Checks.esNulo(activoFichaComercial.getVnc())) {
					String vnc = numberFormat.format(activoFichaComercial.getVnc());
					c.setCellValue(vnc);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Y" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getImporteAdj())) {
					String importeAdj = numberFormat.format(activoFichaComercial.getImporteAdj());
					c.setCellValue(importeAdj);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("Z" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getRenta())) {
					String renta = numberFormat.format(activoFichaComercial.getRenta());
					c.setCellValue(renta);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AA" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getOferta())) {
					String oferta = numberFormat.format(activoFichaComercial.getOferta());
					c.setCellValue(oferta);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AB" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getEurosM2())) {
					String eurosM2 = numberFormat.format(activoFichaComercial.getEurosM2());
					c.setCellValue(eurosM2);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AC" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getComisionHaya())) {
					String comisionHaya = numberFormat.format(activoFichaComercial.getComisionHaya());
					c.setCellValue(comisionHaya);
				} else {
					String comisionHaya = numberFormat.format(new Double("0.0"));
					c.setCellValue(comisionHaya);
				}
				
				cellReference = new CellReference("AD" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				//c.setCellStyle(styleFondoAmarillo);
				if (!Checks.esNulo(activoFichaComercial.getGastosPendientes()) && activoFichaComercial.getGastosPendientes() > 0) {
					String gastosPendientes = numberFormat.format(activoFichaComercial.getGastosPendientes());
					c.setCellValue(gastosPendientes);
				} else {
					String gastosPendientes = numberFormat.format(new Double("0.0"));
					c.setCellValue(gastosPendientes);
				}
				
				cellReference = new CellReference("AE" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				//c.setCellStyle(styleFondoAmarillo);
				if (!Checks.esNulo(activoFichaComercial.getCostesLegales())) {
					String costesLegales = numberFormat.format(activoFichaComercial.getCostesLegales());
					c.setCellValue(costesLegales);
				} else {
					String costesLegales = numberFormat.format(new Double("0.0"));
					c.setCellValue(costesLegales);
				}
				
				cellReference = new CellReference("AF" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getOfertaNeta())) {
					String importeOfertaNeta = numberFormat.format(activoFichaComercial.getOfertaNeta());
					c.setCellValue(importeOfertaNeta);
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AG" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				if (!Checks.esNulo(activoFichaComercial.getLink())) {
					c.setCellValue(activoFichaComercial.getLink());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("AH" + Integer.toString(currentRowDesglose));
				r = mySheetDesglose.getRow(cellReference.getRow());
				if(r == null)
					r = mySheetDesglose.createRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if(c == null)
					c = r.createCell(cellReference.getCol());
				c.setCellValue(activoFichaComercial.getActivoBbva());
				
				currentRowDesglose++;
			}
			
			cellReference = new CellReference("L5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getM2EdificableTotal())) {
				String edificable = decimalFormat.format(dtoExcelFichaComercial.getM2EdificableTotal());
				c.setCellValue(edificable);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("T5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getPrecioComiteTotal()) && dtoExcelFichaComercial.getPrecioComiteTotal() > 0.0) {
				String precioTotalComite = numberFormat.format(dtoExcelFichaComercial.getPrecioComiteTotal());
				c.setCellValue(precioTotalComite);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("U5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getPrecioPublicacionTotal()) && dtoExcelFichaComercial.getPrecioPublicacionTotal() > 0.0) {
				String precioPublicacionTotal = numberFormat.format(dtoExcelFichaComercial.getPrecioPublicacionTotal());
				c.setCellValue(precioPublicacionTotal);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("V5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getPrecioSueloEpaTotal()) && dtoExcelFichaComercial.getPrecioSueloEpaTotal() > 0.0) {
				String precioSueloEpaTotal = numberFormat.format(dtoExcelFichaComercial.getPrecioSueloEpaTotal());
				c.setCellValue(precioSueloEpaTotal);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("W5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getTasacionTotal()) && dtoExcelFichaComercial.getTasacionTotal() > 0.0) {
				String tasacionTotal = numberFormat.format(dtoExcelFichaComercial.getTasacionTotal());
				c.setCellValue(tasacionTotal);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("X5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getVncTotal()) && dtoExcelFichaComercial.getVncTotal() > 0.0) {
				String vncTotal = numberFormat.format(dtoExcelFichaComercial.getVncTotal());
				c.setCellValue(vncTotal);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("Y5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getImporteAdjTotal()) && dtoExcelFichaComercial.getImporteAdjTotal() > 0.0) {
				String importeAdjTotal = numberFormat.format(dtoExcelFichaComercial.getImporteAdjTotal());
				c.setCellValue(importeAdjTotal);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("Z5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getRentaTotal()) && dtoExcelFichaComercial.getRentaTotal() > 0.0) {
				String rentaTotal = numberFormat.format(dtoExcelFichaComercial.getRentaTotal());
				c.setCellValue(rentaTotal);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("AA5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getOfertaTotalDesglose()) && dtoExcelFichaComercial.getOfertaTotalDesglose() > 0.0) {
				String ofertaTotalDesglose = numberFormat.format(dtoExcelFichaComercial.getOfertaTotalDesglose());
				c.setCellValue(ofertaTotalDesglose);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("AB5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getEurosM2Total()) && dtoExcelFichaComercial.getEurosM2Total() > 0.0) {
				String eurosM2Total = numberFormat.format(dtoExcelFichaComercial.getEurosM2Total());
				c.setCellValue(eurosM2Total);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("AC5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getComisionHayaTotal()) && dtoExcelFichaComercial.getComisionHayaTotal() > 0.0) {
				String comisionHayaTotal = numberFormat.format(dtoExcelFichaComercial.getComisionHayaTotal());
				c.setCellValue(comisionHayaTotal);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("AD5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getGastosPendientesTotal()) && dtoExcelFichaComercial.getGastosPendientesTotal() > 0) {
				String gastosPendientesTotal = numberFormat.format(dtoExcelFichaComercial.getGastosPendientesTotal());
				c.setCellValue(gastosPendientesTotal);
			} else {
				c.setCellValue(" ");
			}
			
			cellReference = new CellReference("AE5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getCostesLegalesTotal()) && dtoExcelFichaComercial.getCostesLegalesTotal() > 0.0) {
				String costesLegalesTotal = numberFormat.format(dtoExcelFichaComercial.getCostesLegalesTotal());
				c.setCellValue(costesLegalesTotal);
			} else {
				c.setCellValue("");
			}
			
			cellReference = new CellReference("AF5");
			r = mySheetDesglose.getRow(cellReference.getRow());
			if(r == null)
				r = mySheetDesglose.createRow(cellReference.getRow());
			c = r.getCell(cellReference.getCol());
			if(c == null)
				c = r.createCell(cellReference.getCol());
			if (!Checks.esNulo(dtoExcelFichaComercial.getOfertaNetaTotal()) && dtoExcelFichaComercial.getOfertaNetaTotal() > 0.0) {
				String importeOfertaTotal = numberFormat.format(dtoExcelFichaComercial.getOfertaNetaTotal());
				c.setCellValue(importeOfertaTotal);
			} else {
				c.setCellValue("");
			}			
			
			//Rellenamos hoja historico ofertas
			
			int currentRowHistorico = 7;
			int countNumActDuplicate = 0;
			String totalFFRR = "";
			String totalOferta = "";
			String totalpvpComite = "";
			String totalvTas = "";
			String numActivo = "";
			List<String> numActivosList = new ArrayList<String>();
			
			XSSFCellStyle styleActivoTitleHistorico = myWorkBook.createCellStyle();
			font = myWorkBook.createFont();
			font.setFontHeight(11);
			font.setBold(true);
			styleActivoTitleHistorico.setFont(font);
			styleActivoTitleHistorico.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleActivoTitleHistorico.setBottomBorderColor(new XSSFColor(new java.awt.Color(157, 195, 230)));
			styleActivoTitleHistorico.setFillForegroundColor(new XSSFColor(new java.awt.Color(222, 235, 247)));
			styleActivoTitleHistorico.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			styleActivoTitleHistorico.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			XSSFCellStyle styleTopColumnsHistorico = myWorkBook.createCellStyle();
			font = myWorkBook.createFont();
			font.setFontHeight(11);
			font.setBold(true);
			styleTopColumnsHistorico.setFont(font);
			styleTopColumnsHistorico.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			styleTopColumnsHistorico.setBottomBorderColor(new XSSFColor(new java.awt.Color(157, 195, 230)));
			styleTopColumnsHistorico.setFillForegroundColor(new XSSFColor(new java.awt.Color(222, 235, 247)));
			styleTopColumnsHistorico.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			styleTopColumnsHistorico.setAlignment(XSSFCellStyle.ALIGN_LEFT);
			
			XSSFCellStyle styleBottomColumnsHistorico = myWorkBook.createCellStyle();
			font = myWorkBook.createFont();
			font.setFontHeight(11);
			font.setBold(true);
			styleBottomColumnsHistorico.setFont(font);
			styleBottomColumnsHistorico.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBottomColumnsHistorico.setTopBorderColor(new XSSFColor(new java.awt.Color(157, 195, 230)));
			styleBottomColumnsHistorico.setFillForegroundColor(new XSSFColor(new java.awt.Color(222, 235, 247)));
			styleBottomColumnsHistorico.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
			XSSFCellStyle styleBottomColumnsEHistorico = myWorkBook.createCellStyle();
			font = myWorkBook.createFont();
			font.setFontHeight(11);
			font.setBold(true);
			styleBottomColumnsEHistorico.setFont(font);
			styleBottomColumnsEHistorico.setBorderTop(XSSFCellStyle.BORDER_THIN);
			styleBottomColumnsEHistorico.setTopBorderColor(new XSSFColor(new java.awt.Color(157, 195, 230)));
			styleBottomColumnsEHistorico.setFillForegroundColor(new XSSFColor(new java.awt.Color(222, 235, 247)));
			styleBottomColumnsEHistorico.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			styleBottomColumnsEHistorico.setAlignment(XSSFCellStyle.ALIGN_LEFT);
			styleBottomColumnsEHistorico.setDataFormat(dataFormat.getFormat("#,###,##0.00\\ \"€\""));
			
			XSSFCellStyle styleDataHistoricoBold = myWorkBook.createCellStyle();
			font = myWorkBook.createFont();
			font.setFontHeight(11);
			font.setBold(true);
			styleDataHistoricoBold.setFont(font);
			
			XSSFCellStyle styleDataHistorico = myWorkBook.createCellStyle();
			font = myWorkBook.createFont();
			font.setFontHeight(11);
			font.setBold(false);
			styleDataHistorico.setFont(font);
			
			XSSFCellStyle styleDataEHistorico = myWorkBook.createCellStyle();
			font = myWorkBook.createFont();
			font.setFontHeight(11);
			font.setBold(false);
			styleDataEHistorico.setFont(font);
			styleDataEHistorico.setDataFormat(dataFormat.getFormat("#,###,##0.00\\ \"€\""));
			
			for(DtoHcoComercialFichaComercial historico : dtoExcelFichaComercial.getListaHistoricoOfertas()) {
				numActivosList.add(historico.getNumActivo());
			}
			
			for(DtoHcoComercialFichaComercial historico : dtoExcelFichaComercial.getListaHistoricoOfertas()) {
				
				int numActivoDuplicate = Collections.frequency(numActivosList, historico.getNumActivo());
				countNumActDuplicate++;
				
				if (historico.getNumActivo() != null && !numActivo.equals(historico.getNumActivo())) {
					cellReference = new CellReference("B" +Integer.toString(currentRowHistorico)); 
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					if(!Checks.esNulo(historico.getNumActivo())) {
						c.setCellValue("Activo "+historico.getNumActivo());
						numActivo = historico.getNumActivo();
					} else { 
						c.setCellValue(""); 
					}
					mySheetHistorico.addMergedRegion(new CellRangeAddress(currentRowHistorico-1, currentRowHistorico-1, 1, 11));
					c.setCellStyle(styleActivoTitleHistorico);

					currentRowHistorico++;
					
					cellReference = new CellReference("B" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("Fecha");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("C" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("Nº oferta");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("D" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					r.setHeight((short)600);
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("Fecha \nSanción");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("E" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("Nombre ofertante:");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("F" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					r.setHeight((short)600);
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("Estado de \nOferta");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("G" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("¿Desestimado?");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("H" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					r.setHeight((short)600);
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("Motivo del \ndesestimiento");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("I" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("FF.RR.");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("J" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("OFERTA");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("K" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					r.setHeight((short)600);
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("PVP \nComité");
					c.setCellStyle(styleTopColumnsHistorico);
					
					cellReference = new CellReference("L" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellValue("V Tas");
					c.setCellStyle(styleTopColumnsHistorico);
					
					currentRowHistorico++;
				}
				
				cellReference = new CellReference("B" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getFecha())) {
					c.setCellValue(historico.getFecha());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataHistoricoBold);
				
				cellReference = new CellReference("C" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getNumOferta())) {
					c.setCellValue(historico.getNumOferta());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataHistoricoBold);
				
				cellReference = new CellReference("D" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getFechaSancion())) {
					c.setCellValue(historico.getFechaSancion());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataHistoricoBold);
				
				cellReference = new CellReference("E" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getOfertante())) {
					c.setCellValue(historico.getOfertante());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataHistorico);
				
				cellReference = new CellReference("F" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getEstado())) {
					c.setCellValue(historico.getEstado());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataHistoricoBold);
				
				cellReference = new CellReference("G" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getDesestimado())) {
					c.setCellValue(historico.getDesestimado());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataHistorico);
				
				cellReference = new CellReference("H" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getMotivoDesestimiento())) {
					c.setCellValue(historico.getMotivoDesestimiento());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataHistorico);
				
				cellReference = new CellReference("I" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getFfrr())) {
					c.setCellValue(historico.getFfrr());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataHistorico);
				
				cellReference = new CellReference("J" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getOferta())) {
					c.setCellValue(historico.getOferta());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataEHistorico);
				
				cellReference = new CellReference("K" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getPvpComite())) {
					c.setCellValue(historico.getPvpComite());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataEHistorico);
				
				cellReference = new CellReference("L" + Integer.toString(currentRowHistorico));
				r = mySheetHistorico.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetHistorico.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(historico.getTasacion())) {
					c.setCellValue(historico.getTasacion());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleDataEHistorico);				
				
				currentRowHistorico++;
				
				if (numActivoDuplicate == countNumActDuplicate) {
					cellReference = new CellReference("B" +Integer.toString(currentRowHistorico)); 
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					if(!Checks.esNulo(historico.getNumActivo())) {
						c.setCellValue("Total Activo "+historico.getNumActivo()); 
					} else { 
						c.setCellValue("Total Activo"); 
					}
					mySheetHistorico.addMergedRegion(new CellRangeAddress(currentRowHistorico-1, currentRowHistorico-1, 1, 7));
					c.setCellStyle(styleBottomColumnsHistorico);
					
					String formula = "SUM(I"+String.valueOf(currentRowHistorico-numActivoDuplicate)+":I"+String.valueOf(currentRowHistorico-1)+")";
					cellReference = new CellReference("I" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
					c.setCellFormula(formula);
					c.setCellStyle(styleBottomColumnsHistorico);
					if (totalFFRR.isEmpty()) {
						totalFFRR = formula;
					} else {
						totalFFRR = totalFFRR+"+"+formula;
					}
					
					formula = "SUM(J"+String.valueOf(currentRowHistorico-numActivoDuplicate)+":J"+String.valueOf(currentRowHistorico-1)+")";
					cellReference = new CellReference("J" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
					c.setCellFormula(formula);
					c.setCellStyle(styleBottomColumnsEHistorico);
					if (totalOferta.isEmpty()) {
						totalOferta = formula;
					} else {
						totalOferta = totalOferta+"+"+formula;
					}
					
					formula = "SUM(K"+String.valueOf(currentRowHistorico-numActivoDuplicate)+":K"+String.valueOf(currentRowHistorico-1)+")";
					cellReference = new CellReference("K" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
					c.setCellFormula(formula);
					c.setCellStyle(styleBottomColumnsEHistorico);
					if (totalpvpComite.isEmpty()) {
						totalpvpComite = formula;
					} else {
						totalpvpComite = totalpvpComite+"+"+formula;
					}
					
					formula = "SUM(L"+String.valueOf(currentRowHistorico-numActivoDuplicate)+":L"+String.valueOf(currentRowHistorico-1)+")";
					cellReference = new CellReference("L" + Integer.toString(currentRowHistorico));
					r = mySheetHistorico.getRow(cellReference.getRow());
					if (r == null) {
						r = mySheetHistorico.createRow(cellReference.getRow());
					}
					c = r.getCell(cellReference.getCol());
					if (c == null) {
						c = r.createCell(cellReference.getCol());
					}
					c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
					c.setCellFormula(formula);
					c.setCellStyle(styleBottomColumnsEHistorico);
					if (totalvTas.isEmpty()) {
						totalvTas = formula;
					} else {
						totalvTas = totalvTas+"+"+formula;
					}
					
					currentRowHistorico+=2;
					countNumActDuplicate=0;
				}
			}
			
			cellReference = new CellReference("B" +Integer.toString(currentRowHistorico)); 
			r = mySheetHistorico.getRow(cellReference.getRow());
			if (r == null) {
				r = mySheetHistorico.createRow(cellReference.getRow());
			}
			c = r.getCell(cellReference.getCol());
			if (c == null) {
				c = r.createCell(cellReference.getCol());
			}
			c.setCellValue("Total General   "); 
			mySheetHistorico.addMergedRegion(new CellRangeAddress(currentRowHistorico-1, currentRowHistorico-1, 1, 7));
			c.setCellStyle(styleBottomColumnsHistorico);
			
			cellReference = new CellReference("I" + Integer.toString(currentRowHistorico));
			r = mySheetHistorico.getRow(cellReference.getRow());
			if (r == null) {
				r = mySheetHistorico.createRow(cellReference.getRow());
			}
			c = r.getCell(cellReference.getCol());
			if (c == null) {
				c = r.createCell(cellReference.getCol());
			}
			c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
			if (!totalFFRR.isEmpty()) {
				c.setCellFormula(totalFFRR);
			}
			c.setCellStyle(styleBottomColumnsHistorico);
			
			cellReference = new CellReference("J" + Integer.toString(currentRowHistorico));
			r = mySheetHistorico.getRow(cellReference.getRow());
			if (r == null) {
				r = mySheetHistorico.createRow(cellReference.getRow());
			}
			c = r.getCell(cellReference.getCol());
			if (c == null) {
				c = r.createCell(cellReference.getCol());
			}
			c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
			if (!totalOferta.isEmpty()) {
				c.setCellFormula(totalOferta);
			}
			c.setCellStyle(styleBottomColumnsEHistorico);
			
			cellReference = new CellReference("K" + Integer.toString(currentRowHistorico));
			r = mySheetHistorico.getRow(cellReference.getRow());
			if (r == null) {
				r = mySheetHistorico.createRow(cellReference.getRow());
			}
			c = r.getCell(cellReference.getCol());
			if (c == null) {
				c = r.createCell(cellReference.getCol());
			}
			c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
			if (!totalpvpComite.isEmpty()) {
				c.setCellFormula(totalpvpComite);
			}
			c.setCellStyle(styleBottomColumnsEHistorico);
			
			cellReference = new CellReference("L" + Integer.toString(currentRowHistorico));
			r = mySheetHistorico.getRow(cellReference.getRow());
			if (r == null) {
				r = mySheetHistorico.createRow(cellReference.getRow());
			}
			c = r.getCell(cellReference.getCol());
			if (c == null) {
				c = r.createCell(cellReference.getCol());
			}
			c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
			if (!totalvTas.isEmpty()) {
				c.setCellFormula(totalvTas);
			}
			c.setCellStyle(styleBottomColumnsEHistorico);
			
			//rellenamos la quinta hoja
			
			int currentRowComercial = 27;
			int lastRow = mySheetAutorizacion.getLastRowNum();
			for( DtoListFichaAutorizacion autorizacion : dtoExcelFichaComercial.getListaFichaAutorizacion()) {
							
				cellReference = new CellReference("B" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getIdActivo())) {
					c.setCellValue(autorizacion.getIdActivo());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				
				cellReference = new CellReference("C" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getFinca())) {
					c.setCellValue(autorizacion.getFinca());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				
				cellReference = new CellReference("D" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getRegPropiedad())) {
					c.setCellValue(autorizacion.getRegPropiedad());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				
				cellReference = new CellReference("E" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getLocalidadRegProp())) {
					c.setCellValue(autorizacion.getLocalidadRegProp());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				
				cellReference = new CellReference("F" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getPrecioVenta())) {
					c.setCellValue(autorizacion.getPrecioVenta());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				
				cellReference = new CellReference("G" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getDireccion())) {
					c.setCellValue(autorizacion.getDireccion());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				mySheetAutorizacion.addMergedRegion(new CellRangeAddress(currentRowComercial-1, currentRowComercial-1, 6, 7));
				
				cellReference = new CellReference("I" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getLocalidad())) {
					c.setCellValue(autorizacion.getLocalidad());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				mySheetAutorizacion.addMergedRegion(new CellRangeAddress(currentRowComercial-1, currentRowComercial-1, 8, 10));
				
				cellReference = new CellReference("L" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getProvincia())) {
					c.setCellValue(autorizacion.getProvincia());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				mySheetAutorizacion.addMergedRegion(new CellRangeAddress(currentRowComercial-1, currentRowComercial-1, 11, 12));
				
				cellReference = new CellReference("N" + Integer.toString(currentRowComercial));
				r = mySheetAutorizacion.getRow(cellReference.getRow());
				if (r == null) {
					r = mySheetAutorizacion.createRow(cellReference.getRow());
				}
				c = r.getCell(cellReference.getCol());
				if (c == null) {
					c = r.createCell(cellReference.getCol());
				}
				if (!Checks.esNulo(autorizacion.getCondicionesVenta())) {
					c.setCellValue(autorizacion.getCondicionesVenta());
				} else {
					c.setCellValue("");
				}
				c.setCellStyle(styleBordesCompletos);
				
				currentRowComercial++;

				mySheetAutorizacion.shiftRows(currentRowComercial, lastRow - 1, 1);
			}
			
			for (int x=1; x<35; x++) {
				mySheet.autoSizeColumn(x);
				mySheetHistorico.autoSizeColumn(x);
			}
			
			myWorkBook.write(fileOutStream);
			fileOutStream.close();
			
			return fileOut;
			
		}finally {
			fileOutStream.close();
		}
	}
	
	@Override
	public File getAdvisoryNoteReport(List<VReportAdvisoryNotes> listaAN, HttpServletRequest request, String subcartera) throws IOException {
		
		ServletContext sc = request.getSession().getServletContext();		
		FileOutputStream fileOutStream = null;
		
		try {
			File poiFile  = new File(sc.getRealPath("plantillas/plugin/AdvisoryNoteApple/AdvisoryNoteReport.xlsx"));
			if(!Checks.esNulo(subcartera)) {
				if(DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(subcartera)) {
					poiFile  = new File(sc.getRealPath("plantillas/plugin/AdvisoryNoteApple/AdvisoryNoteReport.xlsx"));
				}else if (DDSubcartera.CODIGO_JAGUAR.equals(subcartera)) {
					poiFile  = new File(sc.getRealPath("plantillas/plugin/AdvisoryNoteJaguar/AdvisoryNoteReport.xlsx"));
				}
			}


			
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
	
	@Override
	public ReportGeneratorResponse requestExcel(ReportGeneratorRequest request, String url) throws IOException {
		Map<String, Object> params = new HashMap<String, Object>();
	 	params.put("id", request.getListId());
	 	params.put("reportCode", request.getReportCode());
	 	HttpSimplePostRequest httpPostClient = new HttpSimplePostRequest(url, params);
	 	return httpPostClient.post(ReportGeneratorResponse.class);
	}
	
	@Override
	public void downloadExcel(ReportGeneratorResponse report, HttpServletResponse response) throws IOException {
		File file = getExcelFileByArrayByte(report.getResponse(), report.getNombre());
	 	this.sendReport(file, response);
	}

	@Override
	@Transactional
	public String sendExcelFichaComercial(Long numExpediente, ReportGeneratorResponse report, String scheme, String serverName) throws IOException {
		File file = getExcelFileByArrayByte(report.getResponse(), report.getNombre());
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "numExpediente", numExpediente));
		return notificationOferta.enviarMailFichaComercial(expediente.getOferta(), file.getName(), scheme, serverName);
	}
	
	private File getExcelFileByArrayByte(byte[] bytes, String fileName) throws IOException {
		String route = appProperties.getProperty(CONSTANTE_RUTA_EXCEL) + "/" + fileName;
	 	File file = new File(route);
	 	org.apache.commons.io.FileUtils.writeByteArrayToFile(file, bytes);
	 	return file;
	}

}
