package es.pfsgroup.recovery.recobroCommon.esquema.dao.impl;

import java.util.HashMap;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.RecobroSimulacionEsquemaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSimulacionEsquema;

@Repository("RecobroSimulacionEsquema")
public class RecobroSimulacionEsquemaDaoImpl extends AbstractEntityDao<RecobroSimulacionEsquema, Long> implements
		RecobroSimulacionEsquemaDao {

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
	public Long countProcesosPorEstado(Long estado) {
		String sb = "Select count(*) from RecobroSimulacionEsquema " +
						"Where estado.id = :estadoId";
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("estadoId", estado);
		Query query = getSession().createQuery(sb);
		setParameters(query, params);

		return (Long) query.uniqueResult();		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<RecobroSimulacionEsquema> getProcesosPorEstado(Long estado) {
		HQLBuilder hb = new HQLBuilder("from RecobroSimulacionEsquema");
		HQLBuilder.addFiltroIgualQue(hb, "estado.id", estado);
		
		return HibernateQueryUtils.list(this, hb);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<RecobroSimulacionEsquema> getSimulacionesDelEsquema(Long idEsquema) {
		HQLBuilder hb = new HQLBuilder("from RecobroSimulacionEsquema sim");
		HQLBuilder.addFiltroIgualQue(hb, "sim.esquema.id", idEsquema);
		
		return HibernateQueryUtils.list(this, hb);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<RecobroSimulacionEsquema> getProcesosPorCodigoEstado(String codigoEstado) {
		HQLBuilder hb = new HQLBuilder("from RecobroSimulacionEsquema");
		HQLBuilder.addFiltroIgualQue(hb, "estado.codigo", codigoEstado);
		
		return HibernateQueryUtils.list(this, hb);
	}


}
