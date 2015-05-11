package es.pfsgroup.plugin.recovery.mejoras.scoring;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class MEJScoringManager implements MEJScoringApi{
	
	@Autowired
	ApiProxyFactory proxyFactory;

	@Override
	@BusinessOperation(MEJ_MGR_SCORING_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsScoringLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.metrica.buttons.left",
				null);
if (l == null)
	return new ArrayList<DynamicElement>();
else
	return l;
	}

	@Override
	@BusinessOperation(MEJ_MGR_SCORING_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsScoringRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.mejoras.web.metrica.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

}
