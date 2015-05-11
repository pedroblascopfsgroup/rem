package es.pfsgroup.procedimientos.contratos;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.jbpm.graph.exe.ExecutionContext;

import es.pfsgroup.procedimientos.PROBaseActionHandler;

public abstract class IteradorActionHandler extends PROBaseActionHandler {
    private static final long serialVersionUID = 1L;

    public static final String STR_LOOP = "LOOP:%s";
    public static final String STR_LOOP_ID_ASSIGNED = "LOOP.ID.%d";
    public static final String STR_LOOP_ITERATION_DECISION = "%sDecision";
    
    public static final String STR_LOOP_TRANSICION_FIN = "fin";
    public static final String STR_LOOP_TRANSICION_SIGUIENTE = "siguiente";
    
    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {

        String nombreNodo = getNombreNodo(executionContext);
        String loopVariableName = String.format(STR_LOOP, nombreNodo);
        String loopValue = (String)getVariable(loopVariableName, executionContext);
        String decision = STR_LOOP_TRANSICION_FIN;

        logger.debug(String.format("Iteramos por el BPM [%s]", nombreNodo));
        
        // Primera iteración
        if (loopValue==null) {
        	List<Long> ids = getIds(executionContext);
        	decision = (ids.size() > 0) ? STR_LOOP_TRANSICION_SIGUIENTE : STR_LOOP_TRANSICION_FIN;
        	loopValue = StringUtils.join(ids.iterator(), ',');
        } 

        // Resto de iteraciones
    	int firstValuePosition = loopValue.indexOf(',');
		String id = null;
    	if (firstValuePosition>0) { // ejecuciones intermedias
    		id = loopValue.substring(0, firstValuePosition);
    		loopValue = (loopValue.length()>=firstValuePosition+1) 
    				? loopValue.substring(firstValuePosition+1) : "";
    	} else if (StringUtils.isNotBlank(loopValue)) {
    		id = loopValue;
    		loopValue = StringUtils.EMPTY;
    	}

    	// Almacena las variables
    	if (id!=null) {
    		decision = STR_LOOP_TRANSICION_SIGUIENTE;
    		String contractVar = String.format(STR_LOOP_ID_ASSIGNED, getTokenId(executionContext));
    		setVariable(contractVar, id, executionContext);
    		setVariable(loopVariableName, loopValue, executionContext);
    	}
        

        // Avanza el BPM
    	String decisionVar = String.format(STR_LOOP_ITERATION_DECISION, getNombreNodo(executionContext));
    	setVariable(decisionVar, decision, executionContext);
        executionContext.getToken().signal();
        
    }

    /**
     * Devuelve los Ids de los contratos para iterar. 
     * @return
     */
    protected abstract List<Long> getIds(ExecutionContext executionContext);
    
}