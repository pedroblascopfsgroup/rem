package es.pfsgroup.plugin.recovery.procuradores.busqueda.api;

import java.util.Collection;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.model.MSVAsuntoAll;

public interface MSVAsuntoAllApi {

	static final String MSV_BO_CONSULTAR_ASUNTOS_ALL =  "es.pfsgroup.plugin.recovery.procuradores.api.getAsuntosAll";
	static final String MSV_BO_CONSULTAR_ASUNTOS_ALL_GRUPOS =  "es.pfsgroup.plugin.recovery.procuradores.api.getAsuntosAllGrupoUsu";

	/**
	 * Devuelve la lista de asuntos que concuerdan con la expresión pasada
	 * (Puede incluir nombre de asunto, plaza, juzgado, auto
	 * @return boolean
	 */
	@BusinessOperationDefinition(MSV_BO_CONSULTAR_ASUNTOS_ALL)
	public Collection<? extends MSVAsuntoAll>  getAsuntos(String query);
	
	/**
	 * Devuelve la lista de asuntos del usuario logueado y el grupo al que pertenece, que concuerdan con la expresión pasada
	 * (Puede incluir nombre de asunto, plaza, juzgado, auto
	 * @return boolean
	 */
	@BusinessOperationDefinition(MSV_BO_CONSULTAR_ASUNTOS_ALL_GRUPOS)
	public Collection<? extends MSVAsuntoAll> getAsuntosGrupoUsuarios(String query);
}
