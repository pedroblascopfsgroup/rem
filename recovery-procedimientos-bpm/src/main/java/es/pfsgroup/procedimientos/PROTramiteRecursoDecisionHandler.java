package es.pfsgroup.procedimientos;

import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.capgemini.devon.bpm.ProcessManager;

@Component("PROTramiteRecursoDecisionHandler")
public class PROTramiteRecursoDecisionHandler extends PROGenericActionHandler {

	private static final long serialVersionUID = 8983221089858907641L;
	
	@Autowired
	private ProcessManager processManager;

	@Override
	protected void process(Object delegateTransitionClass,
			Object delegateSpecificClass, final ExecutionContext executionContext) {
		final Long idTokenPadre = (Long) executionContext.getVariable("tokenJbpmPadre");
		processManager.execute(new JbpmCallback() {
			@Override
			public Object doInJbpm(JbpmContext context) {
				
				String value = "favorable";
				
				// chequear las posibles decisiones de fin de procedimiento Abreviado
				if (executionContext.getVariable("P33_registrarResultadoDecision") != null){
					value = executionContext.getVariable("P33_registrarResultadoDecision").toString();
					if (value.equals("DESFAVORABLE")){
						value = "noRecurrir_desfavorable";
					} else {value = "favorable";}
				} else if (executionContext.getVariable("P33_dictarInstruccionesDecision") != null){ 
					value = executionContext.getVariable("P33_dictarInstruccionesDecision").toString();
					if (value.equals("NO")){
						value = "noRecurrir_desfavorable";
					} else {value = "favorable";}
				} 
				
				ProcessInstance processInstance = context.getGraphSession().getToken(idTokenPadre).getProcessInstance();
				processInstance.getContextInstance().setVariable("P32_BPMtramiteArchivoDecision",value);
				return null;
			}
		});
		//Avanzamos BPM
		executionContext.getToken().signal();
	}
}
