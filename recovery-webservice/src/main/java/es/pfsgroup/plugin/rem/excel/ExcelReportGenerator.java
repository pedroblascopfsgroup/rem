package es.pfsgroup.plugin.rem.excel;


import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
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
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


@Component
public class ExcelReportGenerator implements ExcelReportGeneratorApi {
	
	protected static final Log logger = LogFactory.getLog(ExcelReportGenerator.class);
	
	private static final int MAX_ROW_LIMIT = 50000;

	private static final String EXPORTAR_EXCEL_LIMITE_ACTIVOS = "exportar.excel.limite.activos";

	private static final int START_REPORT_ROW = 0;
	
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
		
		response.setHeader("Content-disposition", "attachment; filename='"+ fileName + "'");
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
			
			// En el ultimo elemento esta el resumen por eso cogemos todos los DTO menos el ultimo
			for (int i = 0; i < l_DtoPropuestaAlq.size()-1; i++) {
				
				DtoPropuestaAlqBankia dtoPAB = l_DtoPropuestaAlq.get(i);
				
				if (primero) {
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
				if (!Checks.esNulo(dtoPAB.getDescripcionEstadoPatrimonio())) {
					c.setCellValue(dtoPAB.getDescripcionEstadoPatrimonio());
				}	
					
				cellReference = new CellReference("B7");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNumActivoUvem())) {
					c.setCellValue(dtoPAB.getNumActivoUvem().toString());
				}
				
				cellReference = new CellReference("B9");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellValue(new Date());
				
				cellReference = new CellReference("B10");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaAltaOferta())) {
					c.setCellValue(dtoPAB.getFechaAltaOferta().toString());
				}
				
				cellReference = new CellReference("B11");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaPublicacionWeb())) {
					c.setCellValue(dtoPAB.getFechaPublicacionWeb().toString());
				}
				
				cellReference = new CellReference("B18");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTipoActivo())) {
					c.setCellValue(dtoPAB.getTipoActivo());
				}
				
				cellReference = new CellReference("B20");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getDireccionCompleta())) {
					c.setCellValue(dtoPAB.getDireccionCompleta());
				}
				
				cellReference = new CellReference("B21");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCodPostMunicipio())) {
					c.setCellValue(dtoPAB.getCodPostMunicipio());
				}
				
				//B22 CARACTERISTICAS ????
				
				cellReference = new CellReference("B24");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNombrePropietario())) {
					c.setCellValue(dtoPAB.getNombrePropietario());
				}

//					
				
				//B38 VALOR DE FONDO TOTAL ????
				//B39 VALOR DE NETO CONTABLE ????
				
				
				cellReference = new CellReference("B40");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteTasacionFinal())) {
					c.setCellValue(dtoPAB.getImporteTasacionFinal().toString());
				}
				
				cellReference = new CellReference("B41");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaUltimaTasacion())) { 
					c.setCellValue(dtoPAB.getFechaUltimaTasacion().toString());
				}
				
				cellReference = new CellReference("B47");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getNombreCompleto())) { 
					c.setCellValue(dtoPAB.getNombreCompleto());
				}
				
				cellReference = new CellReference("B48");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCompradorDocumento())) { 
					c.setCellValue(dtoPAB.getCompradorDocumento());
				}
				
				cellReference = new CellReference("B57");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getImporteOferta())) { 
					c.setCellValue(dtoPAB.getImporteOferta().toString());
				}
				
				cellReference = new CellReference("B60");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCarenciaALquiler())) { 
					c.setCellValue(Integer.toString(dtoPAB.getCarenciaALquiler()));
				}
				
				cellReference = new CellReference("A81");
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTextoOferta())) { 
					c.setCellValue(dtoPAB.getTextoOferta());
				}	
					
			}
			
			
			mySheet = myWorkBook.getSheetAt(0);
			int currentRow = 7;
			
			for (int i = 0; i < l_DtoPropuestaAlq.size()-1; i++) {
				
				DtoPropuestaAlqBankia dtoPAB = l_DtoPropuestaAlq.get(i);
				Long numActivo = dtoPAB.getNumActivoUvem(); // El numero de activo lo necesitamos para referenciar el resto de hojas en las formulas
				
				if (currentRow != 7) {
					mySheet.shiftRows(currentRow, currentRow+1, 1);
				}
				
				cellReference = new CellReference("A" + Integer.toString(currentRow)); // LOTE ??
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getTextoOferta())) { 
					c.setCellValue(dtoPAB.getTextoOferta());
				}
				
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
				if (!Checks.esNulo(dtoPAB.getCompradorNombre()))
					c.setCellValue(dtoPAB.getCompradorNombre());
				
				cellReference = new CellReference("F" + Integer.toString(currentRow)); // DIRECCION
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getDireccionCompleta()))
					c.setCellValue(dtoPAB.getDireccionCompleta());
				
				cellReference = new CellReference("H" + Integer.toString(currentRow)); // MUNICIPIO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getCodPostMunicipio()))
					c.setCellValue(dtoPAB.getCodPostMunicipio());
				
				String formula = "'"+numActivo.toString()+"'.B12";
				cellReference = new CellReference("I" + Integer.toString(currentRow)); // VALOR CONTABLE NETO
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
				c.setCellFormula(formula);
				
				cellReference = new CellReference("J" + Integer.toString(currentRow)); // FECHA PUBLICACION WEB
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaPublicacionWeb()))
					c.setCellValue(dtoPAB.getFechaPublicacionWeb().toString());
				else
					c.setCellValue("Sin publicar");
				
				cellReference = new CellReference("K" + Integer.toString(currentRow)); // VALOR ORIENTATIVO !!! RELLENA EL GESTOR
				r = mySheet.getRow(cellReference.getRow());
				c = r.getCell(cellReference.getCol());
				if (!Checks.esNulo(dtoPAB.getFechaPublicacionWeb()))
					c.setCellValue(dtoPAB.getFechaPublicacionWeb().toString());
				
//				String formula = "'"+numActivo+"'"+".B39";
//				cellReference = new CellReference("L" + Integer.toString(currentRow)); // VALOR CONTABLE NETO
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
//				
//				formula = "$"+numActivo+".B41";
//				cellReference = new CellReference("N" + Integer.toString(currentRow)); // FECHA TASACION
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
//				
//				formula = "$"+numActivo+".B57";
//				cellReference = new CellReference("O" + Integer.toString(currentRow)); // RENTA OFERTA
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
//				
//				formula = "$"+numActivo+".B58";
//				cellReference = new CellReference("P" + Integer.toString(currentRow)); // RENTA BONIFICADA
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
//				
//				formula = "$"+numActivo+".B9";
//				cellReference = new CellReference("Q" + Integer.toString(currentRow)); // FECHA OFERTA
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
//				
//				formula = "$"+numActivo+".B61";
//				cellReference = new CellReference("R" + Integer.toString(currentRow)); // RENTABILIDAD PRIMER ANYO
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
//				
//				formula = "$"+numActivo+".B62";
//				cellReference = new CellReference("S" + Integer.toString(currentRow)); // DIFERENCIA CON EURIBOR
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
//				
//				formula = "$"+numActivo+".B50";
//				cellReference = new CellReference("T" + Integer.toString(currentRow)); // PAX
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
//				
//				formula = "$"+numActivo+".B49";
//				cellReference = new CellReference("U" + Integer.toString(currentRow)); // Ingresos Netos
//				r = mySheet.getRow(cellReference.getRow());
//				c = r.getCell(cellReference.getCol());
//				c.setCellType(XSSFCell.CELL_TYPE_FORMULA);
//				c.setCellFormula(formula);
								
				
				++currentRow; // Siguiente fila
					
			}
			
			
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
