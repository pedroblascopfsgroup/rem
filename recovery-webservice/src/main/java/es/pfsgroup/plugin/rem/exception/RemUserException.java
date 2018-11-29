package es.pfsgroup.plugin.rem.exception;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
/*
 * Custom messages from appMessagesPFS.properties for exceptions in REM.
 * Juan Ramón Llinares / Javier Pons 
 */
public class RemUserException extends Exception {
	
	protected static final Log logger = LogFactory.getLog(RemUserException.class);
	
	private static final long serialVersionUID = 8175509587395156021L;
	
	private String codigoEtiqueta;
	
	private MessageService messageServices;
	
	public RemUserException(String codigoEtiqueta, MessageService messageServices) {		
		
		super(codigoEtiqueta);
		this.codigoEtiqueta = codigoEtiqueta;
		this.messageServices = messageServices;
		
	}
	
	public String getMensaje() {
		
		String result = null;
		
		try {
			
			result = messageServices.getMessage(codigoEtiqueta);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage());
		}
		
		
		if(Checks.esNulo(result)) {
			
			result = codigoEtiqueta;
		}
		
		return result;
		
	}
	
}
