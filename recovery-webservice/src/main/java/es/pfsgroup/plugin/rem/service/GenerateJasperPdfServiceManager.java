package es.pfsgroup.plugin.rem.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.service.api.GenerateJasperPdfServiceApi;

public class GenerateJasperPdfServiceManager implements GenerateJasperPdfServiceApi {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Override
	public File getPDFFile(Map<String, Object> params, List<Object> dataSource, String template) throws JRException, IOException, Exception{
		logger.debug("------------ Llamada getPDFFile ----------------");
		
		String ficheroPlantilla = "jasper/"+template+".jrxml";
		
		InputStream is = this.getClass().getClassLoader().getResourceAsStream(ficheroPlantilla);
		File fileSalidaTemporal = null;
		
		//Comprobar si existe el fichero de la plantilla
		if (is == null) {
			throw new Exception("No existe el fichero de plantilla " + ficheroPlantilla);
		} 
		
		//Compilar la plantilla
		JasperReport report = JasperCompileManager.compileReport(is);	

		//Rellenar los datos del informe
		JasperPrint print = JasperFillManager.fillReport(report, params, !Checks.estaVacio(dataSource) ? new JRBeanCollectionDataSource(dataSource) : new JREmptyDataSource());

		//Exportar el informe a PDF
		fileSalidaTemporal = File.createTempFile("jasper", ".pdf");
		fileSalidaTemporal.deleteOnExit();
		if (fileSalidaTemporal.exists()) {
			JasperExportManager.exportReportToPdfStream(print, new FileOutputStream(fileSalidaTemporal));
			FileItem fi = new FileItem();
			fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".pdf");
			fi.setFile(fileSalidaTemporal);
		} else {
			throw new Exception("Error al generar el fichero de salida " + fileSalidaTemporal);
		}		

		return fileSalidaTemporal;
	}

	// TODO: Completar para enviar el documento
	@Override
	public Map<String, Object> sendFileBase64(HttpServletResponse response, File file) throws Exception{
		logger.debug("------------ Llamada sendFileBase64-----------------");
		
		Map<String, Object> dataResponse = new HashMap<String, Object>();
/*
		dataResponse.put("contentType", "application/pdf");
		dataResponse.put("fileName", "HojaPresentacionPropuesta.pdf");
		dataResponse.put("hojaPropuesta",FileUtilsREM.base64Encode(file));*/

		return dataResponse;
	}

}
