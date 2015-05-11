package es.pfsgroup.recovery.recobroCommon.esquema.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraRankingDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraRanking;

@Repository("RecobroSubCarteraRankingDao")
public class RecobroSubCarteraRankingDaoImpl extends AbstractEntityDao<RecobroSubcarteraRanking, Long> implements RecobroSubCarteraRankingDao{


	@Override
	public RecobroSubcarteraRanking getSubcarteraRankingPorPosicionYSubCartera(
			RecobroSubCartera subCartera,
			RecobroSubcarteraRanking subcarteraRankingOriginal) {
		String hsql = "select distinct scr from RecobroSubcarteraRanking scr, RecobroSubCartera sc ";
		hsql += " WHERE scr.subCartera.id = sc.id AND " +
				"		scr.auditoria.borrado = 0 AND " +
				"		sc.auditoria.borrado = 0 AND " +
				"		sc.id = " + subCartera.getId() + " AND " +
				"		scr.posicion = " + subcarteraRankingOriginal.getPosicion();	
		
		List<RecobroSubcarteraRanking> ret = getHibernateTemplate().find(hsql.toString());

		return ret.size() == 0 ? null : ret.get(0);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Integer getPorcentaje(RecobroSubCartera subCartera, Integer posicion) {
		String sql ="Select posicion from RecobroSubcarteraRanking scr " +
					"Where scr.subCartera.id = " + subCartera.getId() +
					" and scr.posicion = " + posicion;
			
		return (Integer) getSession().createQuery(sql).uniqueResult();
	}

}
