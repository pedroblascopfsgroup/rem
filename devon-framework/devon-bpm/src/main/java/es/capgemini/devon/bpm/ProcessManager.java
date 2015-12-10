package es.capgemini.devon.bpm;

import java.util.Date;
import java.util.Map;

import org.jbpm.graph.def.ProcessDefinition;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.job.Timer;
import org.springmodules.workflow.jbpm31.JbpmCallback;

/**
 * @author Nicolás Cornaglia
 */
public interface ProcessManager {

    /**
     * @param name
     * @return
     */
    public ProcessDefinition findLatestProcessDefinition(String name);

    /**
     * Crea una instancia de proceso por nombre
     * 
     * @param name
     * @return
     */
    public ProcessInstance newProcessInstance(String name);

    /**
     * Crea una instancia de proceso por nombre, pasándole parámetros
     * 
     * @param name
     * @param variables
     * @return
     */
    public ProcessInstance newProcessInstance(String name, Map variables);

    /**
     * Obtiene una instacia de proceso en base a su id
     * 
     * @param id
     * @return
     */
    public ProcessInstance getProcessInstance(Long id);

    /**
     * @param processInstance
     */
    public void save(ProcessInstance processInstance);

    /**
     * @param id
     */
    public void signal(final Long id);

    /**
     * @param callback
     * @return
     */
    public Object execute(final JbpmCallback callback);

    /**
     * @param processInstance
     * @param name
     * @param dueDate
     */
    public void updateTimerDueDate(final ProcessInstance processInstance, final String name, final Date dueDate);

    /**
     * @param processInstance
     * @param name
     * @return
     */
    public Timer getTimer(final ProcessInstance processInstance, final String name);
}
