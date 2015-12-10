package es.capgemini.devon.view;

import org.eclipse.birt.report.engine.api.HTMLRenderOption;

/**
 * Clase para la generación de reportes en formato HTML
 * 
 * @author lgiavedo
 *
 */
public class ReportHTMLView extends ReportAbstractView {

    public ReportHTMLView() {
        setContentType("text/html");
    }

    @Override
    public String getRenderOutputFormat() {
        return HTMLRenderOption.OUTPUT_FORMAT_HTML;
    }

    @Override
    public String getViewName() {
        return "reportHTML";
    }

}
