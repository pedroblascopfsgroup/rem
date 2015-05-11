package es.capgemini.pfs.web.clientes;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.web.menu.ElementoDinamicoPorFuncion;

public class TabClienteAnalisis extends ElementoDinamicoPorFuncion {

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
