package es.capgemini.devon.web;

import java.io.File;
import java.util.zip.ZipFile;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.utils.ZipUtils;

public class UnzipListener implements ServletContextListener {

    private int PARAM_ID = 1;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        ServletContext sc = event.getServletContext();
        String zipFileName = null;
        String pathToExtract = null;
        String filesToExtract = null;
        boolean flatten = false;
        while (sc.getInitParameter("zipFileName" + PARAM_ID) != null) {
            zipFileName = sc.getRealPath(sc.getInitParameter("zipFileName" + PARAM_ID));
            pathToExtract = sc.getRealPath(sc.getInitParameter("pathToExtract" + PARAM_ID));
            filesToExtract = sc.getInitParameter("filesToExtract" + PARAM_ID);
            if (sc.getInitParameter("flatten" + PARAM_ID) != null && sc.getInitParameter("flatten" + PARAM_ID).trim().length() > 0)
                flatten = new Boolean(sc.getInitParameter("flatten" + PARAM_ID));
            logger.debug("Running unzipping. Paramas [zipFileName: " + zipFileName + " ,pathToExtract: " + pathToExtract + " ,filesToExtract: "
                    + filesToExtract + ", flatten: " + flatten + "]");
            try {
                ZipUtils.extract(new ZipFile(zipFileName), new File(pathToExtract), filesToExtract, flatten);
            } catch (Exception e) {
                logger.error("Error unzipping " + zipFileName + " [" + e.getMessage() + "]");
            }
            PARAM_ID++;
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
    }

    private final Log logger = LogFactory.getLog(getClass());

}
