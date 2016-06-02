package es.pfsgroup.plugin.recovery.procuradores.despachoExternoPro.api;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;

public interface DespachoExternoProApi {
	
	public static final String PLUGIN_PROCURADORES_PAGE_DESPACHO_EXTERNO = "plugin.procuradores.despachoexternopro.getPageDespachoExterno";

	@BusinessOperationDefinition(PLUGIN_PROCURADORES_PAGE_DESPACHO_EXTERNO)
	public Page getPageDespachoExterno(CategorizacionDto dto, String nombre);

}
