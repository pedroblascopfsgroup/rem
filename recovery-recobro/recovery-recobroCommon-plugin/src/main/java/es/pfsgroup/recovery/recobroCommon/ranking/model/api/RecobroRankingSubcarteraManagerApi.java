package es.pfsgroup.recovery.recobroCommon.ranking.model.api;

import java.util.Date;
import java.util.List;

import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingHistoricoSubcartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcartera;

/**
 * Interfaz de métodos para el manager de rankings de subcarteras de recobro
 * @author Guillem
 *
 */
public interface RecobroRankingSubcarteraManagerApi {

	/**
	 * Obtener los rankings de agencias por subcartera y fecha
	 * @param subCartera
	 * @param fechaHistorico
	 * @return
	 * @throws Throwable
	 */
	public List<RecobroRankingHistoricoSubcartera> obtenerRankingSubcarteraFecha(RecobroSubCartera subCartera, Date fechaHistorico) throws Throwable;
	
	/**
	 * Trunca la tabla RAS_RANKING_SUBCARTERA
	 */
	public void truncarRankingSubcartera();
	
	/**
	 * Graba los rankings en bd
	 * @param rankings
	 */
	public void guardarRankings(List<RecobroRankingSubcartera> rankings);
	
}
