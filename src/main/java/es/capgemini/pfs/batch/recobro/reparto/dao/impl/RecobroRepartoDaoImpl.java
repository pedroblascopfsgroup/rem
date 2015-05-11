package es.capgemini.pfs.batch.recobro.reparto.dao.impl;

import java.util.Date;
import java.util.HashMap;

import javax.sql.DataSource;

import org.hibernate.Query;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.batch.recobro.reparto.dao.RecobroRepartoDao;
import es.capgemini.pfs.batch.recobro.reparto.model.HistoricoReparto;
import es.capgemini.pfs.dao.AbstractEntityDao;

@Repository("HistoricoReparto")
public class RecobroRepartoDaoImpl extends AbstractEntityDao<HistoricoReparto, Long> implements RecobroRepartoDao {
	
	private DataSource dataSource;
	private String getMinFechaCntAgeSubQuery;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public void setGetMinFechaCntAgeSubQuery(String getMinFechaCntAgeSubQuery) {
		this.getMinFechaCntAgeSubQuery = getMinFechaCntAgeSubQuery;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Date getMinFechaCntAgeSubHistReparto(long cntId, long ageId, long subId) {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		return (Date)jdbcTemplate.queryForObject(getMinFechaCntAgeSubQuery, new Object[] {cntId, subId, ageId}, Date.class);
	}
	
	private void setParameters(Query query, HashMap<String, Object> params) {
		if (params == null) {
			return;
		}
		for (String key : params.keySet()) {
			Object param = params.get(key);
			query.setParameter(key, param);
		}
	}	

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Long getCountClientes(Date fechaHistorico, Long agenciaId) {
		String sb ="Select count(distinct persona) from HistoricoReparto " +
				"Where fechaHistorico = :fechaHistorico ";
		
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("fechaHistorico", fechaHistorico);
		
		if (agenciaId!=null) {
			sb += "and recobroAgencia.id = :agenciaId";
			params.put("agenciaId", agenciaId);
		}
		
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		
		return (Long) query.uniqueResult();
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Long getCountContratos(Date fechaHistorico, Long agenciaId) {
		String sb = "Select count(distinct contrato) from HistoricoReparto " +
				"Where fechaHistorico = :fechaHistorico ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("fechaHistorico", fechaHistorico);
		
		if (agenciaId!=null) {
			sb += "and recobroAgencia.id = :agenciaId";
			params.put("agenciaId", agenciaId);
		}
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		
		return (Long) query.uniqueResult();
	}

	/**
	 * {@inheritDoc} 
	 */		
	@Override
	public Double getSaldoIrregular(Date fechaHistorico, Long agenciaId) {
		String sb = "Select sum(mov.deudaIrregular) from HistoricoReparto hist join hist.contrato cnt join cnt.movimientos mov " +
				"Where cnt.fechaExtraccion = mov.fechaExtraccion and hist.fechaHistorico = :fechaHistorico ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("fechaHistorico", fechaHistorico);
		
		if (agenciaId!=null) {
			sb += "and hist.recobroAgencia.id = :agenciaId ";
			params.put("agenciaId", agenciaId);
		}
		
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		
		return (Double) query.uniqueResult();
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	public Double getSaldoVivo(Date fechaHistorico, Long agenciaId) {
		String sb = "Select sum(mov.riesgo) from HistoricoReparto hist join hist.contrato cnt join cnt.movimientos mov " +
				"Where cnt.fechaExtraccion = mov.fechaExtraccion and hist.fechaHistorico = :fechaHistorico ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("fechaHistorico", fechaHistorico);
		
		if (agenciaId!=null) {
			sb += "and hist.recobroAgencia.id = :agenciaId ";
			params.put("agenciaId", agenciaId);
		}
		
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		
		return (Double) query.uniqueResult();
	}

	/**
	 * {@inheritDoc} 
	 */	
	@Override
	public Date getFechaUltimoRepartoHistorico() {
		String sb ="Select max(fechaHistorico) from HistoricoReparto";
		Query query = getSession().createQuery(sb);
		
		return (Date) query.uniqueResult();
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Long getCountClientes(Date fechaHistorico, Long agenciaId, Long subCarteraId) {
		String sb ="Select count(distinct persona) from HistoricoReparto " +
				"Where fechaHistorico = :fechaHistorico ";
		
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("fechaHistorico", fechaHistorico);
		
		if (agenciaId!=null) {
			sb += " and recobroAgencia.id = :agenciaId";
			params.put("agenciaId", agenciaId);
		}
		
		if (subCarteraId!=null){
			sb += " and recobroSubCartera.id = :subCarteraId";
			params.put("subCarteraId", subCarteraId);
		}
		
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		
		return (Long) query.uniqueResult();
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Long getCountContratos(Date fechaHistorico, Long agenciaId, Long subCarteraId) {
		String sb = "Select count(distinct contrato) from HistoricoReparto " +
				"Where fechaHistorico = :fechaHistorico ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("fechaHistorico", fechaHistorico);
		
		if (agenciaId!=null) {
			sb += " and recobroAgencia.id = :agenciaId";
			params.put("agenciaId", agenciaId);
		}
		
		if (subCarteraId!=null){
			sb += " and recobroSubCartera.id = :subCarteraId";
			params.put("subCarteraId", subCarteraId);
		}
		
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		
		return (Long) query.uniqueResult();
	}

	/**
	 * {@inheritDoc} 
	 */		
	@Override
	public Double getSaldoIrregular(Date fechaHistorico, Long agenciaId, Long subCarteraId) {
		String sb = "Select sum(mov.deudaIrregular) from HistoricoReparto hist join hist.contrato cnt join cnt.movimientos mov " +
				"Where cnt.fechaExtraccion = mov.fechaExtraccion and hist.fechaHistorico = :fechaHistorico ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("fechaHistorico", fechaHistorico);
		
		if (agenciaId!=null) {
			sb += " and hist.recobroAgencia.id = :agenciaId ";
			params.put("agenciaId", agenciaId);
		}
		
		if (subCarteraId!=null){
			sb += " and hist.recobroSubCartera.id = :subCarteraId";
			params.put("subCarteraId", subCarteraId);
		}		
		
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		
		return (Double) query.uniqueResult();
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	public Double getSaldoVivo(Date fechaHistorico, Long agenciaId, Long subCarteraId) {
		String sb = "Select sum(mov.riesgo) from HistoricoReparto hist join hist.contrato cnt join cnt.movimientos mov " +
				"Where cnt.fechaExtraccion = mov.fechaExtraccion and hist.fechaHistorico = :fechaHistorico ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("fechaHistorico", fechaHistorico);
		
		if (agenciaId!=null) {
			sb += " and hist.recobroAgencia.id = :agenciaId ";
			params.put("agenciaId", agenciaId);
		}
		
		if (subCarteraId!=null){
			sb += " and hist.recobroSubCartera.id = :subCarteraId";
			params.put("subCarteraId", subCarteraId);
		}
		
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		
		return (Double) query.uniqueResult();
	}

	
}
