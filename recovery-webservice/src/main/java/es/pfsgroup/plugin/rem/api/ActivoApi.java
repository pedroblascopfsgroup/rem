package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoCargas;
import es.pfsgroup.plugin.rem.model.DtoActivoCargasTab;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoComercialActivo;
import es.pfsgroup.plugin.rem.model.DtoComunidadpropietariosActivo;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.DtoHistoricoDestinoComercial;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoImpuestosActivo;
import es.pfsgroup.plugin.rem.model.DtoLlaves;
import es.pfsgroup.plugin.rem.model.DtoMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPropietario;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoReglasPublicacionAutomatica;
import es.pfsgroup.plugin.rem.model.DtoTasacion;
import es.pfsgroup.plugin.rem.model.HistoricoDestinoComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.VTasacionCalculoLBK;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.dto.File;
import es.pfsgroup.plugin.rem.rest.dto.PortalesDto;


public interface ActivoApi {

	/**
	 * Recupera el Activo indicado.
	 *
	 * @param id Long
	 * @return Activo
	 */
	@BusinessOperationDefinition("activoManager.get")
	Activo get(Long id);

	Activo getByNumActivo(Long id);

	Activo getByNumActivoUvem(Long id);

	@BusinessOperationDefinition("activoManager.saveOrUpdate")
	boolean saveOrUpdate(Activo activo);

	/**
	 * Guarda o acutaliza una lista de
	 *
	 * @param listaPortalesDto
	 * @return
	 */
	ArrayList<Map<String, Object>> saveOrUpdate(List<PortalesDto> listaPortalesDto);

	@BusinessOperationDefinition("activoManager.upload")
	String upload(WebFileItem fileItem) throws Exception;

	/**
	 * Recupera un adjunto
	 *
	 * @return
	 */
	@BusinessOperationDefinition("activoManager.download")
	FileItem download(Long id) throws Exception;

	@BusinessOperationDefinition("activoManager.uploadFoto")
	String uploadFoto(WebFileItem fileItem);

	/**
	 * Registra una foto del gestor documental
	 *
	 * @param fileItem
	 * @return
	 */
	String uploadFoto(File fileItem) throws Exception;

	/**
	 * Recupera la lista completa de Activos
	 *
	 * @return List<Activo>
	 */
	@BusinessOperationDefinition("activoManager.getListActivos")
	Page getListActivos(DtoActivoFilter dto, Usuario usuarioLogado);

	@BusinessOperationDefinition("activoManager.isIntegradoAgrupacionRestringida")
	boolean isIntegradoAgrupacionRestringida(Long id, Usuario usuarioLogado);

	/**
	 * Este método comprueba si el ID de activo pertenece a una agrupación de tipo restringida.
	 *
	 * @param idActivo: ID del activo a comprobar.
	 * @return Devuelve True si el activo pertenece a una agruapción restringida, false si no.
	 */
	boolean isActivoIntegradoAgrupacionRestringida(Long idActivo);

	/**
	 * Este método comprueba si el ID de activo pertenece a una agrupación de tipo comercial.
	 *
	 * @param idActivo: ID del activo a comprobar.
	 * @return Devuelve True si el activo pertenece a una agruapción comercial, false si no.
	 */
	boolean isActivoIntegradoAgrupacionComercial(Long idActivo);

	@BusinessOperationDefinition("activoManager.isIntegradoAgrupacionObraNueva")
	boolean isIntegradoAgrupacionObraNueva(Long id, Usuario usuarioLogado);


	public boolean isIntegradoAgrupacionComercial(Activo activo);

	public boolean necesitaDocumentoInformeOcupacion(Activo activo);

	/**
	 * Elimina un adjunto
	 *
	 * @return
	 */
	@BusinessOperationDefinition("activoManager.deleteAdjunto")
	boolean deleteAdjunto(DtoAdjunto dtoAdjunto);

	@BusinessOperationDefinition("activoManager.savePrecioVigente")
	boolean savePrecioVigente(DtoPrecioVigente precioVigenteDto);

	@BusinessOperationDefinition("activoManager.saveOfertaActivo")
	boolean saveOfertaActivo(DtoOfertaActivo precioVigenteDto) throws JsonViewerException, Exception;

	/**
	 * saveActivoValoracion: Para un activo dado, actualiza o crea una valoracion por tipo de precio. Este mismo proceso tambien se encarga de mantener el historico de valoraciones, si hay cambios en
	 * las valoraciones. Devuelve TRUE si el proceso se ha realizado correctamente
	 *
	 * @param activo Activo (necesario)
	 * @param activoValoracion Si se indica esta, actualiza la valoracion existente. Si no se indica (null), crea una nueva valoracion.
	 * @param dto (necesario) los datos a modificar/crear
	 * @return boolean
	 */
	@BusinessOperation(overrides = "activoManager.saveActivoValoracion")
	boolean saveActivoValoracion(Activo activo, ActivoValoraciones activoValoracion, DtoPrecioVigente dto);

	@BusinessOperationDefinition("activoManager.getComboInferiorMunicipio")
	List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio);

	@BusinessOperationDefinition("activoManager.getMaxOrdenFotoById")
	Integer getMaxOrdenFotoById(Long id);

	@BusinessOperationDefinition("activoManager.getMaxOrdenFotoByIdSubdivision")
	Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv);

	/**
	 * Obtiene el presupuesto de un activo para el ejercicio actual (no el ultimo ejercicio de tabla ejercicios, sino el del año actual)
	 *
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("activoManager.getUltimoPresupuesto")
	Long getPresupuestoActual(Long id);

	/**
	 * Obtiene el presupuesto de un activo para el ultimo ejercicio registrado (el ultimo ejercicio registrado en la tabla ejercicios)
	 *
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("activoManager.getUltimoHistoricoPresupuesto")
	Long getUltimoHistoricoPresupuesto(Long id);

	/**
	 * True si el activo tiene asignado un presupuesto para el ejercicio actual, "aunque sea 0 euros"
	 *
	 * @param idActivo: ID del activo.
	 * @return
	 */
	@BusinessOperationDefinition("activoManager.checkHayPresupuestoEjercicioActual")
	boolean checkHayPresupuestoEjercicioActual(Long idActivo);

	@BusinessOperationDefinition("activoManager.getListHistoricoPresupuestos")
	Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuarioLogado);

	@BusinessOperationDefinition("activoManager.comprobarPestanaCheckingInformacion")
	Boolean comprobarPestanaCheckingInformacion(Long idActivo);

	/**
	 * Devuelve TRUE si encuentra un documento en el activo, buscando por codigo documento
	 * <p>
	 * Esta versión del método de comprobación, es una versión mejorada respecto a la que se viene utilizando en Recovery. Realiza todo el trabajo de búsqueda mediante filtrados con la BBDD. Evita
	 * procesar listas completas de adjuntos.
	 *
	 * @param idActivo identificador del Activo
	 * @param codigoDocumento codigo del documento de DDTipoDocumentoActivo
	 * @return boolean
	 */
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivo")
	Boolean comprobarExisteAdjuntoActivo(Long idActivo, String codigoDocumento);

	/**
	 * Depende del método anterior, pero primero se va a buscar los datos que le hacen falta a partir del trabajo de la tarea.
	 *
	 * @param tarea
	 * @return boolean
	 * @throws Exception
	 */
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivoTarea")
	Boolean comprobarExisteAdjuntoActivoTarea(TareaExterna tarea);

	/**
	 * Devuelve TRUE si el activo tiene fecha de posesión
	 *
	 * @param idActivo identificador del Activo
	 * @return boolean
	 */
	@BusinessOperationDefinition("activoManager.comprobarExisteFechaPosesionActivo")
	Boolean comprobarExisteFechaPosesionActivo(Long idActivo) throws Exception;

	/**
	 * Sirve para que después de guardar un fichero en el servicio de RestClient guarde el identificador obtenido en base de datos
	 *
	 * @param webFileItem
	 * @param idDocRestClient
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition("activoManager.upload2")
	String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception;

	/**
	 * Sirva para saber si el activo está vendido
	 */
	Boolean isVendido(Long idActivo);

	/**
	 * Devuelve mensaje de validación indicando los campos obligatorios que no han sido informados
	 *
	 * @param idActivo identificador del Activo
	 * @return String
	 */
	@BusinessOperationDefinition("activoManager.comprobarObligatoriosCheckingInfoActivo")
	String comprobarObligatoriosCheckingInfoActivo(Long idActivo) throws Exception;

	/**
	 * Recupera una página del historico de valores precios de un activo
	 *
	 * @param dto
	 * @return
	 */
	DtoPage getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto);

	/**
	 * Borrado fisico de una valoración y paso al historico
	 *
	 * @return
	 */
	boolean deleteValoracionPrecio(Long id);

	/**
	 * Borrado físico de una valoración, indicando si se ha de guardar en el histórico o no
	 *
	 * @param id
	 * @param guardadoEnHistorico
	 * @return
	 */
	boolean deleteValoracionPrecioConGuardadoEnHistorico(Long id, Boolean guardadoEnHistorico);

	/**
	 * Este método obtiene un objeto con los condicionantes del activo.
	 *
	 * @param idActivo: ID del activo a filtrar los datos.
	 * @return Devuelve un objeto con los datos obtenidos.
	 */
	VCondicionantesDisponibilidad getCondicionantesDisponibilidad(Long idActivo);

	/**
	 * Este método obtiene una lista de condiciones específicas por el ID del activo.
	 *
	 * @param idActivo : ID del activo para filtrar condiciones.
	 * @return Devuelve una lista de condiciones específicas.
	 */
	List<DtoCondicionEspecifica> getCondicionEspecificaByActivo(Long idActivo);

	/**
	 * Este método crea una condición específica nueva y establece la anterior como dada de baja.
	 *
	 * @param dtoCondicionEspecifica : dto con el idActivo para generar una nueva condición específica.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	Boolean createCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica);

	/**
	 * Este método guarda los cambios en la condición específica por el ID de la condición específica.
	 *
	 * @param dtoCondicionEspecifica : dto con los cambios a almacenar en la DDBB.
	 * @return Devuelve su la operación ha sido satisfactoria, o no.
	 */
	Boolean saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica);

	/**
	 * Recupera una página de propuestas según el filtro recibido
	 *
	 * @param dtoPropuestaFiltro
	 * @return
	 */
	Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);

	/**
	 * Este método obtiene una página de resultados de la búsqueda de Activos Publicación.
	 *
	 * @param dtoActivosPublicacion
	 * @return Devuelve los resultados paginados del grid de la búsqueda de activos publicación.
	 */
	Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion);

	/**
	 * Inserta o actualiza una visita aun activo
	 *
	 * @param visita
	 * @return
	 */
	Visita insertOrUpdateVisitaActivo(Visita visita) throws IllegalAccessException, InvocationTargetException;

	/**
	 * Este método obtiene los estados, el historial, de acciones del informe comercial.
	 *
	 * @param idActivo: ID del activo a filtrar los datos.
	 * @return Devuleve un dto con los datos obtenidos.
	 */
	List<DtoEstadosInformeComercialHistorico> getEstadoInformeComercialByActivo(Long idActivo);

	/**
	 * Validacion TRUE o FALSE que indica si el ultimo estado del INF. Comercial es ACEPTADO
	 *
	 * @param activo
	 * @return
	 */
	boolean isInformeComercialAceptado(Activo activo);

	/**
	 * Este método obtiene los estados, el historial, del mediador de la pestaña informe comercial.
	 *
	 * @param idActivo: ID del activo a filtrar los datos.
	 * @return Devuleve un dto con los datos obtenidos.
	 */
	List<DtoHistoricoMediador> getHistoricoMediadorByActivo(Long idActivo);

	/**
	 * Este método recibe un objeto con los condicionantes del activo y lo almacena en la DDBB.
	 *
	 * @param idActivo: ID del activo a filtrar los datos.
	 * @param dto: dto con los datos a insertar en la DDBB.
	 * @return Devuelve si se ha completado la operación con exito o no.
	 */
	Boolean saveCondicionantesDisponibilidad(Long idActivo, DtoCondicionantesDisponibilidad dto);

	/**
	 * Este método recibe un ID de activo y obtiene los activos vinculados al mismo.
	 *
	 * @param dto: dto con los datos a filtrar la busqueda para el page.
	 * @return Devuelve una lista con los datos obtenidos.
	 */
	List<DtoPropuestaActivosVinculados> getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

	/**
	 * Este método recibe un número de activo y el ID del activo de origen y crea un nuevo registro vinculando ambos.
	 *
	 * @param dto: dto con los datos a insertar en la DDBB.
	 * @return Devuelve si se ha completado la operación con exito o no.
	 */
	boolean createPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

	/**
	 * Este método borra de manera lógica la vinculación entre activos por el ID de la asociación.
	 *
	 * @param dto: dto con los datos a borrar en la DDBB.
	 * @return Devuelve si se ha completado la operación con exito o no.
	 */
	boolean deletePropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

	/**
	 * HREOS-846. Comprueba si el activo esta dentro del perímetro de Haya
	 *
	 * @param idActivo Activo a comprobar
	 * @return true si esta dentro del perimetro Haya, false si esta fuera.
	 */
	boolean isActivoIncluidoEnPerimetro(Long idActivo);

	/**
	 * Devuelve el perimetro del ID de un activo dado
	 *
	 * @param idActivo
	 * @return PerimetroActivo
	 */
	PerimetroActivo getPerimetroByIdActivo(Long idActivo);

	/**
	 * Devuelve el perimetro del numActivo de un activo
	 *
	 * @param numActivo
	 * @return PerimetroActivo
	 */
	PerimetroActivo getPerimetroByNumActivo(Long numActivo);

	/**
	 * Devuelve el perimetro de datos bancarios del ID de un activo dado
	 *
	 * @param idActivo
	 * @return ActivoBancario
	 */
	ActivoBancario getActivoBancarioByIdActivo(Long idActivo);

	/**
	 * Devuelve la calificacion negativa del ID de un activo dado
	 *
	 * @param idActivo
	 * @return ActivoCalificacionNegativa
	 */
	List<ActivoCalificacionNegativa> getActivoCalificacionNegativaByIdActivo(Long idActivo);

	PerimetroActivo saveOrUpdatePerimetroActivo(PerimetroActivo perimetroActivo);

	/**
	 * Actualiza el activo cuando se incluye en una agrupación asistida.
	 *
	 * @param activo
	 * @return Activo
	 */
	Activo updateActivoAsistida(Activo activo);

	/**
	 * Actualiza los valores del perímetro del activo con los valores para un activo asistido.
	 *
	 * @param perimetroActivo
	 * @return PerimetroActivo
	 */
	PerimetroActivo updatePerimetroAsistida(PerimetroActivo perimetroActivo);

	ActivoBancario saveOrUpdateActivoBancario(ActivoBancario activoBancario);

	/**
	 * HREOS-843. Comrpueba si el activo tiene alguna oferta con el estado pasado por parámetro
	 *
	 * @param activo
	 * @param codEstado
	 * @return
	 */
	boolean isActivoConOfertaByEstado(Activo activo, String codEstado);

	/**
	 * HREOS-843. Comprueba si el activo tiene alguna reserva con el estado pasado por parámetro
	 *
	 * @param activo
	 * @param codEstado
	 * @return
	 */
	boolean isActivoConReservaByEstado(Activo activo, String codEstado);

	/**
	 * Devuelve una lista de reservas asociadas al activo pasado por parametro
	 *
	 * @param activo
	 * @return
	 */
	List<Reserva> getReservasByActivoOfertaAceptada(Activo activo);

	/**
	 * HREOS-843. Comrpueba si el activo esta vendido, viendo si tiene fecha de escritura (en Formalizacion)
	 *
	 * @param activo
	 * @return
	 */
	boolean isActivoVendido(Activo activo);

	/**
	 * Comrpueba si el activo esta vendido, viendo si tiene fecha de escritura (en Formalizacion)
	 *
	 * @param activo
	 * @return
	 */
	boolean isActivoAlquilado(Activo activo);

	/**
	 * Comprueba si el activo esta incluido en alguna agrupacion VIGENTE de tipo Asistida (PDV)
	 *
	 * @param activo
	 * @return
	 */
	boolean isIntegradoAgrupacionAsistida(Activo activo);

	/**
	 * Este método da de baja un condicionante por su ID.
	 *
	 * @param dtoCondicionEspecifica : dto con el ID del condicionante para dar de baja.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	Boolean darDeBajaCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica);

	/**
	 * Este método alamcena en la DDBB un nuevo proveedor de tipo mediador en el historico de medidador del informe comercial.
	 *
	 * @param dto : dto con los datos del mediador a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	Boolean createHistoricoMediador(DtoHistoricoMediador dto);

	/**
	 * Comprueba si el activo es asistido
	 *
	 * @param activo
	 * @return
	 */
	boolean isActivoAsistido(Activo activo);

	/**
	 * Obtiene el numero de activos PUBLICADOS de la agrupacion. PUBLICADOS - DD_EPU (Publicado, forzado, oculto, precio oculto y forzado con precio oculto)
	 *
	 * @param activos
	 * @return
	 */
	Integer getNumActivosPublicadosByAgrupacion(List<ActivoAgrupacionActivo> activos);

	/**
	 * Este método recibe un ID de activo y pide por web service el id de tasación.
	 *
	 * @param idActivo : ID del activo.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 * @throws Exception Devuelve una excepción si no se ha podido obtener el ID de la tasación.
	 */
	Boolean solicitarTasacion(Long idActivo) throws Exception;

	/**
	 * Este método obtiene la solicitud de tasacion a Bankia por el ID del activo.
	 *
	 * @param id : ID del activo a filtrar.
	 * @return Devuelve un dto con los datos de la solicitud de tasación, si la hay.
	 */
	DtoTasacion getSolicitudTasacionBankia(Long id);

	/**
	 * Comprueba si el activo tiene activada el check de comercializar
	 *
	 * @param idActivo
	 * @return
	 */
	Boolean comprobarActivoComercializable(Long idActivo);

	/**
	 * Comprueba si el activo tiene activada el check de formalizar
	 *
	 * @param numActivo
	 * @return
	 */
	boolean esActivoFormalizable(Long numActivo);

	/**
	 * Devuelve mensaje de validación indicando los campos obligatorios que no han sido informados en la pestaña "Informe comericla"
	 *
	 * @param idActivo
	 * @return
	 * @throws Exception
	 */
	String comprobarObligatoriosDesignarMediador(Long idActivo) throws Exception;

	/**
	 * Sirve para que después de guardar un fichero en el servicio de RestClient guarde el identificador obtenido en base de datos
	 *
	 * @param webFileItem
	 * @param idDocRestClient
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition("activoManager.uploadDocumento")
	String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activo, String matricula) throws Exception;

	/**
	 * Este método hace una llamada para actualizar el estado de los condicionantes del activo.
	 *
	 * @param idActivo : ID del activo.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	Boolean updateCondicionantesDisponibilidad(Long idActivo);

	/**
	 * Este método comprueba si el activo tiene los check de admisión y gestión
	 *
	 * @param tareaExterna
	 * @return devuelve true si tiene los check activos, false en caso contrario
	 */
	Boolean checkAdmisionAndGestion(TareaExterna tareaExterna);

	/**
	 * Este método obtiene una lista de reglas de publicación automática.
	 *
	 * @return Devuelve una lista de DTOReglasPublicacionAutomatica con los datos obtenidos.
	 */
	List<DtoReglasPublicacionAutomatica> getReglasPublicacionAutomatica(DtoReglasPublicacionAutomatica dto);

	/**
	 * Este método crea una regla de publicación automática en la DB.
	 *
	 * @param dto : DTO con los parámetros a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	boolean createReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto);

	/**
	 * Este método borra de manera lógica una regla de publicación automática en la DB por el ID de la regla.
	 *
	 * @param dto : DTO con el ID de la regla a borrar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	boolean deleteReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto);

	/**
	 * Devuelve la lista de proveedores para un activo
	 *
	 * @param idActivo
	 * @return
	 */
	List<VBusquedaProveedoresActivo> getProveedorByActivo(Long idActivo);

	/**
	 * Devuelve la lista de los gastos proveedores para un activo y un proveedor
	 *
	 * @param idActivo: ID del activo.
	 * @param idProveedor: ID del proveedor.
	 * @param dto: dto con los datos de paginación.
	 * @return
	 */
	Page getGastoByActivo(Long idActivo, Long idProveedor, WebDto dto);

	/**
	 * Averigua si el activo tiene ofertas acpetadas // MODIFICACIÓN: Mira si el expediente está aprobado (y estados posteriores).
	 *
	 * @param activo
	 * @return
	 */
	Oferta tieneOfertaAceptada(Activo activo);

	/**
	 * Comprueba que los tipos de activo del activo y del informe comercial sean distintos.
	 *
	 * @param tareaExterna
	 * @return true si son distintos, false si son iguales
	 */
	Boolean checkTiposDistintos(TareaExterna tareaExterna);

	/**
	 * Comprueba que los datos de activo del activo y del informe comercial sean distintos.
	 *
	 * @param activo
	 * @return true si son distintos, false si son iguales
	 */
	Boolean checkTiposDistintos(Activo activo);

	/**
	 * @param dtoActivoIntegrado
	 * @return
	 */
	List<DtoActivoIntegrado> getProveedoresByActivoIntegrado(DtoActivoIntegrado dtoActivoIntegrado);

	/**
	 * @param idActivo
	 * @return
	 */
	DtoComunidadpropietariosActivo getComunidadPropietariosActivo(Long idActivo);

	/**
	 * Este método crea una integración de un activo en una entidad.
	 *
	 * @param dto : DTO con los parámetros a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	boolean createActivoIntegrado(DtoActivoIntegrado dto);

	/**
	 * Este método devuelve la información de la relación Activo-Integración
	 *
	 * @param id : id
	 * @return Devuelve Dto con la información.
	 */
	DtoActivoIntegrado getActivoIntegrado(String id);

	/**
	 * Este método crea una integración de un activo en una entidad.
	 *
	 * @param dto : DTO con los parámetros a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	boolean updateActivoIntegrado(DtoActivoIntegrado dto);

	/**
	 * Cantidad de ofertas con estadoOferta 01 ó 04 para un determinado activo
	 *
	 * @param activo
	 * @return
	 */
	int cantidadOfertas(Activo activo);

	/**
	 * Mayor oferta con estadoOferta 01 ó 04 para un determinado activo
	 *
	 * @param activo
	 * @return
	 */
	Double mayorOfertaRecibida(Activo activo);

	/**
	 * Método que comprueba que si el activo es VPO
	 *
	 * @param tareaExterna
	 * @return devuelve true si es VPO, false en caso contrario
	 */
	boolean checkVPO(TareaExterna tareaExterna);

	/**
	 * Método que devuelve una lista de ocupaciones ilegales de un activo
	 *
	 * @param dto
	 * @return
	 */
	public DtoPage getListHistoricoOcupacionesIlegales(WebDto dto, Long idActivo);

	/**
	 * Método que devuelve la lista de llaves asociadas a un activo
	 *
	 * @param dto
	 * @return
	 */
	DtoPage getListLlavesByActivo(DtoLlaves dto);

	/**
	 * Método que devuelve una lista de movimientos de una llave
	 *
	 * @param dto
	 * @return
	 */
	DtoPage getListMovimientosLlaveByLlave(WebDto dto, Long idLlave, Long idActivo);

	/**
	 * Guarda la propuesta
	 *
	 * @param idPropuesta
	 */
	void actualizarFechaYEstadoCargaPropuesta(Long idPropuesta);

	/**
	 * Devuelve la valoracion Aprobado venta del activo
	 *
	 * @param activo
	 * @return
	 */
	ActivoValoraciones getValoracionAprobadoVenta(Activo activo);

	/**
	 * Devuelve la última tasación del activo
	 *
	 * @param activo
	 * @return
	 */

	ActivoTasacion getTasacionMasReciente(Activo activo);

	/**
	 * Comprueba si el activo tiene el check de precio a true
	 *
	 * @param activo
	 * @return
	 */
	Boolean getDptoPrecio(Activo activo);

	/**
	 * ESte método obtiene información de la tab comercial del activo.
	 *
	 * @param dto : dto con el ID de activo a filtrar.
	 * @return Devuevle un dto DtoComercialActivo con información sobre la tab comercial del activo.
	 */
	DtoComercialActivo getComercialActivo(DtoComercialActivo dto);

	/**
	 * Este método almacena los cambios obrtenidos del dto.
	 *
	 * @param dto : contiene los cambios a almacenar.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	boolean saveComercialActivo(DtoComercialActivo dto);

	/**
	 * Comprueba si el activo esta incluido en alguna agrupacion VIGENTE de tipo Obra Nueva ó Asistida (PDV)
	 *
	 * @param activo
	 * @return
	 */
	boolean isIntegradoAgrupacionObraNuevaOrAsistida(Activo activo);

	/**
	 * Devuelve el importe de la valoracion filtrado por el tipo de precio, y si esta vigente.
	 *
	 * @param activo
	 * @param codTipoPrecio
	 * @return
	 */
	Double getImporteValoracionActivoByCodigo(Activo activo, String codTipoPrecio);

	/**
	 * Devuelve el codigo del subtipo de trabajo segun el tipo de Oferta
	 *
	 * @param oferta
	 * @return
	 */
	String getSubtipoTrabajoByOferta(Oferta oferta);

	Boolean deleteCarga(DtoActivoCargas dto);

	Boolean saveActivoCarga(DtoActivoCargas cargaDto);

	/**
	 * Actualiza el rating del activo pasado por parametro, con el procedure CALCULO_RATING_ACTIVO_AUTO
	 *
	 * @param idActivo
	 */
	void calcularRatingActivo(Long idActivo);

	/**
	 * Actualiza el tipo comercializar (Singular/Retail) del activo
	 *
	 * @param idActivo
	 */
	void calcularSingularRetailActivo(Long idActivo);

	String getCodigoTipoComercializarByActivo(Long idActivo);

	/**
	 * Comprueba que el activo en el perímetro es comercializable
	 *
	 * @param idActivo
	 * @return
	 */
	boolean checkComercializable(Long idActivo);

	/**
	 * Comprueba que el activo no está vendido
	 *
	 * @param idActivo
	 * @return
	 */
	boolean checkVendido(Long idActivo);

	/**
	 * Comprueba si el activo tiene alguna oferta viva (Estado != Rechazada)
	 *
	 * @param activo
	 * @return
	 */
	boolean isActivoConOfertasVivas(Activo activo);

	/**
	 * Este método llama al api del ActivoDao el cual obtiene el siguiente número de la secuencia para el campo de 'ACT_NUM_ACTIVO_REM'.
	 *
	 * @return Devuelve un Long con el siguiente número de la secuencia.
	 */
	Long getNextNumActivoRem();

	/**
	 * Este método recoje una lista de Ids de activo y obtiene en base a estos una lista de activos.
	 *
	 * @param activosID : Lista de ID de los activos a obtener.
	 * @return Devuelve una lista de Activos.
	 */
	List<Activo> getListActivosPorID(List<Long> activosID);

	/**
	 * Este método devuelve True si el ID del activo pertenece a una agrupación de tipo restringida y es el activo principal de la misma. False si no es el activo principal de la agrupación.
	 *
	 * @param id: ID del activo a comprobar si es el activo principal de la agrupación restringida.
	 * @return Devuelve True si es el activo principal, False si no lo es.
	 */
	boolean isActivoPrincipalAgrupacionRestringida(Long id);

	/**
	 * Este método obtiene un objeto ActivoAgrupacionActivo de una agrupación de tipo restringida por el ID de activo.
	 *
	 * @param id: Id del activo que pertenece a la agrupación.
	 * @return Devuelve un objeto de tipo ActivoAgrupacionActivo.
	 */
	ActivoAgrupacionActivo getActivoAgrupacionActivoAgrRestringidaPorActivoID(Long id);

	/**
	 * (Activo en Promocion Obra Nueva o Asistida // Activo de 1ª o 2ª Residencia )-> Retail Cajamar: VNC <= 500000 -> Retail), en caso contrario -> Singular Sareb/Bankia: AprobadoVenta (si no hay,
	 * valorTasacion) <= 500000 -> Retail), en caso contrario -> Singular
	 *
	 * @param activo
	 * @return
	 */
	String getCodigoTipoComercializacionFromActivo(Activo activo);

	/**
	 * Devuelve el primer Usuario asociado al mediador del activo. En caso de no existir devuelve null.
	 *
	 * @param activo
	 * @return Usuario
	 */
	Usuario getUsuarioMediador(Activo activo);

	/**
	 * Devuelve el ActivoProveedor del activo. En caso de no existir devuelve null.
	 *
	 * @param activo
	 * @return ActivoProveedor
	 */
	ActivoProveedor getMediador(Activo activo);

	Boolean saveActivoCargaTab(DtoActivoCargasTab cargaDto);

	Boolean updateActivoPropietarioTab(DtoPropietario propietario);

	Boolean createActivoPropietarioTab(DtoPropietario propietario);

	Boolean deleteActivoPropietarioTab(DtoPropietario propietario);

	/**
	 * Devuelve la lista de precios vigentes para un activo dado.
	 *
	 * @param id (identificador Activo)
	 * @return List<VPreciosVigentes>
	 */
	List<VPreciosVigentes> getPreciosVigentesById(Long id);

	void deleteActivoDistribucion(Long idActivoInfoComercial);

	void calcularFechaTomaPosesion(Activo activo);

	/**
	 * Reactiva los activos de una agrupacion
	 *
	 * @param idAgrupacion
	 */
	void reactivarActivosPorAgrupacion(Long idAgrupacion);

	/**
	 * Crea un expediente comercial
	 **/
	boolean crearExpediente(Oferta oferta, Trabajo trabajo) throws Exception;
	
	/**
	 * Devuelve una lista de adecuaciones alquiler para el grid de adecuaciones en la pestaña patrimonio de un activo
	 *
	 * @param idActivo
	 * @return
	 */
	List<DtoActivoPatrimonio> getHistoricoAdecuacionesAlquilerByActivo(Long idActivo);

	List<DtoImpuestosActivo> getImpuestosByActivo(Long idActivo);

	boolean createImpuestos(DtoImpuestosActivo dtoImpuestosfilter) throws ParseException;

	boolean deleteImpuestos(DtoImpuestosActivo dtoImpuestosFilter);

	boolean esLiberBank(Long idActivo);

	boolean esCajamar(Long idActivo);

	DtoActivoFichaCabecera getActivosPropagables(Long idActivo);

	List<VTasacionCalculoLBK> getVistaTasacion(Long idAgrupacion);

	/**
	 *
	 * Transforma una lista de HistoricoDestinoComercial en su correspondiente dto
	 *
	 * @param hdc
	 * @return List<DtoHistoricoDestinoComercial>
	 */
	List<DtoHistoricoDestinoComercial> getListDtoHistoricoDestinoComercialByBeanList(List<HistoricoDestinoComercial> hdc);

	DtoHistoricoDestinoComercial getDtoHistoricoDestinoComercialByBean(HistoricoDestinoComercial hdc);

	List<DtoHistoricoDestinoComercial> getDtoHistoricoDestinoComercialByActivo(Long id);

	void updateHistoricoDestinoComercial(Activo activo, Object[] extraArgs);

	boolean isActivoEnPuja(Activo activo);

	boolean updateImpuestos(DtoImpuestosActivo dtoImpuestosFilter) throws ParseException;

	DtoActivoFichaCabecera getActivosAgrupacionRestringida(Long idActivo);

	Long getIdByNumActivo(Long numActivo);

	Integer getGeolocalizacion(Activo activo);

	/**
	 * Devuelve true or false en funcion de si tiene un adjunto el activo y cumple ciertas caracteristicas
	 *
	 * @param idActivo
	 * @return
	 */
	boolean compruebaParaEnviarEmailAvisoOcupacion(DtoActivoSituacionPosesoria activoDto, Long id) ;

	/**
	 * Devuelve true or false en funcion de lo que devuelve el GD y existe el adjunto con la matricula que le pasamos por parametro
	 *
	 * @param idActivo, matriculaActivo
	 * @return
	 */
	boolean compruebaSiExisteActivoBienPorMatricula(Long idActivo, String matriculaActivo);

	/**
	 * Recoge el activo relacionado con el proveedor a partir del id del proveedor.
	 * @param idProveedor
	 * @return
	 */
	public Activo getActivoByIdProveedor(Long idProveedor);

	/**
	 * Recoge el activo relacionado con el proveedor a partir del id del gasto del proveedor.
	 * @param idGastoProveedor
	 * @return
	 */
	public Activo getActivoByIdGastoProveedor(Long idGastoProveedor);
	
	/**
	 * Devuelve el activoPatrimonio a partir de la id de un activo.
	 *
	 * @param idActivo
	 * @return ActivoPatrimonio.
	 */
	ActivoPatrimonio getActivoPatrimonio(Long idActivo);

	/**
	 * Devuelve los motivos de anulacion de un expediente de alquiler.
	 *
	 *
	 * @return DtoMotivoAnulacionExpediente.
	 */
	List<DtoMotivoAnulacionExpediente> getMotivoAnulacionExpediente();
	
}
