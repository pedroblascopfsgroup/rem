package es.capgemini.pfs.batch.mail;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;

/**
 * Implementacion de TareasPendientesDao.
 *
 */
public class TareasPendientesDaoImpl implements TareasPendientesDao {

    private String queryTareasPendientes;
    private DataSource dataSource;

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List obtenerTareasPendientes() {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForList(queryTareasPendientes);
    }

    /**
     * @param queryTareasPendientes the queryTareasPendientes to set
     */
    public void setQueryTareasPendientes(String queryTareasPendientes) {
        this.queryTareasPendientes = queryTareasPendientes;
    }

    /**
     * @param dataSource the dataSource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

}
