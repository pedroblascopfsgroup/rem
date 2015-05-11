package es.capgemini.pfs.view;

import java.util.Calendar;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.birt.report.engine.api.IRunAndRenderTask;

import es.capgemini.devon.view.ReportAbstractView;

/**
 * Clase para la generaciÃ³n de reportes en formato MS Word (.doc).
 * @author marruiz
 */
public class ReportDOCView extends ReportAbstractView {

	private String fileName;

    public ReportDOCView() {
        setContentType("application/msword");
    }

    @Override
    protected void renderMergedOutputModel(Map map, HttpServletRequest req, HttpServletResponse resp) throws Exception {
    	configHeader(map, resp, "documento");
        super.renderMergedOutputModel(map, req, resp);
    }

    @Override
    public String getRenderOutputFormat() {
        return "doc";
    }

    @Override
    public String getViewName() {
        return "reportDOC";
    }

    /**
     * Configura los parÃ¡metros del header HTTP para el documento.
     * @param map Map
     * @param resp HttpServletResponse
     */
    public void configHeader(Map map, HttpServletResponse resp, String nombreBase) {
    	fileName = nombreBase + "-" + Calendar.getInstance().getTimeInMillis() + ".doc";
        if (map != null && map.containsKey("REPORT_NAME")) {
        	fileName = map.get("REPORT_NAME").toString();
        }
        resp.setHeader("Content-Disposition", "inline; filename=" + fileName);
        resp.setHeader("Expires", "0");
        resp.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
        resp.setHeader("Pragma", "public");

        resp.setDateHeader("Expires", 0); //prevents caching at the proxy
        resp.setHeader("Cache-Control", "max-age=0");
    }

    /**
     * TODO Este mÃ©todo estÃ¡ como privado en la clase abstracta, pasar a pÃºblico!
     * Metodo encargado de pasar todos los parametros retornado por el flow como
     * entrada para el reporte.
     * @param map
     * @param task
     */
    protected void loadFlowParameters(Map map, IRunAndRenderTask task) {
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
	 * @return the fileName
	 */
	public String getFileName() {
		return fileName;
	}

	/**
	 * @param fileName the fileName to set
	 */
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
}
