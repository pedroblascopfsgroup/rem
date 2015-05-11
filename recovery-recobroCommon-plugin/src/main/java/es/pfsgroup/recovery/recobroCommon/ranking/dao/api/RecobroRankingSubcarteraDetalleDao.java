package es.pfsgroup.recovery.recobroCommon.ranking.dao.api;

import java.util.List;

import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcarteraDetalle;

public interface RecobroRankingSubcarteraDetalleDao {

	/**
	 * Trunc la tabla RSD_RANKING_SUBCAR_DETALLE
	 */
	public void truncate();

	/**
	 * Guarda un detalle en la base de datos
	 * @param detalle
	 */
	public void guardar(RecobroRankingSubcarteraDetalle detalle);
	
	/**
	 * Obtener los detalles de una agencia
	 * @param agenciaId
	 * @return
	 */
	public List<RecobroRankingSubcarteraDetalle> obtenerDetallesAgenciaId(Long agenciaId);
}
