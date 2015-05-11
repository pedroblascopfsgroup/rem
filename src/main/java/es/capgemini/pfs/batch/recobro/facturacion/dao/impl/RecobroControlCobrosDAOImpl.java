package es.capgemini.pfs.batch.recobro.facturacion.dao.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.recobro.facturacion.dao.RecobroControlCobrosDAO;

public class RecobroControlCobrosDAOImpl implements RecobroControlCobrosDAO {
	
	private DataSource dataSource;
	private String cuentaControlCobrosDiaQuery;	
	private String cuentaControlCobrosEntreDiasQuery;
	private String obtenerDistintasSubcarterasEntreDiasQuery;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public void setCuentaControlCobrosDiaQuery(String cuentaControlCobrosDiaQuery) {
		this.cuentaControlCobrosDiaQuery = cuentaControlCobrosDiaQuery;
	}

	public void setCuentaControlCobrosEntreDiasQuery(String cuentaControlCobrosEntreDiasQuery) {
		this.cuentaControlCobrosEntreDiasQuery = cuentaControlCobrosEntreDiasQuery;
	}

	public String getObtenerDistintasSubcarterasEntreDiasQuery() {
		return obtenerDistintasSubcarterasEntreDiasQuery;
	}

	public void setObtenerDistintasSubcarterasEntreDiasQuery(String obtenerDistintasSubcarterasEntreDiasQuery) {
		this.obtenerDistintasSubcarterasEntreDiasQuery = obtenerDistintasSubcarterasEntreDiasQuery;
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public int cuentaControlCobrosDia(Date dia) {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		return jdbcTemplate.queryForInt(cuentaControlCobrosDiaQuery, new Object[] { dia });
	}

	@Override
	public int cuentaControlCobrosEntreDias(Date desde, Date hasta) {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		return jdbcTemplate.queryForInt(cuentaControlCobrosEntreDiasQuery, new Object[] { desde, hasta });
	}

	@Override
	@SuppressWarnings("unchecked")	
	public List<Map> getSubcarterasCobrosPagosPorFechas(Date fechaDesde, Date fechaHasta) {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		return (List<Map>)jdbcTemplate.queryForList(obtenerDistintasSubcarterasEntreDiasQuery, new Object[] { fechaDesde, fechaHasta});
	}

}
