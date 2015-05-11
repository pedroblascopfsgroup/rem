package es.capgemini.pfs.batch.revisar.arquetipos.repo.dao.impl;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.batch.revisar.arquetipos.repo.dao.ArquetiposBatchDao;

/**
 * Implementación de {@link ArquetiposBatchDao}
 * @author bruno
 *
 */
@Repository("arquetiposBatchDao")
public class ArquetiposBatchDaoImpl implements ArquetiposBatchDao{
	
    private DataSource dataSource;

	@Override
	public List<Map<String, Object>> executeSelect(final String query) {
		if (this.dataSource == null){
			throw new IllegalStateException("'dataSource' No puede ser NULL");
		}
		final JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		return jdbcTemplate.queryForList(query);
	}

	@Override
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

}
