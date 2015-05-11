package es.pfsgroup.recovery.recobroCommon.ranking.manager.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroRankingSubcarteraDetalleDao;
import es.pfsgroup.recovery.recobroCommon.ranking.manager.api.RecobroRankingSubcarteraDetalleManager;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcarteraDetalle;

@Service
public class RecobroRankingSubcarteraDetalleManagerImpl implements
		RecobroRankingSubcarteraDetalleManager {
	
	@Autowired
	private RecobroRankingSubcarteraDetalleDao recobroRankingSubcarteraDetalleDao;

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void truncarRankingSubcarteraDetalle() {
		recobroRankingSubcarteraDetalleDao.truncate();
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void guardarDetalles(List<RecobroRankingSubcarteraDetalle> detalles) {
		for (RecobroRankingSubcarteraDetalle detalle : detalles) {
			recobroRankingSubcarteraDetalleDao.guardar(detalle);
		}
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public List<RecobroRankingSubcarteraDetalle> obtenerDetallesAgenciaId(Long agenciaId) {
		return recobroRankingSubcarteraDetalleDao.obtenerDetallesAgenciaId(agenciaId);
	}

}
