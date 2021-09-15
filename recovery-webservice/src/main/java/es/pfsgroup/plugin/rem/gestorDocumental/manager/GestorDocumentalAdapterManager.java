package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.BajaDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CredencialesUsuarioDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DtoMetadatosEspecificos;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.RecoveryToGestorDocAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearActuacionTecnicaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearEntidadCompradorDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearExpedienteComercialDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearJuntaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearPlusvaliaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearProyectoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearTributoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.RecoveryToGestorExpAssembler;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.DDTdnTipoDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.gestorDocumental.model.RespuestaGeneral;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.gestorDocumental.dto.documentos.GestorDocToRecoveryAssembler;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPlusvalia;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProyecto;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTributos;
import es.pfsgroup.plugin.rem.model.AdjuntoComunicacion;
import es.pfsgroup.plugin.rem.model.AdjuntoGastoAsociado;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoPromocion;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoProyecto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.HistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.MapeoGestorDocumental;
import es.pfsgroup.plugin.rem.model.MapeoPropietarioGestorDocumental;
import es.pfsgroup.plugin.rem.model.RelacionHistoricoComunicacion;
import es.pfsgroup.plugin.rem.model.TipoDocumentoSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDeDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoComunicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoTributos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.perfilAdministracion.dao.PerfilAdministracionDao;


@Service("gestorDocumentalAdapterManager")
public class GestorDocumentalAdapterManager implements GestorDocumentalAdapterApi, Downloader {

	protected static final Log logger = LogFactory.getLog(GestorDocumentalAdapterManager.class);
	private static final String TIPO_EXPEDIENTE= "OP";
	private static final String TIPO_AGRUPACION= "AI";
	private static final String GESTOR_DOCUMENTAL = "GESTOR_DOC";
	private static final String CLIENTE_HRE = "Haya Real Estate";
	private static final String CODIGO_ESTADO_UA = "10";
	SimpleDateFormat parser = new SimpleDateFormat("dd/MM/yyyy");

	@Resource
	private Properties appProperties;
    
    @Autowired 
    private GestorDocumentalApi gestorDocumentalApi;
    
    @Autowired 
    private GestorDocumentalExpedientesApi gestorDocumentalExpedientesApi;
    
    @Autowired
    private UtilDiccionarioApi diccionarioApi;   
    
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private GenericAdapter genericAdapter;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
    private ActivoAgrupacionApi activoAgrupacionApi;
	
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;

    @Autowired
    private ActivoTributoApi activoTributoApi;
    
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private PerfilAdministracionDao perfilAdministracionDao;

    public static final String CODIGO_CLASE_PROYECTO = "09", CODIGO_TIPO_EXPEDIENTE_REO = "AI", CODIGO_CLASE_AGRUPACIONES = "08";
    
	@Override
	public String[] getKeys() {
		return new String[]{GESTOR_DOCUMENTAL};
	}

	@Override
	public List<DtoAdjunto> getAdjuntosActivo(Activo activo) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		String codigoEstado = Checks.esNulo(activo.getEstadoActivo()) ? null : activo.getEstadoActivo().getCodigo();
		Usuario userLogin = genericAdapter.getUsuarioLogado();

		if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoTitulo()) && DDTipoTituloActivo.UNIDAD_ALQUILABLE.equals(activo.getTipoTitulo().getCodigo())) {
			codigoEstado = CODIGO_ESTADO_UA;
		}else if (codigoEstado != null) {
			if (!codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_SUELO) && !codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_EN_CURSO) &&
					!codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_TERMINADO)) {
				codigoEstado = DDEstadoActivo.ESTADO_ACTIVO_TERMINADO;
			}

		} else {
			codigoEstado = DDEstadoActivo.ESTADO_ACTIVO_TERMINADO;
		}

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo.getNumActivo().toString(), getTipoExpediente(activo), codigoEstado);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		docExpDto.setBlacklistmatriculas(perfilAdministracionDao.getBlackListMatriculasByUsuario(userLogin.getUsername()));
		docExpDto.setMetadatatdn1(true);
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

	  /*if (!Checks.esNulo(respuesta.getDocumentos())) {
			ConsistenciaAdjuntosRunnableUtils caru = new ConsistenciaAdjuntosRunnableUtils(respuesta.getDocumentos(), GestorDocumentalConstants.Contenedor.Activo);
			launchNewTasker(caru);
		}*/

		List<DtoAdjunto> list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);

		for (DtoAdjunto adjunto : list) {
			DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
			if (tipoDoc != null) {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
		}

		return list;
	}
	
	@Override
	public List<DtoAdjunto> getAdjuntosActuacionesTecnicas(Trabajo trabajo) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				trabajo.getNumTrabajo().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, GestorDocumentalConstants.CODIGO_CLASE_ACTUACION_TECNICA);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		docExpDto.setMetadatatdn1(true);
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);

		return list;
	}
	
	@Override
	public List<DtoAdjunto> getAdjuntosPlusvalia(ActivoPlusvalia activoPlusvalia) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				activoPlusvalia.getId().toString(), GestorDocumentalConstants.CODIGO_TIPO_PLUSVALIAS, GestorDocumentalConstants.CODIGO_CLASE_PLUSVALIAS);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		List<DtoAdjunto> list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);

		for (DtoAdjunto adjunto : list) {
			DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
			if (tipoDoc == null) {
				adjunto.setDescripcionTipo("");
			} else {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
		}
		return list;
	}

	@Override
	public List<DtoAdjunto> getAdjuntosProveedor(ActivoProveedor proveedor) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		
		if (!Checks.esNulo(proveedor.getIdPersonaHaya())) {
			CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
					proveedor.getIdPersonaHaya(), GestorDocumentalConstants.CODIGO_TIPO_PROVEEDORES, GestorDocumentalConstants.CODIGO_CLASE_PROVEEDORES);
			
			Usuario userLogin = genericAdapter.getUsuarioLogado();
			DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
			RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

			List<DtoAdjunto> list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);

			for (DtoAdjunto adjunto : list) {
				ActivoAdjuntoProveedor activoAdjuntoProveedor = genericDao.get(ActivoAdjuntoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "proveedor", proveedor), 
						genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", adjunto.getId()));
				if (!Checks.esNulo(activoAdjuntoProveedor)) {
					if(!Checks.esNulo(activoAdjuntoProveedor.getTipoDocumentoProveedor())) 
						adjunto.setDescripcionTipo(activoAdjuntoProveedor.getTipoDocumentoProveedor().getDescripcion());
					adjunto.setGestor(activoAdjuntoProveedor.getAuditoria().getUsuarioCrear());
					adjunto.setFechaDocumento(activoAdjuntoProveedor.getAuditoria().getFechaCrear());
				}
			}

			return list;
			
		} else {
			throw new GestorDocumentalException("No existe el contenedor para el proveedor: "+proveedor.getCodigoProveedorRem());
		}
	}

	@Override
	public Long upload(Activo activo, WebFileItem webFileItem, String userLogin, String matricula, DtoMetadatosEspecificos dtoMetadatos) throws Exception, GestorDocumentalException{
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		String codigoEstado = Checks.esNulo(activo.getEstadoActivo()) ? null : activo.getEstadoActivo().getCodigo();

		if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoTitulo()) && DDTipoTituloActivo.UNIDAD_ALQUILABLE.equals(activo.getTipoTitulo().getCodigo())) {
			codigoEstado = CODIGO_ESTADO_UA;
		}else if (codigoEstado != null) {
			if (!codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_SUELO) && !codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_EN_CURSO) &&
					!codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_TERMINADO)) {
				codigoEstado = DDEstadoActivo.ESTADO_ACTIVO_TERMINADO;
			}

		} else {
			codigoEstado = DDEstadoActivo.ESTADO_ACTIVO_TERMINADO;
		}

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo.getNumActivo().toString(), getTipoExpediente(activo), codigoEstado);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDtoConFormulario(webFileItem, userLogin, matricula, dtoMetadatos);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);

		return new Long(respuestaCrearDocumento.getIdDocumento());
	}
	
	@Override
	public List<DtoAdjunto> getAdjuntosGasto(String numGasto) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;		
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(numGasto, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_GASTO);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		/*if (!Checks.esNulo(respuesta.getDocumentos())) {
			ConsistenciaAdjuntosRunnableUtils caru = new ConsistenciaAdjuntosRunnableUtils(respuesta.getDocumentos(), GestorDocumentalConstants.Contenedor.Gasto);
			launchNewTasker(caru);
		}*/

		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);

		return list;
	}

	// TODO Refactorizar con metodo anterior.
	@Override
	public Long uploadDocumentoGasto(GastoProveedor gasto, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(gasto.getNumGastoHaya().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_GASTO);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);

		if(!Checks.esNulo(respuestaCrearDocumento) && !Checks.esNulo(respuestaCrearDocumento.getCodigoError())) {
			logger.debug(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
			throw new GestorDocumentalException(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
		}

		return new Long(respuestaCrearDocumento.getIdDocumento());
	}
	
	@Override
	public Long uploadDocumentoActuacionesTecnicas(Trabajo trabajo,
			WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta;	
		
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				trabajo.getNumTrabajo().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, GestorDocumentalConstants.CODIGO_CLASE_ACTUACION_TECNICA);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		
		RespuestaCrearDocumento respuestaCrearDocumento;

		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}

		return respuesta;
	}

	@Override
	public FileItem getFileItem(Long idDocumento,String nombreDocumento) {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		BajaDocumentoDto login = recoveryToGestorDocAssembler.getDescargaDocumentoDto(userLogin.getUsername());
		RespuestaDescargarDocumento respuesta;
		FileItem fileItem = null;

		try {
			respuesta = gestorDocumentalApi.descargarDocumento(idDocumento, login, nombreDocumento);
			fileItem = respuesta.getFileItem();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		catch(UserException ex) {
			throw ex;
		}
		catch (Exception ex) {
			ex.printStackTrace();
		}

		return fileItem;
	}

	@Override
	public boolean borrarAdjunto(Long idDocumento, String usuarioLogado) {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		BajaDocumentoDto login = recoveryToGestorDocAssembler.getBajaDocumentoDto(usuarioLogado);
		RespuestaGeneral respuesta = null;

		try {
			respuesta = gestorDocumentalApi.bajaDocumento(login, idDocumento.intValue());
			
			if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getCodigoError())) {
				logger.debug(respuesta.getCodigoError() + " - " + respuesta.getMensajeError());				
			}
			
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
		}

		return respuesta != null && "".equals(respuesta.getCodigoError());
	}
	
	@Override	
	public Integer crearEntidadComprador(String idIntervinienteHaya, String usuarioLogado, Long idActivo, Long idAgrupacion, Long idExpediente) throws GestorDocumentalException {

		Activo activoOferta; ActivoAgrupacion agrupacionOferta; ExpedienteComercial expedienteCom;
		String idSistemaOrigen = null;
		
		String codClase = GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_PROYECTO;
		
		if(!Checks.esNulo(idActivo) && Checks.esNulo(idAgrupacion) && Checks.esNulo(idExpediente)) {
			activoOferta = activoApi.get(idActivo);
			idSistemaOrigen = String.valueOf(activoOferta.getId());
		} else if(!Checks.esNulo(idAgrupacion) && Checks.esNulo(idActivo) && Checks.esNulo(idExpediente)) {
			agrupacionOferta = activoAgrupacionApi.get(idAgrupacion);
			idSistemaOrigen = String.valueOf(agrupacionOferta.getId());
		} else if(!Checks.esNulo(idExpediente) && Checks.esNulo(idActivo) && Checks.esNulo(idAgrupacion)){
			expedienteCom = expedienteComercialApi.findOne(idExpediente);
			idSistemaOrigen = String.valueOf(expedienteCom.getId());
		}

		String descripcionExpediente = "";
		
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearEntidadCompradorDto crearActivoOferta = recoveryToGestorAssembler.getCrearActivoOferta(idIntervinienteHaya, usuarioLogado, CLIENTE_HRE, idSistemaOrigen, codClase, descripcionExpediente, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ENTIDADES);
		RespuestaCrearExpediente respuesta;

		try {
			respuesta = gestorDocumentalExpedientesApi.crearActivoOferta(crearActivoOferta);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw new GestorDocumentalException(gex.getMessage());
		}

		Integer idEntidad = null;

		if(!Checks.esNulo(respuesta)) {
			idEntidad = respuesta.getIdExpediente();
		}

		return idEntidad;	
	}

	@Override	
	public Integer crearGasto(GastoProveedor gasto,  String usuarioLogado) throws GestorDocumentalException {
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		String fechaGasto = !Checks.esNulo(gasto.getFechaEmision()) ? formatter.format(gasto.getFechaEmision()) : "";
		String idReo = "";	
		if(!Checks.estaVacio(gasto.getGastoLineaDetalleList()) && !Checks.esNulo(gasto.getGastoLineaDetalleList().get(0).getGastoLineaEntidadList()) && !Checks.estaVacio(gasto.getGastoLineaDetalleList().get(0).getGastoLineaEntidadList())) {
			if(gasto.getGastoLineaDetalleList().get(0).getGastoLineaEntidadList().get(0).getEntidadGasto().getCodigo().equals(DDEntidadGasto.CODIGO_ACTIVO)) {
				Activo act = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", gasto.getGastoLineaDetalleList().get(0).getGastoLineaEntidadList().get(0).getEntidad()));
				if (!Checks.esNulo(act)) {
					idReo= act.getNumActivo().toString();
				}
			}
		}		
		String cliente = getClienteByMGP(gasto.getPropietario());
		String descripcionExpediente =  !Checks.esNulo(gasto.getConcepto()) ? gasto.getConcepto() :  "";
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearGastoDto crearGastoDto = recoveryToGestorAssembler.getCrearGastoDto(gasto.getNumGastoHaya().toString(), gasto.getNumGastoHaya().toString(), idReo, fechaGasto , cliente, descripcionExpediente, usuarioLogado);
		RespuestaCrearExpediente respuesta;

		try {
			respuesta = gestorDocumentalExpedientesApi.crearGasto(crearGastoDto);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}

		Integer idExpediente = null;

		if(!Checks.esNulo(respuesta)) {
			idExpediente = respuesta.getIdExpediente();
		}

		return idExpediente;	
	}
	
	@Override
	public Integer crearPlusvalia(ActivoPlusvalia activoPlusvalia,  String usuarioLogado) throws GestorDocumentalException {
		String idPlusvalia = activoPlusvalia.getId().toString();

		String idSistemaOrigen = "";
		String cliente = "";
		if(!Checks.esNulo(activoPlusvalia)){

		idSistemaOrigen = activoPlusvalia.getActivo().getNumActivo().toString();
		   DDCartera cartera = activoPlusvalia.getActivo().getCartera();
		   DDSubcartera subcartera = activoPlusvalia.getActivo().getSubcartera();
		   ActivoPropietario actPro = activoPlusvalia.getActivo().getPropietarioPrincipal();
		   cliente = getClienteByCarteraySubcarterayPropietario(cartera, subcartera,actPro);	
		}

		String descripcionPlusvalia = "";
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearPlusvaliaDto crearPlusvaliaDto = recoveryToGestorAssembler.getCrearPlusvaliaDto(idPlusvalia,	descripcionPlusvalia,usuarioLogado,	cliente, idSistemaOrigen,GestorDocumentalConstants.CODIGO_CLASE_PLUSVALIAS,	GestorDocumentalConstants.CODIGO_TIPO_PLUSVALIAS);
		RespuestaCrearExpediente respuesta;

		try {
		respuesta = gestorDocumentalExpedientesApi.crearPlusvalia(crearPlusvaliaDto);
		} catch (GestorDocumentalException gex) {
		logger.debug(gex.getMessage());
		throw gex;
		}

		Integer idExpediente = null;

		if(!Checks.esNulo(respuesta)) {
		idExpediente = respuesta.getIdExpediente();
		}

		return idExpediente;	
	}	

	/*@Override	
	public Integer crearProveedor(ActivoProveedorCartera activoProveedorCartera, String username) throws GestorDocumentalException {		
		
		String idSistemaOrigen = "";		
		String cliente = "";
		RespuestaCrearExpediente respuestaComunidad = null;
		RespuestaCrearExpediente respuestaJuntas = null;
		CrearProveedorDto crearProveedorDtoComunidad = null;
		CrearProveedorDto crearProveedorDtoJuntas = null;
		
		if (!Checks.esNulo(activoProveedorCartera) && !Checks.esNulo(activoProveedorCartera.getProveedor()) 
				&& !Checks.esNulo(activoProveedorCartera.getProveedor().getCodigoProveedorRem())) {	
			idSistemaOrigen = activoProveedorCartera.getProveedor().getCodigoProveedorRem().toString();	
			cliente = activoProveedorCartera.getClienteGestorDocumental();
		}
						
		String descripcionProveedor = "";
		
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		
		if(!Checks.esNulo(activoProveedorCartera) && !Checks.esNulo(activoProveedorCartera.getIdPersonaHaya())) {
			String idPersonaHaya = activoProveedorCartera.getIdPersonaHaya().toString();
			crearProveedorDtoComunidad = recoveryToGestorAssembler.getCrearProveedorDto(idPersonaHaya, username, cliente, idSistemaOrigen, 
					GestorDocumentalConstants.CODIGO_CLASE_PROVEEDORES_COMUNIDAD, descripcionProveedor, GestorDocumentalConstants.CODIGO_TIPO_PROVEEDORES);
			crearProveedorDtoJuntas = recoveryToGestorAssembler.getCrearProveedorDto(idPersonaHaya, username, cliente, idSistemaOrigen, 
					GestorDocumentalConstants.CODIGO_CLASE_PROVEEDORES_JUNTAS, descripcionProveedor, GestorDocumentalConstants.CODIGO_TIPO_PROVEEDORES);
		}
		
		try {
			if(!Checks.esNulo(cliente)) {
				if(!Checks.esNulo(crearProveedorDtoComunidad)) respuestaComunidad = gestorDocumentalExpedientesApi.crearProveedor(crearProveedorDtoComunidad);
				if(!Checks.esNulo(crearProveedorDtoJuntas)) respuestaJuntas = gestorDocumentalExpedientesApi.crearProveedor(crearProveedorDtoJuntas);
			} else {
				//Si el cliente es nulo no se creara el contenedor.
				logger.error("GestorDocumentalAdapterManager > EL PARAMETRO CLIENTE PARA CREAR EL CONTENEDOR ES NULO");
			}
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
			
		}
		
		if(!Checks.esNulo(respuestaComunidad) && !Checks.esNulo(respuestaJuntas)) {
			return respuestaComunidad.getIdExpediente()+respuestaJuntas.getIdExpediente();
		}
		
		return null;
	}*/
	
	public Integer crearActuacionTecnica(Trabajo trabajo, String username) throws GestorDocumentalException {		
		String idTrabajo = trabajo.getNumTrabajo().toString();
		
		String idSistemaOrigen = "";
		String cliente = "";
		
		idSistemaOrigen = trabajo.getActivo().getNumActivo().toString();
		DDCartera cartera = trabajo.getActivo().getCartera();
		DDSubcartera subcartera = trabajo.getActivo().getSubcartera();
		ActivoPropietario actPro = trabajo.getActivo().getPropietarioPrincipal();
		cliente = getClienteByCarteraySubcarterayPropietario(cartera, subcartera,actPro);
				
		String estadoTrabajo = Checks.esNulo(trabajo.getEstado()) ? null : trabajo.getEstado().getCodigo();
		String codClase = GestorDocumentalConstants.CODIGO_CLASE_ACTUACION_TECNICA;
		
		String descripcionActuacion = "";
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearActuacionTecnicaDto crearActuacionTecnicaDto = recoveryToGestorAssembler.getCrearActuacionTecnicaDto(idTrabajo, descripcionActuacion, username, cliente, estadoTrabajo, idSistemaOrigen, codClase, TIPO_EXPEDIENTE);
		RespuestaCrearExpediente respuesta;
		
		try {
			respuesta = gestorDocumentalExpedientesApi.crearActuacionTecnica(crearActuacionTecnicaDto);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}
		
		Integer id_Trabajo = null;
		
		if(!Checks.esNulo(respuesta)) {
			id_Trabajo = respuesta.getIdExpediente();
		}
		
		return id_Trabajo;	
	}

	private String getClienteByMGP(ActivoPropietario propietario) {
		
		MapeoPropietarioGestorDocumental mgp = null;
		
		if(propietario != null) {
			mgp = genericDao.get(MapeoPropietarioGestorDocumental.class, 
					genericDao.createFilter(FilterType.EQUALS, "propietario", propietario));
		}	
		
		if(mgp == null || (mgp != null && mgp.getClienteGestorDocumental() == null)) return "";
		
		return mgp.getClienteGestorDocumental();
	}

	@Override
	public boolean modoRestClientActivado() {
		return gestorDocumentalApi.modoRestClientActivado();
	}
	
	@Override
	public List<DtoAdjunto> getAdjuntosEntidadComprador(String idIntervinienteHaya) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idIntervinienteHaya, 
				GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ENTIDADES, GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_PROYECTO);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);
		for (DtoAdjunto adjunto : list) {
			DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
			if (tipoDoc == null) {
				adjunto.setDescripcionTipo("");
			} else {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
		}
		
		return list;
	}

	@Override
	public List<DtoAdjunto> getAdjuntosExpedienteComercial(ExpedienteComercial expedienteComercial) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;

		String codigoEstado = null;
		if(!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta()) && !Checks.esNulo(expedienteComercial.getOferta().getTipoOferta())){
			if(DDTipoOferta.CODIGO_ALQUILER.equalsIgnoreCase(expedienteComercial.getOferta().getTipoOferta().getCodigo())){
				codigoEstado = "08";
			} else if(DDTipoOferta.CODIGO_VENTA.equalsIgnoreCase(expedienteComercial.getOferta().getTipoOferta().getCodigo())){
				codigoEstado = "06";
			}
		}

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				expedienteComercial.getNumExpediente().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, codigoEstado);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		/*if (!Checks.esNulo(respuesta.getDocumentos())) {
			ConsistenciaAdjuntosRunnableUtils caru = new ConsistenciaAdjuntosRunnableUtils(respuesta.getDocumentos(), GestorDocumentalConstants.Contenedor.ExpedienteComercial);
			launchNewTasker(caru);
		}*/

		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);
		for (DtoAdjunto adjunto : list) {
			DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi
					.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
			if (tipoDoc != null) {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
		}

		return list;
	}
	
	@Override
	public Long uploadDocumentoEntidadComprador(String idIntervinienteHaya, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta;

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idIntervinienteHaya, 
				GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ENTIDADES, GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_PROYECTO);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		
		RespuestaCrearDocumento respuestaCrearDocumento;

		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());

		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			gex.printStackTrace();
			throw gex;
		}

		return respuesta;
	}
	
	@Override
	public Long uploadDocumentoProveedor(ActivoProveedor proveedor, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta;

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				proveedor.getIdPersonaHaya(), GestorDocumentalConstants.CODIGO_TIPO_PROVEEDORES, GestorDocumentalConstants.CODIGO_CLASE_PROVEEDORES);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		
		RespuestaCrearDocumento respuestaCrearDocumento;

		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}

		return respuesta;
	}

	@Override
	public Long uploadDocumentoExpedienteComercial(ExpedienteComercial expedienteComercial,
			WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta;
		String codigoEstado = null;
		if(!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta()) && !Checks.esNulo(expedienteComercial.getOferta().getTipoOferta())){
			if(DDTipoOferta.CODIGO_ALQUILER.equalsIgnoreCase(expedienteComercial.getOferta().getTipoOferta().getCodigo())){
				codigoEstado = "08";
			} else if(DDTipoOferta.CODIGO_VENTA.equalsIgnoreCase(expedienteComercial.getOferta().getTipoOferta().getCodigo())){
				codigoEstado = "06";
			}
		}		

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				expedienteComercial.getNumExpediente().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, codigoEstado);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		
		RespuestaCrearDocumento respuestaCrearDocumento;

		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}

		return respuesta;
	}
	
	
	// -------------------------------------- Subir documento pestaña JUNTA ----------------------------------------------------------
	
	@Override
	public Long uploadDocumentoJunta(ActivoJuntaPropietarios activoJuntaEntrada,
			WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta;
		String codigoEstado = null;
		if(!Checks.esNulo(activoJuntaEntrada)){
				codigoEstado = "33";
			
		}		

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				activoJuntaEntrada.getId().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, codigoEstado);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		
		RespuestaCrearDocumento respuestaCrearDocumento;

		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}

		return respuesta;
	}
	
	@Override
	public List<DtoAdjunto> getAdjuntosJunta(ActivoJuntaPropietarios activoJunta) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				activoJunta.getId().toString(), GestorDocumentalConstants.CODIGO_TIPO_JUNTA, GestorDocumentalConstants.CODIGO_CLASE_JUNTA);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		/*
		if (!Checks.esNulo(respuesta.getDocumentos())) {
			ConsistenciaAdjuntosRunnableUtils caru = new ConsistenciaAdjuntosRunnableUtils(respuesta.getDocumentos(), GestorDocumentalConstants.Contenedor.ExpedienteComercial);
			launchNewTasker(caru);
		}
		 */
		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);
		for (DtoAdjunto adjunto : list) {
			DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi
					.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
			if (tipoDoc == null) {
				adjunto.setDescripcionTipo("");
			} else {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
		}

		return list;
	}
	
	
	public Integer crearJunta(ActivoJuntaPropietarios activoJunta, String username) throws GestorDocumentalException {		
		String idJunta = activoJunta.getId().toString();
		
		String idSistemaOrigen = "";
		String cliente = "";
		if(!Checks.esNulo(activoJunta)){
							
			idSistemaOrigen = activoJunta.getActivo().getNumActivo().toString();
		    DDCartera cartera = activoJunta.getActivo().getCartera();
		    DDSubcartera subcartera = activoJunta.getActivo().getSubcartera();
		    ActivoPropietario actPro = activoJunta.getActivo().getPropietarioPrincipal();
		    cliente = getClienteByCarteraySubcarterayPropietario(cartera, subcartera,actPro);			
		}

		String descripcionJunta = "";
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearJuntaDto CrearJuntaDto = recoveryToGestorAssembler.getCrearJuntaDto(idJunta,descripcionJunta, username, cliente, idSistemaOrigen,GestorDocumentalConstants.CODIGO_CLASE_JUNTA, GestorDocumentalConstants.CODIGO_TIPO_JUNTA);
		RespuestaCrearExpediente respuesta;
		
		try {
			respuesta = gestorDocumentalExpedientesApi.crearJunta(CrearJuntaDto);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}
		
		Integer idExpediente = null;
		
		if(!Checks.esNulo(respuesta)) {
			idExpediente = respuesta.getIdExpediente();
		}
		
		return idExpediente;	
	}
	
	
	@Override
	public void crearRelacionJuntas(ActivoJuntaPropietarios activoJunta, Long idDocRestClient, String activos,
			String username, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException {
		
		String codigoEstado = "03";  
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		CredencialesUsuarioDto credUsu = recoveryToGestorDocAssembler.getCredencialesDto(username);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activos,
				getTipoExpediente(activoJunta.getActivo()),codigoEstado);
		cabecera.setIdDocumento(idDocRestClient);

		//Un vez adjuntado el documento al expediente, y obtenido el id del mismo, cread un bucle sobre el listado de activos seleccionados.
		//Llamar al servicio de vinculación entre el documento adjuntado al activo.
		StringBuilder errorMessage = new StringBuilder();
		
			cabecera.setIdExpedienteHaya(activos);

			try {
				gestorDocumentalApi.crearRelacionExpediente(cabecera, credUsu, crearRelacionExpedienteDto);
			} catch (GestorDocumentalException gex) {
				logger.debug(gex.getMessage());
				errorMessage.append("[").append(activos).append("] ").append(gex.getMessage()).append("\n");
			}
		
		if (errorMessage.length()!=0) {
			throw new GestorDocumentalException(errorMessage.toString());
		}		
	}

//------------------------------------------------------------ FIN JUNTA ----------------------------------------------------------------
	

	public Integer crearExpedienteComercialTransactional(ExpedienteComercial eco, String username) throws GestorDocumentalException {
		Integer resultado = null;
		TransactionStatus transaction = null;

		try{
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			resultado = this.crearExpedienteComercial(eco, username);
			transactionManager.commit(transaction);

		}catch(Exception e) {
			logger.error("error creando el contenedor", e);
			transactionManager.rollback(transaction);
		}

		return resultado;
	}

	public Integer crearExpedienteComercial(ExpedienteComercial expedienteComercial, String username) throws GestorDocumentalException {		
		String idExpedienteComercial = expedienteComercial.getNumExpediente().toString();
		
		String idSistemaOrigen = "";
		String cliente = "";
		if(!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta())){
			List<ActivoOferta> listActOfe = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS,"oferta" , expedienteComercial.getOferta().getId()));
			if(!Checks.estaVacio(listActOfe)){
				ActivoOferta actOfe = listActOfe.get(0);
				idSistemaOrigen = actOfe.getPrimaryKey().getActivo().getNumActivo().toString();
				DDCartera cartera = actOfe.getPrimaryKey().getActivo().getCartera();
				DDSubcartera subcartera = actOfe.getPrimaryKey().getActivo().getSubcartera();
				ActivoPropietario actPro = actOfe.getPrimaryKey().getActivo().getPropietarioPrincipal();
				cliente = getClienteByCarteraySubcarterayPropietario(cartera, subcartera,actPro);
			}
		}
		String estadoExpediente = "Alta";
		String codClase = null;
		if(!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta()) && !Checks.esNulo(expedienteComercial.getOferta().getTipoOferta())){
			if(DDTipoOferta.CODIGO_ALQUILER.equalsIgnoreCase(expedienteComercial.getOferta().getTipoOferta().getCodigo())){
				codClase = "08";
			} else if(DDTipoOferta.CODIGO_VENTA.equalsIgnoreCase(expedienteComercial.getOferta().getTipoOferta().getCodigo())){
				codClase = "06";
			}
		}
		
		String descripcionExpediente = "";
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearExpedienteComercialDto crearExpedienteComercialDto = recoveryToGestorAssembler.getCrearExpedienteComercialDto(idExpedienteComercial,descripcionExpediente, username, cliente, estadoExpediente, idSistemaOrigen,codClase, TIPO_EXPEDIENTE);
		RespuestaCrearExpediente respuesta;
		
		try {
			respuesta = gestorDocumentalExpedientesApi.crearExpedienteComercial(crearExpedienteComercialDto);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}
		
		Integer idExpediente = null;
		
		if(!Checks.esNulo(respuesta)) {
			idExpediente = respuesta.getIdExpediente();
		}
		
		return idExpediente;	
	}
	
	@Override
	public String getClienteByCarteraySubcarterayPropietario(DDCartera cartera, DDSubcartera subcartera, ActivoPropietario actPro) {
		if(Checks.esNulo(subcartera)) {
			return "";
		}

		MapeoGestorDocumental mgd = new MapeoGestorDocumental();
		if(Checks.esNulo(actPro)){
			if(!Checks.esNulo(cartera)) {
				mgd = genericDao.get(MapeoGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "cartera", cartera),
						genericDao.createFilter(FilterType.EQUALS, "subcartera", subcartera));
				if(!Checks.esNulo(mgd)){
					if(Checks.esNulo(mgd.getClienteGestorDocumental())) {
						return "";
					}
				}else{
					return "";
				}
			}
		} else {
			if(!Checks.esNulo(cartera)) {
				mgd = genericDao.get(MapeoGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "cartera", cartera),
						genericDao.createFilter(FilterType.EQUALS, "subcartera", subcartera),
						genericDao.createFilter(FilterType.EQUALS, "activoPropietario", actPro));
				if(!Checks.esNulo(mgd)){
					if(Checks.esNulo(mgd.getClienteGestorDocumental())) {
						return "";
					}
				}else{
					mgd = genericDao.get(MapeoGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "cartera", cartera),
							genericDao.createFilter(FilterType.EQUALS, "subcartera", subcartera));
					if(!Checks.esNulo(mgd)){
						if(Checks.esNulo(mgd.getClienteGestorDocumental())) {
							return "";
						}
					}else{
						return "";
					}
				}
			}
		}
		
		return mgd.getClienteGestorDocumental();
	}

	public void crearRelacionActivosExpediente(ExpedienteComercial expedienteComercial, Long idDocRestClient, String[] listaActivos, String login, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		CredencialesUsuarioDto credUsu = recoveryToGestorDocAssembler.getCredencialesDto(login);
		String codigoEstado = "03"; //Hablado con Manuel Pardo
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(expedienteComercial.getNumExpediente().toString(), getTipoExpediente(expedienteComercial.getOferta().getActivoPrincipal()), codigoEstado);
		cabecera.setIdDocumento(idDocRestClient);

		//Un vez adjuntado el documento al expediente, y obtenido el id del mismo, cread un bucle sobre el listado de activos seleccionados.
		//Llamar al servicio de vinculación entre el documento adjuntado al activo.
		StringBuilder errorMessage = new StringBuilder();
		for (String listaActivo : listaActivos) {
			cabecera.setIdExpedienteHaya(listaActivo);

			try {
				gestorDocumentalApi.crearRelacionExpediente(cabecera, credUsu, crearRelacionExpedienteDto);
			} catch (GestorDocumentalException gex) {
				logger.debug(gex.getMessage());
				errorMessage.append("[").append(listaActivo).append("] ").append(gex.getMessage()).append("\n");
			}
		}

		if (errorMessage.length()!=0) {
			throw new GestorDocumentalException(errorMessage.toString());
		}
	}
	
	public void crearRelacionTrabajosActivo(Trabajo trabajo, Long idDocRestClient, String activo, String login,
			CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException {
		String codigoEstado = "03";
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		CredencialesUsuarioDto credUsu = recoveryToGestorDocAssembler.getCredencialesDto(login);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo,
				getTipoExpediente(trabajo.getActivo()),codigoEstado);
		cabecera.setIdDocumento(idDocRestClient);

		//Un vez adjuntado el documento al expediente, y obtenido el id del mismo, cread un bucle sobre el listado de activos seleccionados.
		//Llamar al servicio de vinculación entre el documento adjuntado al activo.
		StringBuilder errorMessage = new StringBuilder();
		
			cabecera.setIdExpedienteHaya(activo);

			try {
				gestorDocumentalApi.crearRelacionExpediente(cabecera, credUsu, crearRelacionExpedienteDto);
			} catch (GestorDocumentalException gex) {
				logger.debug(gex.getMessage());
				errorMessage.append("[").append(activo).append("] ").append(gex.getMessage()).append("\n");
			}
		

		if (errorMessage.length()!=0) {
			throw new GestorDocumentalException(errorMessage.toString());
		}
	}
	

	private String getTipoExpediente (Activo activo) {
		String tipoExp = GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO;
		String codigoClaseActivo = null;

		if (activoApi.getActivoBancarioByIdActivo(activo.getId())!=null && activoApi.getActivoBancarioByIdActivo(activo.getId()).getClaseActivo()!=null) {
			codigoClaseActivo = activoApi.getActivoBancarioByIdActivo(activo.getId()).getClaseActivo().getCodigo();
		}

		if (DDClaseActivoBancario.CODIGO_FINANCIERO.equals(codigoClaseActivo)) {
			tipoExp = GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_GARANTIAS;
		}

		return tipoExp;
	}

	@Override
	public Long uploadDocumentoPromociones(String codPromo, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(codPromo, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_PROMOCIONES);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);

		if(!Checks.esNulo(respuestaCrearDocumento) && !Checks.esNulo(respuestaCrearDocumento.getCodigoError())) {
			logger.debug(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
			throw new GestorDocumentalException(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
		}

		return new Long(respuestaCrearDocumento.getIdDocumento());
	}
	

	@Override
	public Long uploadDocumentoProyecto(String codAgrupacionActivo, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(codAgrupacionActivo, CODIGO_TIPO_EXPEDIENTE_REO, CODIGO_CLASE_PROYECTO);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);

		if(!Checks.esNulo(respuestaCrearDocumento) && !Checks.esNulo(respuestaCrearDocumento.getCodigoError())) {
			logger.debug(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
			throw new GestorDocumentalException(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
		}

		return new Long(respuestaCrearDocumento.getIdDocumento());
	}

	@Override
	public List<DtoAdjuntoPromocion> getAdjuntosPromociones(String codPromo) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(codPromo, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_PROMOCIONES);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
		docExpDto.setBlacklistmatriculas(perfilAdministracionDao.getBlackListMatriculasByUsuario(userLogin.getUsername()));
		List<DtoAdjuntoPromocion> list = GestorDocToRecoveryAssembler.getListDtoAdjuntoPromo(respuesta);

		for (DtoAdjuntoPromocion adjunto : list) {
			DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
			if (tipoDoc == null) {
				adjunto.setDescripcionTipo("");
			} else {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
		}

		return list;
	}

	@Override
	public FileItem getFileItemPromocion(Long idDocumento, String nombreDocumento) throws Exception {
		return this.getFileItem(idDocumento, nombreDocumento);
	}
	
	@Override
	public FileItem getFileItemTributo(Long idDocumento, String nombreDocumento)  throws Exception {
		return this.getFileItem(idDocumento, nombreDocumento);
	}

	@Override
	public List<DtoAdjunto> getAdjuntosComunicacionGencat(ComunicacionGencat comunicacionGencat) throws GestorDocumentalException  {
		return getAdjuntosComunicacionGencat(comunicacionGencat, null);
	}
	@Override
	public List<DtoAdjunto> getAdjuntosComunicacionGencat(ComunicacionGencat comunicacionGencat, HistoricoComunicacionGencat historicoComunicacion) throws GestorDocumentalException  {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;

		String codigoEstado = "31";
		
		String idComunicacion = "";
		if (!Checks.esNulo(comunicacionGencat)) {
			idComunicacion = comunicacionGencat.getId().toString();
		} else if (!Checks.esNulo(historicoComunicacion)) {
			RelacionHistoricoComunicacion relacionHistoricoComunicacion = genericDao.get(RelacionHistoricoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "historicoComunicacionGencat.id", historicoComunicacion.getId()));
			idComunicacion = relacionHistoricoComunicacion.getIdComunicacionGencat().toString();
		}
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				idComunicacion, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, codigoEstado);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);
		for (DtoAdjunto adjunto : list) {
			DDTipoDocumentoComunicacion tipoDoc = genericDao.get(DDTipoDocumentoComunicacion.class,genericDao.createFilter(FilterType.EQUALS, "matricula","OP-31-"+adjunto.getCodigoTipo()));
			if (tipoDoc == null) {
				adjunto.setDescripcionTipo("");
			} else {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
			AdjuntoComunicacion adj = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "idDocRestClient",adjunto.getId()));
			if(!Checks.esNulo(adj)) {
				Usuario usuarioGestor = genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS,"username", adj.getAuditoria().getUsuarioCrear()),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
				adjunto.setGestor(usuarioGestor.getApellidoNombre());
			}
		}

		return list;
	}

	
	/**
	 * 
	 * Método para la creación de un contenedor de comunicaciones Gencat
	 * 
	 */
	@Override
	public Integer crearContenedorComunicacionGencat(ComunicacionGencat comunicacionGencat, String username)  throws GestorDocumentalException {		
		String idComunicacionGencat = comunicacionGencat.getId().toString();
		
		String idSistemaOrigen = "";
		String cliente = "";
		if(!Checks.esNulo(comunicacionGencat) && !Checks.esNulo(comunicacionGencat.getActivo())){
			idSistemaOrigen = comunicacionGencat.getId().toString();
			DDCartera cartera = comunicacionGencat.getActivo().getCartera();
			DDSubcartera subcartera = comunicacionGencat.getActivo().getSubcartera();
			ActivoPropietario actPro = comunicacionGencat.getActivo().getPropietarioPrincipal();
			cliente = getClienteByCarteraySubcarterayPropietario(cartera, subcartera,actPro);		
		}
		String estadoExpediente = "Alta";
		String codClase = "31";
		
		
		String descripcionExpediente = "";
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearExpedienteComercialDto crearExpedienteComercialDto = recoveryToGestorAssembler.getCrearExpedienteComercialDto(idComunicacionGencat,descripcionExpediente, username, cliente, estadoExpediente, idSistemaOrigen,codClase, TIPO_EXPEDIENTE);
		RespuestaCrearExpediente respuesta;
		
		try {
			respuesta = gestorDocumentalExpedientesApi.crearExpedienteComercial(crearExpedienteComercialDto);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}
		
		Integer idExpediente = null;
		
		if(!Checks.esNulo(respuesta)) {
			idExpediente = respuesta.getIdExpediente();
		}
		
		return idExpediente;	
	}
	
	/**
	 * 
	 * Método para subir documentos de comunicación
	 */
	@Override
	public Long uploadDocumentoComunicacionGencat(ComunicacionGencat comunicacionGencat,
			WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta;
		String codigoEstado = "31";
		String fechaNotificacion = webFileItem.getParameter("fechaNotificacion");
		if (Checks.esNulo(fechaNotificacion)) {
			SimpleDateFormat sdf = new SimpleDateFormat("dd/M/yyyy hh:mm");
			fechaNotificacion = sdf.format(new Date());
		}
		String idComunicacion = comunicacionGencat.getId().toString();
		if (!Checks.esNulo(webFileItem.getParameter("idHComunicacion"))) {
			RelacionHistoricoComunicacion relacionHistoricoComunicacion = genericDao.get(RelacionHistoricoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "historicoComunicacionGencat.id", Long.parseLong(webFileItem.getParameter("idHComunicacion"))));
			idComunicacion = relacionHistoricoComunicacion.getIdComunicacionGencat().toString();
		}
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				idComunicacion, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, codigoEstado);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoComunicacionGencatDto(webFileItem, userLogin, matricula,fechaNotificacion);
		
		RespuestaCrearDocumento respuestaCrearDocumento;

		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}

		return respuesta;
	}

	@Override
	public void crearRelacionActivosComunicacion(ComunicacionGencat comunicacionGencat, Long idDocRestClient,
			Activo activo, String username, CrearRelacionExpedienteDto crearRelacionExpedienteDto)  throws GestorDocumentalException  {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		CredencialesUsuarioDto credUsu = recoveryToGestorDocAssembler.getCredencialesDto(username);
		String codigoEstado = "03"; //Hablado con Manuel Pardo
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(comunicacionGencat.getId().toString(), getTipoExpediente(activo), codigoEstado);
		cabecera.setIdDocumento(idDocRestClient);

		//Un vez adjuntado el documento al expediente, y obtenido el id del mismo, cread un bucle sobre el listado de activos seleccionados.
		//Llamar al servicio de vinculación entre el documento adjuntado al activo.
		StringBuilder errorMessage = new StringBuilder();
	
			cabecera.setIdExpedienteHaya(activo.getNumActivo().toString());

			try {
				gestorDocumentalApi.crearRelacionExpediente(cabecera, credUsu, crearRelacionExpedienteDto);
			} catch (GestorDocumentalException gex) {
				logger.debug(gex.getMessage());
				errorMessage.append("[").append(activo.getNumActivo().toString()).append("] ").append(gex.getMessage()).append("\n");
			}
		

		if (errorMessage.length()!=0) {
			throw new GestorDocumentalException(errorMessage.toString());
		}
		
	}

	@Override
	public FileItem getFileItemComunicacionGencat(Long id, String nombreDocumento) {
	return this.getFileItem(id, nombreDocumento);
	}
	
	public String getClienteWSByCarteraySubcarterayPropietario(DDCartera cartera, DDSubcartera subcartera, ActivoPropietario actPro) {
		if(Checks.esNulo(subcartera)) {
			return "";
		}

		MapeoGestorDocumental mgd = new MapeoGestorDocumental();
		if(Checks.esNulo(actPro)){
			if(!Checks.esNulo(cartera)) {
				mgd = genericDao.get(MapeoGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "cartera", cartera),
						genericDao.createFilter(FilterType.EQUALS, "subcartera", subcartera));
				if(!Checks.esNulo(mgd)){
					if(Checks.esNulo(mgd.getClienteMaestroActivos())) {
						return "";
					}
				}else{
					return "";
				}
			}
		} else {
			if(!Checks.esNulo(cartera)) {
				mgd = genericDao.get(MapeoGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "cartera", cartera),
						genericDao.createFilter(FilterType.EQUALS, "subcartera", subcartera),
						genericDao.createFilter(FilterType.EQUALS, "activoPropietario", actPro));
				if(!Checks.esNulo(mgd)){
					if(Checks.esNulo(mgd.getClienteMaestroActivos())) {
						return "";
					}
				}else{
					mgd = genericDao.get(MapeoGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "cartera", cartera),
							genericDao.createFilter(FilterType.EQUALS, "subcartera", subcartera));
					if(!Checks.esNulo(mgd)){
						if(Checks.esNulo(mgd.getClienteMaestroActivos())) {
							return "";
						}
					}else{
						return "";
					}
				}
			}
		}
		
		return mgd.getClienteMaestroActivos();
	}
	
	@Override
	public Long uploadDocumentoTributo(WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(webFileItem.getParameter("idTributo"), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, GestorDocumentalConstants.CODIGO_CLASE_TRIBUTOS);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);

		if(!Checks.esNulo(respuestaCrearDocumento) && !Checks.esNulo(respuestaCrearDocumento.getCodigoError())) {
			logger.debug(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
			throw new GestorDocumentalException(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
		}

		return new Long(respuestaCrearDocumento.getIdDocumento());
	
	}

	@Override
	public Long UploadDocumentoPlusvalia(ActivoPlusvalia activoPlusvalia, WebFileItem webFileItem, String username, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta;
		String codigoEstado = null;
		if(!Checks.esNulo(activoPlusvalia)){
				codigoEstado = GestorDocumentalConstants.CODIGO_CLASE_PLUSVALIAS;
			
		}		

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(
				activoPlusvalia.getId().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, codigoEstado);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, username, matricula);
		
		RespuestaCrearDocumento respuestaCrearDocumento;

		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}

		return respuesta;
	}

	@Override
	public void crearRelacionPlusvalia(ActivoPlusvalia activoPlusvalia, Long idDocRestClient, String activo,
			String username, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException {
		
		String codigoEstado = "03";
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		CredencialesUsuarioDto credUsu = recoveryToGestorDocAssembler.getCredencialesDto(username);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo,
				getTipoExpediente(activoPlusvalia.getActivo()),codigoEstado);
		cabecera.setIdDocumento(idDocRestClient);

		StringBuilder errorMessage = new StringBuilder();
		
			cabecera.setIdExpedienteHaya(activo);

			try {
				gestorDocumentalApi.crearRelacionExpediente(cabecera, credUsu, crearRelacionExpedienteDto);
			} catch (GestorDocumentalException gex) {
				logger.debug(gex.getMessage());
				errorMessage.append("[").append(activo).append("] ").append(gex.getMessage()).append("\n");
			}
		
		if (errorMessage.length()!=0) {
			throw new GestorDocumentalException(errorMessage.toString());
		}	
		
	}
	
	@Override
	public List<DtoAdjuntoTributo> getAdjuntosTributo(ActivoTributos tributo) throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;
		List<DtoAdjuntoTributo> listAdjunto = new ArrayList<DtoAdjuntoTributo>();

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(tributo.getId().toString(),
				GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES, GestorDocumentalConstants.CODIGO_CLASE_TRIBUTOS);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);
		if(!Checks.estaVacio(list)) {
			for (DtoAdjunto adjunto : list) {
				DtoAdjuntoTributo adjTributo = new DtoAdjuntoTributo();
				DDTipoDocumentoTributos tipoDoc = (DDTipoDocumentoTributos) genericAdapter.dameValorDiccionarioByMatricula(DDTipoDocumentoTributos.class, adjunto.getMatricula());
				
				BeanUtils.copyProperties(adjTributo, adjunto);
				
				if (tipoDoc == null) {
					adjTributo.setDescripcionTipo("");
				} else {
					adjTributo.setDescripcionTipo(tipoDoc.getDescripcion());
				}
				
				ActivoAdjuntoTributo adj = activoTributoApi.getAdjuntoTributo(adjunto.getId());
				
				if(adj != null && adjTributo.getGestor() == null) {
					adjTributo.setGestor(adj.getAuditoria().getUsuarioCrear());
				}
				
				listAdjunto.add(adjTributo);
			}
		}
		return listAdjunto;
	}
	
	@Override	
	public Runnable crearTributo(ActivoTributos activoTributo,  String usuarioLogado, String tipoExpediente) throws GestorDocumentalException {
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		
		DDCartera cartera = activoTributo.getActivo().getCartera();
		DDSubcartera subcartera = activoTributo.getActivo().getSubcartera();
		ActivoPropietario actPro = activoTributo.getActivo().getPropietarioPrincipal();
		
		
		String cliente = getClienteByCarteraySubcarterayPropietario(cartera, subcartera,actPro);
		
		CrearTributoDto crearTributoDto = recoveryToGestorAssembler.getCrearTributoDto(activoTributo.getId().toString(), usuarioLogado, tipoExpediente, cliente);
	

		try {
			gestorDocumentalExpedientesApi.crearTributo(crearTributoDto);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}
		return null;

	}
	
	@Override
	public void crearRelacionActivoTributo(ActivoTributos activoTributo, Long idDocRestClient, String activo,
			String username, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException {
		
		String codigoEstado = "03";
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		CredencialesUsuarioDto credUsu = recoveryToGestorDocAssembler.getCredencialesDto(username);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo,getTipoExpediente(activoTributo.getActivo()),codigoEstado);
		cabecera.setIdDocumento(idDocRestClient);

		StringBuilder errorMessage = new StringBuilder();
		
			cabecera.setIdExpedienteHaya(activo);

			try {
				gestorDocumentalApi.crearRelacionExpediente(cabecera, credUsu, crearRelacionExpedienteDto);
			} catch (GestorDocumentalException gex) {
				logger.debug(gex.getMessage());
				errorMessage.append("[").append(activo).append("] ").append(gex.getMessage()).append("\n");
			}
		
		if (errorMessage.length()!=0) {
			throw new GestorDocumentalException(errorMessage.toString());
		}	
	}
		

	@Override
	public List<DtoAdjuntoProyecto> getAdjuntosProyecto(String codProyecto) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(codProyecto, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, CODIGO_CLASE_PROYECTO);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
		docExpDto.setBlacklistmatriculas(perfilAdministracionDao.getBlackListMatriculasByUsuario(userLogin.getUsername()));
		List<DtoAdjuntoProyecto> list = GestorDocToRecoveryAssembler.getListDtoAdjuntoProyecto(respuesta);

		for (DtoAdjuntoProyecto adjunto : list) {
			DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
			if (tipoDoc == null) {
				adjunto.setDescripcionTipo("");
			} else {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
		}

		return list;
	}
	
	@Override
	public Long uploadDocumentoAgrupacionAdjunto(ActivoAgrupacion agrupacion, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta;
		String codigoEstado = "08";
		String idAgrupacion = agrupacion.getNumAgrupRem().toString();
		
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idAgrupacion, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, codigoEstado);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		
		RespuestaCrearDocumento respuestaCrearDocumento;

		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}

		return respuesta;
	}
	
	@Override
	public List<DtoAdjuntoAgrupacion> getAdjuntoAgrupacion(Long idAgrupacion) throws GestorDocumentalException, ParseException { 
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		String idAgrupacionString = String.valueOf(idAgrupacion);
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idAgrupacionString, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, CODIGO_CLASE_AGRUPACIONES);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
		List<DtoAdjuntoAgrupacion> list = GestorDocToRecoveryAssembler.getListDtoAdjuntoAgrupacion(respuesta, idAgrupacion);

		for (DtoAdjuntoAgrupacion adjunto : list) {
			DDTipoDocumentoAgrupacion tipoDoc = genericAdapter.dameValorDiccionarioByMatricula(DDTipoDocumentoAgrupacion.class, adjunto.getMatricula());
			if (tipoDoc == null) {
				adjunto.setDescripcionTipo("");
			} else {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}
		}

		return list;
	}
	
	@Override
	public Integer crearContenedorAdjuntoAgrupacion(Long idAgrupacion, String username)  throws GestorDocumentalException {
		Filter fAgrupacion = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", idAgrupacion);  
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, fAgrupacion);
		String agrupacionId = agrupacion.getNumAgrupRem().toString();
		String idSistemaOrigen = "";
		String cliente = "";
		
		if(!Checks.esNulo(agrupacion)){
			idSistemaOrigen = agrupacion.getNumAgrupRem().toString();
			DDCartera cartera = null;
			if (!Checks.esNulo(agrupacion.getActivoPrincipal())) {
				cartera = agrupacion.getActivoPrincipal().getCartera();
			}else {
				ActivoAgrupacionActivo agrupacionActivo = agrupacion.getActivos().get(0);
				if (!Checks.esNulo(agrupacionActivo) && !Checks.esNulo(agrupacionActivo.getActivo()))
					cartera= agrupacionActivo.getActivo().getCartera();
			}
			DDSubcartera subcartera = null;
			if (!Checks.esNulo(agrupacion.getActivoPrincipal())) {
				subcartera = agrupacion.getActivoPrincipal().getSubcartera();
			}else {
				ActivoAgrupacionActivo agrupacionActivo = agrupacion.getActivos().get(0);
				if (!Checks.esNulo(agrupacionActivo) && !Checks.esNulo(agrupacionActivo.getActivo()))
					subcartera= agrupacionActivo.getActivo().getSubcartera();
			}
			ActivoPropietario actPro = null;
			if (!Checks.esNulo(agrupacion.getActivoPrincipal())) {
				actPro = agrupacion.getActivoPrincipal().getPropietarioPrincipal();
			}else {
				ActivoAgrupacionActivo agrupacionActivo = agrupacion.getActivos().get(0);
				if (!Checks.esNulo(agrupacionActivo) && !Checks.esNulo(agrupacionActivo.getActivo()))
					actPro= agrupacionActivo.getActivo().getPropietarioPrincipal();
			}
			cliente = getClienteByCarteraySubcarterayPropietario(cartera, subcartera,actPro);		
		}
		 
		String estadoExpediente = "Alta"; 
		String codClase = CODIGO_CLASE_AGRUPACIONES;
		String descripcionExpediente = "";
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearExpedienteComercialDto crearExpedienteComercialDto = recoveryToGestorAssembler
				.getCrearAgrupacionlDto(agrupacionId,descripcionExpediente, username, cliente, estadoExpediente, idSistemaOrigen,codClase, TIPO_AGRUPACION);
		logger.error("Llamada al gestor documental : \n"
				+ "\n [Id agrupacion] : " + agrupacionId
				+ "\n [Descripcion expediente] : " + descripcionExpediente
				+ "\n [Usuario] : " + username
				+ "\n [Cliente] : " + cliente
				+ "\n [Estado expediente] : " + estadoExpediente
				+ "\n [Id sistema origen] : " + idSistemaOrigen
				+ "\n [Clase] : " + codClase
				+ "\n [Tipo codigo] : " + TIPO_AGRUPACION);
		RespuestaCrearExpediente respuesta;
		
		try {
			respuesta = gestorDocumentalExpedientesApi.crearExpedienteComercial(crearExpedienteComercialDto);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}
		Integer id = null;
		if(!Checks.esNulo(respuesta)) {
			id = respuesta.getIdExpediente();
		}
		
		return id;	
	}

	@Override
	public FileItem getFileItemAgrupacion(Long id, String nombreDocumento) throws Exception {
		return this.getFileItem(id, nombreDocumento);
	}
	

	@Override	
	public Runnable crearProyecto(Activo activo, ActivoProyecto proyecto,  String usuarioLogado, String tipoExpediente) throws GestorDocumentalException {
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		
		DDCartera cartera = proyecto.getCartera();
		DDSubcartera subcartera = activo.getSubcartera();
		ActivoPropietario actPro = activo.getPropietarioPrincipal();
		
		String cliente = getClienteByCarteraySubcarterayPropietario(cartera, subcartera,actPro);
		
		CrearProyectoDto crearProyectoDto = recoveryToGestorAssembler.getCrearProyectoDto(proyecto.getNumAgrupRem().toString(), usuarioLogado, tipoExpediente, cliente);
		
		try {
			gestorDocumentalExpedientesApi.crearProyecto(crearProyectoDto);
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}
		
		return null;
	
	}

	@Override
	public FileItem getFileItemFactura(Long id, String nombreDocumento) {
		if(id == null) return null;
		FileItem fileItem = null;
		AdjuntoGastoAsociado adjunto = genericDao.get(AdjuntoGastoAsociado.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		if(adjunto == null) return null;
		if(adjunto.getIdentificadorGestorDocumental() == null) {
			fileItem = adjunto.getAdjunto().getFileItem();
			fileItem.setContentType(adjunto.getTipoContenidoDocumento());
			fileItem.setFileName(adjunto.getNombreAdjuntoGastoAsociado());
		}else {
			fileItem = this.getFileItem(adjunto.getIdentificadorGestorDocumental(), nombreDocumento);
		}
		return fileItem;
	}

	@Override
	public FileItem getFileItemExpediente(Long id, String nombreDocumento) {
 		return this.getFileItem(id, nombreDocumento);
	}
	
	@Override
	@Transactional(readOnly = false)
	public void guardarFormularioSubidaDocumento(Long idEntidad, String tipoDocumento, boolean tbjValidado, DtoMetadatosEspecificos dto) throws ParseException{
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id", idEntidad);
		Activo activo = genericDao.get(Activo.class, filtroActivo);
		Order order = new Order(OrderType.DESC, "id");
		ActivoAdmisionDocumento activoAdmisionDocumento = null;
		ActivoConfigDocumento actConfDoc = null;
		
		DDTipoDocumentoActivo tipoDocDiccionario = (DDTipoDocumentoActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumentoActivo.class, tipoDocumento);
		Filter filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.id", tipoDocDiccionario.getId());
		Filter filtrotipoActivo = genericDao.createFilter(FilterType.EQUALS, "tipoActivo.id",activo.getTipoActivo().getId());
		List<ActivoConfigDocumento> actConfDocList = genericDao.getListOrdered(ActivoConfigDocumento.class, order,filtroDocumento,filtrotipoActivo);
		if(actConfDocList != null && !actConfDocList.isEmpty()) {
			actConfDoc = actConfDocList.get(0);
			Filter filtroActConfDoc = genericDao.createFilter(FilterType.EQUALS, "configDocumento.id", actConfDoc.getId());
			List<ActivoAdmisionDocumento> activoAdmisionDocumentoList = genericDao.getListOrdered(ActivoAdmisionDocumento.class,order, filtroActivo, filtroActConfDoc);
			
		if(activoAdmisionDocumentoList != null && !activoAdmisionDocumentoList.isEmpty()) {
			activoAdmisionDocumento = activoAdmisionDocumentoList.get(0);
			
		}else {
			activoAdmisionDocumento = new ActivoAdmisionDocumento();
			activoAdmisionDocumento.setActivo(activo);
			activoAdmisionDocumento.setConfigDocumento(actConfDoc);
		}
		if(dto.getFechaObtencion() != null) {
			activoAdmisionDocumento.setFechaObtencion(parser.parse(dto.getFechaCaducidad()));
		}
		if(dto.getFechaCaducidad() != null) {
			activoAdmisionDocumento.setFechaCaducidad(parser.parse(dto.getFechaCaducidad()));
		}
		if(dto.getFechaEmision() != null) {
			activoAdmisionDocumento.setFechaEmision(parser.parse(dto.getFechaEmision()));
		}
		if(dto.getFechaEtiqueta() != null) {
			activoAdmisionDocumento.setFechaEtiqueta(parser.parse(dto.getFechaEtiqueta()));
		}
		
		if("SI".equalsIgnoreCase(dto.getAplica())) {
			activoAdmisionDocumento.setAplica(true);
		}else {
			activoAdmisionDocumento.setAplica(false);
		}
		
		activoAdmisionDocumento.setRegistro(dto.getRegistro());
		activoAdmisionDocumento.setNoValidado(tbjValidado);

		genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDocumento);
		}

	
	}
	
	@Override
	@Transactional(readOnly = false)
	public void actualizarAdmisionValidado(Trabajo tbj) throws ParseException{
		Order order = new Order(OrderType.DESC, "id");
		ActivoAdmisionDocumento activoAdmisionDocumento = null;
		Filter filterSubTipoTrabajo= genericDao.createFilter(FilterType.EQUALS, "subtipoTrabajo.id", tbj.getSubtipoTrabajo().getId());
		List<TipoDocumentoSubtipoTrabajo> tipoDocList = genericDao.getList(TipoDocumentoSubtipoTrabajo.class, filterSubTipoTrabajo);

		List<ActivoTrabajo> activos = tbj.getActivosTrabajo();
		
		if(tipoDocList == null || activos == null || activos.isEmpty() || tipoDocList.isEmpty() ) {
			return;
		}
		
		for (TipoDocumentoSubtipoTrabajo tipoDoc : tipoDocList) {
			if(tipoDoc.getTipoDocumento() != null) {
				for (ActivoTrabajo activoTrabajo : activos) {
					Activo activo = activoTrabajo.getActivo();
					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id", activo.getId());
					Filter filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo", tipoDoc.getTipoDocumento().getCodigo());
					Filter filtrotipoActivo = genericDao.createFilter(FilterType.EQUALS, "tipoActivo.id",activo.getTipoActivo().getId());
					Filter filtroSubtipoActivo = genericDao.createFilter(FilterType.EQUALS, "subtipoActivo.id",activo.getSubtipoActivo().getId());
					List<ActivoConfigDocumento> lista = genericDao.getList(ActivoConfigDocumento.class, filtroDocumento, filtrotipoActivo, filtroSubtipoActivo);
					ActivoConfigDocumento actConfDoc = null;
					if(lista != null && !lista.isEmpty()) {
						actConfDoc = lista.get(0);
					}
					if(actConfDoc != null) {
						Filter filtroActConfDoc = genericDao.createFilter(FilterType.EQUALS, "configDocumento.id", actConfDoc.getId());
						List<ActivoAdmisionDocumento> activoAdmisionDocumentoList = genericDao.getListOrdered(ActivoAdmisionDocumento.class,order, filtroActivo, filtroActConfDoc);
						if(activoAdmisionDocumentoList != null && !activoAdmisionDocumentoList.isEmpty()) {
							activoAdmisionDocumento = activoAdmisionDocumentoList.get(0);
						}
						if(activoAdmisionDocumento != null) {
							activoAdmisionDocumento.setNoValidado(false);
							genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDocumento);
						}
					}
				}	
			}
		}		
	}
	
}