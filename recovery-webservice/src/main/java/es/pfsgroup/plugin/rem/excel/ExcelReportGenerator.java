package es.pfsgroup.plugin.rem.excel;


import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
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
import org.hsqldb.Row;
import org.springframework.stereotype.Component;

import com.itextpdf.text.Font;

import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import jxl.Cell;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableCell;
import jxl.write.WritableCellFeatures;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import org.apache.poi.hssf.util.CellReference;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


@Component
public class ExcelReportGenerator implements ExcelReportGeneratorApi {
	
	protected static final Log logger = LogFactory.getLog(ExcelReportGenerator.class);
	
	private static final int MAX_ROW_LIMIT = 50000;

	private static final String EXPORTAR_EXCEL_LIMITE_ACTIVOS = "exportar.excel.limite.activos";

	private static final int START_REPORT_ROW = 0;
	
	private static final String TOTAL = "TOTAL";
	
	private static final int NUMERO_COLUMNAS = 21;
	
	private static final String TEXTO_NO_PUBLICADO = "Sin Publicar";
	
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
				
//				dtoPAB.setCompradorDocumento("21800125S");
//				dtoPAB.setNombreCompleto("adhashdojiasdasojidoji");
				
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
					c.setCellValue(format.format(dtoPAB.getImporteTasacionFinal()));
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
					c.setCellValue(dtoPAB.getImporteOferta().toString());
				} else {
					c.setCellValue("");
				}
				
				cellReference = new CellReference("B60");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCarenciaALquiler())) { 
					c.setCellValue(Integer.toString(dtoPAB.getCarenciaALquiler()));
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
				
				formula = "'"+numActivo.toString()+"'!B50";
				cellReference = new CellReference("S" + Integer.toString(currentRow)); // PAX
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

	

}
