package es.capgemini.pfs.exceptions;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.exception.FrameworkException;

/***
 * @author jyebenes
 * 
 * Excepci�n utilizada cuando no se encuentra un campo de la tarea al evaluar un script de plazoTarea
 * 
 * 
 * */
public class PlazosTareasNoEncontradoException extends FrameworkException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8055123453190924610L;
	
	protected final Log logger = LogFactory.getLog(getClass());
		
	public PlazosTareasNoEncontradoException(){
        
		super("ERROR_FECHA_PLAZOS");

	}
	


	

}
