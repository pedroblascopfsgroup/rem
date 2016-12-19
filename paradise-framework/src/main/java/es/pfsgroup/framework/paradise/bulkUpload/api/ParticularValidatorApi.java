package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public interface  ParticularValidatorApi {
	
	public String getOneNumActivoAgrupacionRaw(String numAgrupacion);
	
	public String getCarteraLocationByNumAgr (String numAgr);
	
	public String getCarteraLocationByNumAct (String numActive);
	
	public String getCarteraLocationTipPatrimByNumAct (String numActive);
	
	public Boolean esMismaCarteraLocationByNumAgrupRem (String numAgrupRem);

	public String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion);
	
	public Boolean esActivoEnAgrupacion(Long idActivo, Long idAgrupacion);
	
	public Boolean esActivoEnOtraAgrupacion(Long numActivo, Long numAgrupacion);
	
	public Boolean existeActivo(String numActivo);
	
	public Boolean isActivoPrePublicable(String numActivo);
	
	public Boolean estadoNoPublicadoOrNull(String numActivo);
	
	public Boolean estadoOcultaractivo(String numActivo);
	
	public Boolean estadoDesocultaractivo(String numActivo);
	
	public Boolean estadoOcultarprecio(String numActivo);
	
	public Boolean estadoDesocultarprecio(String numActivo);
	
	public Boolean estadoDespublicar(String numActivo);

	public Boolean estadosValidosDespublicarForzado(String numActivo);
	
	public Boolean estadosValidosDesDespublicarForzado(String numActivo);
	
	public Boolean estadoAutorizaredicion(String numActivo);
	
	public Boolean existeBloqueoPreciosActivo(String numActivo);
	
	public Boolean existeOfertaAprobadaActivo(String numActivo);
	
	public Boolean esActivoConVentaOferta(String numActivo);
	
	public Boolean esActivoVendido(String numActivo);
	
	public Boolean esActivoIncluidoPerimetro(String numActivo);
	
	public Boolean esActivoAsistido (String numActivo);
	
	/**
	 * Validacion para las agrupaciones de la lista excel. Valida si estan dadas de baja
	 * @param numAgrupacion
	 * @return
	 */
	public Boolean esAgrupacionConBaja (String numAgrupacion);
	
	/**
	 * Validacion de Localizacion unica para un grupo de activos
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @return
	 */
	public Boolean esActivosMismaLocalizacion (String inSqlNumActivosRem);
	
	/**
	 * Validacion de Propietario unico para un grupo de activos
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @return
	 */
	public Boolean esActivosMismoPropietario (String inSqlNumActivosRem);
	
	/**
	 * Validacion de ofertas aceptadas para un grupo de activos y agrupaciones de estos
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @param numAgrupRem Numero agrupacion
	 * @return
	 */
	public Boolean esActivosOfertasAceptadas (String inSqlNumActivosRem, String numAgrupRem);
	
	/**
	 * Validacion de un activo: Evalua si un activo tiene propietario
	 * @param sqlNumActivosRem
	 * @return
	 */
	public Boolean esActivoConPropietario(String sqlNumActivoRem);
	
	/**
	 * Validacion de un activo si pertenece a alguna agrupacion no compatible 
	 * @param numActivo
	 * @param codTiposAgrNoCompatibles
	 * @return
	 */
	public Boolean esActivoEnOtraAgrupacionNoCompatible(Long numActivo, Long numAgrupacion, String codTiposAgrNoCompatibles);
	
	/**
	 * Comprueba si el activo Bancario es de clase Financiero
	 * @param numActivo
	 * @return
	 */
	public Boolean esActivoFinanciero(String numActivo);
	
	/**
	 * Comprueba si la propuesta ya ha sido cargada
	 * @param idPropuesta
	 * @return
	 */
	public Boolean esPropuestaYaCargada(Long idPropuesta);
	
	/**
	 * Comprueba si el activo no es comercializable
	 * @param numActivo
	 * @return
	 */
	public Boolean isActivoNoComercializable(String numActivo);

	/**
	 * Este método obtiene una lista de importes actuales por el número de activo.
	 * 
	 * @param numActivo : número haya del activo.
	 * @return Devuelve una lista de importes actuales del activo.
	 */
	public List<BigDecimal> getImportesActualesActivo(String numActivo);

	/**
	 * Este método obtiene una lista de fechas de importes actuales por el número de activo.
	 * 
	 * @param numActivo : número haya del activo.
	 * @return Devuelve una lista de fechas de importes actuales del activo.
	 */
	public List<Date> getFechasImportesActualesActivo(String numActivo);


	
}
