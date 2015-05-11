package es.pfsgroup.plugin.recovery.mejoras.web.main;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class MEJBuzonTareasWebManager {
	@Autowired
	private ApiProxyFactory proxyFactory;

	@BusinessOperation("plugin.mejoras.web.buzonTareas.nodosDinamicos")
	List<DynamicElement> getAccordionExtrasDefinition() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements("plugin.mejoras.web.buzonTareas.nodosDinamicos", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

}
