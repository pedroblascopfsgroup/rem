package es.capgemini.pfs.batch.recobro.reparto.manager.impl;

import java.util.Date;

import es.capgemini.pfs.batch.recobro.reparto.dao.RecobroRepartoDao;
import es.capgemini.pfs.batch.recobro.reparto.manager.RecobroRepartoManager;

//@Service
public class RecobroRepartoManagerImpl implements RecobroRepartoManager {
	
	RecobroRepartoDao recobroRepartoDao;

	public RecobroRepartoDao getRecobroRepartoDao() {
		return recobroRepartoDao;
	}

	public void setRecobroRepartoDao(RecobroRepartoDao recobroRepartoDao) {
		this.recobroRepartoDao = recobroRepartoDao;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Date FechaEntradaCntAgeSub(long cntId, long ageId, long subId) {
		return recobroRepartoDao.getMinFechaCntAgeSubHistReparto(cntId, ageId, subId);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Long getCountClientes(Date fechaHistorico, Long agenciaId) {
		return recobroRepartoDao.getCountClientes(fechaHistorico, agenciaId);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Long getCountContratos(Date fechaHistorico, Long agenciaId) {
		return recobroRepartoDao.getCountContratos(fechaHistorico, agenciaId);
	}

	/**
	 * {@inheritDoc}
	 */		
	@Override
	public Double getSaldoIrregular(Date fechaHistorico, Long agenciaId) {
		return recobroRepartoDao.getSaldoIrregular(fechaHistorico, agenciaId);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Double getSaldoVivo(Date fechaHistorico, Long agenciaId) {
		return recobroRepartoDao.getSaldoVivo(fechaHistorico, agenciaId);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Date getFechaUltimoHistoricoReparto() {
		return recobroRepartoDao.getFechaUltimoRepartoHistorico();
	}
	
	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Long getCountClientes(Date fechaHistorico, Long agenciaId, Long subCarteraId) {
		return recobroRepartoDao.getCountClientes(fechaHistorico, agenciaId, subCarteraId);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Long getCountContratos(Date fechaHistorico, Long agenciaId, Long subCarteraId) {
		return recobroRepartoDao.getCountContratos(fechaHistorico, agenciaId, subCarteraId);
	}

	/**
	 * {@inheritDoc}
	 */		
	@Override
	public Double getSaldoIrregular(Date fechaHistorico, Long agenciaId, Long subCarteraId) {
		return recobroRepartoDao.getSaldoIrregular(fechaHistorico, agenciaId, subCarteraId);
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Double getSaldoVivo(Date fechaHistorico, Long agenciaId, Long subCarteraId) {
		return recobroRepartoDao.getSaldoVivo(fechaHistorico, agenciaId, subCarteraId);
	}

}
