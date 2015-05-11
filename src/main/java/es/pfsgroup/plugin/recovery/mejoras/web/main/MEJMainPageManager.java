package es.pfsgroup.plugin.recovery.mejoras.web.main;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class MEJMainPageManager {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@BusinessOperation("plugin.mejoras.mainpage.dynamicelements.getJsLibraries")
	List<DynamicElement> getJsLibraries() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.mainpage.dynamicelements.jsLibraries", null);
		if (Checks.estaVacio(l)) {
			return new ArrayList<DynamicElement>();
		} else {
			return l;
		}
	}
	
	@BusinessOperation("plugin.mejoras.mainpage.dynamicelements.getCssStyles")
    List<DynamicElement> getCssStyles() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.mainpage.dynamicelements.cssStyles", null);
        if (Checks.estaVacio(l)) {
            return new ArrayList<DynamicElement>();
        } else {
            return l;
        }
    }
	
	
	@BusinessOperation("plugin.mejoras.mainpage.dynamicelements.openInitTabFuncition")
    List<DynamicElement> openInitTabFunction() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.mainpage.dynamicelements.openInitTabFuncition", null);
        if (Checks.estaVacio(l)) {
            return new ArrayList<DynamicElement>();
        } else {
            return l;
        }
    }

}
