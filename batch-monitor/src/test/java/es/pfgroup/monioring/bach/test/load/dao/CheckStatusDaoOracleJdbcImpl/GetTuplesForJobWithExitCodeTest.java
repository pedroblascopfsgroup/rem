package es.pfgroup.monioring.bach.test.load.dao.CheckStatusDaoOracleJdbcImpl;

import static org.junit.Assert.*;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.mockito.InOrder;

import es.pfgroup.monioring.bach.load.dao.model.CheckStatusTuple;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusErrorType;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRuntimeError;

public class GetTuplesForJobWithExitCodeTest extends AbstractCheckStatusDaoOracleJdbcImplTests{

    @Test
    public void testGetTuples_emptyResultSet() {
        initializeResultSet(resultSet, 0);

        List<CheckStatusTuple> result = prepareExecuteAndVerify(query, resultSet, null, null);

        assertTrue(result.isEmpty());
    }

    @Test
    public void testGetTuples_withData_noLastTime() {
        initializeResultSet(resultSet, 20);

        List<CheckStatusTuple> result = prepareExecuteAndVerify(query, resultSet, null, null);

        assertEquals(20, result.size());
    }

    @Test
    public void testGetTuples_withData_withLastTime() {
        initializeResultSet(resultSet, 20);

        List<CheckStatusTuple> result = prepareExecuteAndVerify(query, resultSet, lastTime, null);

        assertEquals(20, result.size());
    }

    @Test
    public void testGetTuples_SQLException() {
        initializeResultSet(resultSet, 0);
        final Class<SQLException> exceptionToTrow = SQLException.class;
        try {

            prepareExecuteAndVerify(query, resultSet, lastTime, exceptionToTrow);
            fail("Se debería haber producido una excepción");
        } catch (CheckStatusRuntimeError e) {
            assertEquals(CheckStatusErrorType.DATABASE_ERROR, e.getErrorType());
            assertEquals(exceptionToTrow, e.getCause().getClass());
        }
    }

    @Override
    protected void stubSqlBuilder(final String query, final Date lastTime) {
        if (lastTime == null) {
            when(sqlBuilder.selectTuplesForJobWithExitCodeOrderedByIdDesc(entity, jobName, exitCode)).thenReturn(query);
        } else {
            when(sqlBuilder.selectTuplesForJobWithExitCodeOrderedByIdDesc(entity, jobName, exitCode, lastTime)).thenReturn(query);
        }
    }

    @Override
    protected List<CheckStatusTuple> runMethod(final Date lastTime) {
        List<CheckStatusTuple> result = null;
		try {
			result = dao.getTuplesForJobWithExitCodeOrderedByIdDesc(entity, jobName, exitCode, lastTime);
		} catch (CheckStatusRecoverableException e) {
			fail("Se ha producido una excepción no controlada");
			e.printStackTrace();
		}
        return result;
    }

}
