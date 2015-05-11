package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchClasspathResourceBuilderImpl;

import static org.junit.Assert.*;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchClasspathResourceBuilderImpl;

public class GetClasspathResourceTest {

    private PFSBatchClasspathResourceBuilderImpl builder;
    private String resourceName;
    
    @Before
    public void before(){
        resourceName = RandomStringUtils.randomAlphabetic(10);
        builder = new PFSBatchClasspathResourceBuilderImpl();
    }
    
    @After
    public void after(){
        builder = null;
        resourceName = null;
    }
    
    @Test
    public void testGetClasspathResource(){
        Resource resource = builder.getClasspathResource(resourceName);
        assertNotNull(resource);
        assertTrue(resource instanceof ClassPathResource);
        assertEquals(resourceName, resource.getFilename());
    }
}
