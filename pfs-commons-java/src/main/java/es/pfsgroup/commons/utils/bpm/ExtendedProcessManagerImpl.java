package es.pfsgroup.commons.utils.bpm;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.jbpm.JbpmConfiguration;
import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.job.Timer;
import org.springframework.stereotype.Component;
import org.springmodules.workflow.jbpm31.JbpmCallback;
import org.springmodules.workflow.jbpm31.JbpmTemplate;

import es.capgemini.devon.bpm.ProcessManagerImpl;

/**
 * Esta clase (incluida en pfs-commons-java 2.6.0) es la implementación extendidad el {@link ProcessManagerImpl} de Devon.
 * <p>
 * Esta clase contiene operaciones adicionales para ejecutar en JBPM.
 * </p>
 * 
 * @since 2.6.0
 * @author bruno
 *
 */
@Component("extendedProcessManager")
public class ExtendedProcessManagerImpl implements ExtendedProcessManager{
    
    private JbpmTemplate jbpmTemplate;
    
    @Resource
    public JbpmConfiguration jbpmConfiguration;
    
    @PostConstruct
    public void initialize() throws Exception {
        jbpmTemplate = new JbpmTemplate(jbpmConfiguration);
        jbpmTemplate.afterPropertiesSet();
    }

    @Override
    public List<Timer> getTimers(final ProcessInstance processInstance, final String expression) {
        return (List<Timer>) jbpmTemplate.execute(new JbpmCallback() {
            public Object doInJbpm(JbpmContext context) {
                return CustomBPMUtils.getTimersByName(context, processInstance, expression);
            }
        });
    }

}
