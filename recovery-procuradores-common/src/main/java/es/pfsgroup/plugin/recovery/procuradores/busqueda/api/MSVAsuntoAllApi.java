package es.pfsgroup.plugin.recovery.procuradores.busqueda.api;

import java.util.Collection;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.model.MSVAsuntoAll;

public interface MSVAsuntoAllApi {

	static final String MSV_BO_CONSULTAR_ASUNTOS_ALL =  "es.pfsgroup.plugin.recovery.procuradores.api.getAsuntosAll";

	/**
	 * Devuelve la lista de asuntos que concuerdan con la expresión pasada
	 * (Puede incluir nombre de asunto, plaza, juzgado, auto
	 * @return boolean
	 */
	@BusinessOperationDefinition(MSV_BO_CONSULTAR_ASUNTOS_ALL)
	public Collection<? extends MSVAsuntoAll>  getAsuntos(String query);
}
