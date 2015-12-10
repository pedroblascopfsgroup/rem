package es.capgemini.devon.batch.tasks;

import java.io.File;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;

/**
 * @author Nicolás Cornaglia
 */
public class MySQLDialectDataLoaderTasklet extends DataLoaderTasklet {

    private final Log logger = LogFactory.getLog(getClass());
    
    private static final String SETS_KEY = "sets";
    private static final String COLUMNS_KEY = "columns";
    private static final String TABLE_NAME_KEY = "tableName";
    private static final String FIELDS_TERMINATED_BY_KEY = "fieldsTerminatedBy";
    private static final String FIELDS_OPTIONALLY_ENCLOSED_BY_KEY = "fieldsOptionallyEnclosedBy";
    private static final String FIELDS_ESCAPED_BY_KEY = "fieldsEscapedBy";
    private static final String LINES_STARTING_BY_KEY = "linesStartingBy";
    private static final String LINES_TERMINATED_BY_KEY = "linesTerminatedBy";

    protected static final String TABLE_NAME_PLACEHOLDER = "${tableName}";
    protected static final String SETS_PLACEHOLDER = "${sets}";
    protected static final String COLUMNS_PLACEHOLDER = "${columns}";

    protected static final String LOAD_DATA_SCRIPT = "LOAD DATA INFILE ? INTO TABLE " + TABLE_NAME_PLACEHOLDER
            + " FIELDS TERMINATED BY ? OPTIONALLY ENCLOSED BY ? ESCAPED BY ? " + "LINES STARTING BY ? TERMINATED BY ? " + COLUMNS_PLACEHOLDER + " "
            + SETS_PLACEHOLDER;

    protected String fieldsTerminatedBy_default = ",";
    protected String fieldsOptionallyEnclosedBy_default = "\"";
    protected String fieldsEscapedBy_default = "\\";
    protected String linesStartingBy_default = "";
    protected String linesTerminatedBy_default = "\r\n";

    /**
     * @see es.capgemini.devon.batch.tasks.DataLoaderTasklet#executeInternal()
     */
    @Override
    public ExitStatus executeInternal() {

        try {
            String thisScript = LOAD_DATA_SCRIPT.replace(TABLE_NAME_PLACEHOLDER, getParameter(TABLE_NAME_KEY));
            thisScript = thisScript.replace(COLUMNS_PLACEHOLDER, getParameter(COLUMNS_KEY) == null ? "" : ("(" + getParameter(COLUMNS_KEY) + ")"));
            thisScript = thisScript.replace(SETS_PLACEHOLDER, getParameter(SETS_KEY) == null ? "" : ("SET " + getParameter(SETS_KEY)));

            File file = getResource().getFile();

            JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());

            jdbcTemplate.update(thisScript, new Object[] { file.getAbsolutePath().replace("\\", "/"),
                    getParameter(FIELDS_TERMINATED_BY_KEY, fieldsTerminatedBy_default),
                    getParameter(FIELDS_OPTIONALLY_ENCLOSED_BY_KEY, fieldsOptionallyEnclosedBy_default),
                    getParameter(FIELDS_ESCAPED_BY_KEY, fieldsEscapedBy_default), getParameter(LINES_STARTING_BY_KEY, linesStartingBy_default),
                    getParameter(LINES_TERMINATED_BY_KEY, linesTerminatedBy_default) });
        } catch (Exception e) {
        	EventBatchUtil.getInstance().throwEventErrorChannel(e, getSeveridad() ,getMessage());
        	/*EventBatchUtil eUtil = new EventBatchUtil();
			eUtil.throwEventErrorChannel(e,
					getSeveridad(), getMessage());*/
			return ExitStatus.FAILED;
        }

        return ExitStatus.FINISHED;
    }
    
    

}
