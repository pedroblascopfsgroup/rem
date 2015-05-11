package es.pfsgroup.plugin.recovery.mejoras.web.contrato;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class MEJBusquedaContratosManager {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@BusinessOperation("plugin.mejoras.web.contratos.busqueda.buttons.left")
	List<DynamicElement> getButtonsLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.contratos.busqueda.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.mejoras.web.contratos.busqueda.buttons.right")
	List<DynamicElement> getButtonsRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.mejoras.web.contratos.busqueda.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

}
