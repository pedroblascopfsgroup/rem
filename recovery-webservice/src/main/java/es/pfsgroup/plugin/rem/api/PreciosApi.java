package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;

public interface PreciosApi {
	
	/**
	 * Devuelve una Page de activos aplicando el filtro que recibe
	 * @param dtoActivoFiltro
	 * @return Page de Activo
	 */
	public Page getActivos(DtoActivoFilter dtoActivoFiltro);

	/**
	 * Crea una nueva propuesta de precios de tipo peticion manual
	 * @param activosPrecios Lista de activos seleccionada en la pantalla de propuestas de precios manuales
	 * @param nombrePropuesta Nombre que se da a la propuesta
	 * @param tipoPropuestaCodigo Tipo de propuesta solicitada: Preciar, Repreciar, Descuento
	 * @return PropuestaPrecio
	 */
	public PropuestaPrecio createPropuestaPreciosManual(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo, Boolean esPropManual);

	/**
	 * Crea una propuesta de precios de tipo peticion automatica
	 * @param activosPrecios
	 * @param nombrePropuesta
	 * @param tipoPropuestaCodigo
	 * @return
	 */
	public PropuestaPrecio createPropuestaPreciosAutom(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo);
	
	
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
	 * Devuelve una lista de activos asociados a la propuesta recibida
	 * @param idPropuesta
	 * @return
	 */
	public Page getActivosByIdPropuesta(Long idPropuesta, WebDto dto);

	/**
	 * HREOS-639
	 * Devuelve una lista con la cantidad de activos por Tipo Precio-Propuesta, agrupadas segun cartera
	 * @return
	 */
	public List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndCartera();

}
