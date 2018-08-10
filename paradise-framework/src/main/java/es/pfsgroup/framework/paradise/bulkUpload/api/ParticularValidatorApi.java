package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public interface ParticularValidatorApi {

	public String getOneNumActivoAgrupacionRaw(String numAgrupacion);

	public String getCarteraLocationByNumAgr(String numAgr);

	public String getCarteraLocationByNumAct(String numActive);

	public String getCarteraLocationTipPatrimByNumAct(String numActive);

	public Boolean esMismaCarteraLocationByNumAgrupRem(String numAgrupRem);

	public String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion);
	
	public Boolean activoEnAgrupacionRestringida(Long idActivo);

	public Boolean esActivoEnAgrupacion(Long idActivo, Long idAgrupacion);
	
	public Boolean esActivoEnAgrupacionPorTipo(Long numActivo, String codTipoAgrupacion);

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

	public Boolean esActivoAsistido(String numActivo);
	
	public Boolean isFechaTraspasoPosteriorAFechaDevengo(String numActivo, String numGasto);

	/**
	 * Validacion para las agrupaciones de la lista excel. Valida si estan dadas de baja
	 * 
	 * @param numAgrupacion
	 * @return
	 */
	public Boolean esAgrupacionConBaja(String numAgrupacion);

	/**
	 * Validacion de Localizacion unica para un grupo de activos
	 * 
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @return
	 */
	public Boolean esActivosMismaLocalizacion(String inSqlNumActivosRem);

	/**
	 * Validacion de Propietario unico para un grupo de activos
	 * 
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @return
	 */
	public Boolean esActivosMismoPropietario(String inSqlNumActivosRem);

	/**
	 * Validacion de ofertas aceptadas para un grupo de activos y agrupaciones de estos
	 * 
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @param numAgrupRem Numero agrupacion
	 * @return
	 */
	public Boolean esActivosOfertasAceptadas(String inSqlNumActivosRem, String numAgrupRem);

	/**
	 * Validacion de un activo: Evalua si un activo tiene propietario
	 * 
	 * @param sqlNumActivosRem
	 * @return
	 */
	public Boolean esActivoConPropietario(String sqlNumActivoRem);

	/**
	 * Validacion de un activo si pertenece a alguna agrupacion no compatible
	 * 
	 * @param numActivo
	 * @param codTiposAgrNoCompatibles
	 * @return
	 */
	public Boolean esActivoEnOtraAgrupacionNoCompatible(Long numActivo, Long numAgrupacion, String codTiposAgrNoCompatibles);

	/**
	 * Comprueba si el activo Bancario es de clase Financiero
	 * 
	 * @param numActivo
	 * @return
	 */
	public Boolean esActivoFinanciero(String numActivo);

	/**
	 * Comprueba si la propuesta ya ha sido cargada
	 * 
	 * @param idPropuesta
	 * @return
	 */
	public Boolean esPropuestaYaCargada(Long idPropuesta);

	/**
	 * Comprueba si el activo no es comercializable
	 * 
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

	/**
	 * Comprueba si el activo esta incluido en la propuesta
	 * 
	 * @param numActivo
	 * @param numPropuesta
	 * @return
	 */
	public Boolean existeActivoEnPropuesta(String numActivo, String numPropuesta);

	/**
	 * Recupera el precio mínimo autorizado actual de un activo
	 * 
	 * @param numActivo
	 * @return
	 */
	public BigDecimal getPrecioMinimoAutorizadoActualActivo(String numActivo);

	/**
	 * Comprueba si el activo tiene alguna oferta viva (estado != Rechazada)
	 * 
	 * @param numActivo
	 * @return
	 */
	public Boolean existeActivoConOfertaViva(String numActivo);

	/**
	 * Comprueba que el activo no este en un expediente comercial vivo (con trámites en activo)
	 * 
	 * @param numActivo
	 * @return
	 */
	public Boolean existeActivoConExpedienteComercialVivo(String numActivo);

	/**
	 * Este método indica si el NIF de la sociedad acreedora existe en la DB o no.
	 * 
	 * @param sociedadAcreedoraNIF : NIF de la sociedad acreedora a buscar en la DB.
	 * @return Devuelve True si se encuentra una coincidencia con el NIF. False si no existe
	 *         coincidencia.
	 */
	public Boolean existeSociedadAcreedora(String sociedadAcreedoraNIF);

	/**
	 * Este método indica si el NIF del propietario existe en la DB o no.
	 * 
	 * @param propietarioNIF : NIF del propietario a buscar en la DB.
	 * @return Devuelve True si se encuentra una coincidencia con el NIF. False si no existe
	 *         coincidencia.
	 */
	public Boolean existePropietario(String propietarioNIF);

	/**
	 * Este método indica si el NIF del proveedor mediador existe en la DB o no.
	 * 
	 * @param proveedorMediadorNIF : NIF del proveedor mediador a buscar en la DB.
	 * @return Devuelve True si se encuentra una coincidencia con el NIF. False si no existe
	 *         coincidencia.
	 */
	public Boolean existeProveedorMediadorByNIF(String proveedorMediadorNIF);

	/**
	 * Este método indica si el código de provincia existe en la DB.
	 * 
	 * @param codigoProvincia : código de la provincia.
	 * @return Devuelve True si existe, False si no existe el código.
	 */
	public Boolean existeProvinciaByCodigo(String codigoProvincia);

	/**
	 * Este método indica si el código de municipio existe en la DB.
	 * 
	 * @param codigoMunicipio : código del municipio.
	 * @return Devuelve True si existe, False si no existe el código.
	 */
	public Boolean existeMunicipioByCodigo(String codigoMunicipio);

	/**
	 * Este método indica si el código de la unidad inferior al municipio existe en la DB.
	 * 
	 * @param codigoUnidadInferiorMunicipio : código de la unidad inferior al municipio.
	 * @return Devuelve True si existe, False si no existe el código.
	 */
	public Boolean existeUnidadInferiorMunicipioByCodigo(String codigoUnidadInferiorMunicipio);
	
	public Boolean existeGasto(String numGasto);
	
	public Boolean propietarioGastoConDocumento(String numGasto);
	
	public Boolean propietarioGastoIgualActivo(String numActivo, String numGasto);
	
	public Boolean activoNoAsignado(String numActivo, String numGasto);
	
	public Boolean isGastoNoAutorizado(String numGasto);
	
	public Boolean isGastoNoAsociadoTrabajo(String numGasto);
	
	public Boolean isGastoPermiteAnyadirActivo(String numGasto);

	Boolean esActivosMismaCartera(String inSqlNumActivosRem, String agrupacion);
	
	public Boolean existeExpedienteComercial(String numExpediente);
	
	public Boolean existeAgrupacion(String numAgrupacion);
	
	public Boolean existeTipoGestor(String tipoGestor);
	
	public Boolean existeUsuario(String username);
	
	public Boolean usuarioEsTipoGestor(String username, String codigoTipoGestor);
	
	public Boolean combinacionGestorCarteraAcagexValida(String codigoGestor, String numActivo, String numAgrupacion,String numExpediente);

	public boolean existeGestorComercialByUsername(String gestorUsername);
	
	public boolean existeSupervisorComercialByUsername (String supervisorUsername);
	
	public boolean existeGestorFormalizacionByUsername(String gestorUsername);
	
	public boolean existeSupervisorFormalizacionByUsername(String supervisorUsername);
	
	public boolean existeGestorAdmisionByUsername(String gestorUsername);
	
	public boolean existeGestorActivosByUsername(String gestorUsername);
	
	public boolean existeGestoriaDeFormalizacionByUsername(String username);

	public boolean existeSubCarteraByCod(String codSubCartera);

	public boolean existeTipoActivoByCod(String codTipoActivo);
	
	public boolean existeSubtipoActivoByCod(String codSubtipoActivo);

	public Boolean distintosTiposImpuesto(String numActivo, String numAgrupacion);

	public boolean comprobarDistintoPropietario(String numActivo, String numAgrupacion);

	boolean comprobarDistintoPropietarioListaActivos(String[] activos);

	boolean activoConOfertasTramitadas(String numActivo);
	
	public boolean existeComiteSancionador(String codComite);
	
	public boolean existeTipoimpuesto(String codTipoImpuesto);
	
	public boolean existeCodigoPrescriptor(String codPrescriptor);
	
	public boolean existeTipoDocumentoByCod(String codDocumento);
	
	/**
	 * El método indica si existe alguna agrupación con la descripcion indicada
	 * 
	 * @param descripcionAgrupacion : Descripion de la agrupación
	 * @return : Devuelve True si existe, False si no existe el código.
	 */
	public Boolean existeAgrupacionByDescripcion(String descripcionAgrupacion);
	
	public Boolean existeProveedorMediadorByNIFConFVD(String proveedorMediadorNIF);
	
	public String getSubcartera(String numActivo);

	Boolean tienenRelacionActivoGasto(String numActivo, String numGasto);

	List<Long> getRelacionGastoActivo(String numGasto);

	public Boolean agrupacionEstaVacia(String numAgrupacion);

	public Boolean distintosTiposImpuestoAgrupacionVacia(List<String> activosList);

	Boolean subcarteraPerteneceCartera(String subcartera, String cartera);

	Boolean esGastoDeLiberbank(String numGasto);

	Boolean esParGastoActivo(String numGasto, String numActivo);

	Boolean existePromocion(String promocion);



}
