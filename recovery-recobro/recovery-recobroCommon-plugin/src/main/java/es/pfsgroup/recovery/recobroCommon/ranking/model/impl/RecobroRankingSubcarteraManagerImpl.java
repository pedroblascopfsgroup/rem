package es.pfsgroup.recovery.recobroCommon.ranking.model.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroRankingHistoricoSubcarteraDAO;
import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroRankingSubcarteraDao;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingHistoricoSubcartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.api.RecobroRankingSubcarteraManagerApi;

/**
 * Implementación del manager de los ranking de subcarteras de recobro
 * @author Guillem
 *
 */
@Service
public class RecobroRankingSubcarteraManagerImpl implements RecobroRankingSubcarteraManagerApi {

	@Autowired
	private RecobroRankingHistoricoSubcarteraDAO recobroRankingHistoricoSubcarteraDAO;
	
	@Autowired
	private RecobroRankingSubcarteraDao recobroRankingSubcarteraDao;
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<RecobroRankingHistoricoSubcartera> obtenerRankingSubcarteraFecha(RecobroSubCartera subCartera, Date fechaHistorico) throws Throwable {
		return recobroRankingHistoricoSubcarteraDAO.obtenerRankingHistoricoSubcarteraFecha(subCartera, fechaHistorico);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void truncarRankingSubcartera() {
		recobroRankingSubcarteraDao.truncate();
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void guardarRankings(List<RecobroRankingSubcartera> rankings) {
		recobroRankingSubcarteraDao.guardarRankings(rankings);
	}

}
