package es.pfsgroup.recovery.recobroCommon.ranking.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroRankingSubcarteraDao;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcartera;

@Repository("RecobroRankingSubcartera")
public class RecobroRankingSubcarteraDaoImpl extends AbstractEntityDao<RecobroRankingSubcartera, Long> implements
		RecobroRankingSubcarteraDao {

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void truncate() {
		StringBuilder hql = new StringBuilder();
		hql.append("Truncate table RAS_RANKING_SUBCARTERA");
		
		getSession().createSQLQuery(hql.toString()).executeUpdate();

	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void guardarRankings(List<RecobroRankingSubcartera> rankings) {
		for (RecobroRankingSubcartera ranking : rankings) {
			this.saveOrUpdate(ranking);
		}
	}

}
