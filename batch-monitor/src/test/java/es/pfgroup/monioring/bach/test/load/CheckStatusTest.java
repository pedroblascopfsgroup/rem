package es.pfgroup.monioring.bach.test.load;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.Date;
import java.util.Random;

import javax.lang.model.type.ErrorType;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InOrder;

import es.pfgroup.monioring.bach.load.BatchExecutionData;
import es.pfgroup.monioring.bach.load.CheckStatusApp;
import es.pfgroup.monioring.bach.load.CheckStatusResult;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusErrorType;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusMalfunctionError;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusUserError;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusWrongArgumentsException;
import es.pfgroup.monioring.bach.load.logic.CheckStatusLogic;
import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitenceService;

public class CheckStatusTest {

    private CheckStatusApp app;

    private CheckStatusLogic logic;

    private CheckStatusPersitenceService persistenceService;

    private String jobName;

    private Integer entity;

    private Date lastTime;

    private BatchExecutionData batchExecutionData;

    @Before
    public void before() {
        final Random random = new Random();
        logic = mock(CheckStatusLogic.class);
        persistenceService = mock(CheckStatusPersitenceService.class);
        batchExecutionData = mock(BatchExecutionData.class);
        app = new CheckStatusApp(logic, persistenceService);
        jobName = RandomStringUtils.randomAlphabetic(100);
        entity = random.nextInt();
        lastTime = new Date(random.nextLong());

        when(persistenceService.getLastCheckStatusTimeOrNull(entity, jobName)).thenReturn(lastTime);
    }

    @After
    public void after() {

        logic = null;
        persistenceService = null;
        batchExecutionData = null;
        app = null;
        jobName = null;
        entity = null;
        lastTime = null;
    }

    @Test
    public void test_NotRunning_NoErrors_NotExecuted_RETURN_NOT_EXECUTED() {
        stubGetExecutionInfo();

        when(batchExecutionData.isRunning()).thenReturn(false);
        when(batchExecutionData.hasErrors()).thenReturn(false);
        when(batchExecutionData.hasExecuted()).thenReturn(false);

        CheckStatusResult result = app.run(createArguments(entity, jobName));
        assertEquals(CheckStatusResult.NOT_EXECUTED, result);

        verify(persistenceService, times(1)).getLastCheckStatusTimeOrNull(entity, jobName);
        // No se persiste la ejecución.
        verifyZeroInteractions(persistenceService);

    }

    @Test
    public void test_RUNNING_NoErrors_NotExecuted_RETURN_RUNNING() {
        stubGetExecutionInfo();

        when(batchExecutionData.isRunning()).thenReturn(true);
        when(batchExecutionData.hasErrors()).thenReturn(false);
        when(batchExecutionData.hasExecuted()).thenReturn(false);

        CheckStatusResult result = app.run(createArguments(entity, jobName));
        assertEquals(CheckStatusResult.RUNNING, result);

        verify(persistenceService, times(1)).getLastCheckStatusTimeOrNull(entity, jobName);
        // No se persiste la ejecución.
        verifyZeroInteractions(persistenceService);

    }

    @Test
    public void test_RUNNING_ERRORS_NotExecuted_RETURN_RUNNING() {
        stubGetExecutionInfo();

        when(batchExecutionData.isRunning()).thenReturn(true);
        when(batchExecutionData.hasErrors()).thenReturn(true);
        when(batchExecutionData.hasExecuted()).thenReturn(false);

        CheckStatusResult result = app.run(createArguments(entity, jobName));
        assertEquals(CheckStatusResult.RUNNING, result);

        verify(persistenceService, times(1)).getLastCheckStatusTimeOrNull(entity, jobName);
        // No se persiste la ejecución.
        verifyZeroInteractions(persistenceService);

    }
    
    @Test
    public void test_RUNNING_NoErrors_EXECUTED_RETURN_RUNNING() {
        stubGetExecutionInfo();

        when(batchExecutionData.isRunning()).thenReturn(true);
        when(batchExecutionData.hasErrors()).thenReturn(true);
        when(batchExecutionData.hasExecuted()).thenReturn(false);

        CheckStatusResult result = app.run(createArguments(entity, jobName));
        assertEquals(CheckStatusResult.RUNNING, result);

        verify(persistenceService, times(1)).getLastCheckStatusTimeOrNull(entity, jobName);
        // No se persiste la ejecución.
        verifyZeroInteractions(persistenceService);

    }

    @Test
    public void test_RUNNING_ERRORS_EXECUTED_RETURN_RUNNING() {
        stubGetExecutionInfo();

        when(batchExecutionData.isRunning()).thenReturn(true);
        when(batchExecutionData.hasErrors()).thenReturn(true);
        when(batchExecutionData.hasExecuted()).thenReturn(true);

        CheckStatusResult result = app.run(createArguments(entity, jobName));
        assertEquals(CheckStatusResult.RUNNING, result);

        verify(persistenceService, times(1)).getLastCheckStatusTimeOrNull(entity, jobName);
        // No se persiste la ejecución.
        verifyZeroInteractions(persistenceService);

    }

    @Test
    public void test_NotRunning_ERRORS_NotExecuted_RETURN_ERROR() {
        stubGetExecutionInfo();

        when(batchExecutionData.isRunning()).thenReturn(false);
        when(batchExecutionData.hasErrors()).thenReturn(true);
        when(batchExecutionData.hasExecuted()).thenReturn(false);

        CheckStatusResult result = app.run(createArguments(entity, jobName));
        assertEquals(CheckStatusResult.ERROR, result);

        verify(persistenceService, times(1)).getLastCheckStatusTimeOrNull(entity, jobName);
        // No se persiste la ejecución.
        verifyZeroInteractions(persistenceService);

    }

    @Test
    public void test_NotRunning_ERRORS_EXECUTED_RETURN_ERROR() {
        stubGetExecutionInfo();

        when(batchExecutionData.isRunning()).thenReturn(false);
        when(batchExecutionData.hasErrors()).thenReturn(true);
        when(batchExecutionData.hasExecuted()).thenReturn(true);

        CheckStatusResult result = app.run(createArguments(entity, jobName));
        assertEquals(CheckStatusResult.ERROR, result);

        verify(persistenceService, times(1)).getLastCheckStatusTimeOrNull(entity, jobName);
        // No se persiste la ejecución.
        verifyZeroInteractions(persistenceService);

    }

    @Test
    public void test_NotRunning_NoErrors_EXECUTED_RETURN_OK() {
        stubGetExecutionInfo();

        when(batchExecutionData.isRunning()).thenReturn(false);
        when(batchExecutionData.hasErrors()).thenReturn(false);
        when(batchExecutionData.hasExecuted()).thenReturn(true);

        CheckStatusResult result = app.run(createArguments(entity, jobName));
        assertEquals(CheckStatusResult.OK, result);

        verify(persistenceService, times(1)).getLastCheckStatusTimeOrNull(entity, jobName);
        // Persistimos la fecha.
        verify(persistenceService, times(1)).saveCheckStatusTime(entity, jobName);

    }

    @Test
    public void testNullArguments() {
        try {
            app.run(null);
            fail("Debería haberse lanzad una excepción.");
        } catch (CheckStatusUserError e) {
            assertEquals(CheckStatusErrorType.MISSING_ARGUMENTS, e.getErrorType());
        }
    }

    @Test
    public void testEmptyArray() {
        try {
            app.run(new String[] {});
            fail("Debería haberse lanzad una excepción.");
        } catch (CheckStatusUserError e) {
            assertEquals(CheckStatusErrorType.MISSING_ARGUMENTS, e.getErrorType());
        }
    }

    @Test
    public void testOnlyOneArgument() {
        try {
            String[] argument = { "bla bla bla" };
            app.run(argument);
            fail("Debería haberse lanzad una excepción.");
        } catch (CheckStatusUserError e) {
            assertEquals(CheckStatusErrorType.MISSING_ARGUMENTS, e.getErrorType());
        }
    }

    @Test
    public void testWrongArgumentsInLogic() {
        final Class<CheckStatusWrongArgumentsException> exception = CheckStatusWrongArgumentsException.class;
        exceptionOnGetExecutionInfo(exception);

        String[] arguments = { entity.toString(), jobName };
        try {
            app.run(arguments);
            fail("Debería haberse lanzado una excepción.");
        } catch (CheckStatusMalfunctionError e) {
            assertEquals(exception, e.getCause().getClass());
        }
    }

    /**
     * Crea un array con los argumentos.
     * 
     * @param entity
     * @param jobName
     * @return
     */
    private String[] createArguments(final Integer entity, final String jobName) {
        String[] arguments = { entity.toString(), jobName };
        return arguments;
    }

    private void stubGetExecutionInfo() {
        try {
            when(logic.getExecutionInfo(entity, jobName, lastTime)).thenReturn(batchExecutionData);
        } catch (CheckStatusWrongArgumentsException e) {
            // SÓLO MOCKS no se produce la excepción
        } catch (CheckStatusRecoverableException e) {
        	// SÓLO MOCKS no se produce la excepción
		}
    }

    private void exceptionOnGetExecutionInfo(Class<CheckStatusWrongArgumentsException> exception) {
        try {
            when(logic.getExecutionInfo(any(Integer.class), any(String.class), any(Date.class))).thenThrow(exception);
        } catch (CheckStatusWrongArgumentsException e) {
            // No se produce la excepción porque es un mock
        } catch (CheckStatusRecoverableException e) {
        	// No se produce la excepción porque es un mock
		}
    }

}
