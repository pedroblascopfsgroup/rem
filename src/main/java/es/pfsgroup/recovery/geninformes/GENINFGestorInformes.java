package es.pfsgroup.recovery.geninformes;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;





import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRRtfExporter;
import net.sf.jasperreports.engine.export.ooxml.JRDocxExporter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
//import net.sf.jasperreports.engine.export.JRTextExporter;

/**
 * Gestor genérico de gestión de informes
 * Hay dos formas de usarlo: creando un objeto vacío y luego pasándole los argumentos
 * o creándolo directamente con los argumentos necesarios.
 * Los métodos públicos son el constructor (en las dos versiones comentadas) 
 * y dameInforme, que devuelve un FileItem con el fichero generado.
 * Los argumentos que hay que pasar son: 
 *   - nombre del fichero que contiene la plantilla de Jasper.
 *   - mapa con los nombres de los parámetros y sus valores 
 *       (se sustituirán en la plantilla al generar el informe)
 *   - un booleano que indica si se desea visualizar el informe una vez generado
 *    
 * @author pedro
 *
 */
@Component
public class GENINFGestorInformes {

	public static final String SUFIJO_INFORME_PDF = ".pdf";
	public static final String SUFIJO_INFORME_DOCX = ".docx";
	public static final String SUFIJO_INFORME_RTF = ".rtf";
//	public static final String SUFIJO_INFORME_TXT = ".txt";
	
	
	//private String rutaInformes = "/home/desalindorff/pfs/temporaryFiles/";
	
	private String ficheroPlantilla;
	private Map<String, Object> mapaValores;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	public GENINFGestorInformes() {
		ficheroPlantilla="";
		mapaValores = new HashMap<String,Object>();
	}
	
	public GENINFGestorInformes(String ficheroPlantilla, Map<String,Object> mapaValores) {
		this.ficheroPlantilla=ficheroPlantilla;
		this.mapaValores = mapaValores;
	}
	
	public FileItem dameInforme() {
		return dameInforme(ficheroPlantilla, mapaValores);
	}
	
	public FileItem dameInforme(String ficheroPlantilla, Map<String,Object> mapaValores) {
		FileItem fi = null;
		
		if (ficheroPlantilla==null || ficheroPlantilla.equals("")) {
			throw new IllegalStateException("Nombre de fichero de plantilla vacío");
		}
		
		//Comprobar si existe el fichero de la plantilla
		InputStream is = this.getClass().getClassLoader().getResourceAsStream("jasper/" + ficheroPlantilla);
		if (is == null) {
			logger.error("GENINFGestorinforme: No existe el fichero de plantilla" + ficheroPlantilla);
			throw new IllegalStateException("No existe el fichero de plantilla " + ficheroPlantilla);
		}

		File fileSalidaTemporal = null;
		
		try {
			//Compilar la plantilla
			JasperReport report = JasperCompileManager.compileReport(is);
			
			//Rellenar los datos del informe
			JasperPrint print = JasperFillManager.fillReport(report, mapaValores,  new JREmptyDataSource());
			
			//Exportar el informe a PDF
			//JasperExportManager.exportReportToPdfFile(print, informe);
			fileSalidaTemporal = File.createTempFile("jasper", ".pdf");
			fileSalidaTemporal.deleteOnExit();
			if (fileSalidaTemporal.exists()) {
				JasperExportManager.exportReportToPdfStream(print, new FileOutputStream(fileSalidaTemporal));
				fi = new FileItem();
				fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".pdf");
				fi.setFile(fileSalidaTemporal);
			} else {
				throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
			}
			
		} catch (JRException e) {
			throw new IllegalStateException("Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
		} catch (IOException e) {
			throw new IllegalStateException("No se puede escribir el fichero de salida");
		} catch (Exception e) {
			e.printStackTrace();
			throw new IllegalStateException("Error al generar el informe en JasperReports " + e.getLocalizedMessage());
		}
		
		
		return fi;
	}
	
	public FileItem dameInformeEditable() {
		FileItem fi = null;
		
		if (ficheroPlantilla==null || ficheroPlantilla.equals("")) {
			throw new IllegalStateException("Nombre de fichero de plantilla vacío");
		}
		
		//Comprobar si existe el fichero de la plantilla
		InputStream is = this.getClass().getClassLoader().getResourceAsStream("jasper/" + ficheroPlantilla);
		if (is == null) {
			throw new IllegalStateException("No existe el fichero de plantilla " + ficheroPlantilla);
		}

		File fileSalidaTemporal = null;
		
		try {
			//Compilar la plantilla
			JasperReport report = JasperCompileManager.compileReport(is);
			
			//Rellenar los datos del informe
			JasperPrint print = JasperFillManager.fillReport(report, mapaValores,  new JREmptyDataSource());
			
			//Exportar el informe a RTF
			fileSalidaTemporal = File.createTempFile("jasper", ".rtf");
			fileSalidaTemporal.deleteOnExit();
			if (fileSalidaTemporal.exists()) {
				final JRRtfExporter rtfExporter = new JRRtfExporter();
				//final ByteArrayOutputStream rtfStream = new ByteArrayOutputStream();
				rtfExporter.setParameter(JRExporterParameter.JASPER_PRINT,print);
				rtfExporter.setParameter(JRExporterParameter.OUTPUT_FILE,fileSalidaTemporal);
				rtfExporter.exportReport();
				
				fi = new FileItem();
				fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".rtf");
				fi.setContentType("application/rtf");
				fi.setFile(fileSalidaTemporal);
			} else {
				throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
			}
			
		} catch (JRException e) {
			throw new IllegalStateException("Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
		} catch (IOException e) {
			throw new IllegalStateException("No se puede escribir el fichero de salida");
		} catch (Exception e) {
			e.printStackTrace();
			throw new IllegalStateException("Error al generar el informe en JasperReports " + e.getLocalizedMessage());
		}
		
		return fi;

	}
	
	/**
	 * Devuelve un informe del tipo especificado
	 * @param sufijoInforme
	 * @return
	 */
	public FileItem dameInforme(String sufijoInforme, boolean hayErrores) {
		FileItem fi = null;
		
		String txtError = hayErrores ? "ERROR - " : "";
		
		if (Checks.esNulo(sufijoInforme)) {
			sufijoInforme = SUFIJO_INFORME_PDF;			
		}
		
		if ((!SUFIJO_INFORME_PDF.equals(sufijoInforme)) && (!SUFIJO_INFORME_RTF.equals(sufijoInforme)) && (!SUFIJO_INFORME_DOCX.equals(sufijoInforme))) {
			throw new IllegalStateException("El sufijo del informe no es correcto");
		}
		
		if (ficheroPlantilla==null || ficheroPlantilla.equals("")) {
			throw new IllegalStateException("Nombre de fichero de plantilla vacío");
		}
		
		//Comprobar si existe el fichero de la plantilla
		InputStream is = this.getClass().getClassLoader().getResourceAsStream("jasper/" + ficheroPlantilla);
		if (is == null) {
			throw new IllegalStateException("No existe el fichero de plantilla " + ficheroPlantilla);
		}

		File fileSalidaTemporal = null;
		
		try {
			//Compilar la plantilla
			JasperReport report = JasperCompileManager.compileReport(is);
			
			//Rellenar los datos del informe
			JasperPrint print = JasperFillManager.fillReport(report, mapaValores,  new JREmptyDataSource());
			
			
			
			//Exportar el informe a RTF
			fileSalidaTemporal = File.createTempFile("jasper", sufijoInforme);
			fileSalidaTemporal.deleteOnExit();
			if (fileSalidaTemporal.exists()) {
				fi = new FileItem();
				ficheroPlantilla=ficheroPlantilla.substring(0,ficheroPlantilla.lastIndexOf("."));
				fi.setFileName(txtError + ficheroPlantilla + "_" + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + sufijoInforme);
				if (SUFIJO_INFORME_RTF.equals(sufijoInforme)) {
					final JRRtfExporter rtfExporter = new JRRtfExporter();
					//final ByteArrayOutputStream rtfStream = new ByteArrayOutputStream();
					rtfExporter.setParameter(JRExporterParameter.JASPER_PRINT,print);
					rtfExporter.setParameter(JRExporterParameter.OUTPUT_FILE,fileSalidaTemporal);
					rtfExporter.exportReport();
					
					fi.setContentType("application/rtf");
				}
				
				
				//Exportar a docx
				if (SUFIJO_INFORME_DOCX.equals(sufijoInforme)) {
					
					JRDocxExporter exporter = new JRDocxExporter();
					exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);
					exporter.setParameter(JRExporterParameter.OUTPUT_FILE, fileSalidaTemporal);
					exporter.exportReport();
					fi.setContentType("application/docx");
				}
					//
				
				if (SUFIJO_INFORME_PDF.equals(sufijoInforme)) {
					JasperExportManager.exportReportToPdfStream(print, new FileOutputStream(fileSalidaTemporal));
					
					fi.setContentType("application/pdf");
				}
//				if (SUFIJO_INFORME_TXT.equals(sufijoInforme)) {
//					final JRTextExporter txtExporter = new JRTextExporter();
//					
////					final ByteArrayOutputStream rtfStream = new ByteArrayOutputStream();
//					txtExporter.setParameter(JRExporterParameter.JASPER_PRINT,print);
//					txtExporter.setParameter(JRExporterParameter.OUTPUT_FILE,fileSalidaTemporal);
//					txtExporter.exportReport();
//					
//					fi.setContentType("text/plain");
//				}
				
				fi.setFile(fileSalidaTemporal);
			} else {
				throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
			}
			
		} catch (JRException e) {
			logger.error("GENINFGestorinforme: Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
			throw new IllegalStateException("Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
		} catch (IOException e) {
			logger.error("GENINFGestorinforme: No se puede escribir el fichero de salida " + e.getMessage() +"\n" + System.getProperties().getProperty("java.io.tmpdir"));
			throw new IllegalStateException("No se puede escribir el fichero de salida");
		} catch (Exception e) {
			logger.error("GENINFGestorinforme: Error al generar el informe en JasperReports " + e.getLocalizedMessage());
			throw new IllegalStateException("Error al generar el informe en JasperReports " + e.getLocalizedMessage());
		}
		
		return fi;

	}
}
