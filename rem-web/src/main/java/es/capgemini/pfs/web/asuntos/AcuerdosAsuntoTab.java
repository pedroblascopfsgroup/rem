package es.capgemini.pfs.web.asuntos;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.webflow.bo.WebExecutor;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.web.menu.ElementoDinamicoPorFuncion;

public class AcuerdosAsuntoTab extends ElementoDinamicoPorFuncion {

    @Autowired
    WebExecutor executor;

    @Override
    public boolean valid(Object param) {
        return tieneAnalisisDePoliticas(param) && super.valid(param);
    }

    private boolean tieneAnalisisDePoliticas(Object id) {
        Asunto asunto = (Asunto) executor.execute("asuntosManager.get", id);
        return asunto != null && asunto.getEstaAceptado();
    }

}
