package es.capgemini.pfs.batch.configuracion.manager.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.batch.configuracion.dao.ConfiguracionEntradaDao;
import es.capgemini.pfs.batch.configuracion.manager.ConfiguracionEntradaManager;
import es.capgemini.pfs.batch.configuracion.model.ConfiguracionEntrada;

@Service
public class ConfiguracionEntradaManagerImpl implements ConfiguracionEntradaManager {
	
	@Autowired
	ConfiguracionEntradaDao configuracionEntradaDao; 

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<ConfiguracionEntrada> obtenerAgenciasOrdenadosCarSubAge() {
		return configuracionEntradaDao.obtenerAgenciasOrdenadosCarSubAge(null);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<ConfiguracionEntrada> obtenerAgenciasOrdenadosCarSubAgeDeEsquemasPendientesSimular() {
		return configuracionEntradaDao.obtenerAgenciasOrdenadosCarSubAge("PTS");
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<ConfiguracionEntrada> obtenerAgenciasOrdenadosCarSubAgeDeEsquemasLiberados() {
		return configuracionEntradaDao.obtenerAgenciasOrdenadosCarSubAge("LBR");
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Long obtenerEsquema() {
		return configuracionEntradaDao.obtenerEsquema();
		
	}

}
