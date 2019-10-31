package es.pfsgroup.plugin.rem.utils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public  class EmptyParamDetector {
	protected static final Log logger = LogFactory.getLog(EmptyParamDetector.class);
	
	public void isEmpty(int size, String busqueda, String usuario) {
		logger.error("Atencion: Export de " + size + " registros de " + busqueda + " por el usuario " + usuario);
	}
}
