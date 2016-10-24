package es.pfsgroup.framework.paradise.bulkUpload.api;

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
	
}
