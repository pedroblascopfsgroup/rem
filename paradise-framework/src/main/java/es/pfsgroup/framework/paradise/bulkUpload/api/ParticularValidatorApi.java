package es.pfsgroup.framework.paradise.bulkUpload.api;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;

public interface ParticularValidatorApi {

	String getOneNumActivoAgrupacionRaw(String numAgrupacion);

	String getCarteraLocationByNumAgr(String numAgr);

	String getCarteraLocationByNumAct(String numActive);

	String getCarteraLocationTipPatrimByNumAct(String numActive);

	Boolean esMismaCarteraLocationByNumAgrupRem(String numAgrupRem);

	String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion);

	Boolean activoEnAgrupacionRestringida(Long numActivo);

	Boolean esActivoEnAgrupacion(Long idActivo, Long idAgrupacion);
	
	boolean existeProveedor(String codProveedor);

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
     * Comprueba si existe un trabajo
     *
     * @param numTrabajo
     * @return true si el trabajo existe, false si recibe un null o no existe el trabajo
     */
	
	Boolean existeTrabajo(String numTrabajo);
	
	Boolean existeGastoTrabajo(String numTrabajo);
	
	Boolean existeSubtrabajo(String codSubtrabajo);
	
	Boolean compararNumeroFilasTrabajo(String numTrabajo, int numeroFilas);
		
	Boolean existeTipoTarifa(String tipoTarifa);
	
	Boolean tipoTarifaValido(String tipoTarifa, String numTrabajo);
	
	

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
	
	Boolean agrupacionActiva(String numAgrupacion);
	
	Boolean existeAgrupacionPA(String numAgrupacion);

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
	
	boolean esGestoriaDeFormalizacionCorrecta(String username);

	boolean existeSubCarteraByCod(String codSubCartera);
	
	boolean existeCarteraByCod(String codCartera);

	boolean existeTipoActivoByCod(String codTipoActivo);

	boolean existeSubtipoActivoByCod(String codSubtipoActivo);

	Boolean distintosTiposImpuesto(String numActivo, String numAgrupacion);

	boolean comprobarDistintoPropietario(String numActivo, String numAgrupacion);

	boolean comprobarDistintoPropietarioListaActivos(String[] activos);

	boolean activoConOfertasTramitadas(String numActivo);
	
	Boolean existeCalifEnergeticaByDesc(String califEnergeticaDesc);
	
	Boolean existeGradoPropiedadByCod(String gradPropiedadCod);
	
	Boolean existeDestComercialByCod(String destComercialCod);
	
	Boolean destComercialContieneAlquiler(String destComercialCod);
	
	Boolean existeTipoAlquilerByCod(String tipoAlquilerCod);
	
	Boolean existeTipoViaByCod(String tipoViaCod);
	
	Boolean existeSubtipoTituloByCod(String subtipoTituloCod);

	Boolean existeUsoDominanteByCod(String usoDominanteCod);
	
	Boolean existeEstadoExpRiesgoByCod(String estadoExpRiesgoCod);
	
	Boolean existeProvinciaByCod(String provCod);
	
	Boolean existeEstadoFisicoByCod(String estFisicoCod);
	
	Boolean existeClaseActivoByDesc(String claseActivoDesc);
	
	Boolean existeProveedorMediadorByNIFConFVD(String proveedorMediadorNIF);

	boolean isMismoTipoComercializacionActivoPrincipalAgrupacion(String numActivo, String numAgrupacion);
	
	boolean isMismoTipoComercializacionActivoPrincipalExcel(String numActivo, String numActivoPrincipalExcel);
	
	Boolean isAgrupacionSinActivoPrincipal(String mumAgrupacionRem);

	boolean isMismoEpuActivoPrincipalAgrupacion(String numActivo, String numAgrupacion);
	
	boolean isMismoTcoActivoPrincipalAgrupacion(String numActivo, String numAgrupacion);
	
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
	Boolean activoConDestinoComercialVenta(String idActivo);

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
	String getCodigoSubcarteraAgrupacion(String numAgrupacion);

	Boolean subtipoPerteneceTipoTitulo(String subtipo, String tipoTitulo);

	Boolean esGastoDeLiberbank(String numGasto);

	Boolean esParGastoActivo(String numGasto, String numActivo);

	Boolean existePromocion(String promocion);

	Boolean mediadorExisteVigente(String codMediador);

	Boolean existeComunidadPropietarios(String idPropietarios);
	
	Boolean existeEstadoLoc(String idSituacion);
	
	Boolean existeSubestadoGestion(String idSituacion);

	Boolean existeActivoEnPropietarios(String numActivo, String idPropietarios);

	
	Boolean isActivoPublicadoVenta(String numActivo);

	Boolean isActivoOcultoVentaPorMotivosManuales(String numActivo);

	Boolean isActivoPublicadoAlquiler(String numActivo);

	Boolean isActivoOcultoAlquilerPorMotivosManuales(String numActivo);

	Boolean existeCatastro(String catastro);
		
		
	Boolean agrupacionEsProyecto(String numAgrupacion);

	Boolean activoTienePRV(String numActivo);

	Boolean activoTieneLOC(String numActivo);

	Boolean esMismaProvincia(Long numActivo, Long numAgrupacion);

	Boolean esMismaLocalidad(Long numActivo, Long numAgrupacion);
	
	Boolean esActivoConComunicacionComunicada(Long numActivoHaya);
	
	Boolean esActivoConComunicacionViva(Long numActivoHaya);
	
	Boolean esActivoSinComunicacionViva(Long numActivoHaya);
	
	Boolean esActivoConMultiplesComunicacionesVivas(Long numActivoHaya);
	
	Boolean esNIFValido(String nif);
	
	/**
	 * 
	 * El método indica si el activo tiene una comunicación ya reclamada
	 * 
	 * @param numActivoHaya : Excel con las reclamaciones
	 * @return Devuelve un boolean. Si es TRUE la comunicación viva ya esta reclamada.
	 * 
	 */
	boolean esActivoConComunicacionReclamada(Long numActivoHaya);
	
	Boolean esActivoConComunicacionGenerada(Long numActivoHaya);
	
	boolean esActivoConAdecuacionFinalizada(Long numActivoHaya);

	/**
	 * Devuelve true si un activo tiene ofertas vivas de tipo venta
	 * 
	 * @param numActivo
	 * @return
	 */
	Boolean existeActivoConOfertaVentaViva(String numActivo);
	
	/**
	 * Devuelve el codigo del destino comercial de un activo
	 * 
	 * @param numActivo
	 * @return
	 */
	Boolean existeActivoConOfertaAlquilerViva(String numActivo);


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
	String getCodigoDestinoComercialByNumActivo(String numActivo);


	public Boolean isActivoFinanciero(String numActivo);

	Boolean esAgrupacionVigente(String numAgrupacion);

	Boolean tieneActivoMatriz(String numAgrupacion);

	String getGestorComercialAlquilerByAgrupacion(String numAgrupacion);

	String getSupervisorComercialAlquilerByAgrupacion(String numAgrupacion);

	String getSuperficieConstruidaActivoMatrizByAgrupacion(String numAgrupacion);

	String getSuperficieConstruidaPromocionAlquilerByAgrupacion(String numAgrupacion);

	String getSuperficieUtilActivoMatrizByAgrupacion(String numAgrupacion);

	String getSuperficieUtilPromocionAlquilerByAgrupacion(String numAgrupacion);

	String getProcentajeTotalActualPromocionAlquiler(String numAgrupacion);
	
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

	Boolean existeActivoConOfertaVivaEstadoExpediente(String numActivo);

	
	/**
	 *  Valida que el activo no pertenezca a las carteras Bankia y Liberbank
	 * @param numActivo
	 * @return 1 - FALSE si no hay error, 0 - TRUE si hay error y pertenece a estas carteras 
	 */
	public Boolean isActivoNotBankiaLiberbank(String numActivo);
	
	/**
	 * 
	 * @param numExpediente
	 * @return true si es de tipo Venta, false si es de tipo Alquiler
	 */
	public Boolean validadorTipoOferta(Long numExpediente);	
	
	/**
	 * 
	 * @param numExpediente
	 * @return true si pertenece a Bankia o Liberbank, 
	 * false si esta entre las otras carteras (incluyendo Bankia Habitat)  
	 */
	public Boolean validadorTipoCartera(Long numExpediente);
	
	/**
	 * true si pertenece a Bankia
	 * @param numExpediente
	 * @return
	 */
	public Boolean validadorCarteraBankia(Long numExpediente);
	
	/**
	 * true si pertenece a liberbank
	 * @param numExpediente
	 * @return
	 */
	public Boolean validadorCarteraLiberbank(Long numExpediente);
	
	/**
	 * 
	 * @param numExpediente
	 * @return true si es diferente a Tramitado, false si es Tramitado  
	 */
	public Boolean validadorEstadoOfertaTramitada(Long numExpediente);
	
	/**
	 * 
	 * @param numExpediente
	 * @return true si el estado no es de los de la lista, 
	 * false si el estado si es de los que se pueden modificar  
	 */
	public Boolean validadorEstadoExpedienteSolicitado(Long numExpediente);
	
	/**
	 * @param numExpediente
	 * @param valorDate
	 * @return true si la fecha de ingreso no es mayor a la fecha alta oferta,
	 * false si lo es
	 */	
	public Boolean validadorFechaMayorIgualFechaAltaOferta(Long numExpediente, String valorDate);
	
	/**
	 * @param numExpediente
	 * @param fecha
	 * @return true si la fecha de ingreso no es mayor a la fecha sancion,
	 * false si lo es
	 */
	public Boolean validadorFechaMayorIgualFechaSancion(Long numExpediente, String fecha);
	
	/**
	 * Para obtener la fecha de la aceptacion, en REM se muestra ese dato, pero en BDA es ECO_FECHA_ALTA
	 * @param numExpediente
	 * @param fecha
	 * @return true si la fecha de ingreso no es mayor a la fecha aceptacion,
	 * false si lo es
	 */
	public Boolean validadorFechaMayorIgualFechaAceptacion(Long numExpediente, String fecha);
	
	/**
	 * Para obtener la fecha de la reserva, en REM se usa la fecha de la firma
	 * @param numExpediente
	 * @param fecha
	 * @return true si la fecha de ingreso no es mayor a la fecha reserva,
	 * false si lo es
	 */
	public Boolean validadorFechaMayorIgualFechaReserva(Long numExpediente, String fecha);
	
	/**
	 * @param numExpediente
	 * @param fecha
	 * @return true si la fecha de ingreso no es mayor a la fecha venta,
	 * false si lo es
	 */
	public Boolean validadorFechaMayorIgualFechaVenta(Long numExpediente, String fecha);

	Boolean isOfferOfGiants(String numOferta);

	Boolean existeOferta(String numOferta);

	Boolean esOfertaPendienteDeSancion(String numOferta);

	Boolean isAgrupacionOfGiants(String numAgrupacion);

	Boolean isActivoOfGiants(String numActivo);
	
	Boolean perteneceDDEstadoActivo(String codigoEstadoActivo);

	Boolean perteneceDDTipoTituloTPA(String codigoTituloTPA);

	Boolean conTituloOcupadoSi(String codigoTituloTPA);	
	
	Boolean conPosesion(String numActivo);
	
	Boolean perteneceDDEstadoDivHorizontal(String codigoEstadoDivHorizontal);

	/**
	 * @param numActivo
	 * @return true si el activo es un activo Matriz de una PA
	 * false si no lo es
	 */
	Boolean isActivoMatriz(String numActivo);
	
	/**
	 * @param numActivo
	 * @return true si el activo es una unidad alquilable de una PA
	 * false si no lo es
	 */
	Boolean isUA(String numActivo);

	List<BigDecimal> activosEnAgrupacion(String numOferta);

	/**
	 * @param entidadFinanciera
	 * @return true si existe la entidad Financiera
	 */
	public Boolean existeEntidadFinanciera(String entidadFinanciera);
	/**
	 * @param tipoFinanciacion
	 * @return true si el tipo de financiazion existe.
	 */
	public Boolean existeTipoDeFinanciacion(String tipoFinanciacion);
	/**
	 * @param numExpedienteComercial
	 * @return true si el activo pertenece a una oferta en venta.
	 */
	
	public Boolean perteneceOfertaVenta(String numExpedienteComercial);
	/**
	 * @param numExpedienteComercial
	 * @return true si el activo pertenece a un activo de venta.
	 */
	
	public Boolean activosVendidos(String numExpedienteComercial);
	
	/**
	 * @param importe Suma de la columna de importes en la hoja
	 * @param numExpedienteComercial
	 * @return true si el total de la oferta es distinto a la suma de los activos en la hoja.
	 */
	public Boolean isTotalOfertaDistintoSumaActivos(Double importe, String numExpedienteComercial);
	
	/**
	 * 
	 * @param numExpedienteComercial
	 * @return true si existe un activo en el Expediente Comercial con importe nulo
	 */
	public Boolean isNullImporteActivos(String numExpedienteComercial);
	
	/**
	 * @param numExpedienteComercial
	 * @param List <activos> contiene una lista con los activos que se supone componen la oferta 
	 * @return false si el nº de los activos de la oferta no coincide con los de la lista 
	 */
	public Boolean isAllActivosEnOferta(String numExpedienteComercial, Hashtable <String, Integer> activos); 
	
	Boolean esActivoPrincipalEnAgrupacion(Long numActivo, String tipoAgr);

	Boolean existeActivoAsociado(String numActivo);
	
	/**
	 * Devuelve el codigo del destino comercial de un activo
	 * 
	 * @param numActivo
	 * @return
	 */
	public Boolean esActivoProductoTerminado(String numActivo);

	public Boolean noExisteEstado(String numActivo);
	

	/** 
	 * @param numGasto
	 * @return true si el emisor del gasto es HAYA
	 */
	public Boolean esGastoEmisorHaya(String numGasto);
	
	/** 
	 * @param numGasto
	 * @return true si el destinatario del gasto es HAYA
	 */
	public Boolean esGastoDestinatarioHaya(String numGasto);
	
	/** 
	 * Comprueba si dos gastos son de la misma cartera
	 * @param numGasto
	 * @param numOtroGasto
	 * @return true si ambos gastos son de la misma cartera
	 */
	public Boolean esGastoMismaCartera(String numGasto, String numOtroGasto);

	/** 
	 * @param codigoServicer
	 * @return true si existe el código de Servicer Activo 
	 */
	public Boolean perteneceDDServicerActivo(String codigoServicer);

	/** 
	 * @param codigoCesion
	 * @return true si existe el código de Cesión Comercial/Saneamiento
	 */
	public Boolean perteneceDDCesionComercial(String codigoCesion);

	/** 
	 * @param codigoValorOrdinario
	 * @return true si existe el código de Clasificación Apple
	 */
	public Boolean perteneceDDClasificacionApple(String codigoValorOrdinario);

	/** 
	 * @param numActivo
	 * @return true si el Activo pertenece a la subcartera Apple
	 */
	public Boolean esActivoApple(String numActivo);

	/***
	 * @param codTipoDoc
	 * @return true si existe el código del documento
	 */
	public Boolean existeTipoDoc(String codTipoDoc);

	/***
	 * @param codEstado
	 * @return true si existe el código de estado
	 */
	public Boolean existeEstadoDocumento(String codEstadoDoc);

	/***
	 * @param codCalificacionEnergetica
	 * @return true si existe el código de calificación energética
	 */
	public Boolean existeCalificacionEnergetica(String codCE);
	
	public Boolean existeActivoPlusvalia(String numActivo);

	public Boolean esActivoUA(String numActivo);

	public Boolean esAccionValido(String codAccion);

	public Boolean esResultadoValido(String codResultado);
	
	public Boolean esTipoTributoValido(String codTipoTributo);
	
	public Boolean esMotivoExento(String codResultado);

	public Boolean esSolicitudValido(String codSolicitud);

	public Boolean existeActivoTributo(String numActivo, String fechaRecurso, String tipoSolicitud, String idTributo);

	public String getIdActivoTributo(String numActivo, String fechaRecurso, String tipoSolicitud, String idTributo);

	public Boolean esNumHayaVinculado(Long numGasto, String numActivo);
	
	public Boolean esnNumExpedienteValido(Long expComercial);
	
	Boolean existeJunta(String numActivo,  String fechaJunta);
	
	public Boolean existeCodJGOJE(String codJunta);

	String getActivoJunta(String numActivo, String fechaJunta);
	
	/**
	 * @param numActivo
	 * @return true si el activo es una unidad alquilable	 
	 */
	Boolean esUnidadAlquilable(String numActivo);
	
	/** 
	 * @param numGasto
	 * @return true si el gasto es refacturado
	 */
	Boolean esGastoRefacturado(String numGasto);

	/** 
	 * @param numGasto
	 * @return true si el propietario del gasto es BANKIA o SAREB
	 */
	Boolean perteneceGastoBankiaSareb(String numGasto);

	/** 
	 * @param numGasto
	 * @return true si el gasto es refacturable
	 */

	Boolean esGastoRefacturable(String numGasto);

	Boolean existeGastoRefacturable(String numGasto);

	Boolean esGastoDestinatarioPropietario(String numGasto);	
	
	Boolean existeFasePublicacion(String fasePublicacion);
	
	Boolean existeSubfasePublicacion(String subfasePublicacion);

	/**
	 * @param numActivo
	 * @return devuelve true si el activo se encuentra incluido en una agrupacion tipo proyecto
	 */
	Boolean activoEnAgrupacionProyecto(String numActivo);

	/**
	 * @param codDocumento
	 * @return true si el código del documento es de tipo CEE
	 */
	public Boolean esDocumentoCEE(String codDocumento);

	/**
	 * @param numActivo
	 * @return Devuelve el número de Agrupacion Restringida a la que pertenece el Activo 
	 */
	public Long obtenerNumAgrupacionRestringidaPorNumActivo(String numActivo);

	/**
	 * @param numAgrupacion
	 * @return true si la Agrupación de tipo alquiler tiene precio
	 */
	public Boolean esAgrupacionAlquilerConPrecio(String numAgrupacion);
	
	/**
	 * @param numActivo
	 * @return Codigo del mediador Api del activo
	 */
	String getCodigoMediadorPrimarioByActivo(String numActivo);
	
	/**
	 * @param numActivo
	 * @return Codigo del mediador Espejo del activo
	 */
	String getCodigoMediadorEspejoByActivo(String numActivo);
	
	/**
	 * @param Codigo Proveedor Rem
	 * @return true si el Codigo Proveedor Rem corresponde a mediador o fuerza venta directa
	 */
	Boolean esTipoMediadorCorrecto(String codMediador);
	
	/** 
	 * @param numActivo
	 * @return true si el activo indicado no es de la cartera bankia
	 */
	public Boolean existeActivoNoBankia(String numActivo);
	
	/**
	 * 
	 * @param numActivo
	 * @return true si el activo tiene titulo
	 */
	public Boolean existeActivoTitulo(String numActivo);

	/**
	 * 
	 * @param situacionTitulo
	 * @return true si existe el estado del titulo
	 */
	public Boolean existeEstadoTitulo(String situacionTitulo);

	/**
	 * 
	 * @param numActivo
	 * @return true si el activo pertenece a la cartera Bankia
	 */
	public Boolean esActivoBankia(String numActivo);

	/**
	 * 
	 * @param codigo
	 * @return true si el codigo pertenece a una entidad hipotecaria
	 */
	public Boolean existeEntidadHipotecaria(String codigo);

	public Boolean existeTipoJuzgado(String celda);

	public Boolean existePoblacionJuzgado(String celda);

	/**
	 * 
	 * @param idActivo
	 * @param tipoAdjudicacion
	 * @return true si el idActivo es del tipo de adjudicación que le estamos pasando por parámetros
	 */
	Boolean verificaTipoDeAdjudicacion(String idActivo, String tipoAdjudicacion);

	Boolean esAccionValidaInscripciones(String codAccion);

	/**
	 * @param numExpediente, numActivo
	 * @return true si un activo esta relacionado con un expediente
	 */
	public Boolean activoConRelacionExpedienteComercial(String numExpediente, String numActivo);

	Boolean esExpedienteVenta(String numExpediente);
	
	/**
	 * @param pveCodRem
	 * @return true si el proveedor ha sido dado de baja
	 */
	public Boolean isProveedorUnsuscribed(String pveCodRem);
	
	/**
	 * @param pveCodRem 
	 * @return true si el al menos hay un proveedor con el código rem
	 */

	public Boolean existeProveedorByCodRem(String pveCodRem);

	/**
	 * @param codSubFasePublicacion
	 * @param codFasePublicacion
	 * @return true si la subfase pertenece a la fase de publicación
	 */
	public Boolean perteneceSubfaseAFasePublicacion(String codSubFasePublicacion, String codFasePublicacion);
	
	 /***
     * @param numTrabajo
     * @return true si existe al menos un trámite en el trabajo.
     */
	
	public Boolean existeTramiteTrabajo(String numTrabajo);
	
	/***
     * @param numTrabajo
     * @return true si existe al menos una tarea asociada al trabajo.
     */
	
	public Boolean existenTareasEnTrabajo(String numTrabajo);

	Boolean esExpedienteValidoFirmado(String numExpediente);

	Boolean esExpedienteValidoReservado(String numExpediente);

	Boolean esExpedienteValidoVendido(String numExpediente);

	Boolean esExpedienteValidoAnulado(String numExpediente);
	
	Boolean esExpedienteValidoAprobado(String numExpediente);
	
	Boolean coincideTipoJuzgadoPoblacionJuzgado(String codigoTipoJuzgado, String codigoPoblacionJuzgado);
		
	/**
	 * 
	 * @param direccionComercial
	 * @return true si la dirección comercial Existe
	 */
	public Boolean direccionComercialExiste(String direccionComercial);

	Boolean isActivoEnCesionDeUso(String numActivo);

	Boolean isActivoEnAlquilerSocial(String numActivo);
	
	/**
	 * 
	 * @param codPerfil
	 * @param codUsuario
	 * @return true si el usuario propuesto no pertenece al perfil
	 */
    public Boolean esPerfilErroneo(String codPerfil, String codUsuario);

    /*
     * @param proveedor (código del proveedor)
     * @param tipologias (Array con las tipologias a verificar)
     * @return false si el proveedor no está en el conjunto de tipologías recibidas
     */
    Boolean isProveedorInTipologias(String proveedor, String[] tipologias);
    
    /*
     * @param user (código usuario)
     * @param codGestor (Código del gestor)
     * @return true si el usuario pertenece al tipo de gestor propuesto en codGestor
     */
    Boolean isUserGestorType(String user, String codGestor);
 
    /*
     * @param codTrabajo (Número de trabajo)
     * @return true si es multiactivo(que el trabajo tiene asociado más de un activo).
     */
    Boolean esTrabajoMultiactivo(String codTrabajo);
	
	public Boolean esSegmentoValido(String codSegmento);
/**
 * 
 * @param codSegmento
 * @param numActivo
 * @return true si pertenece al diccionario SEGMENTO CARTERA SUBCARTERA
 */
	public Boolean perteneceSegmentoCraScr(String codSegmento, String numActivo);

	public Boolean esSubcarteraDivarian(String numActivo);
	
	public Boolean esSubcarteraApple(String numActivo);
	
	public Boolean aCambiadoDestinoComercial(String numActivo, String destinoComercial);

	public Boolean existeCodigoPeticion(String codPeticion);

	public Boolean esPeticionEditable(String codPeticion, String numActivo);

	public Boolean existeTipoPeticion(String codTpoPeticion);

	Boolean esTareaCompletadaTarificadaNoTarificada(String codTrabajo);

	public boolean existeContactoProveedorTipoUsuario(String usrContacto, String codProveedor);

	Boolean existeCodigoPeticionActivo(String codPeticion, String numActivo);

	Boolean existeSituacionTitulo(String codigoSituacionTitulo);
	
	Boolean esActivoSareb(String numActivo);

	Boolean perteneceADiccionarioConTitulo(String conTitulo);
	
	Boolean perteneceADiccionarioEquipoGestion(String codEquipoGestion);
	
	public Boolean esActivoIncluidoPerimetroAdmision(String numActivo);

	public Boolean estadoAdmisionValido(String codEstadoAdmision);

	public Boolean subestadoAdmisionValido(String codSubestadoAdmision);
	
	public Boolean estadoConSubestadosAdmisionValido(String codEstadoAdmision);

	public Boolean relacionEstadoSubestadoAdmisionValido(String codEstadoAdmision, String codSubestadoAdmision);


	Boolean existeTipoSuministroByCod(String codigo);

	Boolean existeSubtipoSuministroByCod(String codigo);

	Boolean existePeriodicidadByCod(String codigo);

	Boolean existeMotivoAltaSuministroByCod(String codigo);

	Boolean existeMotivoBajaSuministroByCod(String codigo);

	Boolean esMismoTipoGestorActivo(String codigo, String numActivo);

	Boolean esActivoBBVA(String numActivo);
	
	String getValidacionCampoCDC(String codCampo);
	
	Boolean existeCampo(String numCampo);

	Boolean perteneceADiccionarioSubtipoRegistro(String subtipo);

	Boolean existeIdentificadorSubregistro(String subtipo, String identificador);

	public boolean incluidoActivoIdOrigenBBVA (String numActivo);

	Boolean estaPerimetroHaya(String activoId);
	
	Boolean estaPerimetroAdmision(String activoId);
	
	Boolean existeActivoPorId(String activoId);
	
	Boolean comprobarCodigoTipoTitulo(String codTipoTitulo);
	
	public boolean existeTipoDeGastoAsociadoCMGA(String codTipoGasto);

	public Boolean esTipoAltaBBVAMenosAltaAutamatica(String codCampo);

	public Boolean esTipoRegimenProteccion(String codCampo);

	Boolean mismaCarteraLineaDetalleGasto(String numGasto, String tipoElemento);

	Boolean isActivoBankia(String numActivo);
	
	Boolean isActivoLiberbank(String numActivo);

	Boolean tipoDeElemento(String tipoElemento);

	Boolean gastoTieneLineaDetalle(String numGasto);

	Boolean subtipoGastoCorrespondeGasto(String numGasto, String subtipoGasto);

	Boolean lineaSubtipoDeGastoRepetida(String numGasto, String subtipoGasto, String tipoImpositivo, String tipoImpuesto);

	Boolean participaciones(String numGasto);

	Boolean existeSubtipoGasto(String codSubtipoGasto);

	Boolean perteneceGastoBankia(String numGasto);

	Boolean agrupacionSinActivos(String numAgrupacion);

	Boolean esGastoYAgrupacionMismoPropietarioByNumGasto(String numAgrupacion, String numGasto);

	Boolean esGastoYActivoMismoPropietarioByNumGasto(String numElemento, String numGastoHaya, String tipoElemento);

	Boolean existeEntidadGasto(String entidad);

	Boolean esGastoRefacturadoPadre(String numGasto);

	Boolean esGastoRefacturadoHijo(String numGasto);

	Boolean gastoEstadoIncompletoPendienteAutorizado(String numGasto);
	
	Boolean existeTipoGastoByCod(String codigo);

	Boolean existeDestinatarioByCod(String codigo);

	Boolean existeTipoOperacionGastoByCod(String codigo);

	Boolean existeTipoRecargoByCod(String codigo);

	Boolean existeTipoElementoByCod(String codigo);

	Boolean subtipoPerteneceATipoGasto(String tipoGasto, String subtipoGasto);

	Boolean esPropietarioDeCarteraByCodigo(String docIdentificadorPropietario, String cartera);

	Boolean esGastoYActivoMismoPropietario(String docIdentificadorPropietario, String numElemento, String tipoElemento);

	Boolean esGastoYAgrupacionMismoPropietario(String docIdentificadorPropietario, String numAgrupacion);

	Boolean existeEmisor(String emisorNIF);

	Boolean relacionPoblacionLocalidad(String columnaPoblacion, String columnaMunicipio);

	Boolean existeMunicipioByDescripcion(String columnaMunicipio);

	Boolean existePoblacionByDescripcion(String columnaPoblacion);

	boolean isProveedorSuministroVigente(String codRem);

	public Boolean esTipoDeTransmisionBBVA(String dameCelda);
	
	public Boolean esTipoDeTituloBBVA(String dameCelda);
	
	public Boolean existeActivoParaCMBBVA(String dameCelda);
	
	public Boolean activoesDeCarteraCerberusBbvaCMBBVA(String dameCelda);
	
	public Boolean esActivoVendidoParaCMBBVA(String numActivo);

	public Boolean esActivoIncluidoPerimetroParaCMBBVA(String numActivo);

	public Boolean esActivoRepetidoNumActivoBBVA(String numActivo);

	public Boolean codigoComercializacionIncorrecto(String codCampo);
	
	boolean existeMismoProveedorContactoInformado(String codProveedor, String numTrabajo);

	boolean isTipoTarifaValidoEnConfiguracion(String codigoTarifa, String numTrabajo);

	String getEstadoTrabajoByNumTrabajo(String numTrabajo);
	
	Boolean existeGastoConElIdLinea(String idGasto, String idLinea);

	Boolean esOfertaBBVA(String numOferta);

	Boolean esOfertaAnulada(String numOferta);

	Boolean esOfertaVendida(String numOferta);

	Boolean esOfertaErronea(String numOferta);

	Boolean existePais(String pais);

	Boolean existeMunicipioDeProvinciaByCodigo(String codProvincia, String codigoMunicipio);
	
	Boolean existeDiccionarioByTipoCampo(String codigoCampo, String valorCampo);
	
	String getCodigoTipoDato(String codigoCampo);

	Boolean gastoRepetido(String factura, String fechaEmision, String nifEmisor, String nifPropietario);

	Boolean propietarioPerteneceCartera(String docIdent, List<String> listaCodigoCarteras);

	String getDocIdentfPropietarioByNumGasto(String numGasto);

	boolean existeTipoRetencion(String tipoRetencion);
	
	boolean existeLineaEnGasto(String idLinea, String numGasto);
	
	public Boolean existePorcentajeConstruccion(String porcentajeConstruccion);

	Boolean existeActivoConONMarcadoSi(String columnaActivo);
	
	boolean conEstadoGasto(String idGasto,String codigoEstado);

	String devolverEstadoGasto(String idGasto);

	boolean tieneGastoFechaContabilizado(String idGasto);

	boolean tieneGastoFechaPagado(String idGasto);


	Boolean estadoPrevioTrabajo(String celdaTrabajo);

	Boolean fechaEjecucionCumplimentada(String celdaTrabajo);

	Boolean resolucionComite(String celdaTrabajo);

	Boolean existeCodigoMotivoAdmision(String codMotivo);

	Boolean tieneFechaVentaExterna(String activo);

	Boolean activoNoComercializable(String activo);

	Boolean maccConCargas(String activo);

	Boolean estadoExpedienteComercial(String activo);
	
	Boolean checkComite(String celdaTrabajo);

	Boolean tieneLlaves(String celdaTrabajo);

	Boolean checkLlaves(String celdaTrabajo);

	Boolean checkProveedoresLlaves(String celdaTrabajo);

	public String sacarCodigoSubtipoActivo(String descripcion);

	Boolean existeTrabajoByCodigo(String codTrabajo);
	
	Boolean existeSubtrabajoByCodigo(String codSubtrabajo);
	
	Boolean esSubtrabajoByCodTrabajoByCodSubtrabajo(String codTrabajo, String codSubtrabajo);
	
	Boolean existeProveedorAndProveedorContacto(String codProveedor, String proveedorContacto);
	
	Boolean esSubtipoTrabajoTomaPosesionPaquete(String subtrabajo);
	
	Boolean esTarifaEnCarteradelActivo(String codTarifa, String idActivo);
	
	Boolean existeProveedorEnCarteraActivo(String proveedor,String idActivo);
	
	Boolean existePromocionBBVA(String promocion);

	Boolean datosRegistralesRepetidos(String refCatastral, String finca, String folio, String libro, String tomo, String numRegistro, String codigoLocalidad);

	Boolean subtipoPerteneceTipoActivo(String subtipo, String tipo);
	
	String getNumActivoPrincipal(String numAgr);

	boolean getExcluirValidaciones(String numActivo);

	String getCheckGestorComercial(String numActivo);

	String getMotivoGestionComercial(String numActivo);

	Boolean existeAlbaran(String idAlbaran);
	
	Boolean existePrefactura(String idPrefactura);
	
	public String devolverEstadoGastoApartirDePrefactura(String idPrefactura);
	
	public String devolverEstadoGastoApartirDeAlbaran(String idAlbaran);

	List<String> getIdPrefacturasByNumAlbaran(String numAlbaran);
	
    Boolean getGastoSuplidoConFactura(String idGastoAfectado);

	Boolean estadoPrevioTrabajoFinalizado(String celdaTrabajo);
	
	Boolean isActivoEnPerimetroAlquilerSocial(String numActivo);

	Boolean situacionComercialAlquilado(String activo);
	Boolean estadoPublicacionCajamarPerteneceVPOYDistintoPublicado(String numActivo);

	Boolean isActivoGestionadoReam(String string);

	Boolean existeCodProveedorRem(String codProveedorREM);

	boolean gastoSarebAnyadeRefacturable(String numGasto);

	Boolean situacionComercialPublicadoAlquiler(String activo);

	Boolean activoPrincipalEnAgrupacionRestringida(String numActivo);
	
	Boolean activoPerteneceAgrupacion(String numActivo);
	
	Boolean activoBBVAPerteneceSociedadParticipada (String numActivo);

	Boolean situacionComercialPublicadoAlquilerOVenta(String activo);

	boolean userHasFunction(String funcion, Long idUsuario);

	Boolean isActivoSareb(String numActivo);

	Boolean isActivoCajamar(String numActivo);

	//Boolean validacionSubfasePublicacion(String activo);

	Boolean isCheckVisibleGestionComercial(String numActivo);

	boolean isConCargasOrCargasEsparta(String activo);

	boolean aplicaComercializar(String activo);

	Boolean isActivoAlquiladoSCM(String activo);

	boolean isActivoPublicadoDependiendoSuTipoComercializacion(String activo);
	
	Boolean esSubCarterasCerberusAppleDivarian(String numActivo);

	boolean isActivoDestinoComercialSoloAlquiler(String activo);

	Boolean isActivoCerberus(String numActivo);

	Boolean esOfertaCaixa(String numOferta);

	Boolean esActivoEnTramite(String numActivo);

	Boolean tieneVigenteFasePublicacionIII(String activo);

	Boolean validacionSubfasePublicacion(String activo, List<String> codigos);

	boolean esClienteEnOfertaCaixa(String numCliente);

	boolean esProveedorOfertaCaixa(String idProveedor);
	
	Boolean existeProvision(String idProvision);

	List<String> getGastosByNumProvision(String idEntidad);
	
	Boolean existeRecomendacionByCod(String recomendacion);

}
