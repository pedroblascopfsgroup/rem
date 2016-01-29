package es.pfsgroup.recovery.ext.api.utils;

import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.api.JBPMProcessApi;

public interface EXTJBPMProcessApi extends JBPMProcessApi{
	
	public static final String EXT_JBPMAPI_GET_CURRENT_NODES = "es.pfsgroup.recovery.ext.api.utils.getCurrentNodes";
	public static final String EXT_JBPMAPI_BORRAR_TIMERS_TAREA = "es.pfsgroup.recovery.ext.api.utils.borraTimersTarea";
	public static final String EXT_JBPMAPI_BORRAR_TIMERS_EXPEDIENTE = "es.pfsgroup.recovery.ext.api.utils.borraTimersExpediente";

	/**
     * Obtiene los nodos actuales del proceso. Este m�todo es �til en los casos que se ha llegado a un Fork
     * @param idProcess id del proceso
     * @return Lista con los nombre de los nodos
     */
    @BusinessOperationDefinition(EXT_JBPMAPI_GET_CURRENT_NODES)
    public List<String> getCurrentNodes(final Long idProcess);
    
    @BusinessOperationDefinition(EXT_JBPMAPI_BORRAR_TIMERS_TAREA)
    public void borraTimersTarea(final Long idTareaExterna);
    
    @BusinessOperationDefinition(EXT_JBPMAPI_BORRAR_TIMERS_EXPEDIENTE)
    public void borraTimersExpediente(final Long idExpediente);
    

}
