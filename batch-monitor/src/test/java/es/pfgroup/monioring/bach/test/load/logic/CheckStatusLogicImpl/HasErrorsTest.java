package es.pfgroup.monioring.bach.test.load.logic.CheckStatusLogicImpl;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Test;

import es.pfgroup.monioring.bach.load.dao.CheckStatusDao;
import es.pfgroup.monioring.bach.load.dao.model.CheckStatusTuple;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusErrorType;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusWrongArgumentsException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusUserError;
import es.pfgroup.monioring.bach.load.logic.CheckStatusLogicImpl;

/**
 * Pruebas de la operación de negocio hasErrors de {@link CheckStatusLogicImpl}
 * 
 * @author bruno
 * 
 */
public class HasErrorsTest extends AbstractCheckStatusLogicImplTests{

    @Test
    public void testAskDaoAndReturnNoError() {
        boolean result = execueAndVerify(entity, jobName, lastTime, new ArrayList());

        assertFalse(result);
    }

    @Test
    public void testAskDaoAndReturnWithErrors() {
        try {
            List<CheckStatusTuple> errorList = new ArrayList<CheckStatusTuple>();
            errorList.add(CheckStatusTuple.createFromResultSet(mock(ResultSet.class)));
            boolean result = execueAndVerify(entity, jobName, lastTime, errorList);

            assertTrue(result);
        } catch (SQLException e) {
            // No se va a producir nunca, es un mock
        }

    }
    
    @Test
    public void testAskDaoAndReturnWithErrors_noLastTime() {
        try {
            List<CheckStatusTuple> errorList = new ArrayList<CheckStatusTuple>();
            errorList.add(CheckStatusTuple.createFromResultSet(mock(ResultSet.class)));
            boolean result = execueAndVerify(entity, jobName, null, errorList);

            assertTrue(result);
        } catch (SQLException e) {
            // No se va a producir nunca, es un mock
        }

    }

    @Test
    public void testNullArguments() {
        try {
            manager.hasErrors(null, null, null);
            fail("Debería haberse producido una excepción.");
        } catch (CheckStatusWrongArgumentsException e) {
            assertEquals(CheckStatusErrorType.MISSING_ARGUMENTS, e.getErrorType());
        } catch (CheckStatusRecoverableException e) {
			fail("Excepción inesperada");
			e.printStackTrace();
		}
    }
    
    @Test
    public void testTwoMissingArguments() {
        try {
            manager.hasErrors(1, null, null);
            fail("Debería haberse producido una excepción.");
        } catch (CheckStatusWrongArgumentsException e) {
            assertEquals(CheckStatusErrorType.MISSING_ARGUMENTS, e.getErrorType());
        } catch (CheckStatusRecoverableException e) {
        	fail("Excepción inesperada");
			e.printStackTrace();
		}
    }

    /**
     * Ejecuta el método del manager, simulado que el dao devuelve unos
     * determinados resultados y verifica que se haya llamado al DAO.
     * 
     * @param entity
     * @param jobName
     * @param lastTime
     *            Fecha de última ejecución. Dependiendo de si es NULL o no se
     *            tendrá en cuenta este valor para la consulta o no.
     * @param daoResult
     * 
     * @return
     */
    private boolean execueAndVerify(final Integer entity, final String jobName, final Date lastTime, final List<CheckStatusTuple> daoResult) {
        try {
            when(dao.getTuplesForJobWithExitCodeOrderedByIdDesc(entity, jobName, CheckStatusDao.EXIT_CODE_ERROR, lastTime)).thenReturn(daoResult);

            boolean result = manager.hasErrors(entity, jobName, lastTime);

            verify(dao, times(1)).getTuplesForJobWithExitCodeOrderedByIdDesc(entity, jobName, CheckStatusDao.EXIT_CODE_ERROR, lastTime);

            return result;
        } catch (CheckStatusWrongArgumentsException e) {
            // Esto no va a ocurrir porque son mocks
            return false;
        } catch (CheckStatusRecoverableException e) {
            // Esto no va a ocurrir porque son mocks
            return false;
		}
    }

}
