package es.capgemini.pfs.web.menu;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.web.DynamicElementAdapter;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.UsuarioManager;

public class ElementoDinamicoPorFunciones extends DynamicElementAdapter {

	private static final long serialVersionUID = -2864875663163501198L;

	@Autowired
    UsuarioManager usuarioManager;

    @Autowired
    FuncionManager funcionManager;

    private String permission = "";

    /**
     * Si el perfil tiene algún permiso de la lista devuelve true
     */
    @Override
    public boolean valid(Object param) {
        if (StringUtils.isBlank(getPermission())) return true;
        String[] permissions = getPermission().split(",");
        for (String permission : permissions) {
			if (tienePerfil(permission)) return true;
		}
        return false;
    }

    private boolean tienePerfil(String perfil) {
        return funcionManager.tieneFuncion(usuarioManager.getUsuarioLogado(), perfil);
    }

    public void setPermission(String permission) {
        this.permission = permission;
    }

    public String getPermission() {
        return permission;
    }

}
