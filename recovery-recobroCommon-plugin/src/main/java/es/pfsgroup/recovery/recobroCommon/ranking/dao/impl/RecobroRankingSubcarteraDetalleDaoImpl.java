package es.pfsgroup.recovery.recobroCommon.ranking.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroRankingSubcarteraDetalleDao;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcarteraDetalle;

@Repository("RecobroRankingSubcarteraDetalle")
public class RecobroRankingSubcarteraDetalleDaoImpl extends AbstractEntityDao<RecobroRankingSubcarteraDetalle, Long> implements
		RecobroRankingSubcarteraDetalleDao {

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void truncate() {
		StringBuilder hql = new StringBuilder();
		hql.append("Truncate table RSD_RANKING_SUBCAR_DETALLE");
		
		getSession().createSQLQuery(hql.toString()).executeUpdate();
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void guardar(RecobroRankingSubcarteraDetalle detalle) {
		this.saveOrUpdate(detalle);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public List<RecobroRankingSubcarteraDetalle> obtenerDetallesAgenciaId(Long agenciaId) {
		HQLBuilder hql = new HQLBuilder("from RecobroRankingSubcarteraDetalle");
		RecobroRankingSubcarteraDetalle a;

		HQLBuilder.addFiltroIgualQue(hql, "agencia.id", agenciaId);
		
		return HibernateQueryUtils.list(this, hql);
	}
}
