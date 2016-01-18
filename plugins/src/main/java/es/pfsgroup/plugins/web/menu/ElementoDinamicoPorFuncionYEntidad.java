package es.pfsgroup.plugins.web.menu;

import java.util.Properties;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.web.DynamicElementAdapter;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;

import es.capgemini.pfs.users.*;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugins.PluginManager;
import es.pfsgroup.plugins.domain.EntidadPlugin;

public class ElementoDinamicoPorFuncionYEntidad extends DynamicElementAdapter {

	private static final long serialVersionUID = -2510012132568258928L;

	@Autowired
	private Executor executor;

	@Autowired
	private FuncionManager funcionManager;

	private String permission = "";

	private String plugin = null;

	@Autowired
	private PluginManager pluginManager;

	@Override
	public boolean valid(Object param) {
		if (StringUtils.isBlank(plugin))
			return false;
		Usuario u = (Usuario) executor
				.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		EntidadPlugin ep = pluginManager.getPluginPorEntidad(plugin, u
				.getEntidad());
		if (Checks.esNulo(ep)) return false;
		if (StringUtils.isBlank(getPermission()))
			return true;
		return tienePerfil(u, getPermission());
	}

	public boolean tienePerfil(Usuario u, String perfil) {
		return funcionManager.tieneFuncion(u, perfil);
	}

	public void setPermission(String permission) {
		this.permission = permission;
	}

	public String getPermission() {
		return permission;
	}

	public void setPlugin(String plugin) {
		this.plugin = plugin;
	}

	public String getPlugin() {
		return plugin;
	}

}
