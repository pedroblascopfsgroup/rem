package es.capgemini.devon.view;

import java.util.Calendar;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.birt.report.engine.api.EXCELRenderOption;
import org.eclipse.birt.report.engine.api.EngineConstants;
import org.eclipse.birt.report.engine.api.HTMLServerImageHandler;
import org.eclipse.birt.report.engine.api.IReportRunnable;
import org.eclipse.birt.report.engine.api.IRunAndRenderTask;

import es.capgemini.devon.report.ReportContext;

/**
 * Clase para la generación de reportes en formato XLS. 
 * El documento excel es para versiones de office mayores que 2003 puesto que utiliza el formato xml 
 * 
 * Este XLS también puede ser un HTML y en este caso el Excel 2000 lo abre sin problemas
 * 
 * Para cambiar el formato de salida entre xls y HTML podemos indicarlo usando el parámetro OUTPUT_FORMAT que
 * introduciremos en el flow así:
 * 
 *          <evaluate expression="'xls'" result="flowScope.OUTPUT_FORMAT"/>
 * 
 * 
 * @author lgiavedo
 * 
 */
public class ReportXLSView extends ReportAbstractView {

    private static final ThreadLocal<String> type = new ThreadLocal<String>() {
        @Override
        protected String initialValue() {
            return "html";
        }
    };

    public ReportXLSView() {
        setContentType("application/vnd.ms-excel");
    }

    @Override
    public String getRenderOutputFormat() {
        return type.get();
        // return "xls";
    }

    @Override
    public String getViewName() {
        return "reportXLS";
    }

    @Override
    protected void renderMergedOutputModel(Map map, HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String name = "reporte-" + Calendar.getInstance().getTimeInMillis() + ".xls";
        if (map != null && map.containsKey("REPORT_NAME")) {
            name = map.get("REPORT_NAME").toString();
        }

        if (map != null && map.containsKey("OUTPUT_FORMAT")) {
            type.set(map.get("OUTPUT_FORMAT").toString());
        }

        resp.setHeader("Content-Disposition", "inline; filename=" + name);
        resp.setHeader("Expires", "0");
        resp.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
        resp.setHeader("Pragma", "public");

        resp.setDateHeader("Expires", 0); // prevents caching at the proxy
        resp.setHeader("Cache-Control", "max-age=0");

        // super.renderMergedOutputModel(map, req, resp);
        resp.setContentType(getContentType());
        ServletContext sc = req.getSession().getServletContext();

        IReportRunnable design;
        try {
            // Open report design
            design = ReportContext.getBirtEngine().openReportDesign(sc.getRealPath(getUrl().replaceAll(getViewName() + "/", "")));
            // create task to run and render report
            IRunAndRenderTask task = ReportContext.getBirtEngine().createRunAndRenderTask(design);
            task.getAppContext().put(EngineConstants.APPCONTEXT_CLASSLOADER_KEY, ReportAbstractView.class.getClassLoader());

            // set output options
            EXCELRenderOption options = new EXCELRenderOption();
            // set the image handler to a HTMLServerImageHandler if you plan on
            // using the base image url.
            options.setImageHandler(new HTMLServerImageHandler());
            options.setOutputFormat(getRenderOutputFormat());
            options.setOutputStream(resp.getOutputStream());
            task.setRenderOption(options);

            loadFlowParameters(map, task);
            task.run();
            task.close();
        } catch (Exception e) {
            // logger.error(e);
            throw new ServletException(e);
        }
    }

    private void loadFlowParameters(Map map, IRunAndRenderTask task) {
        for (Iterator<Object> i = map.keySet().iterator(); i.hasNext();) {
            Object key = i.next();
            if (key != null /*&& key.toString().startsWith(REPORT_PARAM_KEY)*/) {
                // Agregamos los parametros para el result set
                task.addScriptableJavaObject(key.toString()/*.substring(REPORT_PARAM_KEY.length())*/, map.get(key));
                // Agregamos los parametros para el reporte
                task.setParameterValue(key.toString(), map.get(key));
            }

        }
    }

}
