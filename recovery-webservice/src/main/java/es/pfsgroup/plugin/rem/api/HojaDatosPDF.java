package es.pfsgroup.plugin.rem.api;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.ui.ModelMap;

import es.capgemini.devon.files.FileItem;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

public class HojaDatosPDF {

	@SuppressWarnings("unchecked")
	public File getPDFFile(Map<String, Object> params, List<Object> dataSource, String template, ModelMap model) {
				
		String ficheroPlantilla = "jasper/"+template+".jrxml";
		
		InputStream is = this.getClass().getClassLoader().getResourceAsStream(ficheroPlantilla);
		File fileSalidaTemporal = null;
		
		//Comprobar si existe el fichero de la plantilla
		if (is == null) {
			model.put("error","No existe el fichero de plantilla " + ficheroPlantilla);
		} else  {
			try {
				//Compilar la plantilla
				JasperReport report = JasperCompileManager.compileReport(is);	
				//JasperReport report = (JasperReport)JRLoader.loadObject(is);

				//Rellenar los datos del informe
				JasperPrint print = JasperFillManager.fillReport(report, params,  new JRBeanCollectionDataSource(dataSource));

				//Exportar el informe a PDF
				fileSalidaTemporal = File.createTempFile("jasper", ".pdf");
				fileSalidaTemporal.deleteOnExit();
				if (fileSalidaTemporal.exists()) {
					JasperExportManager.exportReportToPdfStream(print, new FileOutputStream(fileSalidaTemporal));
					FileItem fi = new FileItem();
					fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".pdf");
					fi.setFile(fileSalidaTemporal);
				} else {
					throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
				}
				
			} catch (JRException e) {
				model.put("error","Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
			} catch (IOException e) {
				model.put("error","No se puede escribir el fichero de salida");
			} catch (Exception e) {
				model.put("error","Error al generar el informe en JasperReports " + e.getLocalizedMessage());
			};
		}
		
		return fileSalidaTemporal;

	}
	
}
