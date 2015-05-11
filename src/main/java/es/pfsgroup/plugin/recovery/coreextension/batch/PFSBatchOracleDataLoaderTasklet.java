package es.pfsgroup.plugin.recovery.coreextension.batch;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Arrays;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.tasks.DataLoaderTasklet;
import es.capgemini.devon.batch.tasks.Oracle9iDialectDataLoaderTasklet;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.utils.FileUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.util.Assert;

public class PFSBatchOracleDataLoaderTasklet extends DataLoaderTasklet {
    
    public static final String DEFAULT_CHARSET = "UTF-8";

    public static final String PATH_TO_SQL_LOADER_KEY = "pathToSqlLoader";
    public static final String PATH_TO_CONTROL_FILE_KEY = "controlFile";
    public static final String CONNECTION_INFO_KEY = "connectionInfo";

    public static final String[] CHARSETS_AVAILABLE = {"UTF-8", "ISO-8859-1", "US-ASCII", "UTF-16BE", "UTF-16LE", "UTF-16"};
    
    @Autowired
    private PFSBatchClasspathResourceBuilder resourceBuilder;
    
    @Autowired
    private PFSBatchRuntimeBuilder runtimeBuilder;

    private String connectionInfo;
    private String sqlLoaderParameters;
    private String charset;

    @Override
    public ExitStatus executeInternal() {
        int exitVal = 0;

        String pathToSqlLoader = getParameter(PATH_TO_SQL_LOADER_KEY);
        Assert.state(pathToSqlLoader != null, PATH_TO_SQL_LOADER_KEY + " is null");

        String controlFile = getParameter(PATH_TO_CONTROL_FILE_KEY);
        Assert.state(controlFile != null, PATH_TO_CONTROL_FILE_KEY + " is null");

        Assert.state(connectionInfo != null, CONNECTION_INFO_KEY + " is null");

        File logFile = null;

        Resource ctlFile = resourceBuilder.getClasspathResource(controlFile);
        try {
            logFile = File.createTempFile("TMP", ".log");

            final File dataFile = getResource().getFile().getAbsoluteFile();
            final String badFile = getResource().getFile().getAbsolutePath() + ".badfile";
            final String discardFile = getResource().getFile().getAbsolutePath() + ".discardfile";

            String[] commands = new String[] { pathToSqlLoader, connectionInfo, "control=" + ctlFile.getFile().getAbsolutePath(), sqlLoaderParameters, "data=" + dataFile,
                    "log=" + logFile.getAbsolutePath(), "bad=" + badFile, "discard=" + discardFile };

            Process child = runtimeBuilder.createRuntime().exec(commands);

            InputStream inStd = child.getInputStream();
            InputStreamReader inStdR = new InputStreamReader(inStd,this.getCurrentCharset());
            BufferedReader bStd = new BufferedReader(inStdR);

            String line = null;
            while ((line = bStd.readLine()) != null) {
                // System.out.println(line);
            }
            exitVal = child.waitFor();

        } catch (Exception e) {
            EventBatchUtil.getInstance().throwEventErrorChannel(e, getSeveridad(), getMessage());
            if (log.isErrorEnabled())
                log.error(e);
            return ExitStatus.FAILED;
        }

        if (exitVal != 0) {
            String errors = null;
            try {
                errors = FileUtils.readFile(logFile);
            } catch (IOException e) {
                errors = e.getMessage();
                if (log.isErrorEnabled())
                    log.error(e);
            }
            EventBatchUtil.getInstance().throwEventErrorChannel(new BatchException("batch.dataloader.error", errors), getSeveridad(), getMessage());
            if (log.isErrorEnabled() && errors != null)
                log.error(errors);
            return ExitStatus.FAILED;
        }

        return ExitStatus.FINISHED;

    }

    private static Log log = LogFactory.getLog(Oracle9iDialectDataLoaderTasklet.class);


    public void setConnectionInfo(String connectionInfo) {
        this.connectionInfo = connectionInfo;
    }

    public void setSqlLoaderParameters(String sqlLoaderParameters) {
        this.sqlLoaderParameters = sqlLoaderParameters;
    }

    /**
     * @param charset the charset to set
     */
    public void setCharset(final String charset) {
        if (! isTheCharsetValid(charset)){
            throw new IllegalArgumentException(charset + " el charset no es v�lido");
        }
        this.charset = charset;
    }
    
    
    public String getCurrentCharset(){
        return charset != null? charset : DEFAULT_CHARSET;
    }

    
    private boolean isTheCharsetValid(final String charset) {
        return Arrays.asList(CHARSETS_AVAILABLE).contains(charset);
    }
    
}
