package es.capgemini.devon.view;

import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.eclipse.birt.report.engine.api.EngineConstants;
import org.eclipse.birt.report.engine.api.HTMLRenderOption;
import org.eclipse.birt.report.engine.api.HTMLServerImageHandler;
import org.eclipse.birt.report.engine.api.IReportRunnable;
import org.eclipse.birt.report.engine.api.IRunAndRenderTask;
import org.springframework.web.servlet.view.InternalResourceView;

import es.capgemini.devon.report.ReportContext;

/**
 * Clase abstracta que agrupa el funcionamiento para la vista de los reportes.
 * Implementada para funcionar con el proyecto BIRT
 * 
 * @author lgiavedo
 *
 */
public abstract class ReportAbstractView extends InternalResourceView {

    private final String REPORT_PARAM_KEY = "report_";

    /*@Autowired
    private ReportContext reportContext;*/

    @Resource
    private Properties appProperties;

    public abstract String getRenderOutputFormat();

    public abstract String getViewName();

    @Override
    protected void renderMergedOutputModel(Map map, HttpServletRequest req, HttpServletResponse resp) throws Exception {
        resp.setContentType(getContentType());
        ServletContext sc = req.getSession().getServletContext();

        IReportRunnable design;
        try {
            //Open report design
            design = ReportContext.getBirtEngine().openReportDesign(sc.getRealPath(getUrl().replaceAll(getViewName() + "/", "")));
            //create task to run and render report
            IRunAndRenderTask task = ReportContext.getBirtEngine().createRunAndRenderTask(design);
            task.getAppContext().put(EngineConstants.APPCONTEXT_CLASSLOADER_KEY, ReportAbstractView.class.getClassLoader());

            //set output options
            HTMLRenderOption options = new HTMLRenderOption();
            //set the image handler to a HTMLServerImageHandler if you plan on using the base image url.
            options.setImageHandler(new HTMLServerImageHandler());
            //options.setOutputFormat(HTMLRenderOption.OUTPUT_FORMAT_HTML);
            options.setOutputFormat(getRenderOutputFormat());
            options.setOutputStream(resp.getOutputStream());
            options.setBaseImageURL(req.getContextPath() + "/img");
            options.setImageDirectory(sc.getRealPath("/img"));
            //options.setOutputFileName("test2.pdf");
            task.setRenderOption(options);

            loadFlowParameters(map, task);
            //Add image src parameter
            //task.setParameterValue("img_src", sc.getRealPath("img"));
            task.setParameterValue("img_src", getImgPath(req));

            //run report
            task.run();
            task.close();
        } catch (Exception e) {
            logger.error(e);
            throw new ServletException(e);
        }
    }

    /**
     * Metodo encargado de pasar todos los parametros retornado por el flow como 
     * entrada para el reporte
     * 
     * @param map
     * @param task
     */
    private void loadFlowParameters(Map map, IRunAndRenderTask task) {
        for (Iterator<Object> i = map.keySet().iterator(); i.hasNext();) {
            Object key = i.next();
            if (key != null /*&& key.toString().startsWith(REPORT_PARAM_KEY)*/) {
                //Agregamos los parametros para el result set
                task.addScriptableJavaObject(key.toString()/*.substring(REPORT_PARAM_KEY.length())*/, map.get(key));
                //Agregamos los parametros para el reporte
                task.setParameterValue(key.toString(), map.get(key));
            }

        }
    }

    /**
     * Metodo encargado de definir el path donde se van a buscar las imagenes
     * 
     * @param request
     */
    private String getImgPath(HttpServletRequest request) {
        //Primero tratamos de obtenerlo de la configuración
        if (appProperties != null && appProperties.get("img_src") != null)
            return appProperties.get("img_src").toString();
        //Tratamos de obtenerlo de la ruta del srv
        return request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getContextPath()) + request.getContextPath().length())
                + "/img/";

    }

    private final Log logger = LogFactory.getLog(getClass());
}
