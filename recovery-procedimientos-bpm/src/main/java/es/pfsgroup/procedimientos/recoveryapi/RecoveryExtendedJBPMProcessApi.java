package es.pfsgroup.procedimientos.recoveryapi;

import java.util.Map;

import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Nuevas funcionalidades del BPM que hacen falta
 * @author bruno
 *
 */
public interface RecoveryExtendedJBPMProcessApi extends JBPMProcessApi{

	public static final String BO_JBPM_MGR_DELETE_VARIABLES_TO_PROCESS = "RecoveryExtendedJBPMProcessApi.deleteVariableToProcess";
	public static final String BO_JBPM_MGR_ADD_VARIABLE_TO_PROCESS = "RecoveryExtendedJBPMProcessApi.addVariableToProcess";
	
	/**
	 * Borra una variable del contexto del BPM
	 * @param process Identificador de la instancia BPM
	 * @param variableName Nombre de la variable a borrar
	 */
	@BusinessOperationDefinition(RecoveryExtendedJBPMProcessApi.BO_JBPM_MGR_DELETE_VARIABLES_TO_PROCESS)
	void deleteVariableToProcess(Long process, String variableName);
	
	/**
	 * Añade una variable en el contexto del BPM
	 * @param process Identificador de la instancia BPM
	 * @param variableName Nombre de la variable a borrar
	 * @param valor de la variable
	 */
	@BusinessOperationDefinition(RecoveryExtendedJBPMProcessApi.BO_JBPM_MGR_ADD_VARIABLE_TO_PROCESS)
	void addVariableToProcess(Long idProcess, String variableName, Object value); 
	
}
