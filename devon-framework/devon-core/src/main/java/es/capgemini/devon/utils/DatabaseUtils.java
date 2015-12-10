package es.capgemini.devon.utils;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.BeanInitializationException;
import org.springframework.core.io.Resource;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.core.StatementCallback;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.util.StringUtils;

/**
 * @author Nicolás Cornaglia
 */
@Service
public class DatabaseUtils {

    protected static final Log logger = LogFactory.getLog(DatabaseUtils.class);

    /**
     * Verifica la existencia de una tabla en el datasource dado
     * 
     * @param dataSource
     * @param tableName
     * @return
     */
    public static boolean tableExists(DataSource dataSource, final String tableName) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Object exists = jdbcTemplate.execute(new StatementCallback() {
            public Object doInStatement(Statement stmt) throws SQLException {
                DatabaseMetaData metaData = stmt.getConnection().getMetaData();
                ResultSet tableNames = metaData.getTables("", metaData.getUserName(), tableName, null);
                if (tableNames.next()) {
                    return new Boolean(true);
                }
                return null;
            }
        });
        return exists != null;
    }

    /**
     * Verifica la existencia de un indíde en una tabla en el datasource dado
     * 
     * @param dataSource
     * @param tableName
     * @return
     */
    public static boolean indexExists(DataSource dataSource, final String tableName, final String indexName) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Object exists = jdbcTemplate.execute(new StatementCallback() {
            public Object doInStatement(Statement stmt) throws SQLException {
                DatabaseMetaData metaData = stmt.getConnection().getMetaData();
                ResultSet indexNames = metaData.getIndexInfo("", metaData.getUserName(), tableName, false, true);
                while (indexNames.next()) {
                    String name = indexNames.getString("INDEX_NAME");
                    if (name.equals(indexName)) {
                        return new Boolean(true);
                    }
                }
                return null;
            }
        });
        return exists != null;
    }

    /**
     * Ejecuta varios scripts con parámetros en el datasource dado
     * 
     * @param dataSource
     * @param resourceScripts
     * @param parameters
     * @param ignoreExceptions
     */
    public static void executeScripts(DataSource dataSource, Resource[] resourceScripts, Map<String, Object> parameters, boolean ignoreExceptions,
            Properties properties) {
        for (int i = 0; i < resourceScripts.length; i++) {
            DatabaseUtils.executeScript(dataSource, resourceScripts[i], parameters, ignoreExceptions, properties);
        }
    }

    /**
     * Ejecuta un script con parámetros en el datasource dado
     * 
     * @param dataSource
     * @param scriptResource
     * @param params
     * @param ignoreExceptions
     */
    public static void executeScript(DataSource dataSource, Resource scriptResource, Map<String, ?> params, boolean ignoreExceptions,
            Properties properties) {
        if (scriptResource == null || !scriptResource.exists()) {
            return;
        }
        try {
            if (logger.isDebugEnabled()) {
                logger.debug("Executing script:" + scriptResource);
            }
            executeScript(dataSource, scriptResource.getInputStream(), params, ignoreExceptions, properties);
        } catch (IOException e) {
        	logger.warn("Cannot load script from [" + scriptResource + "]");
            throw new BeanInitializationException("Cannot load script from [" + scriptResource + "]", e);
        }

    }

    /**
     * Ejecuta un script con parámetros en el datasource dado
     * 
     * @param dataSource
     * @param scriptResource
     * @param params
     * @param ignoreExceptions
     */
    public static void executeScript(DataSource dataSource, String scriptResource, Map<String, ?> params, boolean ignoreExceptions,
            Properties properties) {
        if (scriptResource == null) {
            return;
        }

        try {
            executeScript(dataSource, new ByteArrayInputStream(scriptResource.getBytes()), params, ignoreExceptions, properties);
        } catch (IOException e) {
        	logger.warn("Cannot load script from [" + scriptResource + "]");
            throw new BeanInitializationException("Cannot load script from [Inline script]", e);
        }
    }

    @SuppressWarnings("unchecked")
    public static void executeScript(DataSource dataSource, InputStream inputStream, Map<String, ?> params, boolean ignoreExceptions,
            Properties properties) throws IOException {
        List<String> script = IOUtils.readLines(inputStream);
        executeScript(dataSource, script, params, ignoreExceptions, properties);
    }

    /**
     * Ejecuta un script con parámetros en el datasource dado
     * 
     * @param dataSource
     * @param script
     * @param params
     * @param ignoreExceptions
     * @param properties
     */
    public static void executeScript(final DataSource dataSource, final List<String> script, final Map<String, ?> params,
            final boolean ignoreExceptions, final Properties properties) {

        TransactionTemplate transactionTemplate = new TransactionTemplate(new DataSourceTransactionManager(dataSource));
        transactionTemplate.execute(new TransactionCallback() {

            public Object doInTransaction(TransactionStatus status) {
                NamedParameterJdbcTemplate jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
                String[] scriptLines = StringUtils.delimitedListToStringArray(stripComments(script), ";");
                for (int i = 0; i < scriptLines.length; i++) {
                    String originalScript = scriptLines[i].trim();
                    if (StringUtils.hasText(originalScript)) {
                        // Resolver propiedades
                        boolean iup = (params == null ? false : true);
                        String script = PropertyPlaceholderUtils.resolve(originalScript, properties, iup);
                        if (params != null) {
                            script = PropertyPlaceholderUtils.resolve(script, params, false);
                        }
                        if (logger.isTraceEnabled()) {
                            logger.trace("executing script: " + script);
                        }
                        try {
                            // Execute
                            jdbcTemplate.execute(script, params, new PreparedStatementCallback() {
                                @Override
                                public Object doInPreparedStatement(PreparedStatement ps) throws SQLException, DataAccessException {
                                    ps.executeUpdate();
                                    return null;
                                }
                            });

                        } catch (DataAccessException e) {
                            // Ignore failed "drops" if configured
                            if ((!ignoreExceptions || (ignoreExceptions && !script.contains("DROP")))) {
                                throw e;
                            }
                        }
                    }
                }
                return null;
            }

        });

    }

    public static void executeScriptBatch(DataSource dataSource, List<String> scriptSource, Map<String, ?> params, final boolean ignoreExceptions,
            Properties properties) {

        Properties p = new Properties(properties);
        if (params != null) {
            for (String key : params.keySet()) {
                p.put(key, params.get(key).toString());
            }
        }

        String[] scriptLines = stripComments(scriptSource).replaceAll("\n", "").split(";");

        // Resolver propiedades
        for (int i = 0; i < scriptLines.length; i++) {
            String originalScript = scriptLines[i];
            scriptLines[i] = PropertyPlaceholderUtils.resolve(originalScript, p);
        }

        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        try {
            jdbcTemplate.batchUpdate(scriptLines);
        } catch (DataAccessException e) {
            //            if ((!ignoreExceptions || (ignoreExceptions && !script.contains("DROP")))) {
            throw e;
            //            }
        }

    }

    private static String stripComments(List<String> list) {
        StringBuffer buffer = new StringBuffer();
        for (Iterator<String> iter = list.iterator(); iter.hasNext();) {
            String line = iter.next();
            if (!line.startsWith("//") && !line.startsWith("--") && line.trim().length() != 0) {
                buffer.append(line.trim()).append("\n");
            }
        }
        return buffer.toString();
    }
}
