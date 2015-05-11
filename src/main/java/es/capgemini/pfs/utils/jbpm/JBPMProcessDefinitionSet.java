package es.capgemini.pfs.utils.jbpm;

import java.util.ArrayList;
import java.util.List;

import org.jbpm.graph.def.ProcessDefinition;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author lgiavedo
 *
 */
@Component("jBPMProcessDefinitionSet")
public class JBPMProcessDefinitionSet implements FactoryBean {

    @Autowired(required = true)
    private List<ProcessDefinition> proDefinitions = new ArrayList<ProcessDefinition>();

    /**
     * @return the proDefinitions
     */
    public final List<ProcessDefinition> getProDefinitions() {
        return proDefinitions;
    }

    @Override
    public Object getObject() throws Exception {
        return proDefinitions;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Class getObjectType() {
        return proDefinitions.getClass();
    }

    @Override
    public boolean isSingleton() {
        return true;
    }

}
