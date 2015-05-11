package es.pfsgroup.plugin.recovery.mejoras.web.expediente;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

@Component
public class MEJBusquedaExpedientesManager {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@BusinessOperation("plugin.mejoras.web.expedientes.busqueda.buttons.left")
	List<DynamicElement> getButtonsLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.expedientes.busqueda.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.mejoras.web.expedientes.busqueda.buttons.right")
	List<DynamicElement> getButtonsRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.mejoras.web.expedientes.busqueda.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

    @BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_EXPEDIENTE_TABS_BUSQUEDA)
    public List<DynamicElement> getTabsExpedienteBusqueda() {
    	List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
    			PluginMejorasBOConstants.MEJ_MGR_EXPEDIENTE_TABS_BUSQUEDA, null);
    	if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
    }
    
}
