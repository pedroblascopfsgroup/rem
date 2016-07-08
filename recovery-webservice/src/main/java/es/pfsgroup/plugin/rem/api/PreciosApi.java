package es.pfsgroup.plugin.rem.api;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;

public interface PreciosApi {
	
	/**
	 * Devuelve una Page de activos aplicando el filtro que recibe
	 * @param dtoActivoFiltro
	 * @return Page de Activo
	 */
	public Page getActivos(DtoActivoFilter dtoActivoFiltro);

	public ExcelReport createPropuestaPrecios(DtoActivoFilter dto, String nombre);

	/**
	 * Devuelve una Page de propuestas aplicando el filtro que recibe
	 * @param dtoPropuestaFiltro
	 * @return Page de PropuestaPrecio
	 */
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);
	

}
