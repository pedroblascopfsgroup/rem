package es.pfsgroup.plugin.recovery.coreextension.batch;

import org.springframework.stereotype.Component;

@Component
public class PFSBatchRuntimeBuilderImpl implements PFSBatchRuntimeBuilder {

    @Override
    public Runtime createRuntime() {
        return Runtime.getRuntime();
    }
    

}
