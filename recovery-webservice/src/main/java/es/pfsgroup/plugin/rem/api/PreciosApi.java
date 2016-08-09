package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;

public interface PreciosApi {
	
	/**
	 * Devuelve una Page de activos aplicando el filtro que recibe
	 * @param dtoActivoFiltro
	 * @return Page de Activo
	 */
	public Page getActivos(DtoActivoFilter dtoActivoFiltro);

	/**
	 * Crea una nueva propuesta de precios de tipo manual
	 * @param activosPrecios Lista de activos seleccionada en la pantalla de propuestas de precios manuales
	 * @param nombrePropuesta Nombre que se da a la propuesta
	 * @param tipoPropuestaCodigo Tipo de propuesta solicitada: Preciar, Repreciar, Descuento
	 * @return PropuestaPrecio
	 */
	public PropuestaPrecio createPropuestaPreciosManual(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo);

	/**
	 * Crea una nueva propuesta de precios del tipo indicado, para una lista de activos
	 * @param activos
	 * @param nombrePropuesta Nombre que se da a la propuesta
	 * @param tipoPropuestaCodigo Tipo de propuesta solicitada: Preciar, Repreciar, Descuento
	 * @return PropuestaPrecio
	 */
	public PropuestaPrecio createPropuestaPrecios(List<Activo> activos, String nombrePropuesta, String tipoPropuestaCodigo);
	
	public ExcelReport createExcelPropuestaPrecios(List<VBusquedaActivosPrecios> activosPrecios, String entidadPropietariaCodigo, String nombrePropuesta);
	
	/**
	 * Devuelve una Page de propuestas aplicando el filtro que recibe
	 * @param dtoPropuestaFiltro
	 * @return Page de PropuestaPrecio
	 */
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);
	

}
