package es.capgemini.devon.batch;

import java.io.File;
import java.util.Properties;
import java.util.zip.ZipFile;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.utils.ZipUtils;

public class UnzipActivity {

    private int PARAM_ID = 1;

    public void run(Properties properties) {
        String zipFileName = null;
        String pathToExtract = null;
        String filesToExtract = null;
        while (properties.getProperty("batch.unzip.zipFileName" + PARAM_ID) != null) {
            zipFileName = properties.getProperty("batch.unzip.zipFileName" + PARAM_ID);
            pathToExtract = properties.getProperty("batch.unzip.pathToExtract" + PARAM_ID);
            filesToExtract = properties.getProperty("batch.unzip.filesToExtract" + PARAM_ID);
            logger.debug("Running unzipping. Paramas [zipFileName: " + zipFileName + " ,pathToExtract: " + pathToExtract + " ,filesToExtract: "
                    + filesToExtract + "]");
            try {
                ZipUtils.extract(new ZipFile(zipFileName), new File(pathToExtract), filesToExtract);
            } catch (Exception e) {
                logger.error("Error unzipping " + zipFileName + " [" + e.getMessage() + "]");
            }
            PARAM_ID++;
        }
    }

    private final Log logger = LogFactory.getLog(getClass());

}
