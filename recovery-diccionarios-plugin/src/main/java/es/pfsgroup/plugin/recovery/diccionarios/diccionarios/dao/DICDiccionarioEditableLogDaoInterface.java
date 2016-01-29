package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao;

import java.io.Serializable;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;

public interface DICDiccionarioEditableLogDaoInterface<T extends Serializable, K extends Serializable> extends AbstractDao<T, K>{

	/**
	 * Devuelve el listado de log para un diccionario dado.
	 * @param idConvenio Tenemos que pasar el id de un convenio
	 * @return
	 */
	public List<T> findByIdDiccionario(K idDiccionarioEditable);

}
