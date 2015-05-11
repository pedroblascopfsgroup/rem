package es.capgemini.pfs.batch.analisis.dao.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.analisis.dao.ResumenDao;

/**
 * Implementacion de ResumenDao.
 *
 */
public class ResumenDaoImpl implements ResumenDao {

    private DataSource dataSource;

    private String realizarAnalisisQuery;

    private String borrarAnalisisQuery;

    private String realizarAnalisisExternaQuery;

    private String borrarAnalisisExternaQuery;

    /**
     * {@inheritDoc}
     */
    @Override
    public Long borrarAnalisis(Date fechaExtraccion) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return Long.valueOf(jdbcTemplate.update(borrarAnalisisQuery, new Object[] { df.format(fechaExtraccion) }));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Long realizarAnalisis(Object[] args) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return Long.valueOf(jdbcTemplate.update(realizarAnalisisQuery, args));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Long borrarAnalisisExterna(Date fechaExtraccion) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return Long.valueOf(jdbcTemplate.update(borrarAnalisisExternaQuery, new Object[] { df.format(fechaExtraccion) }));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Long realizarAnalisisExterna(Object[] args) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return Long.valueOf(jdbcTemplate.update(realizarAnalisisExternaQuery, args));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setRealizarAnalisisQuery(String realizarAnalisisQuery) {
        this.realizarAnalisisQuery = realizarAnalisisQuery;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setBorrarAnalisisQuery(String borrarAnalisisQuery) {
        this.borrarAnalisisQuery = borrarAnalisisQuery;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setRealizarAnalisisExternaQuery(String realizarAnalisisExternaQuery) {
        this.realizarAnalisisExternaQuery = realizarAnalisisExternaQuery;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setBorrarAnalisisExternaQuery(String borrarAnalisisExternaQuery) {
        this.borrarAnalisisExternaQuery = borrarAnalisisExternaQuery;
    }
}
