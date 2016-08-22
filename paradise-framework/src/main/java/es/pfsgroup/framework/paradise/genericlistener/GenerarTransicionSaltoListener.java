package es.pfsgroup.framework.paradise.genericlistener;

import java.util.Map;

import es.capgemini.pfs.generico.GenericListener;

public interface GenerarTransicionSaltoListener extends GenericListener {
	
	public static final String CLAVE_EXECUTION_CONTEXT = "executionContext";
	public static final String CLAVE_ID_TAREA = "idTarea";
	
	void fireEventGeneric(Map<String, Object> map, String tipoSalto);

}
