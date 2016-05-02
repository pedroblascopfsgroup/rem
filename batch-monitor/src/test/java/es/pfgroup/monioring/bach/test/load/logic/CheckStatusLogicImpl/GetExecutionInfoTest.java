package es.pfgroup.monioring.bach.test.load.logic.CheckStatusLogicImpl;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import es.pfgroup.monioring.bach.load.BatchExecutionData;
import es.pfgroup.monioring.bach.load.dao.model.CheckStatusTuple;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusWrongArgumentsException;

public class GetExecutionInfoTest extends AbstractCheckStatusLogicImplTests {

    @Test
    public void testGetExecutionInfo_NoTuples_nullResult() {
        try {
            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(null);

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_NotRunning_NoErrors_NotExecuted(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
            fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
			e.printStackTrace();
		}
    }

    @Test
    public void testGetExecutionInfo_NoTuples_emtpyCollection() {
        try {
            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(new ArrayList());

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_NotRunning_NoErrors_NotExecuted(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
            fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
            e.printStackTrace();
		}
    }

    @Test
    public void testGetExecutionInfo_OnlyRunning() {
        try {
            final List<CheckStatusTuple> tuples = new ArrayList<CheckStatusTuple>();
            tuples.add(createRunningTuple(entity, jobName));

            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(tuples);

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_RUNNING_NoErrors_NotExecuted(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
        	fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
            e.printStackTrace();
		}
    }

    @Test
    public void testGetExecutionInfo_Running_and_Others() {
        try {
            final List<CheckStatusTuple> tuples = new ArrayList<CheckStatusTuple>();
            tuples.add(createRunningTuple(entity, jobName));
            addGarbageContent(tuples, entity, jobName);

            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(tuples);

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_RUNNING_NoErrors_EXECUTED(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
        	fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
            e.printStackTrace();;
		}
    }


    @Test
    public void testGetExecutionInfo_onlyCompleted_NoPasajeProduccion() {
        try {
            final List<CheckStatusTuple> tuples = new ArrayList<CheckStatusTuple>();
            tuples.add(createCompletedTuple(entity, jobName));
            
            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(tuples);

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_NotRunning_NoErrors_EXECUTED(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
        	fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
            e.printStackTrace();
		}
    }
    
    @Test
    public void testGetExecutionInfo_onlyCompleted_PasajeProduccion() {
        try {
            final List<CheckStatusTuple> tuples = new ArrayList<CheckStatusTuple>();
            tuples.add(createCompletedTuple(entity, jobName + CheckStatusTuple.PASAJE_PRODUCCION_MARK));
            
            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(tuples);

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_NotRunning_NoErrors_EXECUTED(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
        	fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
            e.printStackTrace();
		}
    }

    @Test
    public void testGetExecutionInfo_completed_FirstNoPasajeProduccion_and_Others() {
        try {
            final List<CheckStatusTuple> tuples = new ArrayList<CheckStatusTuple>();

            tuples.add(createCompletedTuple(entity, jobName));
            
            addGarbageContent(tuples, entity, jobName);

            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(tuples);

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_NotRunning_NoErrors_EXECUTED(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
        	fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
            e.printStackTrace();
		}
    }

    @Test
    public void testGetExecutionInfo_onlyError() {
        try {
            final List<CheckStatusTuple> tuples = new ArrayList<CheckStatusTuple>();

            tuples.add(createErrorTuple(entity, jobName));

            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(tuples);

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_NotRunning_ERRORS_NotExecuted(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
        	fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
            e.printStackTrace();
		}
    }
    
    @Test
    public void testGetExecutionInfo_firstError_and_Ohters() {
        try {
            final List<CheckStatusTuple> tuples = new ArrayList<CheckStatusTuple>();

            tuples.add(createErrorTuple(entity, jobName));
            
            addGarbageContent(tuples, entity, jobName);

            when(dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime)).thenReturn(tuples);

            final BatchExecutionData result = manager.getExecutionInfo(entity, jobName, lastTime);

            assert_NotRunning_ERRORS_EXECUTED(result);

        } catch (CheckStatusWrongArgumentsException e) {
            // No se tiene porquÃ© producir
        	fail("Excepción inesperada");
            e.printStackTrace();
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
            e.printStackTrace();
		}
    }

    private CheckStatusTuple createRunningTuple(final Integer entity, final String jobName) {
        final CheckStatusTuple mockTuple = mock(CheckStatusTuple.class);
        when(mockTuple.getNombreJob()).thenReturn(jobName);
        when(mockTuple.getEntidad()).thenReturn(entity);
        when(mockTuple.getCodigoEstado()).thenReturn(CheckStatusTuple.CODIGO_ESTADO_RUNNING);
        return mockTuple;
    }

    private CheckStatusTuple createCompletedTuple(final Integer entity, final String jobName) {
        final CheckStatusTuple mockTuple = mock(CheckStatusTuple.class);
        when(mockTuple.getNombreJob()).thenReturn(jobName);
        when(mockTuple.getEntidad()).thenReturn(entity);
        when(mockTuple.getCodigoEstado()).thenReturn(CheckStatusTuple.CODIGO_ESTADO_COMPLETED);
        when(mockTuple.getCodigoSalida()).thenReturn(CheckStatusTuple.CODIGO_SALIDA_COMPLETED);
        return mockTuple;
    }

    private CheckStatusTuple createErrorTuple(final Integer entity, final String jobName) {
        final CheckStatusTuple mockTuple = mock(CheckStatusTuple.class);
        when(mockTuple.getNombreJob()).thenReturn(jobName);
        when(mockTuple.getEntidad()).thenReturn(entity);
        when(mockTuple.getCodigoEstado()).thenReturn(CheckStatusTuple.CODIGO_ESTADO_COMPLETED);
        when(mockTuple.getCodigoSalida()).thenReturn(CheckStatusTuple.CODIGO_SALIDA_FAILED);
        return mockTuple;
    }

    private void addGarbageContent(final List<CheckStatusTuple> tuples, final Integer entity, final String jobName) {
        tuples.add(createErrorTuple(entity, jobName));
        tuples.add(createCompletedTuple(entity, jobName + CheckStatusTuple.PASAJE_PRODUCCION_MARK));
        tuples.add(createErrorTuple(entity, jobName));
        tuples.add(createErrorTuple(entity, jobName + CheckStatusTuple.PASAJE_PRODUCCION_MARK));
        tuples.add(createCompletedTuple(entity, jobName));
        tuples.add(createCompletedTuple(entity, jobName));
        tuples.add(createCompletedTuple(entity, jobName + CheckStatusTuple.PASAJE_PRODUCCION_MARK));
        tuples.add(createErrorTuple(entity, jobName));
        tuples.add(createCompletedTuple(entity, jobName + CheckStatusTuple.PASAJE_PRODUCCION_MARK));
        tuples.add(createErrorTuple(entity, jobName));
        tuples.add(createCompletedTuple(entity, jobName));
        tuples.add(createErrorTuple(entity, jobName + CheckStatusTuple.PASAJE_PRODUCCION_MARK));
        tuples.add(createCompletedTuple(entity, jobName));
    }

    private void assert_NotRunning_NoErrors_NotExecuted(final BatchExecutionData result) {
        genericAssertMethod(result, false, false, false);
    }

    private void assert_RUNNING_NoErrors_NotExecuted(final BatchExecutionData result) {
        genericAssertMethod(result, true, false, false);
    }

    private void assert_RUNNING_NoErrors_EXECUTED(BatchExecutionData result) {
        genericAssertMethod(result, true, false, true);
    }

    private void assert_RUNNING_ERRORS_NotExecuted(BatchExecutionData result) {
        genericAssertMethod(result, true, true, false);
    }

    private void assert_RUNNING_ERRORS_EXECUTED(BatchExecutionData result) {
        genericAssertMethod(result, true, true, true);
    }

    private void assert_NotRunning_NoErrors_EXECUTED(BatchExecutionData result) {
        genericAssertMethod(result, false, false, true);
    }

    private void assert_NotRunning_ERRORS_EXECUTED(BatchExecutionData result) {
        genericAssertMethod(result, false, true, true);
    }

    private void assert_NotRunning_ERRORS_NotExecuted(BatchExecutionData result) {
        genericAssertMethod(result, false, true, false);
    }

    private void genericAssertMethod(final BatchExecutionData result, final boolean isRunning, final boolean hasErrors, final boolean hasExecuted) {
        assertEquals(isRunning, result.isRunning());
        assertEquals(hasErrors, result.hasErrors());
        assertEquals(hasExecuted, result.hasExecuted());
    }

}
