package es.capgemini.pfs.registro;

import es.capgemini.pfs.generico.GenericListener;


public interface ModificacionAsuntoListener extends GenericListener{
	
	public static final String ID_ASUNTO = "idAsunto";
	public static final String CLAVE_NOMBRE_ANTERIOR = "nameOld"; 
    public static final String CLAVE_NOMBRE_POSTERIOR = "nameNew"; 

}
