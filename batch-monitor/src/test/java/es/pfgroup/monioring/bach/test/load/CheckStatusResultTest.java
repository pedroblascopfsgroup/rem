package es.pfgroup.monioring.bach.test.load;

import static org.junit.Assert.*;

import org.junit.Test;

import es.pfgroup.monioring.bach.load.CheckStatusResult;

/**
 * Comprueba que los códigos de error sean los esperados
 * @author bruno
 *
 */
public class CheckStatusResultTest {
    
    @Test
    public void testExitStatus(){
        assertEquals("El código de estado para OK no es el esperado", 0, CheckStatusResult.OK.ordinal());
        assertEquals("El código de estado par ERROR no es el esperado", 1, CheckStatusResult.ERROR.ordinal());
        assertEquals("El código de error para no ejecutado  no es el esperado", 2, CheckStatusResult.RUNNING.ordinal());
        assertEquals("El código de error para no ejecutado  no es el esperado", 3, CheckStatusResult.NOT_EXECUTED.ordinal());
    }

}
