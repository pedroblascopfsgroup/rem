package es.capgemini.pfs.web.expedientes;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.webflow.bo.WebExecutor;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.web.menu.ElementoDinamicoPorFuncion;

public class MarcadoPoliticaTab extends ElementoDinamicoPorFuncion {

    @Autowired
    UsuarioManager usuarioManager;

    @Autowired
    WebExecutor executor;

    @Override
    public boolean valid(Object param) {
        return puedeMostrarTab(param) && super.valid(param);
    }

    private boolean puedeMostrarTab(Object id) {
        Boolean puedeMostrarSolapaDecisionComite = (Boolean) executor.execute("expedienteManager.puedeMostrarSolapaMarcadoPoliticas", id);
        Expediente expediente = (Expediente) executor.execute("expedienteManager.getExpediente", id);
        return puedeMostrarSolapaDecisionComite && expediente.getSeguimiento();
    }

}
