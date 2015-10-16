package es.pfgroup.monioring.bach.test.load.persistence.CheckStatusPersitenceServiceImpl;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InOrder;

import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitenceServiceImpl;
import es.pfgroup.monioring.bach.load.persistence.utils.ExtendedFileOutputStream;

/**
 * Pruebas del método saveCurrentDateTime de
 * {@link CheckStatusPersitenceService}
 * 
 * @author bruno
 * 
 */
public class SaveCurrentDateTimeTest extends AbstractCheckStatusPersitenceServiceImplTests {
    
    private String jobName;
    private Integer entity;
    private String dateTimeProperty;
    
    @Override
    protected void childBefore() {
        Random random = new Random();
        jobName = RandomStringUtils.randomAlphabetic(100);
        entity = Math.abs(random.nextInt(9999));
        dateTimeProperty = jobName + "." + entity + "." + CheckStatusPersitenceServiceImpl.CHECK_STATUS_TIME_PROPERTY;
    }

    @Override
    protected void childAfter() {
        jobName = null;
        entity = null;
        dateTimeProperty = null;
    }

    @Test
    public void testSaveDateTime() {
        
        try {
            persistence.saveCheckStatusTime(entity,jobName);

            InOrder order = inOrder(properties);
            ArgumentCaptor<ExtendedFileOutputStream> fileOutputStramCaptor = ArgumentCaptor.forClass(ExtendedFileOutputStream.class);

            order.verify(properties, times(1)).setProperty(dateTimeProperty, currentDateFormated);
            order.verify(properties, times(1)).store(fileOutputStramCaptor.capture(), any(String.class));

            ExtendedFileOutputStream fos = fileOutputStramCaptor.getValue();
            assertEquals(file, fos.getFile());
        } catch (IOException e) {
            // No se va a producir, son mocks
        } finally {
            file.deleteOnExit();
        }
    }

    

}
