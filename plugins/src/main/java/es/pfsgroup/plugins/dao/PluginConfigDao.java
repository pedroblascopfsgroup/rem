package es.pfsgroup.plugins.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugins.domain.PluginConfig;

public interface PluginConfigDao extends AbstractDao<PluginConfig, Long>{

	/**
	 * Devuelve los datos de configuraci�n de un determinado plugin 
	 * @param plugin  Plugin code
	 * @return Devuelve una lista vacia si no hay configuraciones
	 */
	List<PluginConfig> getPluginConfig(String plugin);

}
