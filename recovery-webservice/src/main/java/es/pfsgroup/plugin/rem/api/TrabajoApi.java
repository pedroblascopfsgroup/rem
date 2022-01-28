package es.pfsgroup.plugin.rem.api;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoGestionEconomicaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoPresupuestoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoPresupuestosTrabajo;
import es.pfsgroup.plugin.rem.model.DtoProveedorContactoSimple;
import es.pfsgroup.plugin.rem.model.DtoProveedorFiltradoManual;
import es.pfsgroup.plugin.rem.model.DtoProveedorMediador;
import es.pfsgroup.plugin.rem.model.DtoProvisionSuplido;
import es.pfsgroup.plugin.rem.model.DtoRecargoProveedor;
import es.pfsgroup.plugin.rem.model.DtoTarifaTrabajo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoParticipa;
import es.pfsgroup.plugin.rem.model.VProveedores;
import es.pfsgroup.plugin.rem.model.dd.DDAcoAprobacionComite;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDIdentificadorReam;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.rest.dto.TrabajoDto;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoAgendaTrabajo;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoGridFilter;

public interface TrabajoApi {

	public static final String PESTANA_FICHA = "ficha";
	public static final String PESTANA_GESTION_ECONOMICA = "gestionEconomica";
	public static final String CODIGO_T004_AUTORIZACION_BANKIA = "T004_AutorizacionBankia";
	public static final String CODIGO_T004_AUTORIZACION_PROPIETARIO = "T004_AutorizacionPropietario";
	public static final String CODIGO_T004_SOLICITUD_EXTRAORDINARIA = "T004_SolicitudExtraordinaria";
	public static final String PERFIL_CAPA_CONTROL_BANKIA="PERFGCCBANKIA";
	public static final String PERFIL_USUARIOS_DE_CONSULTA="HAYACONSU";
	public static final String CODIGO_OBTENCION_DOCUMENTACION="02";
	public static final String CODIGO_ACTUACION_TECNICA="03";
	
	/**
	 * 
	 * @param id
	 * @param pestana
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getTrabajoById")
	public Object getTrabajoById(Long id, String pestana);

	/**
	 * Recupera el Trabajo relacionado con una Tarea
	 * 
	 * @param TareaExterna
	 * @return Trabajo
	 */
	
	@BusinessOperation(overrides = "trabajoManager.getTrabajoByTareaExterna")
	public Trabajo getTrabajoByTareaExterna(TareaExterna tarea);

	@BusinessOperationDefinition("trabajoManager.createTramiteTrabajo")
	public ActivoTramite createTramiteTrabajo(Trabajo trabajo);

	/**
	 * Recupera la lista completa de Trabajos
	 * 
	 * @return List<Trabajo>
	 */
	@BusinessOperationDefinition("trabajoManager.findAll")
	public Page findAll(DtoTrabajoFilter dto, Usuario usuarioLogado);

	/**
	 * 
	 * @param trabajo
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.saveFichaTrabajo")
	public boolean saveFichaTrabajo(DtoFichaTrabajo trabajo, Long id);

	/**
	 * 
	 * @param dtoGestionEconomica
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.saveGestionEconomicaTrabajo")
	public boolean saveGestionEconomicaTrabajo(DtoGestionEconomicaTrabajo dtoGestionEconomica, Long id);

	/**
	 * 
	 * @param trabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.actualizarImporteTotalTrabajo")
	public Trabajo actualizarImporteTotalTrabajo(Long idTrabajo);

	/**
	 * Crear trabajo a partir de una lista de activos y un subtipo dados: -
	 * Nuevos trabajos del módulo de precios y marketing - Otros trabajos que no
	 * provengan de la pantalla "Crear trabajo", por esto no requiere el
	 * DtoFichaTrabajo solo requiere una lista de activos y el subtipo de
	 * trabajo a generar. - La propuesta ES OPCIONAL para crear el trabajo. Si
	 * se pasa la propuesta crea la relación, si no, solo crea el
	 * trabajo-tramite.
	 * 
	 * @param subtipoTrabajo
	 * @param listaActivos
	 * @param propuetaPrecio
	 *            (Opcional) Si es un trabajo derivado de la propuesta, se le
	 *            pasa la propuesta
	 * @return
	 */
	
	public Trabajo getTrabajoByNumeroTrabajo(Long numTrabajo);

	
	public Trabajo create(DDSubtipoTrabajo subtipoTrabajo, List<Activo> listaActivos, PropuestaPrecio propuestaPrecio) throws Exception;

	/**
	 * Crear trabajo a partir de una lista de activos y un subtipo dados: -
	 * Nuevos trabajos del módulo de precios y marketing - Otros trabajos que no
	 * provengan de la pantalla "Crear trabajo", por esto no requiere el
	 * DtoFichaTrabajo solo requiere una lista de activos y el subtipo de
	 * trabajo a generar. - La propuesta ES OPCIONAL para crear el trabajo. Si
	 * se pasa la propuesta crea la relación, si no, solo crea el
	 * trabajo-tramite.
	 * 
	 * @param subtipoTrabajo
	 * @param listaActivos
	 * @param propuestaPrecio
	 * @param inicializarTramite
	 * @return
	 */
	public Trabajo create(DDSubtipoTrabajo subtipoTrabajo, List<Activo> listaActivos, PropuestaPrecio propuestaPrecio,
			boolean inicializarTramite)  throws Exception;

	/**
	 * Crear trabajo desde la pantalla de crear trabajos: - Crea un trabajo
	 * desde el activo o desde la agrupación de activos (Nuevos trabajos Fase1)
	 * o crea un trabajo introduciendo un listado de activos en excel (trabajos
	 * con tramite multiactivo Fase 2) - Son solo trabajos que provienen de la
	 * pantalla "Crear trabajo"
	 * 
	 * @param dtoTrabajo
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.create")
	public Long create(DtoFichaTrabajo dtoTrabajo);

	/**
	 * Crea los trabajos partiendo de una lista de dto
	 * 
	 * @param listaTrabajoDto
	 * @return
	 * @throws Exception
	 */
	public ArrayList<Map<String, Object>> createTrabajos(List<TrabajoDto> listaTrabajoDto) throws Exception;

	/**
	 * 
	 * @param id
	 * @return
	 * @throws GestorDocumentalException 
	 */
	@BusinessOperationDefinition("trabajoManager.getAdjuntosTrabajo")
	public Object getAdjuntos(Long id) throws GestorDocumentalException;

	/**
	 * 
	 * @param dtoAdjunto
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.deleteAdjunto")
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto);

	/**
	 * 
	 * @param dtoAdjunto
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getFileItemAdjunto")
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto);

	/**
	 * 
	 * @param fileItem
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.upload")
	public String upload(WebFileItem fileItem) throws Exception;

	/**
	 * Devuelve la lista de activos de un trabajo
	 * 
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getListActivosTrabajo")
	public Page getListActivos(DtoActivosTrabajoFilter dto) throws InstantiationException, IllegalAccessException, Exception;


	@BusinessOperationDefinition("trabajoManager.findOne")
	Trabajo findOne(Long id);

	/**
	 * Recupera las observaciones de un trabajo
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getObservaciones")
	public DtoPage getObservaciones(DtoTrabajoFilter dto);

	/**
	 * Actualiza una observacion
	 * 
	 * @param dtoObservacion
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.saveObservacion")
	public boolean saveObservacion(DtoObservacion dtoObservacion);

	/**
	 * Crea una observación
	 * 
	 * @param dtoObservacion
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.createObservacion")
	public boolean createObservacion(DtoObservacion dtoObservacion, Long idTrabajo);

	/**
	 * Elimina una observación
	 * 
	 * @param idObservacion
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.deleteObservacion")
	public boolean deleteObservacion(Long idObservacion);

	/**
	 * Modifica un ActivoTrabajo
	 * 
	 * @param idObservacion
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.saveActivoTrabajo")
	public boolean saveActivoTrabajo(DtoActivoTrabajo activoTrabajo);

	@BusinessOperationDefinition("trabajoManager.uploadFotos")
	public String uploadFotos(List<WebFileItem> webFileItemList);

	/**
	 * Devuelve los activos de una agrupación con la información necesaria para
	 * crear un trabajo
	 * 
	 * @param filtro
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getListActivosAgrupacion")
	public Page getListActivosAgrupacion(DtoAgrupacionFilter filtro, Long id);

	/**
	 * Devuelve la selección de tarifas disponibles para aplicar a un trabajo
	 * determinado
	 * 
	 * @param filtro
	 * @param cartera,
	 *            tipoTrabajo, subtipoTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getSeleccionTarifasTrabajo")
	public DtoPage getSeleccionTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, String cartera, String tipoTrabajo,
			String subtipoTrabajo, String codigoTarifa, String descripcionTarifa,String subcarteraCodigo);

	/**
	 * Devuelve una lista de tarifas aplicadas al trabajo determinado
	 * 
	 * @param filtro
	 * @param idTrabajo
	 * @return
	 */
	public List<DtoTarifaTrabajo> getListDtoTarifaTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo);

	/**
	 * Devuelve un DtoPage con la lista de tarifas aplicadas a un trabajo
	 * determinado
	 * 
	 * @param filtro
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getTarifasTrabajo")
	public DtoPage getTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo);

	/**
	 * Devuelve los presupuestos aplicados a un trabajo determinado
	 * 
	 * @param filtro
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getPresupuestosTrabajo")
	public DtoPage getPresupuestosTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo);

	/**
	 * Crea una tarifa asociada al trabajo
	 * 
	 * @param tarifaDto
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.createTarifaTrabajo")
	public boolean createTarifaTrabajo(DtoTarifaTrabajo tarifaDto, Long idTrabajo);

	/**
	 * Crea un presupuesto asociado al trabajo
	 * 
	 * @param presupuestoDto
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.createPresupuestoTrabajo")
	public boolean createPresupuestoTrabajo(DtoPresupuestosTrabajo tarifaDto, Long idTrabajo);

	/**
	 * Actualiza un presupuesto asociado al trabajo
	 * 
	 * @param presupuestoDto
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.savePresupuestoTrabajo")
	public boolean savePresupuestoTrabajo(DtoPresupuestosTrabajo tarifaDto);

	/**
	 * Elimina un presupuesto asociado al trabajo
	 * 
	 * @param idT
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.deletePresupuestoTrabajo")
	public boolean deletePresupuestoTrabajo(Long id);

	/**
	 * Actualiza una tarifa asociada al trabajo
	 * 
	 * @param tarifaDto
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.saveTarifaTrabajo")
	public boolean saveTarifaTrabajo(DtoTarifaTrabajo tarifaDto);

	/**
	 * Elimina una tarifa asociada al trabajo
	 * 
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.deleteTarifaTrabajo")
	public boolean deleteTarifaTrabajo(Long id);

	/**
	 * Evalúa para una tarea, si existe presupuesto(s) asociados al trabajo
	 * 
	 * @param TareaExterna
	 * @return Boolean
	 */
	@BusinessOperationDefinition("trabajoManager.existePresupuestoTrabajo")
	public Boolean existePresupuestoTrabajo(TareaExterna tarea);

	/**
	 * Verifica desde una tarea si el presupuesto acumulado del trabajo supera
	 * el ultimo presupuesto del activo Retorna true si hay un exceso de
	 * presupuesto sobre el saldo del activo Retorna false si el activo tiene
	 * suficiente saldo
	 * 
	 * @param tarea
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.checkSuperaPresupuestoActivoTarea")
	public Boolean checkSuperaPresupuestoActivoTarea(TareaExterna tarea) throws Exception;

	/**
	 * Verifica desde una tarea si el presupuesto acumulado del trabajo supera
	 * el ultimo presupuesto del activo Retorna true si hay un exceso de
	 * presupuesto sobre el saldo del activo Retorna false si el activo tiene
	 * suficiente saldo
	 * 
	 * @param trabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.checkSuperaPresupuestoActivo")
	public Boolean checkSuperaPresupuestoActivo(Trabajo trabajo) throws Exception;

	/**
	 * Obtiene el importe de exceso de presupuesto del activo, para el acumulado
	 * de presupuestos de trabajos incluyendo el presupuesto del trabajo que se
	 * consulta
	 * 
	 * @param trabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getExcesoPresupuestoActivo")
	public Float getExcesoPresupuestoActivo(Trabajo trabajo) throws Exception;

	/**
	 * Evalúa para una tarea, si existe tarifa(s) asociados al trabajo
	 * 
	 * @param TareaExterna
	 * @return Boolean
	 */
	@BusinessOperationDefinition("trabajoManager.existeTarifaTrabajo")
	public Boolean existeTarifaTrabajo(TareaExterna tarea);

	/**
	 * Evalúa para una tarea, si existe tarifa(s) asociados al trabajo y si el
	 * importe de dicha tarifa es superior a cero
	 * 
	 * @param tarea
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.existeTarifaSuperiorCeroTrabajo")
	Boolean existeTarifaSuperiorCeroTrabajo(TareaExterna tarea);

	/**
	 * Evalúa para una tarea, si existe proveedor(es) asociados al trabajo
	 * 
	 * @param TareaExterna
	 * @return Boolean
	 */
	@BusinessOperationDefinition("trabajoManager.existeProveedorTrabajo")
	public Boolean existeProveedorTrabajo(TareaExterna tarea);

	/**
	 * Devuelve una lista de proveedores filtrando por cartera
	 * 
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getComboSubtipoTrabajo")
	public List<VProveedores> getComboProveedor(Long idTrabajo);

	/**
	 * Devuelve un presupuesto
	 * 
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajomanager.getPresupuestoById")
	public DtoPresupuestoTrabajo getPresupuestoById(Long id);

	/**
	 * Devuelve una lista con los recargos de un proveedor para un trabajo dado
	 * 
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getRecargosProveedor")
	public List<DtoRecargoProveedor> getRecargosProveedor(Long idTrabajo);

	/**
	 * Crea un recargo para un proveedor y trabajo
	 * 
	 * @param recargoDto
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.createRecargoProveedor")
	public boolean createRecargoProveedor(DtoRecargoProveedor recargoDto, Long idTrabajo);

	/**
	 * Modifica un recargo para un proveedor y trabajo
	 * 
	 * @param recargoDto
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.saveRecargoProveedor")
	public boolean saveRecargoProveedor(DtoRecargoProveedor recargoDto);

	/**
	 * Elimina un recargo para un proveedor y trabajo
	 * 
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.deleteRecargoProveedor")
	public boolean deleteRecargoProveedor(Long id);

	/**
	 * Devuelve una lista con las provisiones y suplidos para un trabajo dado
	 * 
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.getProvisionSuplidos")
	public List<DtoProvisionSuplido> getProvisionSuplidos(Long idTrabajo);

	/**
	 * Crea una Previsión/Suplido para un trabajo dado
	 * 
	 * @param recargoDto
	 * @param idTrabajo
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.createProvisionSuplido")
	public boolean createProvisionSuplido(DtoProvisionSuplido recargoDto, Long idTrabajo);

	/**
	 * Modifica una Previsión/Suplido para un trabajo dado
	 * 
	 * @param recargoDto
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.saveProvisionSuplido")
	public boolean saveProvisionSuplido(DtoProvisionSuplido recargoDto);

	/**
	 * Elimina una Previsión/Suplido para un trabajo dado
	 * 
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition("trabajoManager.deleteProvisionSuplido")
	public boolean deleteProvisionSuplido(Long id);

	/**
	 * Devuelve TRUE si encuentra un documento en el trabajo, buscando por
	 * codigo documento
	 * <p>
	 *
	 * @param idTrabajo
	 *            identificador del Trabajo
	 * @param codigoDocumento
	 *            codigo del documento de DDTipoDocumentoActivo
	 * @return boolean
	 */
	@BusinessOperationDefinition("trabajoManager.comprobarExisteAdjuntoActivo")
	public Boolean comprobarExisteAdjuntoTrabajo(Long idTrabajo, String codigoDocumento);

	/**
	 * Devuelve la fecha de hoy() del servidor en formato valido groovy-bmp
	 * 
	 * @return String
	 */
	@BusinessOperationDefinition("trabajoManager.hoyDate")
	public String hoyDateServer();

	/**
	 * Devuelve NUMERO, al comparar las 2 fechas de los parámetros = E Si las
	 * fechas son iguales < N Si la fecha1 es mayor que la fecha2 > P Si la
	 * fecha1 es menor que la fecha2
	 * <p>
	 *
	 * @param String
	 *            Fecha1 de comparación con formato groovy-bpm
	 * @param String
	 *            Fecha2 de comparación con formato groovy-bpm
	 * @return String
	 */
	@BusinessOperationDefinition("trabajoManager.diffDate")
	public String diffDate(String date1, String date2) throws ParseException;

	@BusinessOperationDefinition("trabajoManager.getFechaSolicitudTrabajo")
	public String getFechaSolicitudTrabajo(TareaExterna tareaExterna);

	@BusinessOperationDefinition("trabajoManager.getFechaAprobacionTrabajo")
	public String getFechaAprobacionTrabajo(TareaExterna tareaExterna);

	@BusinessOperationDefinition("trabajoManager.getFechaRechazoTrabajo")
	public String getFechaRechazoTrabajo(TareaExterna tareaExterna);

	@BusinessOperationDefinition("trabajoManager.getFechaEleccionProveedorTrabajo")
	public String getFechaEleccionProveedorTrabajo(TareaExterna tareaExterna);

	@BusinessOperationDefinition("trabajoManager.getFechaEjecutadoTrabajo")
	public String getFechaEjecutadoTrabajo(TareaExterna tareaExterna);

	@BusinessOperationDefinition("trabajoManager.getFechaValidacionTrabajo")
	public String getFechaValidacionTrabajo(TareaExterna tareaExterna);

	@BusinessOperationDefinition("trabajoManager.getFechaAnulacionTrabajo")
	public String getFechaAnulacionTrabajo(TareaExterna tareaExterna);

	@BusinessOperationDefinition("trabajoManager.getFechaCierreEcoTrabajo")
	public String getFechaCierreEcoTrabajo(TareaExterna tareaExterna);

	@BusinessOperationDefinition("trabajoManager.getFechaPagoTrabajo")
	public String getFechaPagoTrabajo(TareaExterna tareaExterna);

	/**
	 * Devuelve si existe un Trabajo por idTrabajoWebcom.
	 * 
	 * @param idTrabajoWebcom
	 *            a consultar
	 * @return Trabajo
	 */
	public Boolean existsTrabajoByIdTrabajoWebcom(Long idTrabajoWebcom);

	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de
	 * las peticiones POST.
	 * 
	 * @param TrabajoDto
	 *            con los parametros de entrada
	 * @return List<String>
	 */
	public HashMap<String, String> validateTrabajoPostRequestData(TrabajoDto trabajoDto);

	/**
	 * Devuelve un DtoFichaTrabajo a partir del TrabajoDto pasado por parámetros
	 * 
	 * @param TrabajoDto
	 *            con los parametros de entrada
	 * @return DtoFichaTrabajo
	 */
	public DtoFichaTrabajo convertTrabajoDto2DtoFichaTrabajo(TrabajoDto trabajoDto);

	/**
	 * Devuelve el trabajo asociado a la tarea externa indicada.
	 * 
	 * @param tareaExterna
	 * @return
	 */
	public Trabajo tareaExternaToTrabajo(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo tiene formalización
	 * 
	 * @param tareaExterna
	 * @return true si tiene formalización, false si no la tiene
	 */
	public boolean checkFormalizacion(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo pertenece a la cartera Sareb.
	 * 
	 * @param tareaExterna
	 * @return true si pertenece a la cartera, false si no.
	 */
	public boolean checkSareb(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo pertenece a la cartera Sareb.
	 * 
	 * @param trabajo
	 * @return true si pertenece a la cartera, false si no
	 */
	public boolean checkSareb(Trabajo trabajo);
	
	/**
	 * Método que comprueba si el activo pertenece a la cartera Tango.
	 * 
	 * @param tareaExterna
	 * @return true si pertenece a la cartera, false si no.
	 */
	public boolean checkTango(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo pertenece a la cartera Tango.
	 * 
	 * @param trabajo
	 * @return true si pertenece a la cartera, false si no
	 */
	public boolean checkTango(Trabajo trabajo);
	
	/**
	 * Método que comprueba si el activo pertenece a la cartera Giants.
	 * 
	 * @param tareaExterna
	 * @return true si pertenece a la cartera, false si no.
	 */
	public boolean checkGiants(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo pertenece a la cartera Giants.
	 * 
	 * @param trabajo
	 * @return true si pertenece a la cartera, false si no
	 */
	public boolean checkGiants(Trabajo trabajo);

	/**
	 * Método que comprueba si el activo pertenece a la cartera Bankia.
	 * 
	 * @param tareaExterna
	 * @return true si pertenece a la cartera, false si no.
	 */
	public boolean checkBankia(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo pertenece a la cartera Bankia.
	 * 
	 * @param trabajo
	 * @return true si pertenece a la cartera, false si no
	 */
	public boolean checkBankia(Trabajo trabajo);
	/**
	 * Método que comprueba si el activo pertenece a la cartera Cerberus subcarteras Agora/Apple.
	 * 
	 * @param tareaExterna
	 * @return true si pertenece a la cartera, false si no.
	 */
	public boolean checkCerberusAgoraApple(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo pertenece a la cartera Cerberus subcarteras Agora/Apple.
	 * 
	 * @param trabajo
	 * @return true si pertenece a alguna de sus subcarteras, false si no
	 */
	public boolean checkCerberusAgoraApple(Trabajo trabajo);
	/**
	 * Método que comprueba si el activo pertenece a la cartera Cajamar.
	 * 
	 * @param tareaExterna
	 * @return true si pertenece a a alguna de sus subcarteras, false si no.
	 */
	public boolean checkCajamar(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo pertenece a la cartera Cajamar.
	 * 
	 * @param trabajo
	 * @return true si pertenece a la cartera, false si no
	 */
	public boolean checkCajamar(Trabajo trabajo);

	/**
	 * Comprueba la existencia de una propuesta en el tramite de Propuestas, en
	 * la tarea Generacion de propuesta, devolviendo mensaje en caso de que se
	 * haya creado.
	 * 
	 * @param tareaExterna
	 * @return
	 */
	public String comprobarPropuestaPrecios(TareaExterna tareaExterna);

	/**
	 * Devuelve una plantilla pasandole el codigo por parametro
	 * 
	 * @param request
	 * @param response
	 * @param codPlantilla
	 * @throws Exception
	 */
	public void downloadTemplateActivosTrabajo(HttpServletRequest request, HttpServletResponse response,
			String codPlantilla) throws Exception;

	public Boolean checkSuperaDelegacion(TareaExterna tarea);

	/**
	 * Devuelve un listado de ProveedoresContacto filtrado por proveedor
	 * 
	 * @param idProveedor
	 * @return List<DtoProveedorContactoSimple> con la lista ordenada de
	 *         contactos asociados al proveedor
	 */
	public List<DtoProveedorContactoSimple> getComboProveedorContacto(Long idProveedor) throws Exception;

	/**
	 * Devuelve una lista de proveedores filtrada por cartera y tipos de
	 * proveedor segun el tipo/subtipo de trabajo
	 * 
	 * @param idTrabajo
	 * @return
	 */
	public List<VProveedores> getComboProveedorFiltered(Long idTrabajo, String codigoTipoProveedor);

	/**
	 * Devuelve un ActivoTrabajo compuesto por un activo, un trabajo y su
	 * participación.
	 * 
	 * @param activo
	 *            : activo a asignar
	 * @param trabajo
	 *            : trabajo al que se asigna.
	 * @param participacion
	 *            : participación del activo.
	 * @return ActivoTrabajo
	 */
	public ActivoTrabajo createActivoTrabajo(Activo activo, Trabajo trabajo, String participacion);

	/**
	 * Método que comprueba si el trabajo es Multiactivo
	 * 
	 * @param tareaExterna
	 * @return true si es multiactivo. false si no.
	 */
	public boolean checkEsMultiactivo(TareaExterna tareaExterna);

	public Map<String, Long> getSupervisorGestor(Long idAgrupacion);

	List<DDTipoProveedor> getComboTipoProveedorFiltered(Long idTrabajo);

	/**
	 * Metodo que dado una tarea devuelve la cartera
	 *  
	 * @param tareaExterna
	 * @return devuelve null en caso de que no se encuentre una cartera para dicha tarea (no deberia pasar)
	 */
	DDCartera getCartera(TareaExterna tareaExterna);
	
	/**
	 * Este método comprueba que el campo ReservaNecesaria contenga un valor SI ó NO.
	 * @param tareaExterna
	 * @return
	 */
	public boolean checkReservaNecesariaNotNull(TareaExterna tareaExterna);
	
	/**
	 * Este método comprueba que el campo ReservaNecesaria contenga un valor SI ó NO.
	 * @param tareaExterna
	 * @return
	 */
	public boolean checkReservaNecesariaNotNull(ExpedienteComercial expediente);

	
	
	public Boolean trabajoTieneTarifaPlana(TareaExterna tareaExterna);

	boolean checkLiberbank(TareaExterna tareaExterna);

	boolean checkLiberbank(Trabajo trabajo);
	
	boolean checkBBVA(TareaExterna tareaExterna);

	public boolean superaLimiteLiberbank(Long idTrabajo);

	Boolean trabajoEsTarificado(Long idTramite);

	boolean checkJaipur(Trabajo trabajo);

	boolean checkGaleon(Trabajo trabajo);
	
	Long getIdByNumTrabajo(Long numTrabajo);

	/**
	 * @param tbjNumTrabajo
	 * @param codTarea
	 * @return devuelve el id de la tarea activa.
	 */
	public Long getIdTareaBytbjNumTrabajoAndCodTarea(Long tbjNumTrabajo, String codTarea);
	
	@BusinessOperationDefinition("trabajoManager.getListActivoMatrizPresupuesto")
	Page getActivoMatrizPresupuesto(DtoActivosTrabajoFilter dto);

	Boolean tipoTramiteValidoObtencionDocSolicitudDocumentoGestoria(Trabajo trabajo);
	
	public ActivoTramite createTramiteTrabajo(Long idTrabajo, ExpedienteComercial expedienteComercial);

	ActivoTramite createTramiteTrabajo(Trabajo trabajo, ExpedienteComercial expedienteComercial);

	/*Envía una lista de DTOs de proveedores filtrados por cartera siempre con el 'nombre', de manera que,
	 * ya sea el campo nombre o el campo nombreComercial el seleccionado, se envíe siempre como 'nombre' para
	 * evitar conflictos*/
	public List<DtoProveedorFiltradoManual> getComboProveedorFiltradoManual(Long idTrabajo) throws Exception;
	
	public List<DDEstadoTrabajo> getComboEstadoSegunEstadoGdaOProveedor(Long idTrabajo);
	
	public DtoPage getListHistoricoDeCampos(Long idTrabajo, String codPestanya);

	/**
	 * Recupera la lista completa de Trabajos para el buscador de gastos
	 * 
	 * @return List<Trabajo>
	 */
	@BusinessOperationDefinition("trabajoManager.findBuscadorGastos")
	public DtoPage findBuscadorGastos(DtoTrabajoFilter dto);

	
	public List<DDAcoAprobacionComite> getComboAprobacionComite();
	
	public List<DtoAgendaTrabajo> getListAgendaTrabajo(Long idTrabajo);
	
	@BusinessOperationDefinition("trabajoManager.createAgendaTrabajo")
	public boolean createAgendaTrabajo(DtoAgendaTrabajo agendaTrabajo);
	
	@BusinessOperationDefinition("trabajoManager.deleteAgendaTrabajo")
	public boolean deleteAgendaTrabajo(Long id);
	
	public List<DDEstadoTrabajo>getComboEstadoTrabajo();
	public List<DDEstadoGasto> getComboEstadoGasto();

	List<VBusquedaActivosTrabajoParticipa> getListActivosTrabajo(Long id);

	public Date getFechaConcretaParametrizada(String tipoTrabajo, String subtipoTrabajo,String cartera, String subCartera);
	
	public Boolean getAplicaComiteParametrizado(String tipoTrabajo, String subtipoTrabajo,String cartera, String subCartera);

	public List<String> getTransicionesEstadoTrabajoByCodigoEstado(String estadoActual);
	
	public DtoProveedorMediador getProveedorParametrizado(Long idActivo, String tipoTrabajo, String subtipoTrabajo,String cartera, String subcartera);

	public List<VProveedores> getComboProveedorFilteredCreaTrabajo(String codCartera);

	public Map<String, String> getDocumentosFinalizacionTrabajo(Long idTrabajo);

	public Object getExisteTareaWebServiceHaya(String idTareaHaya);
	
	public List<DDIdentificadorReam>getComboAreaPeticionaria();

	void EnviarCorreoTrabajos(Trabajo trabajo, String origen);

	public BigDecimal getImporteTotalSuplidosByTrabajo(Trabajo trabajo);

	boolean activoTieneTrabajoValidadoByTipoDocumento(Long idActivo, String tipoDocumento);

	public List<DtoProveedorContactoSimple> getComboProveedorContactoLlaves(Long idProveedor) throws Exception;

	/**
	 * Devuelve un objeto Page con los trabajos que se cargarán en el grid
	 * @param dto
	 * @param usuarioLogado
	 * @return 
	 */
	public Page getBusquedaTrabajosGrid(DtoTrabajoGridFilter dto, Usuario usuarioLogado);
}