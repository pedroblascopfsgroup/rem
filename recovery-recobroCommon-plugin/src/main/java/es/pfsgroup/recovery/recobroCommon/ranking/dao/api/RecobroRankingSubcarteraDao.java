package es.pfsgroup.recovery.recobroCommon.ranking.dao.api;

import java.util.List;

import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcartera;

/**
 * Interfaz de métodos para el DAO de rankings de subcarteras de recobro
 * @author javier
 *
 */

public interface RecobroRankingSubcarteraDao {

	/**
	 * Trunca la tabla RAS_RANKING_SUBCARTERA
	 */
	public void truncate();
	
	/**
	 * Graba los rankings en bd
	 * @param rankings
	 */
	public void guardarRankings(List<RecobroRankingSubcartera> rankings);	
}
