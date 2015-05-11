package es.capgemini.pfs.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.utils.jbpm.JBPMProcessDefinitionSet;


/**
 * @author lgiavedo
 *
 */
@Component
@ManagedResource("devon:type=JbpmUtils")
public class JBPMConsolePlugin{
    
    @Autowired
    private JBPMProcessManager jbpmProcessUtils;
    
    @Autowired
    private JBPMProcessDefinitionSet proDefinitionSet;
    
    
    
    @ManagedOperation
    public void stopJobExecutor() {
        jbpmProcessUtils.stopJobExecutor();
    }
    
    @ManagedOperation
    public void startJobExecutor() {
        jbpmProcessUtils.startJobExecutor();
    }
    
    @ManagedOperation
    public String[] listProcessDefinitions(){
        return es.capgemini.pfs.utils.CollectionUtils.toString(proDefinitionSet.getProDefinitions());
    }
    


}
