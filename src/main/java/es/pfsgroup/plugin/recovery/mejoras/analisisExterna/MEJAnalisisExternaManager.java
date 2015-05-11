package es.pfsgroup.plugin.recovery.mejoras.analisisExterna;

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
public class MEJAnalisisExternaManager implements MEJAnalisisExternaApi{
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_ANALISIS_EXT_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsAnalisisExternaLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.analisisExterna.buttons.left",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_ANALISIS_EXT_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsAnalisisExternaRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.analisisExterna.buttons.right",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

}
