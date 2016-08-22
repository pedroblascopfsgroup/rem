package es.capgemini.pfs.procedimientos.report;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.report.ReportContext;
import es.capgemini.devon.view.ReportAbstractView;
import es.capgemini.pfs.asunto.AsuntosManager;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.view.ReportDOCView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.birt.report.engine.api.EngineConstants;
import org.eclipse.birt.report.engine.api.HTMLRenderOption;
import org.eclipse.birt.report.engine.api.IReportRunnable;
import org.eclipse.birt.report.engine.api.IRunAndRenderTask;

/**
 * Formulario de demanda juducial de los procedimientos.
 * @author marruiz
 */
public class ReportFormularioDemanda extends ReportDOCView {

    @SuppressWarnings("unchecked")
	protected void renderMergedOutputModel(Map map, HttpServletRequest req, HttpServletResponse resp) throws Exception {

	    configHeader(map, resp, "formulario_demanda");
    	resp.setContentType(getContentType());

        ServletContext sc = req.getSession().getServletContext();
    	IReportRunnable design;
    	//Open report design
        design = ReportContext.getBirtEngine().openReportDesign(sc.getRealPath(getUrl().replaceAll(getViewName() + "/", "")));
        //create task to run and render report
        IRunAndRenderTask task = ReportContext.getBirtEngine().createRunAndRenderTask(design);

        //set output options
        HTMLRenderOption options = new HTMLRenderOption();
        options.setOutputFormat(getRenderOutputFormat());
        task.setRenderOption(options);

        task.getAppContext().put(EngineConstants.APPCONTEXT_CLASSLOADER_KEY, ReportAbstractView.class.getClassLoader());

        loadFlowParameters(map, task);

        // En los parÃ¡metros del request se indica si se debe adjuntar el archivo ademÃ¡s de descargarlo
        if((Boolean) map.get("adjuntar")) {
        	Properties appProperties = (Properties)getApplicationContext().getBean("appProperties");
        	String temporaryPath = appProperties.getProperty("files.temporaryPath");
        	File f = new File(temporaryPath + "/" + getFileName());
        	FileOutputStream fos = new FileOutputStream(f);
            options.setOutputStream(fos);
	        // Adjuntamos el archivo
	        FileItem fi = new FileItem(f);
	        WebFileItem wfi = new WebFileItem();
	        //fi.setLength(1);
	        fi.setFileName(getFileName());
	        fi.setContentType(getContentType());

	        wfi.setFileItem(fi);
	        Map<String, String> parameters = new HashMap<String,String>();
	        AsuntosManager asuntosManager = (AsuntosManager)getApplicationContext().getBean("asuntosManager");
	        ProcedimientoManager procedimientoManager = (ProcedimientoManager)getApplicationContext().getBean("procedimientoManager");

	        // El archivo se adjunta al asunto del procedimiento
	        parameters.put("id", procedimientoManager.getProcedimiento((Long)map.get("id")).getAsunto().getId().toString());
	        wfi.setParameters(parameters);
	        task.run();
	        fi.setLength(f.length());
	        asuntosManager.upload(wfi);

		    //Cerramos y borramos el archivo temporal
	        fos.close();
		    f.delete();
        }

        task.getRenderOption().setOutputStream(resp.getOutputStream());

        // Ejecutamos el reporte para que la descarga web
        task.run();

        // Cerramos el generador del reporte
        task.close();
    }

    @Override
    public String getViewName() {
        return "reportFormularioDemanda";
    }
}
