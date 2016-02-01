package es.pfsgroup.plugin.recovery.liquidaciones.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;

@Component("plugin.liquidaciones.consultaAsuntoManager")
public class LIQConsultaAsuntoManager {
	@Autowired
	DynamicElementManager tabManager;

	@BusinessOperation("asunto.buttons")
	public List<DynamicElement> getTabs(long idCliente) {
		return tabManager.getDynamicElements("asunto.buttons", idCliente);
	}
}
