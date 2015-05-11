package es.capgemini.pfs.web.expedientes;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.webflow.bo.WebExecutor;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.web.menu.ElementoDinamicoPorFuncion;

public class DecisionAsuntoTab extends ElementoDinamicoPorFuncion {

    @Autowired
    UsuarioManager usuarioManager;

    @Autowired
    WebExecutor executor;

    @Override
    public boolean valid(Object param) {
        return puedeMostrarSolapaDecisionComite(param) && super.valid(param);
    }

    private boolean puedeMostrarSolapaDecisionComite(Object id) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, id);
        if (asunto == null) return false;
        return asunto.getEstaPropuesto() && (Boolean) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_PUEDE_VER_DECISIONES_COMITE, id);
    }
}
