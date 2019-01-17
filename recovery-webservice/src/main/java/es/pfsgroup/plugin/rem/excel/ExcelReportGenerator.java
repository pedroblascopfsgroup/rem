package es.pfsgroup.plugin.rem.excel;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
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
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.propuestaprecios.service.impl.GenerarPropuestaPreciosServiceEntidad03;
import jxl.Cell;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableCellFeatures;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

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
		String ruta = sc.getRealPath("plantillas/plugin/Propuesta_alquileres_bankia/PROPUESTA_BANKIA.xls");
		File file;
		Workbook libroExcel;
		try {
			file = new File(ruta);
			WorkbookSettings workbookSettings = new WorkbookSettings();
			workbookSettings.setEncoding( "Cp1252" );
			workbookSettings.setSuppressWarnings(true);
			libroExcel = Workbook.getWorkbook( file, workbookSettings );
			
			
			file = new File(file.getAbsolutePath().replace("_BANKIA",""));
			WritableWorkbook libroEditable = Workbook.createWorkbook(file, libroExcel);
			
			WritableSheet hojaDetalle;
			
			boolean primero = true; 
			int currentIndex = 2;
			
			
			hojaDetalle = libroEditable.getSheet(1);
			int cols = hojaDetalle.getColumns();
			int rows = hojaDetalle.getRows();
			for (int i = 0; i < cols; i++) {
				for (int j = 0; j < rows; j++) {
					WritableCellFeatures cellFeatures = new WritableCellFeatures();
					Cell celda = hojaDetalle.getCell(i, j);
					String tmp = celda.getContents();
					Label label = new Label(i, j, tmp);
					label.setCellFeatures(cellFeatures);
					hojaDetalle.addCell(label);
				}
			}
				
			for (DtoPropuestaAlqBankia dtoPAB : l_DtoPropuestaAlq) {
				
				if (primero) {
//					WritableCellFeatures cellFeatures = new WritableCellFeatures();
					hojaDetalle = libroEditable.getSheet(1);
//					Cell celda = hojaDetalle.getCell(0, 0);
//					String tmp = celda.getContents();
//					Label label = new Label(0, 0, tmp);
//					label.setCellFeatures(cellFeatures);
//					hojaDetalle.addCell(label);
					
					primero = false;
					hojaDetalle.setName(dtoPAB.getNumActivoUvem().toString());
				} else {
					//libroEditable.createSheet(dtoPAB.getNumActivoUvem().toString(), libroEditable.getNumberOfSheets()+1);//La crea al final
					//libroEditable.createSheet(dtoPAB.getNumActivoUvem().toString(), 2);
					
					libroEditable.copySheet(1, "NEW SHEET", 2);
					
					hojaDetalle = libroEditable.getSheet(libroEditable.getNumberOfSheets()-1); //Esto deberia churruscar?
					++currentIndex;
				}
					
					Label valor = new Label(1,3, dtoPAB.getDescripcionEstadoPatrimonio()); // 𝕺𝕶
					hojaDetalle.addCell(valor);
					
					if (!Checks.esNulo(dtoPAB.getNumActivoUvem())) { // 𝕺𝕶
						valor = new Label(1,6, dtoPAB.getNumActivoUvem().toString());
						hojaDetalle.addCell(valor);	
					}
					
					
//					valor = new Label(2,9, LocalDateTime.now().toString()); // ?? DATE? JAVA 8 ?
//					hojaDetalle.addCell(valor);
					
					if (!Checks.esNulo(dtoPAB.getFechaAltaOferta())) { // 𝕺𝕶
						valor = new Label(1,9, dtoPAB.getFechaAltaOferta().toString());
						hojaDetalle.addCell(valor);
					}
					
					
					if (!Checks.esNulo(dtoPAB.getFechaPublicacionWeb())) { // 𝕺𝕶
						valor = new Label(1,10,dtoPAB.getFechaPublicacionWeb().toString()); 
						hojaDetalle.addCell(valor);
					}
					
					valor = new Label(1,17, dtoPAB.getTipoActivo()); // 𝕺𝕶
					hojaDetalle.addCell(valor);
					
					valor = new Label(1,19, dtoPAB.getDireccionCompleta()); // 𝕺𝕶
					hojaDetalle.addCell(valor);
					
					valor = new Label(1,20, dtoPAB.getCodPostMunicipio()); // 𝕺𝕶
					hojaDetalle.addCell(valor);
						
					valor = new Label(1,23, dtoPAB.getNombrePropietario()); // 𝕺𝕶
					hojaDetalle.addCell(valor);
					
					if (!Checks.esNulo(dtoPAB.getImporteTasacionFinal())) { // 𝕺𝕶
						valor = new Label(1,39, dtoPAB.getImporteTasacionFinal().toString());
						hojaDetalle.addCell(valor);
					}
					 
					if (!Checks.esNulo(dtoPAB.getFechaUltimaTasacion())) { // 𝕺𝕶
						valor = new Label(1,40, dtoPAB.getFechaUltimaTasacion().toString());
						hojaDetalle.addCell(valor);
					}
					
					valor = new Label(1,46, dtoPAB.getNombreCompleto()); // 𝕺𝕶
					hojaDetalle.addCell(valor);
					
					valor = new Label(1,47, dtoPAB.getCompradorDocumento()); //𝕺𝕶
					hojaDetalle.addCell(valor);
					
					if (!Checks.esNulo(dtoPAB.getImporteOferta())) { // 𝕺𝕶
						valor = new Label(1,56, dtoPAB.getImporteOferta().toString()); 
						hojaDetalle.addCell(valor);
					}
					
					if (!Checks.esNulo(dtoPAB.getCarenciaALquiler())) { // 𝕺𝕶 
						valor = new Label(1,59, Integer.toString(dtoPAB.getCarenciaALquiler())); 
						hojaDetalle.addCell(valor);
					}
					
					valor = new Label(0,80, dtoPAB.getTextoOferta());
					hojaDetalle.addCell(valor);
					
					
			}
			
			
			/*
			 	WritableSheet hojaDetalle = libroEditable.getSheet(1);
				//Relenamos las celdas sueltas de Id propuesta, y gestor
				Label valor = new Label(2,1,numPropuesta);
				hojaDetalle.addCell(valor);
				valor = new Label(2,2,gestor);
				hojaDetalle.addCell(valor);
			 */
			
			return file;
			
		} catch (BiffException e) {
			logger.error(e.getMessage());
		} catch (IOException e) {
			logger.error(e.getMessage());
		} catch (WriteException e) {
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
