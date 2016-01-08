package es.pfsgroup.plugin.recovery.burofax.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;

@Component("plugin.burofax.consultaClienteManager")
public class BURConsultaClienteManager {

	@Autowired
    DynamicElementManager tabManager;

    @BusinessOperation("clientes.buttons")
    public List<DynamicElement> botonesDeCliente(long idCliente) {
        return tabManager.getDynamicElements("clientes.buttons", idCliente);
    }
}
