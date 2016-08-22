package es.capgemini.pfs.web.expedientes;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.webflow.bo.WebExecutor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.web.menu.ElementoDinamicoPorFuncion;

public class DecisionTab extends ElementoDinamicoPorFuncion {

    @Autowired
    UsuarioManager usuarioManager;

    @Autowired
    WebExecutor executor;

    @Override
    public boolean valid(Object param) {
        return puedeMostrarSolapaDecisionComite(param) && super.valid(param);
    }

    private boolean puedeMostrarSolapaDecisionComite(Object id) {
        return (Boolean) executor.execute("expedienteManager.puedeMostrarSolapaDecisionComite", id);
    }

}
