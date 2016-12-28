package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.sql.SQLException;
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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoLlaves;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoReglasPublicacionAutomatica;
import es.pfsgroup.plugin.rem.model.DtoTasacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.dto.File;
import es.pfsgroup.plugin.rem.rest.dto.PortalesDto;

public interface ActivoApi {

	/**
	 * Recupera el Activo indicado.
	 * 
	 * @param id
	 *            Long
	 * @return Activo
	 */
	@BusinessOperationDefinition("activoManager.get")
	public Activo get(Long id);

	public Activo getByNumActivo(Long id);

	public Activo getByNumActivoUvem(Long id);

	@BusinessOperationDefinition("activoManager.saveOrUpdate")
	public boolean saveOrUpdate(Activo activo);

	/**
	 * Guarda o acutaliza una lista de
	 * 
	 * @param listaPortalesDto
	 * @return
	 */
	public ArrayList<Map<String, Object>> saveOrUpdate(List<PortalesDto> listaPortalesDto);

	@BusinessOperationDefinition("activoManager.upload")
	public String upload(WebFileItem fileItem) throws Exception;

	/**
	 * Recupera un adjunto
	 * 
	 * @param parameter
	 * @return
	 */
	@BusinessOperationDefinition("activoManager.download")
	public FileItem download(Long id) throws Exception;

	@BusinessOperationDefinition("activoManager.uploadFoto")
	public String uploadFoto(WebFileItem fileItem);

	/**
	 * Registra una foto del gestor documental
	 * 
	 * @param fileItem
	 * @return
	 */
	public String uploadFoto(File fileItem);

	/**
	 * Recupera la lista completa de Activos
	 * 
	 * @return List<Activo>
	 * 
	 */
	@BusinessOperationDefinition("activoManager.getListActivos")
	public Page getListActivos(DtoActivoFilter dto, Usuario usuarioLogado);

	@BusinessOperationDefinition("activoManager.isIntegradoAgrupacionRestringida")
	public boolean isIntegradoAgrupacionRestringida(Long id, Usuario usuarioLogado);

	@BusinessOperationDefinition("activoManager.isIntegradoAgrupacionObraNueva")
	public boolean isIntegradoAgrupacionObraNueva(Long id, Usuario usuarioLogado);

	public boolean isIntegradoAgrupacionComercial(Activo activo);
	/**
	 * Elimina un adjunto
	 * 
	 * @param activoId
	 * @param adjuntoId
	 * @return
	 */
	@BusinessOperationDefinition("activoManager.deleteAdjunto")
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto);

	@BusinessOperationDefinition("activoManager.savePrecioVigente")
	public boolean savePrecioVigente(DtoPrecioVigente precioVigenteDto);

	@BusinessOperationDefinition("activoManager.saveOfertaActivo")
	public boolean saveOfertaActivo(DtoOfertaActivo precioVigenteDto);

	/**
	 * saveActivoValoracion: Para un activo dado, actualiza o crea una
	 * valoracion por tipo de precio. Este mismo proceso tambien se encarga de
	 * mantener el historico de valoraciones, si hay cambios en las
	 * valoraciones. Devuelve TRUE si el proceso se ha realizado correctamente
	 *
	 * @param activo
	 *            Activo (necesario)
	 * @param activoValoracion
	 *            Si se indica esta, actualiza la valoracion existente. Si no se
	 *            indica (null), crea una nueva valoracion.
	 * @param DtoPrecioVigente
	 *            dto (necesario) los datos a modificar/crear
	 * @return boolean
	 */
	@BusinessOperation(overrides = "activoManager.saveActivoValoracion")
	public boolean saveActivoValoracion(Activo activo, ActivoValoraciones activoValoracion, DtoPrecioVigente dto);

	@BusinessOperationDefinition("activoManager.getComboInferiorMunicipio")
	public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio);

	@BusinessOperationDefinition("activoManager.getMaxOrdenFotoById")
	Integer getMaxOrdenFotoById(Long id);

	@BusinessOperationDefinition("activoManager.getMaxOrdenFotoByIdSubdivision")
	Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv);

	@BusinessOperationDefinition("activoManager.getUltimoPresupuesto")
	Long getUltimoPresupuesto(Long id);

	@BusinessOperationDefinition("activoManager.getListHistoricoPresupuestos")
	public Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuarioLogado);

	@BusinessOperationDefinition("activoManager.comprobarPestanaCheckingInformacion")
	public Boolean comprobarPestanaCheckingInformacion(Long idActivo);

	/**
	 * Devuelve TRUE si encuentra un documento en el activo, buscando por codigo
	 * documento
	 * <p>
	 * Esta versión del método de comprobación, es una versión mejorada respecto
	 * a la que se viene utilizando en Recovery. Realiza todo el trabajo de
	 * búsqueda mediante filtrados con la BBDD. Evita procesar listas completas
	 * de adjuntos.
	 *
	 * @param idActivo
	 *            identificador del Activo
	 * @param codigoDocumento
	 *            codigo del documento de DDTipoDocumentoActivo
	 * @return boolean
	 */
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivo")
	public Boolean comprobarExisteAdjuntoActivo(Long idActivo, String codigoDocumento);

	/**
	 * Depende del método anterior, pero primero se va a buscar los datos que le
	 * hacen falta a partir del trabajo de la tarea.
	 * 
	 * @param tarea
	 * @return boolean
	 * @throws Exception
	 */
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivoTarea")
	public Boolean comprobarExisteAdjuntoActivoTarea(TareaExterna tarea);

	/**
	 * Devuelve TRUE si el activo tiene fecha de posesión
	 *
	 * @param idActivo
	 *            identificador del Activo
	 * @return boolean
	 */
	@BusinessOperationDefinition("activoManager.comprobarExisteFechaPosesionActivo")
	public Boolean comprobarExisteFechaPosesionActivo(Long idActivo) throws Exception;

	/**
	 * Sirve para que después de guardar un fichero en el servicio de RestClient
	 * guarde el identificador obtenido en base de datos
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
	public Boolean isVendido(Long idActivo);

	/**
	 * Devuelve mensaje de validación indicando los campos obligatorios que no
	 * han sido informados
	 *
	 * @param idActivo
	 *            identificador del Activo
	 * @return String
	 */
	@BusinessOperationDefinition("activoManager.comprobarObligatoriosCheckingInfoActivo")
	public String comprobarObligatoriosCheckingInfoActivo(Long idActivo) throws Exception;

	/**
	 * Recupera una página del historico de valores precios de un activo
	 * 
	 * @param dto
	 * @return
	 */
	public DtoPage getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto);

	/**
	 * Borrado fisico de una valoración y paso al historico
	 * 
	 * @param precioVigenteDto
	 * @return
	 */
	public boolean deleteValoracionPrecio(Long id);

	/**
	 * Borrado físico de una valoración, indicando si se ha de guardar en el
	 * histórico o no
	 * 
	 * @param id
	 * @param guardadoEnHistorico
	 * @return
	 */
	public boolean deleteValoracionPrecioConGuardadoEnHistorico(Long id, Boolean guardadoEnHistorico);

	/**
	 * Este método obtiene un objeto con los condicionantes del activo.
	 * 
	 * @param idActivo:
	 *            ID del activo a filtrar los datos.
	 * @return Devuelve un objeto con los datos obtenidos.
	 */
	public VCondicionantesDisponibilidad getCondicionantesDisponibilidad(Long idActivo);

	/**
	 * Este método obtiene una lista de condiciones específicas por el ID del
	 * activo.
	 * 
	 * @param idActivo
	 *            : ID del activo para filtrar condiciones.
	 * @return Devuelve una lista de condiciones específicas.
	 */
	public List<DtoCondicionEspecifica> getCondicionEspecificaByActivo(Long idActivo);

	/**
	 * Este método crea una condición específica nueva y establece la anterior
	 * como dada de baja.
	 * 
	 * @param dtoCondicionEspecifica
	 *            : dto con el idActivo para generar una nueva condición
	 *            específica.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public Boolean createCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica);

	/**
	 * Este método guarda los cambios en la condición específica por el ID de la
	 * condición específica.
	 * 
	 * @param dtoCondicionEspecifica
	 *            : dto con los cambios a almacenar en la DDBB.
	 * @return Devuelve su la operación ha sido satisfactoria, o no.
	 */
	public Boolean saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica);

	/**
	 * Este método obtiene los estados, el historial, de publicación de un
	 * activo.
	 * 
	 * @param idActivo:
	 *            ID del activo a filtrar los datos.
	 * @return Devuleve un dto con los datos obtenidos.
	 */
	public List<DtoEstadoPublicacion> getEstadoPublicacionByActivo(Long idActivo);

	/**
	 * Este método obtiene los datos del apartado 'datos publicación' de la tab
	 * 'publicacion' de un activo.
	 * 
	 * @param idActivo:
	 *            ID del activo a filtrar los datos.
	 * @return Devuelve un dto con los datos obtenidos.
	 */
	public DtoDatosPublicacion getDatosPublicacionByActivo(Long idActivo);

	/**
	 * Recupera una página de propuestas según el filtro recibido
	 * 
	 * @param dtoPropuestaFiltro
	 * @return
	 */
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);

	/**
	 * Este método obtiene una página de resultados de la búsqueda de Activos
	 * Publicación.
	 * 
	 * @param dtoActivosPublicacion
	 * @return Devuelve los resultados paginados del grid de la búsqueda de
	 *         activos publicación.
	 */
	public Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion);

	/**
	 * Este método obtiene el último HistoricoEstadoPublicacion por el ID de
	 * activo.
	 * 
	 * @param activoID
	 *            : ID del activo para buscar el HistoricoEstadoPublicacion.
	 * @return Devuelve el último histórico por ID para el ID del activo.
	 */
	public ActivoHistoricoEstadoPublicacion getUltimoHistoricoEstadoPublicacion(Long activoID);

	/**
	 * Ejecuta los pasos necesarios para publicar activos de forma ordinaria
	 * (con validaciones de publicacion) para un activo dado. Retorna TRUE si la
	 * ejecucion se ha producido sin errores. 1.) Rellena un dto con los
	 * parametros de publicacion ordinaria, [incluye motivo de publicacion] 2.)
	 * Llama al metodo designado para el cambio de estados de publicacion 2.1)
	 * El metodo de cambio de estados es el que invoca al procedure de publicar
	 * activo Lanza excepciones SQL, si el procedure se ejecuta con errores.
	 * Ademas, retorna TRUE/FALSE, si el activo se ha publicado o no.
	 * 
	 * @param idActivo
	 * @return
	 * @throws SQLException
	 */
	boolean publicarActivo(Long idActivo) throws SQLException;

	/**
	 * Igual que publicarActivo pero con motivo de publicacion
	 * 
	 * @param idActivo
	 * @param motivo
	 * @return
	 * @throws SQLException
	 */
	boolean publicarActivo(Long idActivo, String motivo) throws SQLException;

	/**
	 * Inserta o actualiza una visita aun activo
	 * 
	 * @param vista
	 * @return
	 */
	public Visita insertOrUpdateVisitaActivo(Visita visita) throws IllegalAccessException, InvocationTargetException;

	/**
	 * Este método obtiene los estados, el historial, de acciones del informe
	 * comercial.
	 * 
	 * @param idActivo:
	 *            ID del activo a filtrar los datos.
	 * @return Devuleve un dto con los datos obtenidos.
	 */
	public List<DtoEstadosInformeComercialHistorico> getEstadoInformeComercialByActivo(Long idActivo);

	/**
	 * Este método obtiene los estados, el historial, del mediador de la pestaña
	 * informe comercial.
	 * 
	 * @param idActivo:
	 *            ID del activo a filtrar los datos.
	 * @return Devuleve un dto con los datos obtenidos.
	 */
	public List<DtoHistoricoMediador> getHistoricoMediadorByActivo(Long idActivo);

	/**
	 * Este método recibe un objeto con los condicionantes del activo y lo
	 * almacena en la DDBB.
	 * 
	 * @param id:
	 *            ID del activo a filtrar los datos.
	 * @param dto:
	 *            dto con los datos a insertar en la DDBB.
	 * @return Devuelve si se ha completado la operación con exito o no.
	 */
	public Boolean saveCondicionantesDisponibilidad(Long idActivo, DtoCondicionantesDisponibilidad dto);

	/**
	 * Este método recibe un ID de activo y obtiene los activos vinculados al
	 * mismo.
	 * 
	 * @param dto:
	 *            dto con los datos a filtrar la busqueda para el page.
	 * @return Devuelve una lista con los datos obtenidos.
	 */
	public List<DtoPropuestaActivosVinculados> getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

	/**
	 * Este método recibe un número de activo y el ID del activo de origen y
	 * crea un nuevo registro vinculando ambos.
	 * 
	 * @param dto:
	 *            dto con los datos a insertar en la DDBB.
	 * @return Devuelve si se ha completado la operación con exito o no.
	 */
	public boolean createPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

	/**
	 * Este método borra de manera lógica la vinculación entre activos por el ID
	 * de la asociación.
	 * 
	 * @param dto:
	 *            dto con los datos a borrar en la DDBB.
	 * @return Devuelve si se ha completado la operación con exito o no.
	 */
	public boolean deletePropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

	/**
	 * HREOS-846. Comprueba si el activo esta dentro del perímetro de Haya
	 * 
	 * @param idActivo
	 *            Activo a comprobar
	 * @return true si esta dentro del perimetro Haya, false si esta fuera.
	 */
	public boolean isActivoIncluidoEnPerimetro(Long idActivo);

	/**
	 * Devuelve el perimetro del ID de un activo dado
	 * 
	 * @param idActivo
	 * @return PerimetroActivo
	 */
	public PerimetroActivo getPerimetroByIdActivo(Long idActivo);

	/**
	 * Devuelve el perimetro de datos bancarios del ID de un activo dado
	 * 
	 * @param idActivo
	 * @return ActivoBancario
	 */
	public ActivoBancario getActivoBancarioByIdActivo(Long idActivo);

	public PerimetroActivo saveOrUpdatePerimetroActivo(PerimetroActivo perimetroActivo);

	/**
	 * Actualiza el activo cuando se incluye en una agrupación asistida.
	 * 
	 * @param activo
	 * @return Activo
	 */
	public Activo updateActivoAsistida(Activo activo);

	/**
	 * Actualiza los valores del perímetro del activo con los valores para un
	 * activo asistido.
	 * 
	 * @param perimetroActivo
	 * @return PerimetroActivo
	 */
	public PerimetroActivo updatePerimetroAsistida(PerimetroActivo perimetroActivo);

	public ActivoBancario saveOrUpdateActivoBancario(ActivoBancario activoBancario);

	/**
	 * HREOS-843. Comrpueba si el activo tiene alguna oferta con el estado
	 * pasado por parámetro
	 * 
	 * @param activo
	 * @param codEstado
	 * @return
	 */
	public boolean isActivoConOfertaByEstado(Activo activo, String codEstado);

	/**
	 * HREOS-843. Comprueba si el activo tiene alguna reserva con el estado
	 * pasado por parámetro
	 * 
	 * @param activo
	 * @param codEstado
	 * @return
	 */
	public boolean isActivoConReservaByEstado(Activo activo, String codEstado);

	/**
	 * Devuelve una lista de reservas asociadas al activo pasado por parametro
	 * 
	 * @param activo
	 * @return
	 */
	public List<Reserva> getReservasByActivo(Activo activo);

	/**
	 * HREOS-843. Comrpueba si el activo esta vendido, viendo si tiene fecha de
	 * escritura (en Formalizacion)
	 * 
	 * @param activo
	 * @return
	 */
	public boolean isActivoVendido(Activo activo);

	/**
	 * Comprueba si el activo esta incluido en alguna agrupacion VIGENTE de tipo
	 * Asistida (PDV)
	 * 
	 * @param activo
	 * @return
	 */
	public boolean isIntegradoAgrupacionAsistida(Activo activo);

	/**
	 * Este método da de baja un condicionante por su ID.
	 * 
	 * @param dtoCondicionEspecifica
	 *            : dto con el ID del condicionante para dar de baja.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public Boolean darDeBajaCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica);

	/**
	 * Este método alamcena en la DDBB un nuevo proveedor de tipo mediador en el
	 * historico de medidador del informe comercial.
	 * 
	 * @param dto
	 *            : dto con los datos del mediador a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public Boolean createHistoricoMediador(DtoHistoricoMediador dto);

	/**
	 * Comprueba si el activo es asistido
	 * 
	 * @param activo
	 * @return
	 */
	public boolean isActivoAsistido(Activo activo);

	/**
	 * Obtiene el numero de activos PUBLICADOS de la agrupacion. PUBLICADOS -
	 * DD_EPU (Publicado, forzado, oculto, precio oculto y forzado con precio
	 * oculto)
	 * 
	 * @param activos
	 * @return
	 */
	public Integer getNumActivosPublicadosByAgrupacion(List<ActivoAgrupacionActivo> activos);

	/**
	 * Este método recibe un ID de activo y pide por web service el id de
	 * tasación.
	 * 
	 * @param idActivo
	 *            : ID del activo.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 * @throws Exception
	 *             Devuelve una excepción si no se ha podido obtener el ID de la
	 *             tasación.
	 */
	public Boolean solicitarTasacion(Long idActivo) throws Exception;

	/**
	 * Este método obtiene la solicitud de tasacion a Bankia por el ID del
	 * activo.
	 * 
	 * @param id
	 *            : ID del activo a filtrar.
	 * @return Devuelve un dto con los datos de la solicitud de tasación, si la
	 *         hay.
	 */
	public DtoTasacion getSolicitudTasacionBankia(Long id);

	/**
	 * Comprueba si el activo tiene activada el check de comercializar
	 * 
	 * @param idActivo
	 * @return
	 */
	public Boolean comprobarActivoComercializable(Long idActivo);

	/**
	 * Devuelve mensaje de validación indicando los campos obligatorios que no
	 * han sido informados en la pestaña "Informe comericla"
	 * 
	 * @param idActivo
	 * @return
	 * @throws Exception
	 */
	public String comprobarObligatoriosDesignarMediador(Long idActivo) throws Exception;

	/**
	 * Sirve para que después de guardar un fichero en el servicio de RestClient
	 * guarde el identificador obtenido en base de datos
	 * 
	 * @param webFileItem
	 * @param idDocRestClient
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition("activoManager.uploadDocumento")
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activo, String matricula)
			throws Exception;

	/**
	 * Este método hace una llamada para actualizar el estado de los
	 * condicionantes del activo.
	 * 
	 * @param idActivo
	 *            : ID del activo.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public Boolean updateCondicionantesDisponibilidad(Long idActivo);

	/**
	 * Este método comprueba si el activo tiene los check de admisión y gestión
	 * 
	 * @param tareaExterna
	 * @return devuelve true si tiene los check activos, false en caso contrario
	 */
	public Boolean checkAdmisionAndGestion(TareaExterna tareaExterna);

	/**
	 * Este método obtiene una lista de reglas de publicación automática.
	 * 
	 * @return Devuelve una lista de DTOReglasPublicacionAutomatica con los
	 *         datos obtenidos.
	 */
	public List<DtoReglasPublicacionAutomatica> getReglasPublicacionAutomatica(DtoReglasPublicacionAutomatica dto);

	/**
	 * Este método crea una regla de publicación automática en la DB.
	 * 
	 * @param dto
	 *            : DTO con los parámetros a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean createReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto);

	/**
	 * Este método borra de manera lógica una regla de publicación automática en
	 * la DB por el ID de la regla.
	 * 
	 * @param dto
	 *            : DTO con el ID de la regla a borrar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean deleteReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto);

	/**
	 * Devuelve la lista de proveedores para un activo
	 * 
	 * @param idActivo
	 * @return
	 */
	public List<VBusquedaProveedoresActivo> getProveedorByActivo(Long idActivo);

	/**
	 * Devuelve la lista de los gastos proveedores para un activo y un proveedor
	 * 
	 * @param idActivo
	 * @return
	 */
	public List<VBusquedaGastoActivo> getGastoByActivo(Long idActivo, Long idProveedor);

	/**
	 * Averigua si el activo tiene ofertas acpetadas
	 * 
	 * @param activo
	 * @return
	 */
	public Oferta tieneOfertaAceptada(Activo activo);

	/**
	 * Comprueba que los tipos de activo del activo y del informe comercial sean
	 * distintos.
	 * 
	 * @param tareaExterna
	 * @return true si son distintos, false si son iguales
	 */
	public Boolean checkTiposDistintos(TareaExterna tareaExterna);

	/**
	 * Comprueba que los datos de activo del activo y del informe comercial sean
	 * distintos.
	 * 
	 * @param activo
	 * @return true si son distintos, false si son iguales
	 */
	public Boolean checkTiposDistintos(Activo activo);

	/**
	 * 
	 * @param dtoActivoIntegrado
	 * @return
	 */
	public List<DtoActivoIntegrado> getProveedoresByActivoIntegrado(DtoActivoIntegrado dtoActivoIntegrado);

	/**
	 * Este método crea una integración de un activo en una entidad.
	 * 
	 * @param dto
	 *            : DTO con los parámetros a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean createActivoIntegrado(DtoActivoIntegrado dto);

	/**
	 * Este método devuelve la información de la relación Activo-Integración
	 * 
	 * @param id
	 *            : id
	 * @return Devuelve Dto con la información.
	 */
	public DtoActivoIntegrado getActivoIntegrado(String id);

	/**
	 * Este método crea una integración de un activo en una entidad.
	 * 
	 * @param dto
	 *            : DTO con los parámetros a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean updateActivoIntegrado(DtoActivoIntegrado dto);

	/**
	 * Cantidad de ofertas con estadoOferta 01 ó 04 para un determinado activo
	 * 
	 * @param activo
	 * @return
	 */
	public int cantidadOfertas(Activo activo);

	/**
	 * Mayor oferta con estadoOferta 01 ó 04 para un determinado activo
	 * 
	 * @param activo
	 * @return
	 */
	public Double mayorOfertaRecibida(Activo activo);

	/**
	 * Método que comprueba que si el activo es VPO
	 * 
	 * @param tareaExterna
	 * @return devuelve true si es VPO, false en caso contrario
	 */
	public boolean checkVPO(TareaExterna tareaExterna);

	/**
	 * Método que devuelve la lista de llaves asociadas a un activo
	 * 
	 * @param idActivo
	 * @return
	 */
	public DtoPage getListLlavesByActivo(DtoLlaves dto);

	/**
	 * Método que devuelve una lista de movimientos de una llave
	 * 
	 * @param dto
	 * @return
	 */
	public DtoPage getListMovimientosLlaveByLlave(WebDto dto, Long idLlave);

	/**
	 * Guarda la propuesta
	 * 
	 * @param popuesta
	 */
	public void actualizarFechaYEstadoCargaPropuesta(Long idPropuesta);

	/**
	 * Devuelve la valoracion Aprobado venta del activo
	 * @param activo
	 * @return
	 */
	public ActivoValoraciones getValoracionAprobadoVenta(Activo activo);
	/**
	 * Devuelve la última tasación del activo
	 * @param activo
	 * @return
	 */
	public ActivoTasacion getTasacionMasReciente(Activo activo);
}
