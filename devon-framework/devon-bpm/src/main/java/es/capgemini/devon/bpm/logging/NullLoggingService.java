package es.capgemini.devon.bpm.logging;

import org.jbpm.logging.LoggingService;
import org.jbpm.logging.log.ProcessLog;
import org.jbpm.svc.Service;

public class NullLoggingService implements LoggingService, Service{

    private static final long serialVersionUID = 1L;

    @Override
    public void log(ProcessLog arg0) {
        // do nothing 
    }

    @Override
    public void close() {
        // do nothing 
    }

}
