package es.pfsgroup.plugin.rem.listener;

import java.io.FileInputStream;
import java.util.Properties;

import javax.naming.ConfigurationException;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class RemContextListener implements ServletContextListener {

	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String DEVON_PROPERTIE = "devonProperties";

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// empty
	}

	@Override
	public void contextInitialized(ServletContextEvent servletContextEvent) {
		Properties appProperties = new Properties();
		try {
			if (servletContextEvent.getServletContext().getAttribute(RemContextListener.DEVON_PROPERTIE) == null) {
				String path = getDevonPath();
				logger.error("################# INICIADOR DE PROPIEDADES PARA EL FRONTEND ############################"
						.concat(path));
				appProperties.load(new FileInputStream(path));
				servletContextEvent.getServletContext().setAttribute(RemContextListener.DEVON_PROPERTIE, appProperties);
			}

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}

	private String getDevonPath() throws ConfigurationException {
		String path = null;
		if (System.getenv("DEVON_HOME") != null && !System.getenv("DEVON_HOME").isEmpty()) {

			path = System.getenv("DEVON_HOME").concat("/devon.properties");

			if (path.charAt(0) != '/') {
				path = "/".concat(path);
			}
		} else {
			throw new ConfigurationException("#################  DEVON_HOME no está configurada correctamente");
		}

		return path;
	}

}
