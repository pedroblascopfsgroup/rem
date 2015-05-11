package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class NMBBusquedaLoteSubastasManager {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@BusinessOperation("es.pfsgroup.plugin.recovery.nuevoModeloBienes.lotesubastas.busqueda.buttons.left")
	List<DynamicElement> getButtonsLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
			.getDynamicElements("plugin.nuevoModeloBienes.web.lotesubastas.busqueda.buttons.left",null);
		if (l == null) return new ArrayList<DynamicElement>();
		else return l;
	}
			
	@BusinessOperation("es.pfsgroup.plugin.recovery.nuevoModeloBienes.lotesubastas.busqueda.buttons.right")
	List<DynamicElement> getButtonsRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.nuevoModeloBienes.web.lotesubastas.busqueda.buttons.right", null);
		if (l == null) return new ArrayList<DynamicElement>();
		else return l;
	}

}
