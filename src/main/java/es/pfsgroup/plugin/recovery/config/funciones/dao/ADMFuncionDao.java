package es.pfsgroup.plugin.recovery.config.funciones.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.plugin.recovery.config.funciones.dto.ADMDtoBuscarFunciones;

public interface ADMFuncionDao extends AbstractDao<Funcion, Long>{

	/**
	 * Crea un nuevo objeto. Sin persistir.
	 * @return
	 */
	public Funcion createNew();

	/**
	 * Devuelve todas las funciones existentes paginadas
	 * @return
	 */
	public Page findAll(ADMDtoBuscarFunciones dto);

}
