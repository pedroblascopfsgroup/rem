package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchRuntimeBuilderImpl;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchRuntimeBuilderImpl;

public class CreateRuntimeTest {

    private PFSBatchRuntimeBuilderImpl builder;
    
    @Before
    public void before(){
        builder = new PFSBatchRuntimeBuilderImpl();
    }
    
    @After
    public void after(){
        builder = null;
    }
    
    @Test
    public void testCreateRuntime(){
        Runtime runtime = builder.createRuntime();
        
        assertNotNull(runtime);
        
    }
}
