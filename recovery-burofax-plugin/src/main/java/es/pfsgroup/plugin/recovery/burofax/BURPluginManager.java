package es.pfsgroup.plugin.recovery.burofax;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugins.PluginManager;
import es.pfsgroup.plugins.domain.PluginConfigurations;

@Component(PluginBurofaxConstantsComponents.PLUGIN_MANAGER)
public class BURPluginManager {

	public static final String PLUGIN_CODE = "burofax";

	@Autowired
	private PluginManager pluginManager;

	@BusinessOperation(PluginBurofaxConstantsBO.GET_PLUGIN_CONFIG)
	public PluginConfigurations getConfig() {
		return pluginManager.getConfig(PLUGIN_CODE);

	}
}
