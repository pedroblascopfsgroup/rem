package es.pfgroup.monioring.bach.load.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLRecoverableException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import es.pfgroup.monioring.bach.load.dao.jdbc.JDBCConnectionFacace;
import es.pfgroup.monioring.bach.load.dao.jdbc.OracleJdbcFacade;
import es.pfgroup.monioring.bach.load.dao.model.CheckStatusTuple;
import es.pfgroup.monioring.bach.load.dao.model.query.OracleModelQueryBuilder;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRuntimeError;

public class CheckStatusDaoOracleJdbcImpl implements CheckStatusDao {

    private final JDBCConnectionFacace jdbc;
    private final OracleModelQueryBuilder queryBuilder;

    public CheckStatusDaoOracleJdbcImpl(final JDBCConnectionFacace jdbcFacade, OracleModelQueryBuilder sqlBuilder) {
        this.jdbc = jdbcFacade;
        this.queryBuilder = sqlBuilder;

    }

    @Override
    public List<CheckStatusTuple> getTuplesForJobWithExitCodeOrderedByIdDesc(final Integer entity, final String jobName, final String exitCode, final Date lastTime) throws CheckStatusRecoverableException {
        final String query = queryWithExitCode(entity, jobName, exitCode, lastTime);
        return runQuery(query);
    }

    @Override
    public List<CheckStatusTuple> getTuplesForJobOrderedByIdDesc(Integer entity, String jobName, Date lastTime) throws CheckStatusRecoverableException {
        final String query = queryWithoutExitCode(entity, jobName, lastTime);
        return runQuery(query);
    }

    private String queryWithExitCode(final Integer entity, final String jobName, final String exitCode, final Date lastTime) {
        String query;
        if (lastTime != null) {
            query = queryBuilder.selectTuplesForJobWithExitCodeOrderedByIdDesc(entity, jobName, exitCode, lastTime);
        } else {
            query = queryBuilder.selectTuplesForJobWithExitCodeOrderedByIdDesc(entity, jobName, exitCode);
        }
        return query;
    }

    private String queryWithoutExitCode(final Integer entity, final String jobName, final Date lastTime) {
        String query;
        if (lastTime != null) {
            query = queryBuilder.selectTuplesForJobOrderedByIdDesc(entity, jobName, lastTime);
        } else {
            query = queryBuilder.selectTuplesForJobOrderedByIdDesc(entity, jobName);
        }
        return query;
    }

    private List<CheckStatusTuple> runQuery(final String query) throws CheckStatusRecoverableException {
        ArrayList<CheckStatusTuple> tuples = new ArrayList<CheckStatusTuple>();
        try {

            ResultSet resultSet = jdbc.connectAndExecute(query);
            while (resultSet.next()) {
                tuples.add(CheckStatusTuple.createFromResultSet(resultSet));
            }
		} catch (SQLRecoverableException sre) {
			throw new CheckStatusRecoverableException(sre);
        }catch (SQLException sqle) {
            throw new CheckStatusRuntimeError(sqle);
        } finally {
            try {
                jdbc.close();
            } catch (SQLException e) {
                throw new CheckStatusRuntimeError(e);
            }
        }
        return tuples;
    }

}
