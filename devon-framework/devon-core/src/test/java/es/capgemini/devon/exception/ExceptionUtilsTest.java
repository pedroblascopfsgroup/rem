package es.capgemini.devon.exception;

import static junit.framework.Assert.assertFalse;
import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.assertNull;
import static junit.framework.Assert.assertTrue;

import org.junit.Test;

public class ExceptionUtilsTest {

    private class MyUserException extends UserException {

    }

    private class MyFwkException extends FrameworkException {

    }

    @Test
    public void testFwkExceptions() {
        FrameworkException fwkE = new FrameworkException();
        MyFwkException myFwkE = new MyFwkException();
        RuntimeException rtE = new RuntimeException();
        MyUserException myE = new MyUserException();

        RuntimeException rtFwk = new RuntimeException(fwkE);
        RuntimeException rtVl = new RuntimeException(myFwkE);
        RuntimeException rtMyE = new RuntimeException(myE);

        assertTrue(ExceptionUtils.hasFwkExceptionCause(fwkE));

        assertTrue(ExceptionUtils.hasFwkExceptionCause(myFwkE));

        assertTrue(ExceptionUtils.hasFwkExceptionCause(myE));

        assertTrue(ExceptionUtils.hasUserExceptionCause(myE));

        assertTrue(ExceptionUtils.hasUserExceptionCause(rtMyE));

        assertFalse(ExceptionUtils.hasUserExceptionCause(myFwkE));

        assertFalse(ExceptionUtils.hasUserExceptionCause(fwkE));

        assertFalse(ExceptionUtils.hasFwkExceptionCause(rtE));

        assertFalse(ExceptionUtils.hasUserExceptionCause(rtE));

        assertNotNull(ExceptionUtils.getFwkExceptionCause(fwkE));

        assertNotNull(ExceptionUtils.getFwkExceptionCause(myFwkE));

        assertNotNull(ExceptionUtils.getUserExceptionCause(myE));

        assertNotNull(ExceptionUtils.getUserExceptionCause(rtMyE));

        assertNull(ExceptionUtils.getUserExceptionCause(myFwkE));

        assertNull(ExceptionUtils.getFwkExceptionCause(rtE));

        assertNull(ExceptionUtils.getUserExceptionCause(rtE));

    }

}
