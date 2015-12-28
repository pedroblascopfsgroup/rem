package es.pfsgroup.plugin.recovery.comites.api.web;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.capgemini.devon.web.DynamicElement;

public interface DynamicElementApi {

	String BO_DYNAMIC_ELEMENTS_GET = "dynamicElementManager.getDynamicElements";

	/** Combina los tabs opcionales con los de la lista que se pasa
     * @param param 
     * @param tabs
     */
    @BusinessOperationDefinition(BO_DYNAMIC_ELEMENTS_GET)
    public List<DynamicElement> getDynamicElements(String entity, Object param);
}
