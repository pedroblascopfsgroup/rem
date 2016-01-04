package es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.model.ResolucionesCategorias;

public interface ResolucionesCategoriasApi {

	public static final String PLUGIN_PROCURADORES_GET_RESOLUCIONES_PENDIENTES = "plugin.procuradores.resolucionesCategorias.getResolucionesPendientes";

	/**
	 * Obtiene un listado de resoluciones por cada {@link Categoria}.
	 * @param Categoria
	 * @return lista de {@link ResolucionesCategorias}.
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_GET_RESOLUCIONES_PENDIENTES)
	public List<ResolucionesCategorias> getResolucionesPendientes(Long idUsuario);
	
}