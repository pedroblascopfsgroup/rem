package es.pfsgroup.recovery.recobroCommon.ranking.manager.api;

import java.util.List;

import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcarteraDetalle;

/**
 * Interfaz de métodos para el manager de rankings de subcartera detalle de recobro
 * @author javier
 *
 */
public interface RecobroRankingSubcarteraDetalleManager {

	/**
	 * Trunca la tabla RSD_RANKING_SUBCAR_DETALLE
	 */
	public void truncarRankingSubcarteraDetalle();
	
	/**
	 * Grabamos en base de datos los detalles de la lista
	 * @param detalles
	 */
	public void guardarDetalles(List<RecobroRankingSubcarteraDetalle> detalles);
	
	/**
	 * Obtener los detalles de una agencia
	 * @param subCarteraId
	 * @return
	 */
	public List<RecobroRankingSubcarteraDetalle> obtenerDetallesAgenciaId(Long agenciaId);	
}
