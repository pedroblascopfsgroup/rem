package es.capgemini.pfs.batch.recobro.simulacion.manager.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.batch.recobro.simulacion.dao.TemporalRepartoDao;
import es.capgemini.pfs.batch.recobro.simulacion.manager.TemporalRepartoManager;

@Service
public class TemporalRepartoManagerImpl implements TemporalRepartoManager {
	
	@Autowired
	TemporalRepartoDao temporalRepartoDao;


	/**
	 * @{inheritDoc}
	 */
	@Override
	public Long getCountClientes(Long agenciaId) {
		return temporalRepartoDao.getCountClientes(agenciaId);
	}

	/**
	 * @{inheritDoc}
	 */
	@Override
	public Long getCountContratos(Long agenciaId) {
		return temporalRepartoDao.getCountContratos(agenciaId);
	}

	/**
	 * @{inheritDoc}
	 */	
	@Override
	public Double getSaldoIrregular(Long agenciaId) {
		return temporalRepartoDao.getSaldoIrregular(agenciaId);
	}

	/**
	 * @{inheritDoc}
	 */	
	@Override
	public Double getSaldoVivo(Long agenciaId) {
		return temporalRepartoDao.getSaldoVivo(agenciaId);
	}

	/**
	 * @{inheritDoc}
	 */	
	@Override
	public Long getCountClientes(Long agenciaId, Long subCarteraId) {
		return temporalRepartoDao.getCountClientes(agenciaId, subCarteraId);
	}

	/**
	 * @{inheritDoc}
	 */	
	@Override
	public Long getCountContratos(Long agenciaId, Long subCarteraId) {
		return temporalRepartoDao.getCountContratos(agenciaId, subCarteraId);
	}

	/**
	 * @{inheritDoc}
	 */	
	@Override
	public Double getSaldoIrregular(Long agenciaId, Long subCarteraId) {
		return temporalRepartoDao.getSaldoIrregular(agenciaId, subCarteraId);
	}

	/**
	 * @{inheritDoc}
	 */	
	@Override
	public Double getSaldoVivo(Long agenciaId, Long subCarteraId) {
		return temporalRepartoDao.getSaldoVivo(agenciaId, subCarteraId);
	}
	
}
