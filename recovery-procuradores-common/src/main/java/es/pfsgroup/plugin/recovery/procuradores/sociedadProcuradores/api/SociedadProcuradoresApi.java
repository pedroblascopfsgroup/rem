package es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.api;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dto.SociedadProcuradoresDto;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.model.SociedadProcuradores;


public interface SociedadProcuradoresApi {

	public static final String PLUGIN_PROCURADORES_SOCIEDAD_PROCURADORES_GET_LISTA_SOCIEDADES = "plugin.procuradores.sociedadprocuradores.getListaSociedadesProcuradores";
	public static final String PLUGIN_PROCURADORES_SOCIEDAD_PROCURADORES_GET_SOCIEDAD_PROCURADORES = "plugin.procuradores.sociedadprocuradores.getSociedadProcuradores";
;
	

	
	/**
	 * Obtiene un listado de {@link SociedadProcuradores}. Soporta paginación, filtrado y ordenación.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link SociedadProcuradores} paginada.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_SOCIEDAD_PROCURADORES_GET_LISTA_SOCIEDADES)
	public Page getListaSociedadesProcuradores(SociedadProcuradoresDto dto);
	
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_SOCIEDAD_PROCURADORES_GET_SOCIEDAD_PROCURADORES)
	public SociedadProcuradores getSociedadProcuradores(Long idSociedad);

	
	
}
