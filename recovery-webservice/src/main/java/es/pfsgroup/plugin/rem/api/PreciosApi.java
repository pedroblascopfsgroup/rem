package es.pfsgroup.plugin.rem.api;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoConfiguracionPropuestasPrecios;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosUnificada;

public interface PreciosApi {
	
	public static final String COD_MSG_GENERAR_PROPUESTA_PRECIOS_ALGUNOS = "01"; //Existen ALGUNOS activos en otras propuestas en tramite
	public static final String COD_MSG_GENERAR_PROPUESTA_PRECIOS_TODOS = "02";   //TODOS los activos están en otras propuestas en trámite
	
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
	public PropuestaPrecio createPropuestaPreciosManual(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo) throws Exception;

	/**
	 * Crea una propuesta de precios de tipo peticion automatica
	 * @param activosPrecios
	 * @param nombrePropuesta
	 * @param tipoPropuestaCodigo
	 * @return
	 */
	public PropuestaPrecio createPropuestaPreciosAutom(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo);
	
	/**
	 * Crea una propuesta de precios desde un trabajo
	 * @param idTrabajo
	 * @param nombrePropuesta
	 * @return
	 */
	public PropuestaPrecio createPropuestaPreciosFromTrabajo(Long idTrabajo, String nombrePropuesta);
	
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
	
	public List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndEstado(String entidadPropietariaCodigo);
	
	public List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndEstadoSareb();
	
	/**
	 * Devuelve el Dto para rellenar el Excel de la Propuesta Unidicada.
	 * @param idPropuesta
	 * @return
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */	
	public List<DtoGenerarPropuestaPreciosUnificada> getDatosPropuestaUnificada(Long idPropuesta) throws IllegalAccessException, InvocationTargetException;
	 
	/**
	 * Comprueba si no existe ya una propuesta asociada al trabajo, y si el trabajo es del tipo y subtipo de propuesta de preciar, descuento
	 * @param idTrabajo
	 * @return
	 */
	public String puedeCreasePropuestaFromTrabajo(Long idTrabajo);
	
	/**
	 * Devuelve una propuesta por el idTrabajo
	 * @param idTrabajo
	 * @return
	 */
	public PropuestaPrecio getPropuestaByTrabajo(Long idTrabajo);
	
	/**
	 * Guarda la propuesta como adjunto del Trabajo asociado.
	 * @param file
	 * @param trabajo
	 */
	public void guardarFileEnTrabajo(File file, Trabajo trabajo);
	
	/**
	 * Devuelve los datos para generar la excel de una propuesta según la entidad filtrada
	 * @param propuesta
	 * @return
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public <T> List<T> getDatosPropuestaByEntidad(PropuestaPrecio propuesta) throws IllegalAccessException, InvocationTargetException;

	/**
	 * Este método obtiene una lista de configuración de propuestas de precios.
	 * 
	 * @return Devuelve una lista de DtoConfiguracionPropuestasPrecios por cada propuesta encontrada.
	 */
	public List<DtoConfiguracionPropuestasPrecios> getConfiguracionGeneracionPropuestas();

	/**
	 * Este método elimina una regla por su ID.
	 * 
	 * @param dto : dto con el ID de la regla a eliminar.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	public boolean deleteConfiguracionGeneracionPropuesta(DtoConfiguracionPropuestasPrecios dto);

	/**
	 * Este método genera una nueva regla con los datos del dto.
	 * 
	 * @param dto : contiene los datos de la nueva regla.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	public boolean createConfiguracionGeneracionPropuesta(DtoConfiguracionPropuestasPrecios dto);

	/**
	 * Este método modifica una regla con los datos del dto por el ID de regla.
	 * 
	 * @param dto : dto con los datos y el ID de la regla a modificar.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	public boolean updateConfiguracionGeneracionPropuesta(DtoConfiguracionPropuestasPrecios dto);
	
	/**
	 * Devuelve mensaje de advertencia si hay algún activo que ya existen en una propuesta de precios en Tramitación (Estado != Cargada)
	 * @param listaActivos
	 * @return
	 */
	public String tienePropuestaActivosEnPropuestasEnTramitacion(List<VBusquedaActivosPrecios> listaActivos);
	
	/**
	 * Devuelve mensaje de adverventia, de si el trabajo tiene activos en propuestas en trámite
	 * @param idTrabajo
	 * @return
	 */
	public String tieneTrabajoActivosEnPropuestasEnTramitacion(Long idTrabajo);
}
