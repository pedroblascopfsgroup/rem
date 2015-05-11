package es.pfsgroup.recovery.recobroCommon.ranking.dao.api;

import java.util.Date;
import java.util.List;

import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingHistoricoSubcartera;

/**
 * Interfaz de métodos para el DAO de rankings históricos de subcarteras de recobro
 * @author Guillem
 *
 */
public interface RecobroRankingHistoricoSubcarteraDAO {

	/**
	 * Obtener los rankings de agencias por subcartera y fecha
	 * @param subCartera
	 * @param fechaHistorico
	 * @return
	 * @throws Throwable
	 */
	public List<RecobroRankingHistoricoSubcartera> obtenerRankingHistoricoSubcarteraFecha(RecobroSubCartera subCartera, Date fechaHistorico) throws Throwable;
	
	/**
	 * Se obtiene la ultima fecha del historico de ranking
	 * @return
	 */	
	public Date obtenerUltimaFechaRanking();	
	
	/**
	 * Historificamos el ranking subcartera
	 */
	public void HistorificarRankingSubcartera();
	
	/**
	 * Historificamos el ranking subcartera detalle
	 */
	public void HistorificarRankingSubcarteraDetalle();
	
}
