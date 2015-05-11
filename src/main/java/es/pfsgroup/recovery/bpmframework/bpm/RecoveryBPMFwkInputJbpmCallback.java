package es.pfsgroup.recovery.bpmframework.bpm;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jbpm.JbpmContext;
import org.jbpm.JbpmException;
import org.jbpm.graph.def.Transition;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.graph.exe.Token;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Callback del JBPM para avanzar un BPM gracias a un Input
 * @author bruno
 *
 */
public class RecoveryBPMFwkInputJbpmCallback implements JbpmCallback{
    
    private final Long idProcess;
    
    private final String transitionName;
    
    private final RecoveryBPMfwkInput input;

    public RecoveryBPMFwkInputJbpmCallback(Long idProcess, String transitionName, RecoveryBPMfwkInput input) {
        this.idProcess = idProcess;
        this.transitionName = transitionName;
        this.input = input;
    }

    @SuppressWarnings("unchecked")
	@Override
    public Object doInJbpm(final JbpmContext context) throws JbpmException {
        final ProcessInstance pi = context.getGraphSession().getProcessInstance(idProcess);
        final List<Token> tokens = pi.findAllTokens();
        final Map<String, Object> variables = new HashMap<String, Object>();
        final String date = new SimpleDateFormat("yyyyMMddhhmmss").format(new Date());
        if (!Checks.estaVacio(tokens)){
            for (Token t : tokens){
                if (hasTransition(t, transitionName)){
                    String nodeName = t.getNode().getName();
                    variables.put(nodeName + "." + transitionName + "." + date + ".input", input.getId());
                    t.signal(transitionName);
                }
            }
            if (!Checks.estaVacio(variables)){
                pi.getContextInstance().setVariables(variables);
            }
        }
        return null;
    }

    private boolean hasTransition(final Token token, final String transitionName) {
        Transition trans = token.getNode().getLeavingTransition(transitionName);
        return trans != null;
    }

    public Long getIdProcess() {
        return this.idProcess;
    }

    public String getTransitionName() {
        return this.transitionName;
    }

    public RecoveryBPMfwkInput getInput() {
        return this.input;
    }

}
