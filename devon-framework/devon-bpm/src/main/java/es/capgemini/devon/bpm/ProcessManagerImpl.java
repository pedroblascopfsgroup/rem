package es.capgemini.devon.bpm;

import java.util.Date;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.hibernate.Session;
import org.jbpm.JbpmConfiguration;
import org.jbpm.JbpmContext;
import org.jbpm.JbpmException;
import org.jbpm.context.exe.ContextInstance;
import org.jbpm.graph.def.ProcessDefinition;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.job.Timer;
import org.springmodules.workflow.jbpm31.JbpmCallback;
import org.springmodules.workflow.jbpm31.JbpmTemplate;

import es.capgemini.devon.utils.BPMUtils;

/**
 * @author Nicolás Cornaglia
 */
//@Component("processManager")
public class ProcessManagerImpl implements ProcessManager {

    @Resource
    public JbpmConfiguration jbpmConfiguration;

    private JbpmTemplate jbpmTemplate;

    /**
     * @param jbpmConfiguration the jbpmConfiguration to set
     */
    public void setJbpmConfiguration(JbpmConfiguration jbpmConfiguration) {
        this.jbpmConfiguration = jbpmConfiguration;
    }

    @PostConstruct
    public void initialize() throws Exception {
        jbpmTemplate = new JbpmTemplate(jbpmConfiguration);
        jbpmTemplate.afterPropertiesSet();

        // jbpmConfiguration.getJobExecutor().start();

    }

    // Util methods

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#newProcessInstance(java.lang.String)
     */
    public ProcessInstance newProcessInstance(String name) {
        return newProcessInstance(name, null);
    }

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#newProcessInstance(java.lang.String, java.util.Map)
     */
    @SuppressWarnings("unchecked")
    public synchronized ProcessInstance newProcessInstance(final String name, final Map variables) {
        return (ProcessInstance) jbpmTemplate.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) throws JbpmException {
                ProcessInstance processInstance = context.newProcessInstance(name);
                if (variables != null) {
                    ContextInstance cn = processInstance.getContextInstance();
                    cn.setVariables(variables);
                }
                processInstance.signal();
                context.save(processInstance);
                return processInstance;
            }
        });
    }

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#save(org.jbpm.graph.exe.ProcessInstance)
     */
    public void save(ProcessInstance processInstance) {
        jbpmTemplate.saveProcessInstance(processInstance);
    }

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#newProcessInstance(java.lang.String)
     */
    public ProcessDefinition findLatestProcessDefinition(final String name) {
        return (ProcessDefinition) jbpmTemplate.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) throws JbpmException {
                return context.getGraphSession().findLatestProcessDefinition(name);
            }
        });

    }

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#getProcessInstance(java.lang.Long)
     */
    public ProcessInstance getProcessInstance(final Long id) {
        return (ProcessInstance) jbpmTemplate.execute(new JbpmCallback() {
            public Object doInJbpm(JbpmContext context) {
                return context.getGraphSession().getProcessInstance(id.longValue());
            }
        });
    }

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#signal(java.lang.Long)
     */
    public void signal(final Long id) {
        jbpmTemplate.execute(new JbpmCallback() {
            public Object doInJbpm(JbpmContext context) {
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(id.longValue());
                processInstance.signal();
                context.save(processInstance);
                return null;
            }
        });
    }

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#execute(org.springmodules.workflow.jbpm31.JbpmCallback)
     */
    public Object execute(final JbpmCallback callback) {
        return jbpmTemplate.execute(callback);
    }

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#updateTimerDueDate(org.jbpm.graph.exe.ProcessInstance, java.lang.String, java.util.Date)
     */
    public void updateTimerDueDate(final ProcessInstance processInstance, final String name, final Date dueDate) {
        jbpmTemplate.execute(new JbpmCallback() {
            public Object doInJbpm(JbpmContext context) {
                Timer timer = BPMUtils.getTimer(context, processInstance, name);

                timer.setDueDate(dueDate);

                Session session = context.getSession();
                session.save(timer);

                return null;
            }
        });
    }

    /**
     * @see es.capgemini.devon.bpm.ProcessManager#getTimer(org.jbpm.graph.exe.ProcessInstance, java.lang.String)
     */
    public Timer getTimer(final ProcessInstance processInstance, final String name) {
        return (Timer) jbpmTemplate.execute(new JbpmCallback() {
            public Object doInJbpm(JbpmContext context) {
                return BPMUtils.getTimer(context, processInstance, name);
            }
        });
    }
}
