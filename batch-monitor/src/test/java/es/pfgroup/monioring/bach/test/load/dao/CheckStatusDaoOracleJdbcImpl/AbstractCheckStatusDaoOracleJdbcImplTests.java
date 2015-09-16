package es.pfgroup.monioring.bach.test.load.dao.CheckStatusDaoOracleJdbcImpl;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.mockito.stubbing.OngoingStubbing;

import es.pfgroup.monioring.bach.load.dao.CheckStatusDaoOracleJdbcImpl;
import es.pfgroup.monioring.bach.load.dao.jdbc.OracleJdbcFacade;
import es.pfgroup.monioring.bach.load.dao.model.CheckStatusTuple;
import es.pfgroup.monioring.bach.load.dao.model.query.OracleModelQueryBuilder;

public abstract class AbstractCheckStatusDaoOracleJdbcImplTests {

    protected CheckStatusDaoOracleJdbcImpl dao;
    protected OracleJdbcFacade jdbcFacade;
    protected OracleModelQueryBuilder sqlBuilder;
    protected String exitCode;
    protected String jobName;
    protected ResultSet resultSet;
    protected String query;
    protected Integer entity;
    protected Date lastTime;

    @Before
    public void before() {
        final Random random = new Random();
    
        jdbcFacade = mock(OracleJdbcFacade.class);
        sqlBuilder = mock(OracleModelQueryBuilder.class);
    
        dao = new CheckStatusDaoOracleJdbcImpl(jdbcFacade, sqlBuilder);
    
        exitCode = RandomStringUtils.randomAlphabetic(10);
        jobName = RandomStringUtils.randomAlphabetic(100);
        query = RandomStringUtils.random(1000);
        entity = random.nextInt();
        resultSet = mock(ResultSet.class);
        lastTime = new Date(random.nextLong());
    }

    @After
    public void after() {
        jdbcFacade = null;
        dao = null;
        exitCode = null;
        jobName = null;
        entity = null;
        lastTime = null;
    }

    protected void initializeResultSet(final ResultSet resultSet, final int size) {
    
        try {
            OngoingStubbing<Boolean> stub = when(resultSet.next());
            for (int i = 0; i < size; i++) {
                stub = stub.thenReturn(true);
            }
            stub.thenReturn(false);
    
        } catch (SQLException e) {
            // No se va a producir nunca, es un mock
        }
    }

    /**
     * Prepara los mocks, ejecuta el método del dao y verifica la ejecución.
     * 
     * @param query
     *            Consulta que se quiere ejecutar
     * @param resultSet
     *            Resultado esperado..
     * @param lastTime
     *            Fecha/hora por la que filtrar. Puede ser NULL
     * @param exceptionToTrow
     *            Excepción que hay que lanzar, si se especifica se va a simular
     *            que se produce esta excepción a nivel de JDBC.
     * @return Resultado real obtenido por el DAO
     */
    protected List<CheckStatusTuple> prepareExecuteAndVerify(final String query, final ResultSet resultSet, final Date lastTime, final Class<SQLException> exceptionToTrow) {
        try {
            stubSqlBuilder(query, lastTime);
    
            if (exceptionToTrow == null) {
                when(jdbcFacade.connectAndExecute(query)).thenReturn(resultSet);
            } else {
                when(jdbcFacade.connectAndExecute(query)).thenThrow(exceptionToTrow);
            }
    
            List<CheckStatusTuple> result = runMethod(lastTime);
    
            verify(jdbcFacade, times(1)).connectAndExecute(query);
            verify(jdbcFacade, times(1)).close();
            return result;
        } catch (SQLException sqle) {
            // Estas excepciones no se produciran, se usan mocks
            return null;
        }
    
    }

    protected abstract void stubSqlBuilder(final String query, final Date lastTime);
    
    protected abstract List<CheckStatusTuple> runMethod(final Date lastTime);

}
