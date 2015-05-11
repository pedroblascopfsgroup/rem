package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchOracleDataLoaderTasklet;

import static org.mockito.Mockito.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.core.io.Resource;

import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.events.EventManager;
import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchClasspathResourceBuilder;
import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchOracleDataLoaderTasklet;
import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchRuntimeBuilder;

public abstract class AbstractPFSBatchOracleDataLoaderTaskletTests {

    @InjectMocks
    protected PFSBatchOracleDataLoaderTasklet tasklet;
    
    @Mock
    protected PFSBatchClasspathResourceBuilder mockResourceBuilder;
    
    @Mock
    protected PFSBatchRuntimeBuilder mockRuntimeBuilder;
    
    @Mock
    protected Process mockProcess;
    
    @Mock
    protected EventManager mockEventManager;
    
    protected Random random;
    
    private String pathToSqlLoader;
    private String connectionInfo;
    private String sqlLoaderParameters;
    private String pathToControlFile;
    
    @Before
    public void before(){
        EventBatchUtil.getInstance().setEventManager(mockEventManager);
        
        random = new Random();
        
        pathToSqlLoader = RandomStringUtils.random(100);
        connectionInfo = RandomStringUtils.random(100);
        sqlLoaderParameters = RandomStringUtils.random(100);
        pathToControlFile = RandomStringUtils.random(100);
        
        tasklet.setConnectionInfo(connectionInfo);
        tasklet.setSqlLoaderParameters(sqlLoaderParameters);
        Map<String, String> params = new HashMap<String, String>();
        params.put(PFSBatchOracleDataLoaderTasklet.PATH_TO_SQL_LOADER_KEY, pathToSqlLoader);
        params.put(PFSBatchOracleDataLoaderTasklet.PATH_TO_CONTROL_FILE_KEY, pathToControlFile);
        tasklet.setParams(params );
        
        setUpGetResource();
        
        setUpGetRuntime(mockProcess);
        
        childBefore();
    }

    
    @After
    public void after(){
        childAfter();
        
        pathToSqlLoader = null;
        connectionInfo = null;
        sqlLoaderParameters = null;
        pathToControlFile = null;
        
        reset(mockResourceBuilder);
        reset(mockEventManager);
        reset(mockProcess);
        
        random = null;
    }
    
    protected abstract void childBefore();
    
    protected abstract void childAfter();
    
    private void setUpGetRuntime(Process mockProcess) {
        Runtime mockRuntime = mock(Runtime.class);
        when(mockRuntimeBuilder.createRuntime()).thenReturn(mockRuntime );
        
        try {
            when(mockRuntime.exec(any(String[].class))).thenReturn(mockProcess);
        } catch (IOException e) {
           // Esta excepción no se va a producir
        }
        
        InputStream fakeInputStream = IOUtils.toInputStream(RandomStringUtils.random(10000));
        when(mockProcess.getInputStream()).thenReturn(fakeInputStream);
        
    }

    private void setUpGetResource() {
        Resource mockCtlResource = mock(Resource.class);
        File fakeCtlFile = new File(RandomStringUtils.randomAlphabetic(100));
        try {
            when(mockCtlResource.getFile()).thenReturn(fakeCtlFile );
        } catch (IOException e) {
            // No se va a producir esta excepción
        }
        when(mockResourceBuilder.getClasspathResource(pathToControlFile)).thenReturn(mockCtlResource);
    }
}
