package es.capgemini.devon.bpm.logging;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.svc.Service;
import org.jbpm.svc.ServiceFactory;

import es.capgemini.devon.utils.PropertyUtils;

public class BPMLoggingServiceFactory implements ServiceFactory{
    
    private static final long serialVersionUID = 1L;
    
    private static final Log logger = LogFactory.getLog(BPMLoggingServiceFactory.class);

    private static final String LOGGIN_CLASS_KEY = "bpm.logging.class";

    @Override
    public void close() {
        // do nothing
        
    }

    @Override
    public Service openService() {
        try {
            return (Service)Class.forName(PropertyUtils.getProperty(LOGGIN_CLASS_KEY)).newInstance();
        } catch (Exception e) {
            logger.error("Error al obtener el BPMLoggingServiceFactory con la propiedad "+LOGGIN_CLASS_KEY+" = "+PropertyUtils.getProperty(LOGGIN_CLASS_KEY),e);
        }
        return null;
    }

}
