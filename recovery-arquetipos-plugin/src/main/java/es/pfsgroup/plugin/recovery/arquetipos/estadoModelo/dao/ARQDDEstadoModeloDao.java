package es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.model.ARQDDEstadoModelo;

public interface ARQDDEstadoModeloDao extends AbstractDao<ARQDDEstadoModelo, Long>{
	
	public ARQDDEstadoModelo getByCodigo(String codigoEstadoVigente);

}
