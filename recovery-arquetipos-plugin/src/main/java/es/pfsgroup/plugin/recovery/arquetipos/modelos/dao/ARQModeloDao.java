package es.pfsgroup.plugin.recovery.arquetipos.modelos.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dto.ARQDtoBusquedaModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.model.ARQModelo;

public interface ARQModeloDao extends AbstractDao<ARQModelo, Long> {

	/**
	 * Nos crea una nueva instancia de ARQModelo
	 * @return
	 */
	public ARQModelo createNewModelo();

	/**
	 * 
	 * @param dto de b�squeda de modelos
	 * @return devuelve una lista paginada de modelos cuyos criterios
	 * de b�squeda coincidan con los del dto que le pasamos como entrada
	 */
	public Page findModelos(ARQDtoBusquedaModelo dto);

}
