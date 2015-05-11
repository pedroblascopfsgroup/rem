package es.pfsgroup.plugin.recovery.coreextension.batch;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

@Component
public class PFSBatchClasspathResourceBuilderImpl implements PFSBatchClasspathResourceBuilder{

    @Override
    public Resource getClasspathResource(String resourceName) {
        return new ClassPathResource(resourceName);
    }
    
    

}
