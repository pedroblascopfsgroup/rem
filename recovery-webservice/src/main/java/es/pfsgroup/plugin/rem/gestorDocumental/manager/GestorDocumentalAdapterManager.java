package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import es.pfsgroup.plugin.rem.model.dd.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

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
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.gestorDocumental.dto.documentos.GestorDocToRecoveryAssembler;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoPromocion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.MapeoGestorDocumental;
import es.pfsgroup.plugin.rem.model.MapeoPropietarioGestorDocumental;

@Service("gestorDocumentalAdapterManager")
public class GestorDocumentalAdapterManager implements GestorDocumentalAdapterApi, Downloader {

	protected static final Log logger = LogFactory.getLog(GestorDocumentalAdapterManager.class);
	private static final String TIPO_EXPEDIENTE= "OP";
	private static final String GESTOR_DOCUMENTAL = "GESTOR_DOC";

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
	private ApplicationContext applicationContext;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;


	@Override
	public String[] getKeys() {
		return new String[]{GESTOR_DOCUMENTAL};
	}

	@Override
	public List<DtoAdjunto> getAdjuntosActivo(Activo activo) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		String codigoEstado = Checks.esNulo(activo.getEstadoActivo()) ? null : activo.getEstadoActivo().getCodigo();
		Usuario userLogin = genericAdapter.getUsuarioLogado();

		if (!Checks.esNulo(codigoEstado)) {
			if (!codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_SUELO) && !codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_EN_CURSO) &&
					!codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_TERMINADO)) {
				codigoEstado = DDEstadoActivo.ESTADO_ACTIVO_TERMINADO;
			}

		} else {
			codigoEstado = DDEstadoActivo.ESTADO_ACTIVO_TERMINADO;
		}

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo.getNumActivo().toString(), getTipoExpediente(activo), codigoEstado);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		/* if (!Checks.esNulo(respuesta.getDocumentos())) {
			ConsistenciaAdjuntosRunnableUtils caru = new ConsistenciaAdjuntosRunnableUtils(respuesta.getDocumentos(), GestorDocumentalConstants.Contenedor.Activo,userLogin.getUsername());
			launchNewTasker(caru);
		}*/

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
	public Long upload(Activo activo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		String codigoEstado = Checks.esNulo(activo.getEstadoActivo()) ? null : activo.getEstadoActivo().getCodigo();

		if (!Checks.esNulo(codigoEstado)) {
			if (!codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_SUELO) && !codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_EN_CURSO) &&
					!codigoEstado.equals(DDEstadoActivo.ESTADO_ACTIVO_TERMINADO)) {
				codigoEstado = DDEstadoActivo.ESTADO_ACTIVO_TERMINADO;
			}

		} else {
			codigoEstado = DDEstadoActivo.ESTADO_ACTIVO_TERMINADO;
		}

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo.getNumActivo().toString(), getTipoExpediente(activo), codigoEstado);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
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

		/* if (!Checks.esNulo(respuesta.getDocumentos())) {
			ConsistenciaAdjuntosRunnableUtils caru = new ConsistenciaAdjuntosRunnableUtils(respuesta.getDocumentos(), GestorDocumentalConstants.Contenedor.Gasto,userLogin.getUsername());
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
	public FileItem getFileItem(Long idDocumento,String nombreDocumento) {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		BajaDocumentoDto login = recoveryToGestorDocAssembler.getDescargaDocumentoDto(userLogin.getUsername());
		RespuestaDescargarDocumento respuesta;
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

		return !Checks.esNulo(respuesta) && "".equals(respuesta.getCodigoError());
	}

	@Override	
	public Integer crearGasto(GastoProveedor gasto,  String usuarioLogado) throws GestorDocumentalException {
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		String fechaGasto = !Checks.esNulo(gasto.getFechaEmision()) ? formatter.format(gasto.getFechaEmision()) : "";
		String idReo = !Checks.estaVacio(gasto.getGastoProveedorActivos()) ?  gasto.getGastoProveedorActivos().get(0).getActivo().getNumActivo().toString() : "";		
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

	private String getClienteByMGP(ActivoPropietario propietario) {
		
		MapeoPropietarioGestorDocumental mgp = null;
		
		if(!Checks.esNulo(propietario)) {
			mgp = genericDao.get(MapeoPropietarioGestorDocumental.class, 
					genericDao.createFilter(FilterType.EQUALS, "propietario", propietario));
		}	
		
		if(Checks.esNulo(mgp) || Checks.esNulo(mgp.getClienteGestorDocumental())) return "";
		
		return mgp.getClienteGestorDocumental();
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
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);

		/*if (!Checks.esNulo(respuesta.getDocumentos())) {
			ConsistenciaAdjuntosRunnableUtils caru = new ConsistenciaAdjuntosRunnableUtils(respuesta.getDocumentos(), GestorDocumentalConstants.Contenedor.ExpedienteComercial,userLogin.getUsername());
			launchNewTasker(caru);
		}*/

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

	public Integer crearExpedienteComercialTransactional(Long idEco, String username) throws GestorDocumentalException {
		Integer resultado = null;
		TransactionStatus transaction = null;

		try{
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			ExpedienteComercial eco = expedienteComercialApi.findOne(idEco);
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
				cliente = getClienteByCarteraySubcartera(cartera, subcartera);
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

	private String getClienteByCarteraySubcartera(DDCartera cartera, DDSubcartera subcartera) {
		if(Checks.esNulo(subcartera)) {
			return "";
		}

		MapeoGestorDocumental mgd = new MapeoGestorDocumental();

		if(!Checks.esNulo(cartera)) {
			mgd = genericDao.get(MapeoGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "cartera", cartera),
					genericDao.createFilter(FilterType.EQUALS, "subcartera", subcartera));
			
			if(Checks.esNulo(mgd.getClienteGestorDocumental())) {
				return "";
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
	public List<DtoAdjuntoPromocion> getAdjuntosPromociones(String codPromo) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler = new RecoveryToGestorDocAssembler(appProperties);
		Usuario userLogin = genericAdapter.getUsuarioLogado();
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(codPromo, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_PROMOCIONES);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto(userLogin.getUsername());
		RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
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

	/**
	 * Este método lanza un nuevo hilo de ejecución con una clase runnable pasada por parámetro para llevar a cabo labores de
	 * consistencia entre las relaciones de los documentos adjuntos en las bases de REM y los documentos localizados en el
	 * gestor documental. Establece el contexto de seguridad para la sesión en el nuevo hilo así como inicializar los autowired.
	 *
	 * @param caru: clase runnable para llevar a cabo labores de consistencia de documentos.
	 */
	private void launchNewTasker(final ConsistenciaAdjuntosRunnableUtils caru) {
		// Inicializa los elementos Autowired de la clase runnable.
		applicationContext.getAutowireCapableBeanFactory().autowireBean(caru);

		// Traslada el contexto de seguridad de Spring hacia el nuevo hilo.
		caru.setSpringSecurityContext(SecurityContextHolder.getContext());

		Thread thread = new Thread(caru);
		thread.setName("GD-CONSISTENCY-TASKER-");
		thread.setPriority(Thread.NORM_PRIORITY);
		thread.setUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {
			public void uncaughtException(Thread t, Throwable e) {
				logger.error("Error al llevar a cabo la consistencia de los documentos adjuntos para la entidad " + caru.getContenedor().toString(), e);
			}
		});
		thread.start();
	}

	@Override
	public FileItem getFileItemPromocion(Long idDocumento, String nombreDocumento) throws Exception {
		return this.getFileItem(idDocumento, nombreDocumento);
	}
}