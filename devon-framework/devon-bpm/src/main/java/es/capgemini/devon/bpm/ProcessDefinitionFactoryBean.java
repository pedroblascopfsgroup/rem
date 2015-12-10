package es.capgemini.devon.bpm;

import java.io.InputStream;

import org.jbpm.graph.def.ProcessDefinition;
import org.springframework.beans.FatalBeanException;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.core.io.Resource;

/**
 * Process Definition Factory Bean. It acts as a simple utility for loading ProcessDefinitions
 * using Spring own resource.
 * 
 * <strong>Note:</strong> Jbpm does not support parsing subprocesses - use LocalJbpmConfigurationFactoryBean#setProcessDefinitionsResources in this case.
 * See <a href="http://opensource.atlassian.com/projects/spring/browse/MOD-193">MOD-193</a> for more details.
 * 
 * @see org.springmodules.workflow.jbpm31.LocalJbpmConfigurationFactoryBean#setProcessDefinitionsResources(Resource[])
 * 
 * @author Rob Harrop
 * @author Costin Leau
 */
public class ProcessDefinitionFactoryBean implements FactoryBean, InitializingBean {

    private ProcessDefinition processDefinition;

    private Resource definitionLocation;

    private int version = -1;

    public void setDefinitionLocation(Resource definitionLocation) {
        this.definitionLocation = definitionLocation;
    }

    public void afterPropertiesSet() throws Exception {
        if (this.definitionLocation == null) {
            throw new FatalBeanException("Property [definitionLocation] of class [" + ProcessDefinitionFactoryBean.class.getName() + "] is required.");
        }

        InputStream inputStream = null;
        try {
            inputStream = this.definitionLocation.getInputStream();
            this.processDefinition = ProcessDefinition.parseXmlInputStream(inputStream);
            this.processDefinition.setVersion(version);

        } finally {
            if (inputStream != null) {
                inputStream.close();
            }
        }
    }

    public Object getObject() throws Exception {
        return this.processDefinition;
    }

    public Class getObjectType() {
        return (processDefinition == null) ? ProcessDefinition.class : processDefinition.getClass();
    }

    public boolean isSingleton() {
        return true;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(int version) {
        this.version = version;
    }

}
