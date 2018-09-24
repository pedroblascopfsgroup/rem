package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.BajaDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CredencialesUsuarioDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.RecoveryToGestorDocAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearExpedienteComercialDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
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
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.gestorDocumental.dto.documentos.GestorDocToRecoveryAssembler;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;

@Service("gestorDocumentalAdapterManager")
public class GestorDocumentalAdapterManager implements GestorDocumentalAdapterApi, Downloader {
	
	protected static final Log logger = LogFactory.getLog(GestorDocumentalAdapterManager.class);
	public static final String TIPO_EXPEDIENTE= "OP";

	
	@Override
	public String[] getKeys() {
		return new String[]{GESTOR_DOCUMENTAL};	}
	

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
	private UtilDiccionarioApi utilDiccionarioApi;
    
    private final String GESTOR_DOCUMENTAL = "GESTOR_DOC";
    private final String TANGO_MANDAR_GESTOR_DOCUMENTAL = "Waterfall";
    
	@Override
	public List<DtoAdjunto> getAdjuntosActivo(Activo activo) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;
		String codigoEstado = Checks.esNulo(activo.getEstadoActivo()) ? null : activo.getEstadoActivo().getCodigo();
		Usuario userLogin = genericAdapter.getUsuarioLogado();	
		if (!Checks.esNulo(codigoEstado)) {
			if (!codigoEstado.equals("01") && !codigoEstado.equals("02") && !codigoEstado.equals("03")) {
				codigoEstado = "03";
			}
		} else {
			codigoEstado = "03";
		}
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo.getNumActivo().toString(), getTipoExpediente(activo), codigoEstado);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = null;
		respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
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
	
	@Override
	public Long upload(Activo activo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		String codigoEstado = Checks.esNulo(activo.getEstadoActivo()) ? null : activo.getEstadoActivo().getCodigo();
		Long respuesta = null;
		if (!Checks.esNulo(codigoEstado)) {
			if (!codigoEstado.equals("01") && !codigoEstado.equals("02") && !codigoEstado.equals("03")) {
				codigoEstado = "03";
			}
		}else{
			codigoEstado = "03";
		}
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo.getNumActivo().toString(), getTipoExpediente(activo), codigoEstado);		
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin,
				matricula);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
		respuesta = new Long(respuestaCrearDocumento.getIdDocumento());

		return respuesta;
	}
	
	@Override
	public List<DtoAdjunto> getAdjuntosGasto(String numGasto) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;		
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(numGasto, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_GASTO);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = null;
		respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);

		return list;
	}
	
	// TODO Refactorizar con metodo anterior.
	@Override
	public Long uploadDocumentoGasto(GastoProveedor gasto, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta = null;
				
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(gasto.getNumGastoHaya().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_GASTO);
		
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
		
		if(!Checks.esNulo(respuestaCrearDocumento) && !Checks.esNulo(respuestaCrearDocumento.getCodigoError())) {
			logger.debug(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
			throw new GestorDocumentalException(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
		}
		respuesta =  new Long(respuestaCrearDocumento.getIdDocumento());
		
		return respuesta;
	}

	@Override
	public FileItem getFileItem(Long idDocumento,String nombreDocumento) {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		BajaDocumentoDto login = recoveryToGestorDocAssembler.getDescargaDocumentoDto(userLogin.getUsername());
		RespuestaDescargarDocumento respuesta = null;
		FileItem fileItem = null;
		try {
			respuesta = gestorDocumentalApi.descargarDocumento(idDocumento, login,nombreDocumento);
			fileItem = GestorDocToRecoveryAssembler.getFileItem(respuesta);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception ex) {
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
		if(!Checks.esNulo(respuesta) && "".equals(respuesta.getCodigoError())) {
			return true;
		}
		return false;
		
	}

	
	@Override	
	public Integer crearGasto(GastoProveedor gasto,  String usuarioLogado) throws GestorDocumentalException {			
		
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		String fechaGasto = !Checks.esNulo(gasto.getFechaEmision()) ? formatter.format(gasto.getFechaEmision()) : "";
		String idReo = !Checks.estaVacio(gasto.getGastoProveedorActivos()) ?  gasto.getGastoProveedorActivos().get(0).getActivo().getNumActivo().toString() : "";		
		DDCartera cartera = null;
		if (gasto.getPropietario()!=null) {
			cartera = gasto.getPropietario().getCartera();
		}else{
			//si no hay propietario es sareb
			cartera = (DDCartera) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDCartera.class, DDCartera.CODIGO_CARTERA_SAREB);
			
		}
		String cliente = !Checks.estaVacio(gasto.getGastoProveedorActivos()) ?  getClienteByCartera(cartera) : "";
		
		if((Checks.esNulo(cliente) || cliente.isEmpty())) {			
			cliente = getClienteByCartera(cartera);
		}	
		
		
		String descripcionExpediente =  !Checks.esNulo(gasto.getConcepto()) ? gasto.getConcepto() :  "";
		
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearGastoDto crearGastoDto = recoveryToGestorAssembler.getCrearGastoDto(gasto.getNumGastoHaya().toString(), gasto.getNumGastoHaya().toString(), idReo, fechaGasto , cliente, descripcionExpediente, usuarioLogado);
		RespuestaCrearExpediente respuesta = null;
		
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
	public boolean modoRestClientActivado() {
		
		return gestorDocumentalApi.modoRestClientActivado();
		
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
		RespuestaDocumentosExpedientes respuesta = null;
		respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
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

	@Override
	public Long uploadDocumentoExpedienteComercial(ExpedienteComercial expedienteComercial,
			WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta = null;
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
		
		RespuestaCrearDocumento respuestaCrearDocumento = null;
		try {
			respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta = new Long(respuestaCrearDocumento.getIdDocumento());
		} catch (GestorDocumentalException gex) {
			logger.debug(gex.getMessage());
			throw gex;
		}
		return respuesta;
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
				cliente = getClienteByCartera(cartera);
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
		String tipoExpediente = TIPO_EXPEDIENTE;
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearExpedienteComercialDto crearExpedienteComercialDto = recoveryToGestorAssembler.getCrearExpedienteComercialDto(idExpedienteComercial,descripcionExpediente, username, cliente, estadoExpediente, idSistemaOrigen,codClase,tipoExpediente);
		
		RespuestaCrearExpediente respuesta = null;
		
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
	
	// Obtiene en nombre del Cliente tal y como se va a utilizar en el GD
	private String getClienteByCartera(DDCartera cartera) {
		if (cartera!=null) {
			if (DDCartera.CODIGO_CARTERA_HYT.equals(cartera.getCodigo())) {
				return DDCartera.DESCRIPCION_CARTERA_HYT;
			} else if(DDCartera.CODIGO_CARTERA_TANGO.equals(cartera.getCodigo())){
				return TANGO_MANDAR_GESTOR_DOCUMENTAL;
			}else {
				return cartera.getDescripcion();
			}
		}
		return "";
	}
	
	public void crearRelacionActivosExpediente(ExpedienteComercial expedienteComercial, Long idDocRestClient, String[] listaActivos, String login, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException {	
		
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		
		CredencialesUsuarioDto credUsu = recoveryToGestorDocAssembler.getCredencialesDto(login);
		String codigoEstado = "03"; //Hablado con Manuel Pardo
		
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(expedienteComercial.getNumExpediente().toString(), getTipoExpediente(expedienteComercial.getOferta().getActivoPrincipal()), codigoEstado);		
		
		cabecera.setIdDocumento(idDocRestClient);

		//Un vez adjuntado el documento al expediente, y obtenido el id del mismo, cread un bucle sobre el listado de activos seleccionados.
		//Llamar al servicio de vinculación entre el documento adjuntado al activo.
		String errorMessage = "";
		for (int x=0; x<listaActivos.length; x++) {
			cabecera.setIdExpedienteHaya(listaActivos[x]);
			try {
				gestorDocumentalApi.crearRelacionExpediente(cabecera,credUsu,crearRelacionExpedienteDto);
			} catch (GestorDocumentalException gex) {
				logger.debug(gex.getMessage());
				errorMessage = errorMessage + "["+listaActivos[x]+"] "+gex.getMessage() + "\n"; }
		}
		if (errorMessage.length()!=0) {
			GestorDocumentalException gex = new GestorDocumentalException(errorMessage);
			throw gex;
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
	public Long uploadDocumentoPromociones(GastoProveedor gasto, WebFileItem webFileItem, String userLogin, String matricula) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta = null;
		
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(gasto.getNumGastoHaya().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_PROMOCIONES);
		
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
		
		if(!Checks.esNulo(respuestaCrearDocumento) && !Checks.esNulo(respuestaCrearDocumento.getCodigoError())) {
			logger.debug(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
			throw new GestorDocumentalException(respuestaCrearDocumento.getCodigoError() + " - " + respuestaCrearDocumento.getMensajeError());
		}
		respuesta =  new Long(respuestaCrearDocumento.getIdDocumento());
		
		return respuesta;
	}
	
	@Override
	public List<DtoAdjunto> getAdjuntosPromociones(Long idPromocion) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idPromocion.toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_PROMOCIONES);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = null;
		respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
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
	
}