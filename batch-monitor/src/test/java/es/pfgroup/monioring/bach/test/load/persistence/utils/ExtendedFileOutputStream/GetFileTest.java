package es.pfgroup.monioring.bach.test.load.persistence.utils.ExtendedFileOutputStream;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.io.File;
import java.io.FileNotFoundException;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;


import es.pfgroup.monioring.bach.load.persistence.utils.ExtendedFileOutputStream;

/**
 * Prueba del método getFile de {@link ExtendedFileOutputStream}
 * @author bruno
 *
 */
public class GetFileTest {

    @Test
    public void test(){
        File file = new File("target/" + RandomStringUtils.randomAlphabetic(20));
        ExtendedFileOutputStream fos;
        try {
            fos = new ExtendedFileOutputStream(file, false);
            assertEquals(file, fos.getFile());
            file.deleteOnExit();
        } catch (FileNotFoundException e) {
            // No se va a producir la excepción
        }
     
        
    }
}
