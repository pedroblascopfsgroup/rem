package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPropuesta;

public interface PreciosApi {
	
	/**
	 * Devuelve una Page de activos aplicando el filtro que recibe
	 * @param dtoActivoFiltro
	 * @return Page de Activo
	 */
	public Page getActivos(DtoActivoFilter dtoActivoFiltro);

	/**
	 * Crea una nueva propuesta de precios de tipo manual
	 * @param activosPrecios
	 * @param nombrePropuesta
	 * @return PropuestaPrecio
	 */
	public PropuestaPrecio createPropuestaPreciosManual(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta);

	/**
	 * Crea una nueva propuesta de precios para una lista de activos
	 * @param activosPrecios
	 * @param nombrePropuesta
	 * @return PropuestaPrecio
	 */
	public PropuestaPrecio createPropuestaPrecios(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta);
	
	public ExcelReport createExcelPropuestaPrecios(List<VBusquedaActivosPrecios> activosPrecios, String entidadPropietariaCodigo, String nombrePropuesta);
	
	/**
	 * Devuelve una Page de propuestas aplicando el filtro que recibe
	 * @param dtoPropuestaFiltro
	 * @return Page de PropuestaPrecio
	 */
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);
	
	/**
	 * HREOS-641
	 * Devuelve una Page de propuestas de precios aplicando el filtro que recibe
	 * @param dtoPropuestaFiltro
	 * @return
	 */
	public Page getHistoricoPropuestasPrecios(DtoHistoricoPropuestaFilter dtoPropuestaFiltro);
	
	/**
	 * HREOS-641
	 * Devuelve una Page de activos asociados a la propuesta recibida
	 * @param idPropuesta
	 * @return
	 */
	public List<VBusquedaActivosPropuesta> getActivosByIdPropuesta(Long idPropuesta);

}
