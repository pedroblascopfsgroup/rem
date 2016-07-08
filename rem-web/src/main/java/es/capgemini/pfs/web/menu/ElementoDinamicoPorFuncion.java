package es.capgemini.pfs.web.menu;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.web.DynamicElementAdapter;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.UsuarioManager;

public class ElementoDinamicoPorFuncion extends DynamicElementAdapter {

    @Autowired
    UsuarioManager usuarioManager;

    @Autowired
    FuncionManager funcionManager;

    private String permission = "";

    @Override
    public boolean valid(Object param) {
        if (StringUtils.isBlank(getPermission())) return true;
        return tienePerfil(getPermission());
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
