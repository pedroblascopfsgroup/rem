package es.capgemini.devon.bpm;

import org.jbpm.graph.def.ActionHandler;
import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.devon.utils.DbIdContextHolder;

/**
 * Clase abstracta que identifica las acciones de JBPM
 * 
 * @author lgiavedo
 */
public abstract class JbpmActionHandler implements ActionHandler {

    private static final long serialVersionUID = 1L;

    protected ExecutionContext executionContext;

    public abstract void run() throws Exception;

    @Override
    public void execute(ExecutionContext executionContext) throws Exception {
        this.executionContext = executionContext;
        //Seteamos el id de la BD ya que puede estar corriendo en otro thread
        DbIdContextHolder.setDbId((Long) executionContext.getVariable(DbIdContextHolder.DB_ID));
        run();
    }

}
