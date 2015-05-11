package es.pfsgroup.procedimientos;

import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.procedimientos.recoveryapi.AbstractJBPMProcessManager;
import es.pfsgroup.procedimientos.recoveryapi.RecoveryExtendedJBPMProcessApi;

/**
 * Implementa las operaciones de negocio que extienden la funcionalidad del BPM
 * 
 * @author bruno
 * 
 */
@Component
public class RecoveryExtendedJPBMManager extends AbstractJBPMProcessManager implements RecoveryExtendedJBPMProcessApi {

	@Autowired
	private ProcessManager processManager;

	@Override
	@BusinessOperation(RecoveryExtendedJBPMProcessApi.BO_JBPM_MGR_DELETE_VARIABLES_TO_PROCESS)
	public void deleteVariableToProcess(final Long process, final String variableName) {
		if ((process == null) || (Checks.esNulo(variableName))) {
			return;
		}
		processManager.execute(new JbpmCallback() {
			@Override
			public Object doInJbpm(JbpmContext context) {
				// Obtener la �ltima instancia conocida
				ProcessInstance processInstance = context.getGraphSession().getProcessInstance(process);
				if (processInstance == null)
					return null;

				// Borrar variables del proceso
				processInstance.getContextInstance().deleteVariable(variableName);
				return null;
			}
		});

	}

	@Override
	@BusinessOperation(RecoveryExtendedJBPMProcessApi.BO_JBPM_MGR_ADD_VARIABLE_TO_PROCESS)
	public void addVariableToProcess(final Long idProcess, final String variableName, final Object value) {
		if ((idProcess == null) || (Checks.esNulo(variableName))) {
			return;
		}
        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(idProcess);
                if (processInstance == null) return null;

                //Insertar las variables al proceso
                processInstance.getContextInstance().setVariable(variableName, value);
                return null;
            }
        });
	}

}
