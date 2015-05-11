package es.capgemini.pfs.batch.events;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.annotation.MessageEndpoint;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.core.Message;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.tasks.BatchValidationException;
import es.capgemini.devon.events.ErrorEvent;
import es.capgemini.devon.utils.DbIdContextHolder;

/**
 * @author Juan Pablo Bosnjak
 */
@MessageEndpoint
public class ErrorChannelBatchHandler {

    private final Log logger = LogFactory.getLog(getClass());

    private DataSource dataSource;

    private String query;

    /**
     * Eventos de error Batch por validaciones erroneas.
     * Insertar Una incidencia en la BBDD.
     * @param message Message
     */
    @ServiceActivator(inputChannel = "errorChannelBatch")
    public void handle(Message<?> message) {
        ErrorEvent ev = (ErrorEvent) message.getPayload();
        Exception e = ev.getException();
        if (e instanceof BatchValidationException) {
            if (ev.getProperty("dbId") != null) {
                DbIdContextHolder.setDbId((Long) ev.getProperty("dbId"));
            }
            BatchValidationException bve = (BatchValidationException) e;
            logger.debug("Manejando error de validacion - Se genera una Incidencia de Carga");
            String traza = getStackTrace(bve);
            logger.debug(bve.getMessage());
            if (bve.getImprimeTraza()) {
                logger.error(traza);
            } else {
                traza = "";
            }

            final int lengthTraza = 490;
            if (traza != null && traza.length() > lengthTraza) {
                traza = traza.substring(0, lengthTraza);
            }

            final int lengthMensaje = 250;
            String mensaje = bve.getMessage();
            if (mensaje.length() > lengthMensaje) {
                mensaje = mensaje.substring(0, lengthMensaje);
            }
            Object[] params = new Object[] { bve.getOriginalkey(), null, null, null, mensaje, traza, bve.getSeveridad() };
            try {
                JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());
                jdbcTemplate.update(getQuery(), params);
            } catch (Exception eX) {
                logger.error(eX);
            }
        } else {
            logger.error(e.getCause());
        }
    }

    /**
     * getStackTrace.
     * @param aThrowable exception
     * @return stack serialize
     */
    public String getStackTrace(Throwable aThrowable) {
        final Writer result = new StringWriter();
        final PrintWriter printWriter = new PrintWriter(result);
        aThrowable.printStackTrace(printWriter);
        return result.toString();
    }

    /**
     * getDataSource.
     * @return the datasource
     */
    public DataSource getDataSource() {
        return dataSource;
    }

    /**
     * setDataSource.
     * @param dataSource the datasource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
      * getQuery.
      * @return the query
      */
    public String getQuery() {
        return query;
    }

    /**
     * setQuery.
     * @param query the query to set
     */
    public void setQuery(String query) {
        this.query = query;
    }
}
