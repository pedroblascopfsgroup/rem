package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public interface ParticularValidatorApi {

	String getOneNumActivoAgrupacionRaw(String numAgrupacion);

	String getCarteraLocationByNumAgr(String numAgr);

	String getCarteraLocationByNumAct(String numActive);

	String getCarteraLocationTipPatrimByNumAct(String numActive);

	Boolean esMismaCarteraLocationByNumAgrupRem(String numAgrupRem);

	String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion);

	Boolean activoEnAgrupacionRestringida(Long idActivo);

	Boolean esActivoEnAgrupacion(Long idActivo, Long idAgrupacion);

	Boolean esActivoEnAgrupacionPorTipo(Long numActivo, String codTipoAgrupacion);

	Boolean esActivoPrincipalEnAgrupacion(Long numActivo);

	Boolean esActivoEnOtraAgrupacion(Long numActivo, Long numAgrupacion);

	Boolean existeActivo(String numActivo);

	Boolean isActivoVendido(String numActivo);

	Boolean existePlusvalia(String numActivo);

	Boolean isActivoPrePublicable(String numActivo);

	Boolean estadoNoPublicadoOrNull(String numActivo);

	Boolean estadoOcultaractivo(String numActivo);

	Boolean estadoDesocultaractivo(String numActivo);

	Boolean estadoOcultarprecio(String numActivo);

	Boolean estadoDesocultarprecio(String numActivo);

	Boolean estadoDespublicar(String numActivo);

	Boolean estadosValidosDespublicarForzado(String numActivo);

	Boolean estadosValidosDesDespublicarForzado(String numActivo);

	Boolean estadoAutorizaredicion(String numActivo);

	Boolean existeBloqueoPreciosActivo(String numActivo);

	Boolean existeOfertaAprobadaActivo(String numActivo);

	Boolean esActivoConVentaOferta(String numActivo);

	Boolean esActivoVendido(String numActivo);

	Boolean esActivoIncluidoPerimetro(String numActivo);

	Boolean esActivoAsistido(String numActivo);

	Boolean isFechaTraspasoPosteriorAFechaDevengo(String numActivo, String numGasto);

	/**
	 * Validacion para las agrupaciones de la lista excel. Valida si estan dadas de baja
	 *
	 * @param numAgrupacion
	 * @return
	 */
	Boolean esAgrupacionConBaja(String numAgrupacion);

	/**
	 * Validacion de Localizacion unica para un grupo de activos
	 *
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @return
	 */
	Boolean esActivosMismaLocalizacion(String inSqlNumActivosRem);

	/**
	 * Validacion de Propietario unico para un grupo de activos
	 *
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @return
	 */
	Boolean esActivosMismoPropietario(String inSqlNumActivosRem);

	/**
	 * Validacion de ofertas aceptadas para un grupo de activos y agrupaciones de estos
	 *
	 * @param inSqlNumActivosRem El parametro es una cadena de numActivoRem separados por comas
	 * @param numAgrupRem Numero agrupacion
	 * @return
	 */
	Boolean esActivosOfertasAceptadas(String inSqlNumActivosRem, String numAgrupRem);

	/**
	 * Validacion de un activo: Evalua si un activo tiene propietario
	 *
	 * @param sqlNumActivoRem
	 * @return
	 */
	Boolean esActivoConPropietario(String sqlNumActivoRem);

	/**
	 * Validacion de un activo si pertenece a alguna agrupacion no compatible
	 *
	 * @param numActivo
	 * @param codTiposAgrNoCompatibles
	 * @return
	 */
	Boolean esActivoEnOtraAgrupacionNoCompatible(Long numActivo, Long numAgrupacion, String codTiposAgrNoCompatibles);

	/**
	 * Comprueba si el activo Bancario es de clase Financiero
	 *
	 * @param numActivo
	 * @return
	 */
	Boolean esActivoFinanciero(String numActivo);

	/**
	 * Comprueba si la propuesta ya ha sido cargada
	 *
	 * @param idPropuesta
	 * @return
	 */
	Boolean esPropuestaYaCargada(Long idPropuesta);

	/**
	 * Comprueba si el activo no es comercializable
	 *
	 * @param numActivo
	 * @return
	 */
	Boolean isActivoNoComercializable(String numActivo);

	/**
	 * Este método comprueba si un activo es publicable por su perímetro de publicación.
	 *
	 * @param numActivo: Numero del activo para realizar las comprobaciones.
	 * @return Devuelve True si un activo no es publicable por su perímetro, False si no lo es.
	 */
	Boolean isActivoNoPublicable(String numActivo);

	/**
	 * Este método comprueba si un activo no se encuentra en el destino comercial de venta.
	 *
	 * @param numActivo: Numero del activo para realizar las comprobaciones.
	 * @return Devuelve True si un activo no se encuentra en el destino comercial de venta, False si se encuentra.
	 */
	Boolean isActivoDestinoComercialNoVenta(String numActivo);

	/**
	 * Este método comprueba si un activo no se encuentra en el destino comercial de alquiler.
	 *
	 * @param numActivo: Numero del activo para realizar las comprobaciones.
	 * @return Devuelve True si un activo no se encuentra en el destino comercial de alquiler, False si se encuentra.
	 */
	Boolean isActivoDestinoComercialNoAlquiler(String numActivo);

	/**
	 * Este método comprueba si un activo no dispone de precio de venta web asignado.
	 *
	 * @param numActivo: Numero del activo para realizar las comprobaciones.
	 * @return Devuelve True si un activo no tiene precio de venta web, False si se lo tiene.
	 */
	Boolean isActivoSinPrecioVentaWeb(String numActivo);

	/**
	 * Este método comprueba si un activo no dispone de precio de renta web asignado.
	 *
	 * @param numActivo: Numero del activo para realizar las comprobaciones.
	 * @return Devuelve True si un activo no tiene precio de renta web, False si se lo tiene.
	 */
	Boolean isActivoSinPrecioRentaWeb(String numActivo);

	/**
	 * Este método comprueba si un activo no tiene el informe aprobado.
	 *
	 * @param numActivo: Numero del activo para realizar las comprobaciones.
	 * @return Devuelve True si un activo no tiene el informe aprobado, False si lo tiene  aprobado.
	 */
	Boolean isActivoSinInformeAprobado(String numActivo);

	/**
	 * Este método obtiene una lista de importes actuales por el número de activo.
	 *
	 * @param numActivo : número haya del activo.
	 * @return Devuelve una lista de importes actuales del activo.
	 */
	List<BigDecimal> getImportesActualesActivo(String numActivo);

	/**
	 * Este método obtiene una lista de fechas de importes actuales por el número de activo.
	 *
	 * @param numActivo : número haya del activo.
	 * @return Devuelve una lista de fechas de importes actuales del activo.
	 */
	List<Date> getFechasImportesActualesActivo(String numActivo);

	/**
	 * Comprueba si el activo esta incluido en la propuesta
	 *
	 * @param numActivo
	 * @param numPropuesta
	 * @return
	 */
	Boolean existeActivoEnPropuesta(String numActivo, String numPropuesta);

	/**
	 * Recupera el precio mínimo autorizado actual de un activo
	 *
	 * @param numActivo
	 * @return
	 */
	BigDecimal getPrecioMinimoAutorizadoActualActivo(String numActivo);

	/**
	 * Comprueba si el activo tiene alguna oferta viva (estado != Rechazada)
	 *
	 * @param numActivo
	 * @return
	 */
	Boolean existeActivoConOfertaViva(String numActivo);

	/**
	 * Comprueba que el activo no este en un expediente comercial vivo (con trámites en activo)
	 *
	 * @param numActivo
	 * @return
	 */
	Boolean existeActivoConExpedienteComercialVivo(String numActivo);

	/**
	 * Este método indica si el NIF de la sociedad acreedora existe en la DB o no.
	 *
	 * @param sociedadAcreedoraNIF : NIF de la sociedad acreedora a buscar en la DB.
	 * @return Devuelve True si se encuentra una coincidencia con el NIF. False si no existe coincidencia.
	 */
	Boolean existeSociedadAcreedora(String sociedadAcreedoraNIF);

	/**
	 * Este método indica si el NIF del propietario existe en la DB o no.
	 *
	 * @param propietarioNIF : NIF del propietario a buscar en la DB.
	 * @return Devuelve True si se encuentra una coincidencia con el NIF. False si no existe coincidencia.
	 */
	Boolean existePropietario(String propietarioNIF);

	/**
	 * Este método indica si el NIF del proveedor mediador existe en la DB o no.
	 *
	 * @param proveedorMediadorNIF : NIF del proveedor mediador a buscar en la DB.
	 * @return Devuelve True si se encuentra una coincidencia con el NIF. False si no existe coincidencia.
	 */
	Boolean existeProveedorMediadorByNIF(String proveedorMediadorNIF);

	/**
	 * Este método indica si el código de provincia existe en la DB.
	 *
	 * @param codigoProvincia : código de la provincia.
	 * @return Devuelve True si existe, False si no existe el código.
	 */
	Boolean existeProvinciaByCodigo(String codigoProvincia);

	/**
	 * Este método indica si el código de municipio existe en la DB.
	 *
	 * @param codigoMunicipio : código del municipio.
	 * @return Devuelve True si existe, False si no existe el código.
	 */
	Boolean existeMunicipioByCodigo(String codigoMunicipio);

	/**
	 * Este método indica si el código de la unidad inferior al municipio existe en la DB.
	 *
	 * @param codigoUnidadInferiorMunicipio : código de la unidad inferior al municipio.
	 * @return Devuelve True si existe, False si no existe el código.
	 */
	Boolean existeUnidadInferiorMunicipioByCodigo(String codigoUnidadInferiorMunicipio);

	Boolean existeGasto(String numGasto);

	Boolean propietarioGastoConDocumento(String numGasto);

	Boolean propietarioGastoIgualActivo(String numActivo, String numGasto);

	Boolean activoNoAsignado(String numActivo, String numGasto);

	Boolean isGastoNoAutorizado(String numGasto);

	Boolean isGastoNoAsociadoTrabajo(String numGasto);

	Boolean isGastoPermiteAnyadirActivo(String numGasto);

	Boolean esActivosMismaCartera(String inSqlNumActivosRem, String agrupacion);

	Boolean existeExpedienteComercial(String numExpediente);

	Boolean existeAgrupacion(String numAgrupacion);

	Boolean existeTipoGestor(String tipoGestor);

	Boolean existeUsuario(String username);

	Boolean usuarioEsTipoGestor(String username, String codigoTipoGestor);

	Boolean combinacionGestorCarteraAcagexValida(String codigoGestor, String numActivo, String numAgrupacion, String numExpediente);

	Boolean destinoFinalNoVenta(String numActivo);

	Boolean destinoFinalNoAlquiler(String numActivo);

	Boolean activoNoPublicado(String numActivo);

	Boolean activoOcultoVenta(String numActivo);

	Boolean activoOcultoAlquiler(String numActivo);

	Boolean motivoNotExistsByCod(String codigoMotivo);

	boolean existeGestorComercialByUsername(String gestorUsername);

	boolean existeSupervisorComercialByUsername(String supervisorUsername);

	boolean existeGestorFormalizacionByUsername(String gestorUsername);

	boolean existeSupervisorFormalizacionByUsername(String supervisorUsername);

	boolean existeGestorAdmisionByUsername(String gestorUsername);

	boolean existeGestorActivosByUsername(String gestorUsername);

	boolean existeGestoriaDeFormalizacionByUsername(String username);

	boolean existeSubCarteraByCod(String codSubCartera);

	boolean existeTipoActivoByCod(String codTipoActivo);

	boolean existeSubtipoActivoByCod(String codSubtipoActivo);

	Boolean distintosTiposImpuesto(String numActivo, String numAgrupacion);

	boolean comprobarDistintoPropietario(String numActivo, String numAgrupacion);

	boolean comprobarDistintoPropietarioListaActivos(String[] activos);

	boolean activoConOfertasTramitadas(String numActivo);

	Boolean existeProveedorMediadorByNIFConFVD(String proveedorMediadorNIF);

	boolean isMismoTipoComercializacionActivoPrincipalAgrupacion(String numActivo, String numAgrupacion);
	
	boolean isMismoTipoComercializacionActivoPrincipalExcel(String numActivo, String numActivoPrincipalExcel);
	
	Boolean isAgrupacionSinActivoPrincipal(String mumAgrupacionRem);

	boolean isMismoEpuActivoPrincipalAgrupacion(String numActivo, String numAgrupacion);
	
	boolean isMismoEpuActivoPrincipalExcel(String numActivo, String numActivoPrincipalExcel);

	String idAgrupacionDelActivoPrincipal(String numActivo);

	Boolean esActivoVendidoAgrupacion(String numAgrupacion);

	Boolean isActivoNoComercializableAgrupacion(String numAgrupacion);

	Boolean isActivoNoPublicableAgrupacion(String numAgrupacion);

	Boolean isActivoDestinoComercialNoVentaAgrupacion(String numAgrupacion);

	Boolean isActivoSinPrecioVentaWebAgrupacion(String numAgrupacion);

	Boolean isActivoSinInformeAprobadoAgrupacion(String numAgrupacion);

	Boolean isActivoDestinoComercialNoAlquilerAgrupacion(String numAgrupacion);

	Boolean activosNoOcultosVentaAgrupacion(String numAgrupacion);

	Boolean activosNoOcultosAlquilerAgrupacion(String numAgrupacion);

	Boolean isActivoSinPrecioRentaWebAgrupacion(String numAgrupacion);

	Boolean isActivoNoPublicadoAlquiler(String numActivo);

	Boolean isActivoNoPublicadoVenta(String numActivo);

	boolean existeComiteSancionador(String codComite);

	boolean existeTipoimpuesto(String codTipoImpuesto);

	boolean existeCodigoPrescriptor(String codPrescriptor);

	boolean existeTipoDocumentoByCod(String codDocumento);

	/**
	 * El método indica si existe alguna agrupación con la descripcion indicada
	 *
	 * @param descripcionAgrupacion : Descripion de la agrupación
	 * @return : Devuelve True si existe, False si no existe el código.
	 */
	Boolean existeAgrupacionByDescripcion(String descripcionAgrupacion);

	String getSubcartera(String numActivo);

	Boolean tienenRelacionActivoGasto(String numActivo, String numGasto);

	List<Long> getRelacionGastoActivo(String numGasto);

	Boolean agrupacionEstaVacia(String numAgrupacion);

	Boolean distintosTiposImpuestoAgrupacionVacia(List<String> activosList);

	Boolean subcarteraPerteneceCartera(String subcartera, String cartera);

	/**
	 * @param idActivo
	 * @return devuelve true si un activo tiene un destino comercial de tipo venta (no confundir con venta y alquiler)
	 */
	public Boolean activoConDestinoComercialVenta(String idActivo);

	/**
	 * @param numActivo
	 * @return devuelve true si el activo tiene una situación comercial de alquilado
	 */
	Boolean esActivoAlquilado(String numActivo);

	/**
	 *
	 * @param numActivo
	 * @return devuelve true si el activo se encuentra incluido en una agrupacion viva de tipo comercial
	 */
	Boolean activoEnAgrupacionComercialViva(String numActivo);

	/**
	 * @param numActivo:
	 * @return devuelve true si un activo tiene un destino comercial de tipo alquiler (no confundir con venta y alquiler)
	 */
	Boolean activoConDestinoComercialAlquiler(String numActivo);

	/**
	 * @param numAgrupacion
	 * @return devuelve true si la agrupacion es de tipo comercial alquiler
	 */
	Boolean esAgrupacionTipoAlquiler(String numAgrupacion);

	/**
	 * @param numAgrupacion
	 * @param numActivo
	 * @return Devuelve true si el activo tiene el mismo tipo de alquiler que la agrupacion.
	 */
	Boolean mismoTipoAlquilerActivoAgrupacion(String numAgrupacion, String numActivo);

	/**
	 * @param numAgrupacion
	 * @return devuelve true si la agrupacion es de tipo comercial venta
	 */
	Boolean esAgrupacionTipoComercialVenta(String numAgrupacion);

	/**
	 * @param numAgrupacion
	 * @return devuelve el código de la subcartera de una agrupación según su activo principal
	 */
	public String getCodigoSubcarteraAgrupacion(String numAgrupacion);

	Boolean subtipoPerteneceTipoTitulo(String subtipo, String tipoTitulo);

	Boolean esGastoDeLiberbank(String numGasto);

	Boolean esParGastoActivo(String numGasto, String numActivo);

	Boolean existePromocion(String promocion);

	Boolean mediadorExisteVigente(String codMediador);

	Boolean existeComunidadPropietarios(String idPropietarios);

	Boolean existeSituacion(String idSituacion);

	Boolean existeActivoEnPropietarios(String numActivo, String idPropietarios);

	
	/**
	 * Devuelve true si un activo tiene ofertas vivas de tipo venta
	 *
	 * @param numActivo
	 * @return
	 */
	Boolean existeActivoConOfertaVentaViva(String numActivo);

	
	Boolean isActivoPublicadoVenta(String numActivo);

	Boolean isActivoOcultoVentaPorMotivosManuales(String numActivo);

	Boolean isActivoPublicadoAlquiler(String numActivo);

	Boolean isActivoOcultoAlquilerPorMotivosManuales(String numActivo);

	Boolean existeCatastro(String catastro);
		
		
	public Boolean agrupacionEsProyecto(String numAgrupacion);

	public Boolean activoTienePRV(String numActivo);

	public Boolean activoTieneLOC(String numActivo);

	public Boolean esMismaProvincia(Long numActivo, Long numAgrupacion);

	public Boolean esMismaLocalidad(Long numActivo, Long numAgrupacion);

	
	/**
	 * Devuelve el codigo del destino comercial de un activo
	 * 
	 * @param numActivo
	 * @return
	 */
	public Boolean existeActivoConOfertaAlquilerViva(String numActivo);


	Boolean isActivoOcultoVenta(String numActivo);

	Boolean isActivoOcultoAlquiler(String numActivo);

	
	/**
	 * Este método te comprueba si el campo perimetro de alquiler está activo.
	 *
	 * @param numActivo número de activo haya.
	 * @return Devuelve un true si el campo está activo o un false si no.
	 */
	Boolean isActivoIncluidoPerimetroAlquiler(String numActivo);

	/**
	 * Devuelve el codigo del destino comercial de un activo
	 *
	 * @param numActivo
	 * @return
	 */
	public String getCodigoDestinoComercialByNumActivo(String numActivo);


	public Boolean isActivoFinanciero(String numActivo);

	/**
	 * 
	 * @param idImpuesto
	 * @return true si existe, false si no existe o es nulo
	 */
	public Boolean existeCodImpuesto(String idImpuesto);

	/**
	 * 
	 * @param codPeriodicidad
	 * @return true si existe, false si no existe o es nulo
	 */
	public Boolean existePeriodicidad(String codPeriodicidad);
	
	/**
	 * 
	 * @param codCalculo
	 * @return true si existe, false si no existe o es nulo
	 */
	public Boolean existeCalculo(String codCalculo);
}
