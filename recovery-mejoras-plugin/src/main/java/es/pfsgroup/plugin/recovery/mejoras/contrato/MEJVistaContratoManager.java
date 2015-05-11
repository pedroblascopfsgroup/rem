package es.pfsgroup.plugin.recovery.mejoras.contrato;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

@Component
public class MEJVistaContratoManager implements MEJVistaContratoApi{
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private DynamicElementManager tabManager;

	
	@Override
	@BusinessOperation(MEJ_MGR_CONTRATO_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsContratoLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.contratos.consulta.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(MEJ_MGR_CONTRATO_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsContratoRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.contratos.consulta.buttons.right",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_CONTRATO_BUTTONS_LEFT_FAST)
	public List<DynamicElement> getButtonsContratoLeftFast() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"entidad.contrato.buttons.left.fast",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_CONTRATO_BUTTONS_RIGHT_FAST)
	public List<DynamicElement> getButtonsContratoRightFast() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"entidad.contrato.buttons.right.fast",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_CONTRATO_TABS_FAST)
	public List<DynamicElement> getTabsFast() {
		return tabManager.getDynamicElements("tabs.contrato.fast", null);
	}

	/* Este metodo solo se utiliza por NuevomodeloBienes, a extinguir */
	@BusinessOperation("contrato.buttons")
	public List<DynamicElement> getButtons(long idContrato) {
		return tabManager.getDynamicElements("contrato.buttons", idContrato);
	}

}
