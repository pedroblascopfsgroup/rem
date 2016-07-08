package es.capgemini.pfs.web.menu;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.users.UsuarioManager;

public class MenusNoExternos extends ElementoDinamicoPorFuncion {

    @Autowired
    UsuarioManager usuarioManager;

    @Override
    public boolean valid(Object param) {
        return isValid() && super.valid(param);
    }

    private boolean isValid() {
        return !usuarioManager.getUsuarioLogado().getUsuarioExterno();
    }

}
