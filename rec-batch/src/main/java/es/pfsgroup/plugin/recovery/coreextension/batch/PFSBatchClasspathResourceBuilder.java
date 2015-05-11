package es.pfsgroup.plugin.recovery.coreextension.batch;

import org.springframework.core.io.Resource;

public interface PFSBatchClasspathResourceBuilder {

    Resource getClasspathResource(String resourceName);

}
