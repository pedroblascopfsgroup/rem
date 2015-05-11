package es.capgemini.pfs.web.asuntos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;

@Component
public class ConsultaAsuntoManager {
    @Autowired
    DynamicElementManager tabManager;

    @BusinessOperation()
    public List<DynamicElement> getTabs(long idCliente) {
        return tabManager.getDynamicElements("tabs.asuntos", idCliente);
    }
}
