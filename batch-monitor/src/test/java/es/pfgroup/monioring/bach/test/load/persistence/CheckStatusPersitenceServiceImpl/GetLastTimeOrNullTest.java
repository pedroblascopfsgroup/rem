package es.pfgroup.monioring.bach.test.load.persistence.CheckStatusPersitenceServiceImpl;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InOrder;

import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitenceService;
import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitenceServiceImpl;

/**
 * Prueba del método getLastTimeOrNull de
 * {@link CheckStatusPersitenceServiceImpl}
 * 
 * @author bruno
 * 
 */
public class GetLastTimeOrNullTest extends AbstractCheckStatusPersitenceServiceImplTests {

    private Date adate;
    private FileInputStream mockFileInputStream;
    
    private String jobName;
    private String dateTimeProperty;
    private Integer entity;

    @Override
    protected void childBefore() {
        Random random = new Random();
        adate = new Date(random.nextLong());
        entity = Math.abs(random.nextInt(9999));
        jobName = RandomStringUtils.randomAlphabetic(100);
        dateTimeProperty = jobName + "." + entity + "." + CheckStatusPersitenceServiceImpl.CHECK_STATUS_TIME_PROPERTY;
        try {
            mockFileInputStream = mock(FileInputStream.class);
            // file es devuelto por el fileWrapper

            when(fileStreamBuilder.createFileInputStream(file)).thenReturn(mockFileInputStream);
        } catch (IOException e) {
            // No se va a producir el error, sólo mocks
        }

    }

    @Override
    protected void childAfter() {
        adate = null;
        jobName = null;
        entity = null;
        dateTimeProperty = null;
        
        InOrder order = inOrder(properties);
        try {
            order.verify(properties, times(1)).load(mockFileInputStream);
        } catch (IOException e) {
            // NO se va a producir, todo mocks
        } finally {
            file.deleteOnExit();
        }
    }

    /**
     * Devuelve NULL si en el fichero de properties no existe la fecha o no
     * existe el fichero.
     */
    @Test
    public void testGetNull() {
        when(properties.getProperty(dateTimeProperty)).thenReturn(null);

        Date lastTime = persistence.getLastCheckStatusTimeOrNull(entity, jobName);
        assertNull(lastTime);

    }

    /**
     * Devuelve la fecha que existe en el fichero
     */
    @Test
    public void testGetNotNull() {
        when(properties.getProperty(dateTimeProperty)).thenReturn(formatea(adate));

        Date lastTime = persistence.getLastCheckStatusTimeOrNull(entity, jobName);
        assertNotNull(lastTime);
        assertEquals(formatea(adate), formatea(lastTime));

    }

    private String formatea(Date date) {
        return new SimpleDateFormat(CheckStatusPersitenceServiceImpl.DATE_TIME_FORMAT).format(date);
    }

}
