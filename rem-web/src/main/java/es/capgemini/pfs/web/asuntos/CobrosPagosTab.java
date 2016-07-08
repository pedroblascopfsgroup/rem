package es.capgemini.pfs.web.asuntos;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.webflow.bo.WebExecutor;
import es.capgemini.pfs.web.menu.ElementoDinamicoPorFuncion;

public class CobrosPagosTab extends ElementoDinamicoPorFuncion {

    @Autowired
    WebExecutor executor;

    @Override
    public boolean valid(Object param) {
        return tieneAnalisisDePoliticas(param) && super.valid(param);
    }

    private boolean tieneAnalisisDePoliticas(Object id) {
        Boolean esGestor = (Boolean) executor.execute("asuntosManager.esGestor", id);
        Boolean esSupervisor = (Boolean) executor.execute("asuntosManager.esSupervisor", id);
        return esGestor || esSupervisor;
    }

}
