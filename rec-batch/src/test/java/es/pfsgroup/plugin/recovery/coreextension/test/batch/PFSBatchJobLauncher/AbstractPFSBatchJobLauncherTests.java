package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchJobLauncher;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import static org.mockito.Mockito.*;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.capgemini.devon.batch.BatchManager;
import es.capgemini.devon.events.EventManager;
import es.capgemini.pfs.dsm.DataSourceManager;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.job.JobController;

public abstract class AbstractPFSBatchJobLauncherTests {

    protected static final String FAKE_DIR = File.separator+"fakePath"+File.separator+"load"+File.separator+"test"+File.separator+"batch";
    protected static final String FAKE_DIR_WIND = "C:/fakePath/load/test/batch";

    @InjectMocks
    protected PFSBatchJobLauncherForTesting launcher;

    @Mock
    protected EntidadDao mockEntidadDao;

    @Mock
    protected EventManager mockEventManager;

    @Mock
    protected BatchManager mockBatchManager;
    
    @Mock
    private JobController mockJobController;

    protected Map<String, Object> params;
    protected File semaphore;
    protected String workingCode;
    protected Date extractTime;
    protected String jobName;
    private String semaphoreName;
    private String chainChannel; 
    protected Random random;
    protected String extension;
    protected String pathToSqlLoader;
    protected String connectionInfo;
    protected String sqlldrParams;

    private VerificadorPFSBatchJobLauncher verificador;

    @Before
    public void before() {
        params = new HashMap<String, Object>();
        random = new Random();
        semaphore = new File(FAKE_DIR + "/semaphore.sem");
        workingCode = RandomStringUtils.random(5);
        extension = RandomStringUtils.random(3);
        long timestamp = Math.abs(random.nextLong());
        if (timestamp < 0){
            timestamp *= -1;
        }
        extractTime = new Date(timestamp);
        pathToSqlLoader = RandomStringUtils.random(1000);
        connectionInfo = RandomStringUtils.random(1000);
        sqlldrParams = RandomStringUtils.random(1000);
        jobName = RandomStringUtils.random(100);
        semaphoreName = RandomStringUtils.random(20);
        chainChannel = RandomStringUtils.random(20);

        launcher.setWorkingCode(workingCode);
        launcher.setExtractTime(extractTime);
        launcher.setFilesExtension(extension);
        launcher.setJobName(jobName);
        launcher.setSemaphoreName(semaphoreName);
        launcher.setFilesToLoad(filesToLoad(random.nextInt(50)));
        launcher.setChainChannel(chainChannel);

        Entidad mockEntidad = mock(Entidad.class);
        when(mockEntidadDao.get(any(Long.class))).thenReturn(mockEntidad);
        when(mockEntidadDao.findByWorkingCode(workingCode)).thenReturn(mockEntidad);
        when(mockEntidad.getId()).thenReturn(random.nextLong());
        when(mockEntidad.configValue(DataSourceManager.PATH_TO_SQLLOADER)).thenReturn(pathToSqlLoader);
        when(mockEntidad.configValue(DataSourceManager.CONNECTION_INFO)).thenReturn(connectionInfo);
        when(mockEntidad.configValue(DataSourceManager.SQLLDR_PARAMS)).thenReturn(sqlldrParams);

        verificador = new VerificadorPFSBatchJobLauncher(mockBatchManager, mockJobController);

        childBefore();
    }

    private Map<String, String> filesToLoad(int count) {
        final HashMap<String, String> files = new HashMap<String, String>();
        final String keyPhrase = RandomStringUtils.random(10);
        final String valuePhrase = RandomStringUtils.random(10);

        for (int i = 0; i < Math.abs(count); i++) {
            files.put(keyPhrase + i, valuePhrase + i);
        }
        return files;
    }

    @After
    public void after() {
        childAfter();
        launcher = null;
        params = null;
        extractTime = null;
        workingCode = null;
        extension = null;
        semaphore = null;
        random = null;
        connectionInfo = null;
        pathToSqlLoader = null;
        sqlldrParams = null;
        jobName = null;
        semaphoreName = null;
        chainChannel = null;
        reset(mockEntidadDao);
        reset(mockBatchManager);
        reset(mockEventManager);

        verificador = null;
    }

    protected abstract void childBefore();

    protected abstract void childAfter();

    protected String getExtractTimeAsString() {
        return new SimpleDateFormat("yyyyMMdd").format(extractTime);
    }

    protected VerificadorPFSBatchJobLauncher verificar() {
        return this.verificador;
    }

}
