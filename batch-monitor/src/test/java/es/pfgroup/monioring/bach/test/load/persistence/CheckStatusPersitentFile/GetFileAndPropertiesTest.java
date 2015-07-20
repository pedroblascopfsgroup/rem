package es.pfgroup.monioring.bach.test.load.persistence.CheckStatusPersitentFile;

import static org.junit.Assert.*;

import java.util.Properties;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;

import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitentFile;

/**
 * Prueba de obtener el File y el Properties  al crear en {@link CheckStatusPersitentFile}
 * @author bruno
 *
 */
public class GetFileAndPropertiesTest {

    
    @Test
    public void test(){
        final String path = "/" + RandomStringUtils.randomAlphabetic(50);
        CheckStatusPersitentFile testObj = new CheckStatusPersitentFile(path);
        
        // Probamos que el properties que obtenemos sea siempre el mismo
        Properties p1 = testObj.getProperties();
        Properties p2 = testObj.getProperties();
        Properties p3 = testObj.getProperties();
        
        assertEquals(p1, p2);
        assertEquals(p2, p3);
        // Y por tanto p3 = p1
        
        assertEquals(path, testObj.getFile().getAbsolutePath());
    }
}
