package es.pfsgroup.plugin.rem.listener;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class RemContextListener implements ServletContextListener {

	private final Log logger = LogFactory.getLog(getClass());

	

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// empty
	}

	@Override
	public void contextInitialized(ServletContextEvent servletContextEvent) {
		Properties appProperties = new Properties();
		try {
			if(System.getenv("DEVON_HOME") != null && !System.getenv("DEVON_HOME").isEmpty()) {
				appProperties
				.load(new FileInputStream(System.getenv("DEVON_HOME").concat("/devon.properties")));
				logger.error("################# INICIADOR DE PROPIEDADES PARA EL FRONTEND ############################ ${DEVON_HOME}");
				servletContextEvent.getServletContext().setAttribute("devonProperties", appProperties);
			}else {
				logger.error("################# no se encuenta DEVON_HOME ############################");
			}
			
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
		}
	}

}
