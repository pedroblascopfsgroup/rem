package es.capgemini.devon.log;

import javax.annotation.PostConstruct;

import org.apache.log4j.Level;
import org.apache.log4j.WriterAppender;
import org.apache.log4j.spi.LoggingEvent;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.exception.FrameworkException;

/**
 * @author Nicolás Cornaglia
 */
public class EventAppender extends WriterAppender {

    private static EventAppender instance;

    @Autowired
    private EventManager eventManager;

    @PostConstruct
    public void initialize() {
        instance = this;
    }

    @Override
    public void append(LoggingEvent event) {
        subAppend(event);
    }

    @Override
    public void subAppend(LoggingEvent event) {
        if (instance != null && event.getLevel().toInt() > Level.DEBUG.toInt()) {

            FrameworkException fe = null;

            if (event.getThrowableInformation() != null) {
                Throwable t = event.getThrowableInformation().getThrowable();
                if (t instanceof FrameworkException) {
                    fe = (FrameworkException) t;
                } else {
                    fe = new FrameworkException(t);
                }
            }

            if (event.getLevel().toInt() > Level.WARN.toInt()) {
                // FATAL OR ERROR
                if (fe == null) {
                    fe = new FrameworkException(event.getMessage().toString());
                }
                instance.eventManager.fireEvent(EventManager.ERROR_CHANNEL, fe);
            } else if (event.getLevel().toInt() > Level.DEBUG.toInt()) {
                // INFO OR WARN
                String message = null;
                if (fe == null) {
                    message = event.getMessage().toString();
                } else {
                    message = fe.getMessage();
                }
                instance.eventManager.fireEvent(EventManager.GENERIC_CHANNEL, message);
            }

        }
    }

}
