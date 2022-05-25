package es.pfsgroup.plugin.rem.gestorDocumental.api;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DtoMetadatosEspecificos;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.List;

public interface GestorDocumentalAdapterApi {
	
	public static final String ENTIDAD_ACTIVO = "activo";
	public static final String ENTIDAD_TRABAJO = "trabajo";
	
	List<DtoAdjunto> getAdjuntosActivo (Activo activo) throws GestorDocumentalException;
	
	List<DtoAdjunto> getAdjuntosActuacionesTecnicas (Trabajo trabajo) throws GestorDocumentalException;
	
	public List<DtoAdjunto> getAdjuntosPlusvalia(ActivoPlusvalia activoPlusvalia) throws GestorDocumentalException;

	FileItem getFileItem(Long idDocumento, String nombreDocumento) throws Exception;
	
	//Long upload(Activo activo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	Long uploadDocumentoGasto(GastoProveedor gasto, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	Long uploadDocumentoActuacionesTecnicas(Trabajo trabajo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;

	boolean borrarAdjunto(Long idDocumento, String usuarioLogado);

	boolean modoRestClientActivado();

	Integer crearGasto(GastoProveedor gasto,  String usuarioLogado) throws GestorDocumentalException;
	
	Integer crearPlusvalia(ActivoPlusvalia activoPlusvalia,  String usuarioLogado) throws GestorDocumentalException;

	Integer crearActuacionTecnica(Trabajo trabajo, String usuarioLogado) throws GestorDocumentalException;

	List<DtoAdjunto> getAdjuntosGasto(String numGasto) throws GestorDocumentalException;

	List<DtoAdjunto> getAdjuntosExpedienteComercial(ExpedienteComercial expedienteComercial) throws GestorDocumentalException;
	
	List<DtoAdjunto> getAdjuntosJunta(ActivoJuntaPropietarios activoJunta) throws GestorDocumentalException;

	Long uploadDocumentoExpedienteComercial(ExpedienteComercial expedienteComercialEntrada, WebFileItem webFileItem, String username, String matricula) throws GestorDocumentalException;

	Long uploadDocumentoJunta(ActivoJuntaPropietarios activoJuntaEntrada, WebFileItem webFileItem, String username, String matricula) throws GestorDocumentalException;
	
	Integer crearExpedienteComercial(ExpedienteComercial expedienteComercial, String username) throws GestorDocumentalException;
	
	Integer crearJunta(ActivoJuntaPropietarios activoJunta, String username) throws GestorDocumentalException;
	
	Integer crearExpedienteComercialTransactional(ExpedienteComercial idEco, String username) throws GestorDocumentalException;
	
	void crearRelacionActivosExpediente(ExpedienteComercial expedienteComercial, Long idDocRestClient, String[] listaActivos, String login, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException ;
	
	Long uploadDocumentoPromociones(String codPromo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	Long uploadDocumentoProyecto(String codAgrupacion, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	List<DtoAdjuntoPromocion> getAdjuntosPromociones (String codPromo) throws GestorDocumentalException;
	
	List<DtoAdjuntoProyecto> getAdjuntosProyecto (String codProyecto) throws GestorDocumentalException;

	void crearRelacionTrabajosActivo(Trabajo trabajo, Long idDocRestClient, String activo, String login, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException ;

	List<DtoAdjunto> getAdjuntosComunicacionGencat(ComunicacionGencat comunicacionGencat) throws GestorDocumentalException;
	
	List<DtoAdjunto> getAdjuntosComunicacionGencat(ComunicacionGencat comunicacionGencat, HistoricoComunicacionGencat historicoComunicacion) throws GestorDocumentalException;

	Integer crearContenedorComunicacionGencat(ComunicacionGencat comunicacionGencat, String username) throws GestorDocumentalException;

	Long uploadDocumentoComunicacionGencat(ComunicacionGencat comunicacionGencat, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException;

	void crearRelacionActivosComunicacion(ComunicacionGencat comunicacionGencat, Long idDocRestClient, Activo Activo, String username, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException;

	List<DtoAdjunto> getAdjuntosExpedienteComercialMultiTipo(ExpedienteComercial expedienteComercial) throws GestorDocumentalException, UnsupportedEncodingException;

	Long uploadDocumentoEntidadComprador(String idIntervinienteHaya, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException;

	List<DtoAdjunto> getAdjuntosEntidadComprador(String idIntervinienteHaya) throws GestorDocumentalException;

	Integer crearEntidadComprador(String idIntervinienteHaya, String usuarioLogado, Long idActivo, Long idAgrupacion, Long idExpediente) throws GestorDocumentalException;

	Long uploadDocumentoTributo(WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException;

	FileItem getFileItemTributo(Long idDocumento, String nombreDocumento) throws Exception;

	void crearRelacionJuntas(ActivoJuntaPropietarios activoJunta, Long idDocRestClient, String activos, String username, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException;

	Long UploadDocumentoPlusvalia(ActivoPlusvalia activoPlusvalia, WebFileItem webFileItem, String username, String matricula) throws GestorDocumentalException;

	void crearRelacionPlusvalia(ActivoPlusvalia activoPlusvalia, Long idDocRestClient, String activo, String username,
			CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException;

	Runnable crearTributo(ActivoTributos activoTributo, String usuarioLogado, String tipoExpediente) throws GestorDocumentalException;

	public void crearRelacionActivoTributo(ActivoTributos activoTributo, Long idDocRestClient, String activo, String username, CrearRelacionExpedienteDto crearRelacionExpedienteDto)
			throws GestorDocumentalException;

	List<DtoAdjuntoTributo> getAdjuntosTributo(ActivoTributos tributo) throws GestorDocumentalException, IllegalAccessException, InvocationTargetException;

	Long uploadDocumentoAgrupacionAdjunto(ActivoAgrupacion agrupacion, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException;

	List<DtoAdjuntoAgrupacion> getAdjuntoAgrupacion(Long idAgrupacion) throws GestorDocumentalException, ParseException;

	Integer crearContenedorAdjuntoAgrupacion(Long idAgrupacion, String username) throws GestorDocumentalException;

	FileItem getFileItemAgrupacion(Long id, String nombreDocumento) throws Exception;

	//Integer crearProveedor(ActivoProveedorCartera actProvCar, String username) throws GestorDocumentalException;
	
	public String getClienteByCarteraySubcarterayPropietario(DDCartera cartera, DDSubcartera subcartera, ActivoPropietario actPro);

	public Long uploadDocumentoProveedor(ActivoProveedor proveedor, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException;

	public List<DtoAdjunto> getAdjuntosProveedor(ActivoProveedor proveedor) throws GestorDocumentalException;

	Runnable crearProyecto(Activo activo, ActivoProyecto proyecto, String usuarioLogado, String tipoExpediente) throws GestorDocumentalException;

	Long upload(Activo activo, WebFileItem webFileItem, String userLogin, String matricula, DtoMetadatosEspecificos dtoMetadatos) throws Exception;

	void guardarFormularioSubidaDocumento(Long idEntidad, String tipoDocumento, boolean tbjValidado, DtoMetadatosEspecificos dto) throws ParseException;

	void actualizarAdmisionValidado(Trabajo tbj) throws ParseException;

	String getMaestroPersonasByCarteraySubcarterayPropietario(DDCartera cartera, DDSubcartera subcartera,ActivoPropietario actPro);

}
