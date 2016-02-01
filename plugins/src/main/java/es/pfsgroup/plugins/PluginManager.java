package es.pfsgroup.plugins;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.plugins.dao.EntidadPluginDao;
import es.pfsgroup.plugins.dao.PluginConfigDao;
import es.pfsgroup.plugins.domain.EntidadPlugin;
import es.pfsgroup.plugins.domain.PluginConfig;
import es.pfsgroup.plugins.domain.PluginConfigurations;

@Component
public class PluginManager {

	@Autowired
	private EntidadPluginDao entidadPluginDao;
	
	@Autowired
	private PluginConfigDao pluginConfigDao;
	
	/**
	 * Devuelve la relación de un determinado plugin para una entidad
	 * @param plugin Código del plugin
	 * @param entidad Entidad
	 * @return Si no está activado el plugin para dicha entidad devolvemos NULL
	 */
	public EntidadPlugin getPluginPorEntidad(String plugin, Entidad entidad) {
		Assertions.assertNotNull(plugin,null);
		Assertions.assertNotNull(entidad, null);
		return entidadPluginDao.getPluginPorEntidad(plugin, entidad.getId());
	}

	/**
	 * Devuelve las configuraciones de un determinado plugin para una entidad.
	 * @param plugin
	 * @param entidad
	 * @return
	 */
	public PluginConfigurations getConfig(String plugin){
		Assertions.assertNotNull(plugin,null);
		PluginConfigurations configuration = new PluginConfigurations();
		List<PluginConfig> list = pluginConfigDao.getPluginConfig(plugin);
		for (PluginConfig pc : list){
			configuration.add(pc);
		}
		return configuration;
	}
}
