package es.pfsgroup.plugin.recovery.mejoras.web.comite;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class MEJComitesManager {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@BusinessOperation("plugin.mejoras.web.comites.celebracion.buttons.left")
	List<DynamicElement> getButtonComitesLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.comites.celebracion.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.mejoras.web.comites.celebracion.buttons.right")
	List<DynamicElement> getButtonsComitesRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.mejoras.web.comites.celebracion.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}
	
	@BusinessOperation("plugin.mejoras.web.comites.actas.buttons.left")
	List<DynamicElement> getButtonActasLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.comites.actas.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.mejoras.web.comites.actas.buttons.right")
	List<DynamicElement> getButtonsActasRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.mejoras.web.comites.actas.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

}
