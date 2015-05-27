package es.pfsgroup.plugin.recovery.procuradores.procurador.api;

import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.ProcuradorDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;


public interface ProcuradorApi {

	public static final String PLUGIN_PROCURADORES_PROCURADOR_GET_LISTA_PROCURADORES = "plugin.procuradores.procurador.getListaCategorias";
	public static final String BO_PROCURADORES_GET_PROCURADOR_REAL = "plugin.procuradores.procurador.getProcuradorReal";
	public static final String PR_PROCURADORES_GET_PROCURADOR = "plugin.procuradores.procurador.getPrProcurador";
	public static final String SAVE_PROCEDIMIENTO_PROCURADOR = "plugin.procuradores.procurador.saveProcedimientoProcurador";
	public static final String PLUGIN_PROCURADORES_POR_CODIGO ="plugin.procuradores.procurador.getProcuradorPorCodigo";

	
	/**
	 * Obtiene un listado de {@link Categoria}. Soporta paginación, filtrado y ordenación.
	 * @param dto dto con los datos de filtado y paginación.
	 * @return lista de {@link Categoria} paginada.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_PROCURADOR_GET_LISTA_PROCURADORES)
	public Page getListaProcuradores(ProcuradorDto dto);
	
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_POR_CODIGO)
	public int getProcuradorPorCodigo(ProcuradorDto dto);

	@BusinessOperationDefinition(PR_PROCURADORES_GET_PROCURADOR)
	public Procurador getProcurador(Long idProcurador);
	
	@BusinessOperationDefinition(BO_PROCURADORES_GET_PROCURADOR_REAL)
	public String getProcuradorReal(Long idProcedimiento);
	
	@BusinessOperationDefinition(SAVE_PROCEDIMIENTO_PROCURADOR)
	public void saveProcedimientoProcurador(WebRequest request);
	
}
