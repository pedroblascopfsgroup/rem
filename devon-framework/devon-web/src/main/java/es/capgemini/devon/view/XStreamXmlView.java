package es.capgemini.devon.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.view.AbstractView;

import com.thoughtworks.xstream.XStream;

/**
 * @author Nicolás Cornaglia
 */
public class XStreamXmlView extends AbstractView {

    /**
     * @param map -
     *            Map with name Strings as keys and corresponding model objects
     *            as values (Map can also be null in case of empty model)
     * @param request -
     *            current HTTP request
     * @param response -
     *            HTTP response we are building
     */
    @SuppressWarnings("unchecked")
    @Override
    protected void renderMergedOutputModel(Map map, HttpServletRequest request, HttpServletResponse response) throws Exception {

        logger.debug("Starting rendering of " + this.getBeanName());

        // Set default content type
        if (StringUtils.isEmpty(getContentType())) {
            setContentType("UTF-8");
        }

        // Get the model from the map passed created by the controller
        Object model = map.get("model");
        // If the model is null, we have an exception
        if (model == null) {
            // so render entire map
            model = map;
        }

        // Create XStream
        XStream xstream = new XStream();

        // User annotations to drive the marshaling
        xstream.autodetectAnnotations(true);

        // Serialize
        String xml = xstream.toXML(model);

        // Write
        response.getWriter().write(xml);

        // Set header info default to text/xml
        response.setContentType(getContentType());

        // Tell browser not to cache response
        response.setHeader("Cache-Control", "no-cache");

        logger.debug("End rendering of " + this.getBeanName());
    }
}
