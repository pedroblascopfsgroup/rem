package es.capgemini.pfs.batch.recobro.ranking.dao.impl;

import java.util.Date;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.recobro.ranking.dao.RecobroRankingDao;

public class RecobroRankingDaoImpl implements RecobroRankingDao {

	private DataSource dataSource;
	private String calcularContabilidadQuery;
	
	public DataSource getDataSource() {
		return dataSource;
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public String getCalcularContabilidadQuery() {
		return calcularContabilidadQuery;
	}

	public void setCalcularContabilidadQuery(String calcularContabilidadQuery) {
		this.calcularContabilidadQuery = calcularContabilidadQuery;
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Float calcularContactabilidad(Date fechaInicio, Date fechaFin) {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		return (Float) jdbcTemplate.queryForObject(calcularContabilidadQuery, new Object[] {fechaInicio, fechaFin}, Float.class);
	}
}
