package es.capgemini.pfs.web.clientes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;

@Component
public class ConsultaClienteManager {

    @Autowired
    DynamicElementManager tabManager;

    @BusinessOperation("clientes.tabs")
    public List<DynamicElement> tabsDeCliente(long idCliente) {
        return tabManager.getDynamicElements("clientes", idCliente);
    }

}
