package es.pfgroup.monioring.bach.test.load.persistence.CheckStatusPersitenceServiceImpl;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;

import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitenceServiceImpl;
import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitentFile;
import es.pfgroup.monioring.bach.load.persistence.utils.CheckStatusFileStreamBuilder;

public abstract class AbstractCheckStatusPersitenceServiceImplTests {

    protected CheckStatusPersitenceServiceImpl persistence;
    protected CheckStatusPersitentFile fileWrapper;
    protected CheckStatusFileStreamBuilder fileStreamBuilder;
    protected String filePath;
    protected String currentDateFormated;
    protected Properties properties;
    protected File file;

    public AbstractCheckStatusPersitenceServiceImplTests() {
        super();
    }

    @Before
    public void before() {
        fileWrapper = mock(CheckStatusPersitentFile.class);
        fileStreamBuilder = mock(CheckStatusFileStreamBuilder.class);
        filePath = "target/" + RandomStringUtils.randomAlphabetic(10);
        persistence = new CheckStatusPersitenceServiceImpl(fileWrapper, fileStreamBuilder);
        SimpleDateFormat sdf = new SimpleDateFormat(CheckStatusPersitenceServiceImpl.DATE_TIME_FORMAT);
        currentDateFormated = sdf.format(new Date());
        
        properties = mock(Properties.class);
        file = new File(filePath);
        when(fileWrapper.getProperties()).thenReturn(properties);
        when(fileWrapper.getFile()).thenReturn(file);
        
        childBefore();
    }

    @After
    public void after() {
        childAfter();
        
        fileWrapper = null;
        fileStreamBuilder = null;
        persistence = null;
        filePath = null;
        currentDateFormated = null;
        file = null;
        properties = null;
    }
    
    protected abstract void childBefore();
    protected abstract void childAfter();

}