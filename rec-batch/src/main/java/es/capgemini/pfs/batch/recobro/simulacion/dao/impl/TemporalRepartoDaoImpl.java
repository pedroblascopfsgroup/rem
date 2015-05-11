package es.capgemini.pfs.batch.recobro.simulacion.dao.impl;

import java.util.HashMap;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.batch.recobro.simulacion.dao.TemporalRepartoDao;
import es.capgemini.pfs.batch.recobro.simulacion.model.TemporalRepartos;
import es.capgemini.pfs.dao.AbstractEntityDao;

@Repository("TemporalRepartoDao")
public class TemporalRepartoDaoImpl extends AbstractEntityDao<TemporalRepartos, Long>  implements TemporalRepartoDao {

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
	public Long getCountClientes(Long agenciaId) {
		String sb = "Select count(distinct persona) from TemporalRepartos ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		if (agenciaId!=null) {
			sb += "Where recobroAgencia.id = :agenciaId";
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
	public Long getCountContratos(Long agenciaId) {
		String sb = "Select count(distinct contrato) from TemporalRepartos ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		if (agenciaId!=null) {
			sb += "Where recobroAgencia.id = :agenciaId";
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
	public Double getSaldoIrregular(Long agenciaId) {
		String sb = "select sum(deudaIrregular) from Movimiento where id in (select mov.id from TemporalRepartos tmp join tmp.contrato cnt join cnt.movimientos mov ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		if (agenciaId!=null) {
			sb += " Where cnt.fechaExtraccion = mov.fechaExtraccion and tmp.recobroAgencia.id = :agenciaId )";
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
	public Double getSaldoVivo(Long agenciaId) {
		String sb = "select sum(posVivaNoVencida) + sum(deudaIrregular) from Movimiento where id in (select mov.id from TemporalRepartos tmp join tmp.contrato cnt join cnt.movimientos mov ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		if (agenciaId!=null) {
			sb += " Where cnt.fechaExtraccion = mov.fechaExtraccion and tmp.recobroAgencia.id = :agenciaId )";
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
	public Long getCountClientes(Long agenciaId, Long subCarteraId) {
		String sb = "Select count(distinct persona) from TemporalRepartos ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		sb += " Where 1=1 ";
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
	public Long getCountContratos(Long agenciaId, Long subCarteraId) {
		String sb = "Select count(distinct contrato) from TemporalRepartos ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		sb += " Where 1=1 ";
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
	public Double getSaldoIrregular(Long agenciaId, Long subCarteraId) {
		String sb = "select sum(deudaIrregular) from Movimiento where id in (select mov.id from TemporalRepartos tmp join tmp.contrato cnt join cnt.movimientos mov ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		sb += " Where 1=1 and cnt.fechaExtraccion = mov.fechaExtraccion";
		if (agenciaId!=null) {
			sb += " and tmp.recobroAgencia.id = :agenciaId";
			params.put("agenciaId", agenciaId);
		}
		if (subCarteraId!=null){
			sb += " and tmp.recobroSubCartera.id = :subCarteraId";
			params.put("subCarteraId", subCarteraId);
		}
		sb += ")";
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		return (Double) query.uniqueResult();
	}

	/**
	 * {@inheritDoc} 
	 */		
	@Override
	public Double getSaldoVivo(Long agenciaId, Long subCarteraId) {
		String sb = "select sum(posVivaNoVencida) + sum(deudaIrregular) from Movimiento where id in (select mov.id from TemporalRepartos tmp join tmp.contrato cnt join cnt.movimientos mov ";
		HashMap<String, Object> params = new HashMap<String, Object>();
		sb += " Where 1=1 and cnt.fechaExtraccion = mov.fechaExtraccion";
		if (agenciaId!=null) {
			sb += " and tmp.recobroAgencia.id = :agenciaId ";
			params.put("agenciaId", agenciaId);
		}
		if (subCarteraId!=null){
			sb += " and tmp.recobroSubCartera.id = :subCarteraId ";
			params.put("subCarteraId", subCarteraId);
		}	
		sb += ")";
		Query query = getSession().createQuery(sb);
		setParameters(query, params);
		return (Double) query.uniqueResult();
	} 	
	
}
