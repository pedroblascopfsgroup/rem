package es.capgemini.pfs.web.clientes;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.webflow.bo.WebExecutor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.web.menu.ElementoDinamicoPorFuncion;

public class AnalisisPoliticaTab extends ElementoDinamicoPorFuncion {

    @Autowired
    UsuarioManager usuarioManager;

    @Autowired
    WebExecutor executor;

    @Override
    public boolean valid(Object param) {
        return tieneAnalisisDePoliticas(param) && super.valid(param);
    }

    private boolean tieneAnalisisDePoliticas(Object id) {
        return executor.execute("analisisPoliticaManager.getAnalisisPolitica", id) != null;
    }

}
