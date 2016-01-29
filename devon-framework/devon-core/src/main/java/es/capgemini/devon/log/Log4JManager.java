package es.capgemini.devon.log;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import org.apache.log4j.Level;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.jmx.export.annotation.ManagedAttribute;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedOperationParameter;
import org.springframework.jmx.export.annotation.ManagedOperationParameters;
import org.springframework.jmx.export.annotation.ManagedResource;

/**
 * @author Nicolás Cornaglia
 */
@ManagedResource(description = "Manages the Application logger", objectName = "type=logger")
public class Log4JManager implements LoggerManager {

    /**
     * @see es.capgemini.devon.log.LoggerManager#getLoggerLevel(java.lang.String)
     */
    @ManagedOperation(description = "Get the category log level")
    public String getLoggerLevel(String category) {
        if (category != null) {
            Logger logger = LogManager.getLogger(category);
            if (logger != null && logger.getLevel() != null) {
                return logger.getLevel().toString();
            }
        }
        return "Categoty not found";
    }

    /**
     * @see es.capgemini.devon.log.LoggerManager#setLoggerLevel(java.lang.String, java.lang.String)
     */
    @ManagedOperation(description = "Set the category log level")
    @ManagedOperationParameters( { @ManagedOperationParameter(name = "category", description = "The category name"),
            @ManagedOperationParameter(name = "level", description = "The log level [OFF|FATAL|ERROR|WARN|INFO|DEBUG|TRACE|ALL]") })
    public String setLoggerLevel(String category, String level) {
        if (category != null) {
            Logger logger = LogManager.getLogger(category);
            if (logger != null) {
                Level logLevel = Level.toLevel(level, null);
                if (logLevel != null) {
                    logger.setLevel(logLevel);
                    return "Now logger level for " + logger.getName() + " = " + logger.getLevel();
                } else {
                    return "Invalid level. Use: [OFF|FATAL|ERROR|WARN|INFO|DEBUG|TRACE|ALL]";
                }
            }
        }
        return "Invalid category";
    }

    /**
     * @see es.capgemini.devon.log.LoggerManager#getCategories()
     */
    @SuppressWarnings("unchecked")
    @ManagedAttribute(description = "List log categories and levels")
    public List<String> getCategories() {
        ArrayList<String> result = new ArrayList<String>();
        Enumeration categories = LogManager.getCurrentLoggers();
        while (categories.hasMoreElements()) {
            Logger category = (Logger) categories.nextElement();
            Level level = category.getLevel();
            result.add(category.getName() + " = " + (level != null ? level.toString() : ""));
        }
        return result;
    }

}
