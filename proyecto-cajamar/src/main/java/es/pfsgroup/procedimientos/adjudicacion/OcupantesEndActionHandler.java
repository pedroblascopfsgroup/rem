package es.pfsgroup.procedimientos.adjudicacion;

import static es.capgemini.pfs.BPMContants.TOKEN_JBPM_PADRE;

import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.capgemini.devon.bpm.ProcessManager;
import es.pfsgroup.procedimientos.PROEndProcessActionHandler;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;

public class OcupantesEndActionHandler extends PROEndProcessActionHandler {

	private static final long serialVersionUID = 8983221089858907641L;
	
	@Autowired
	private ProcessManager processManager;
	
    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    @Override
    public void run(final ExecutionContext executionContext) throws Exception {
    	
		final Long idToken = (Long) executionContext.getVariable("tokenJbpmPadre");
		
        //si este proceso ha sido iniciado por otro, lanzar� una se�al con su nombre
        if (hasVariable(TOKEN_JBPM_PADRE, executionContext)) {
            String transitionName = getNombreProceso(executionContext);

            //Si cuando vayamos a avisar al nodo, existe ese nodo activo y existe una transici�n correcta
            if (proxyFactory.proxy(JBPMProcessApi.class).hasTransitionToken(idToken, transitionName)) {
            	
        		processManager.execute(new JbpmCallback() {
        			
        			@Override
        			public Object doInJbpm(JbpmContext context) {
        				
        				// chequear las posibles decisiones de fin de procedimiento Abreviado
        				String value = "favorable";
        				if (executionContext.getVariable("CJ048_ResolucionFirmeDecision") != null) {
        					value = executionContext.getVariable("CJ048_ResolucionFirmeDecision").toString();
        				} 
        				
        				ProcessInstance processInstance = context.getGraphSession().getToken(idToken).getProcessInstance();
        				processInstance.getContextInstance().setVariable("H048_BPMTramiteOcupadosResultado",value);
        				return null;
        			}
        		});
            	
            	proxyFactory.proxy(JBPMProcessApi.class).signalToken(idToken, transitionName);
            }
        }
    }
    

}
