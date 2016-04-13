package es.pfsgroup.recovery.adjunto.haya;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.expediente.api.ExpedienteManagerApi;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearPropuestaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.RecoveryToGestorExpAssembler;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.IdentificacionDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;
import es.pfsgroup.plugin.gestordocumental.api.GestorDocumentalServicioDocumentosApi;
import es.pfsgroup.plugin.gestordocumental.api.GestorDocumentalServicioExpedientesApi;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.RecoveryToGestorDocAssembler;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.UsuarioPasswordDto;
import es.pfsgroup.procedimientos.context.HayaProjectContext;
import es.pfsgroup.recovery.adjunto.AdjuntoAssembler;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.adjunto.dao.EXTAdjuntoAsuntoDao;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.haya.contenedor.model.ContenedorGestorDocumental;
import es.pfsgroup.recovery.haya.gestorDocumental.GestorDocToRecoveryAssembler;
import es.pfsgroup.tipoFicheroAdjunto.MapeoTipoFicheroAdjunto;

@Component
public class AdjuntoHayaManager {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	
	@Autowired
	private GenericABMDao genericdDao;
	
	@Autowired
    private Executor executor;
    
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GestorDocumentalApi gestorDocumentalApi;
	
	@Autowired
	private GestorDocumentalServicioDocumentosApi gestorDocumentalServicioDocumentosApi;
	
	@Autowired
	private GestorDocumentalServicioExpedientesApi gestorDocumentalServicioExpedientesApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteManagerApi expedienteManagerApi;
	
	@Autowired
	private AdjuntoAssembler adjuntoAssembler;
	
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
	@Autowired
	private HayaProjectContext hayaProjectContext;    
	
	@Autowired
	private EXTAdjuntoAsuntoDao extAdjuntoAsuntoDao;
	
    @Resource
    Properties appProperties;
	
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
    	Asunto asun = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
   		
        for(Procedimiento prc : asun.getProcedimientos()) {
    			if( buscarTPRCsinContenedor(prc)) {
    				//Si entra, este procedimiento requiere un contenedor y no existe.
    				//AQUI LA LLAMADA A crearPropuesta
    				
    				String idAsunto=asun.getId().toString();
    	    		String claseExpe = hayaProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
    				UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);
    	    		CrearPropuestaDto crearPropuesta = RecoveryToGestorExpAssembler.getCrearPropuestaDto(idAsunto, claseExpe, usuPass);
    	    		
    	    		try {
    					RespuestaCrearExpediente respuesta = gestorDocumentalServicioExpedientesApi.crearPropuesta(crearPropuesta);
    					insertarContenedor(respuesta.getIdExpediente(), asun, claseExpe);
    				} catch (GestorDocumentalException e) {
    					e.printStackTrace();
    				}
    			}
    		}
    		List<Integer> idsDocumento = new ArrayList<Integer>();
    		try {
    			for(String claseExpediente : getDistinctTipoProcedimientoFromAsunto(asun)) {
    				UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);
    				CabeceraPeticionRestClientDto cabecera = RecoveryToGestorDocAssembler.getCabeceraPeticionRestClient(id.toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExpediente);
    				DocumentosExpedienteDto docExpDto = RecoveryToGestorDocAssembler.getDocumentosExpedienteDto(usuPass);
    				RespuestaDocumentosExpedientes respuesta = gestorDocumentalServicioDocumentosApi.documentosExpediente(cabecera, docExpDto);
    				for(IdentificacionDocumento idenDoc : respuesta.getDocumentos()) {
    						idsDocumento.add(idenDoc.getIdentificadorNodo());
    				}
    			}
    		} catch (GestorDocumentalException e) {
    			logger.error("getAdjuntosConBorrado error: " + e);
    		}
    		
    		if(Checks.esNulo(idsDocumento) || Checks.estaVacio(idsDocumento)) {
    			return null;
    		}
    		Set<AdjuntoAsunto> list = extAdjuntoAsuntoDao.getAdjuntoAsuntoByIdDocumentoAndPrcId(idsDocumento, null);
    		List<EXTAdjuntoDto> adjuntosAsunto = new ArrayList<EXTAdjuntoDto>();
    		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
    		adjuntosAsunto.addAll(creaObjetosEXTAsuntos(list, usuario, false));
    		return adjuntosAsunto;
	}

    private void insertarContenedor(Integer idExpediente, Asunto asun, String claseExp) {
    	ContenedorGestorDocumental contenedor = new ContenedorGestorDocumental();
		contenedor.setIdExterno(new Long(idExpediente));
		contenedor.setAsunto(asun);
		contenedor.setCodigoTipo(GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS);
		contenedor.setCodigoClase(claseExp);
		Auditoria.save(contenedor);
		genericDao.save(ContenedorGestorDocumental.class, contenedor);
		
    }
    
    private List<String> getDistinctTipoProcedimientoFromAsunto(Asunto asun) {
    	List<String> listTipoProcedimiento = new ArrayList<String>();
    	for (Procedimiento prc : asun.getProcedimientos()) {
    		String claseExpe = hayaProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
    		if(!listTipoProcedimiento.contains(claseExpe) && !Checks.esNulo(claseExpe)) {
    			listTipoProcedimiento.add(claseExpe);
    		}
    	}
    	return listTipoProcedimiento;
    }

	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		return null;
//		return super.getAdjuntosContratosAsu(id);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		return null;
//		return super.getAdjuntosPersonaAsu(id);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		return null;
//		return super.getAdjuntosExpedienteAsu(id);
	}

	public String upload(WebFileItem uploadForm) {
		
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){			
			Long idAsunto = Long.parseLong(uploadForm.getParameter("id"));
			Procedimiento prc = null;
			String claseExp = "";
			List<String> listaContenedores = null;
			if (!Checks.esNulo(uploadForm.getParameter("prcId"))){
				Long idProcedimiento = Long.parseLong(uploadForm.getParameter("prcId"));
				prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento));
				claseExp = getClaseExpedienteByProcedimientoPadre(prc);
				uploadGestorDoc(idAsunto, claseExp, uploadForm);
			}else{
				boolean contenedorEncontrado = false;
				listaContenedores = getContenedoresByAsunto(idAsunto);
				//Contenedores adecuados segun el combo elegido - ELIMINADO ESTE FILTRO DE CRUCE
				//listaContenedores = contenedoresAdecuadosYOrdenados(uploadForm, listaContenedores);				
				for(String claseExpe : listaContenedores) {
					if(!Checks.esNulo(claseExpe)) {
						RespuestaCrearDocumento respuesta = uploadGestorDoc(idAsunto, claseExpe, uploadForm);
						if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getIdDocumento())) {
							contenedorEncontrado = true;
							break;
						}
					}
				}
				
				if(!contenedorEncontrado) {
					return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR;
				}
			}
		}
		return null;
	}
	
	private RespuestaCrearDocumento uploadGestorDoc(Long idAsunto, String claseExp, WebFileItem uploadForm) {
		RespuestaCrearDocumento respuesta = null;
		CabeceraPeticionRestClientDto cabecera = RecoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idAsunto.toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExp);	
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), usuario.getUsername());
		CrearDocumentoDto crearDoc = RecoveryToGestorDocAssembler.getCrearDocumentoDto(uploadForm, usuPass, obtenerMatricula(GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExp, uploadForm.getParameter("comboTipoFichero")));
		try {
			respuesta = gestorDocumentalServicioDocumentosApi.crearDocumento(cabecera, crearDoc);
			uploadDoc(uploadForm, new Long(respuesta.getIdDocumento()));
		} catch (GestorDocumentalException e) {
			logger.error("upload error: " + e);
		}
		return respuesta;
	}
	
	private String obtenerMatricula(String tipoExp, String claseExp, String tipoFichero){
		StringBuilder sb = new StringBuilder();
		MapeoTipoFicheroAdjunto mapeo = genericDao.get(MapeoTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "tipoFichero.codigo", tipoFichero));
		if(!Checks.esNulo(mapeo)){
			sb.append(tipoExp);
			sb.append("-");
			sb.append(claseExp);
			sb.append("-");
			sb.append(mapeo.getTipoFicheroExterno());
		}
		return sb.toString();
	}
	
	private String getClaseExpedienteByProcedimientoPadre(Procedimiento prc) {
		String claseExp = hayaProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
		Procedimiento padre = prc.getProcedimientoPadre();
		while(Checks.esNulo(claseExp)) {
			if(hayaProjectContext.getMapaClasesExpeGesDoc().get(padre.getTipoProcedimiento().getCodigo()) == null){
				padre = padre.getProcedimientoPadre();
			}else{
				claseExp = hayaProjectContext.getMapaClasesExpeGesDoc().get(padre.getTipoProcedimiento().getCodigo());
			}
		}
		return claseExp;
	}

	public String uploadPersona(WebFileItem uploadForm) {
		return null;
//		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
//			return super.uploadPersona(uploadForm);
//		}else{
//			return null;
//		}
	}

	public String uploadExpediente(WebFileItem uploadForm) {
		return null;
//		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
//			return super.uploadExpediente(uploadForm);
//		}else{
//			return null;
//		}
	}

	public String uploadContrato(WebFileItem uploadForm) {
		return null;
//		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
//			return super.uploadContrato(uploadForm);
//		}else{
//			return null;
//		}
	}

	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
		if( buscarTPRCsinContenedor(prc)) {
			//Si entra, este procedimiento requiere un contenedor y no existe.
			//AQUI LA LLAMADA A crearPropuesta
			String idAsunto=prc.getAsunto().getId().toString();
    		String claseExpe = hayaProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
			UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);
    		CrearPropuestaDto crearPropuesta = RecoveryToGestorExpAssembler.getCrearPropuestaDto(idAsunto, claseExpe, usuPass);
    		
    		try {
				RespuestaCrearExpediente respuesta = gestorDocumentalServicioExpedientesApi.crearPropuesta(crearPropuesta);
				insertarContenedor(respuesta.getIdExpediente(), prc.getAsunto(), claseExpe);
			} catch (GestorDocumentalException e) {
				e.printStackTrace();
			}
		}
		List<Integer> idsDocumento = new ArrayList<Integer>();
		try {
			String claseExpediente = getClaseExpedienteByProcedimientoPadre(prc);
			UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);
			CabeceraPeticionRestClientDto cabecera = RecoveryToGestorDocAssembler.getCabeceraPeticionRestClient(prc.getAsunto().getId().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExpediente);
			DocumentosExpedienteDto docExpDto = RecoveryToGestorDocAssembler.getDocumentosExpedienteDto(usuPass);
			RespuestaDocumentosExpedientes respuesta = gestorDocumentalServicioDocumentosApi.documentosExpediente(cabecera, docExpDto);
			for(IdentificacionDocumento idenDoc : respuesta.getDocumentos()) {
				idsDocumento.add(idenDoc.getIdentificadorNodo());
			}
		} catch (GestorDocumentalException e) {
			logger.error("getAdjuntosConBorradoByPrcId error: " + e);
		}
		if(Checks.esNulo(idsDocumento) || Checks.estaVacio(idsDocumento)) {
			return null;
		}
		Set<AdjuntoAsunto> list = extAdjuntoAsuntoDao.getAdjuntoAsuntoByIdDocumentoAndPrcId(idsDocumento, prcId);
		List<EXTAdjuntoDto> adjuntosAsunto = new ArrayList<EXTAdjuntoDto>();
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		adjuntosAsunto.addAll(creaObjetosEXTAsuntos(list, usuario, false));
		return adjuntosAsunto;
	}

	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		return null;
//		return super.getAdjuntosConBorradoExp(id);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		return null;
//		return super.getAdjuntosPersonasExp(id);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		return null;
//		return super.getAdjuntosContratoExp(id);
	}

	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id){
		return null;
//		return super.getAdjuntosCntConBorrado(id);
	}

	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		return null;
//		return super.getAdjuntosPersonaConBorrado(id);
	}
	
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId, String nombre, String extension) {
		RespuestaDescargarDocumento respuesta = null;
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), usuario.getUsername());
		try {
			respuesta = gestorDocumentalServicioDocumentosApi.descargarDocumento(Long.valueOf(adjuntoId), usuPass);
		} catch (NumberFormatException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		} catch (GestorDocumentalException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		}
		try {
			return GestorDocToRecoveryAssembler.getFileItem(respuesta);
		} catch (IOException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		}
		return null;
	}
	
	public FileItem bajarAdjuntoExpediente(String adjuntoId, String nombre, String extension) {
		return null;
//		return super.bajarAdjuntoExpediente(adjuntoId, nombre, extension);
	}

	public FileItem bajarAdjuntoContrato(String adjuntoId, String nombre, String extension) {
		return null;
//		return super.bajarAdjuntoContrato(adjuntoId, nombre, extension);
	}

	public FileItem bajarAdjuntoPersona(String adjuntoId, String nombre, String extension) {
		return null;
//		return super.bajarAdjuntoPersona(adjuntoId, nombre, extension);
	}

	public String altaDocumento(Long idEntidad, String tipoEntidadGrid, String tipoDocumento, WebFileItem uploadForm){
		return gestorDocumentalApi.altaDocumento(idEntidad, tipoEntidadGrid, tipoDocumento, uploadForm);
	}
	
	public FileItem recuperacionDocumento(String id, String nombre, String extension){
		String ficheroBase64 = gestorDocumentalApi.recuperacionDocumento(id);
		try {
			return generaFileItem(nombre, ficheroBase64, extension);
		} catch (Throwable e) {
			logger.error("RecuperacionDocumento error: " + e);
		}
		return new FileItem();
	}
	
	private FileItem generaFileItem(String nombreFichero, String contenido, String extension) throws Throwable {
		logger.info("Recupera documento generaFileItem...");
		String nomFichero = "nomFichero";
		String ext = nombreFichero.substring(nombreFichero.lastIndexOf(".")+1);
		
		File fileSalidaTemporal = null;
		FileItem resultado = null;
		InputStream stream =  new ByteArrayInputStream(Base64.decodeBase64(contenido.getBytes()));
		
		fileSalidaTemporal = File.createTempFile(nomFichero, "."+ext);
		fileSalidaTemporal.deleteOnExit();
		
		resultado = new FileItem();
		resultado.setFileName(nomFichero + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "."+ext);
		if(Checks.esNulo(extension)) {
			resultado.setContentType("");			
		}else{
			resultado.setContentType(extension);
		}
		resultado.setFile(fileSalidaTemporal);
        OutputStream outputStream = resultado.getOutputStream(); // Last step is to get FileItem's output stream, and write your inputStream in it. This is the way to write to your FileItem.
        int read = 0;
		byte[] bytes = new byte[1024];

		while ((read = stream.read(bytes)) != -1) {
			outputStream.write(bytes, 0, read);
		}

		outputStream.close();
		logger.info("Finaliza generaFileItem...");
		return resultado;
		
	}
	
	private String getUsuarioGestorDocumental() {
		Parametrizacion parametro = proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.GESTOR_DOCUMENTAL_REST_CLIENT_USUARIO);
		return parametro.getValor();
	}
	
	private String getPasswordGestorDocumental() {
		Parametrizacion parametro = proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.GESTOR_DOCUMENTAL_REST_CLIENT_PASSWORD);
		return parametro.getValor();
	}
	
	/**
	 * Busca si NO hay contenedor para el tipo de prc.
	 * @param prc
	 *  @return false - No se ha de crear contenedor ||| true - Hay que crear un contenedor para el TIPO de prc
	 */
	public boolean buscarTPRCsinContenedor(Procedimiento prc) {
		
		boolean resultado = false;
		
		String claseExpe = hayaProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
		if(Checks.esNulo(claseExpe) || claseExpe=="")
		{
			//Para este tipo de procedimiento no se requiere contendor
			return false;
		}
		ContenedorGestorDocumental contenedor = genericDao.get(ContenedorGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "asunto", prc.getAsunto()), genericDao.createFilter(FilterType.EQUALS, "codigoClase", claseExpe));
		
		if(Checks.esNulo(contenedor)) {
			//Se requiere contenedor y no existe actualmente
			resultado = true;
		}
		
		return resultado;		
	}
	
	/**
	 * Devuelve un lista de la clase de expediente que contiene el asunto ordenada por su fecha de creación
	 * @param asu
	 * @return
	 */
	private List<String> getContenedoresByAsunto(Long idAsunto) {
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		List<ContenedorGestorDocumental> listaContenedor = genericDao.getListOrdered(ContenedorGestorDocumental.class, order ,genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto));
		List<String> listaClaseExp = new ArrayList<String>();
		
		for(ContenedorGestorDocumental contenedor : listaContenedor) {
			listaClaseExp.add(contenedor.getCodigoClase());
		}
		
		return listaClaseExp;
	}
	
	private Set<EXTAdjuntoDto> creaObjetosEXTAsuntos(final Set<AdjuntoAsunto> adjuntos, final Usuario usuario, final Boolean borrarOtrosUsu) {
		if (adjuntos == null)
			return null;

		HashSet<EXTAdjuntoDto> result = new HashSet<EXTAdjuntoDto>();

		for (final AdjuntoAsunto aa : adjuntos) {
			EXTAdjuntoDto dto = new EXTAdjuntoDto() {
				@Override
				public Boolean getPuedeBorrar() {
					if (borrarOtrosUsu || aa.getAuditoria().getUsuarioCrear().equals(usuario.getUsername())) {
						return true;
					} else {
						return false;
					}
				}

				@Override
				public AdjuntoAsunto getAdjunto() {
					return (AdjuntoAsunto) aa;
				}

				@Override
				public String getTipoDocumento() {
					if (aa instanceof EXTAdjuntoAsunto) {
						if (((EXTAdjuntoAsunto) aa).getTipoFichero() != null)
							return ((EXTAdjuntoAsunto) aa).getTipoFichero().getDescripcion();
						else
							return "";
					} else
						return "";

				}

				@Override
				public Long prcId() {
					if (aa instanceof EXTAdjuntoAsunto) {
						if(((EXTAdjuntoAsunto) aa).getProcedimiento() != null)
							return ((EXTAdjuntoAsunto) aa).getProcedimiento().getId();
						else 
							return null;
					}
					else 
						return null;
				}

				@Override
				public String getRefCentera() {
					if(aa.getServicerId() != null) {
						return aa.getServicerId().toString();
					}
					return null;
				}

				@Override
				public String getNombreTipoDoc() {
					// TODO Auto-generated method stub
					return null;
				}
			};
			result.add(dto);
		}
		return result;
	}
	
	public String uploadDoc(WebFileItem uploadForm, Long idDocumento) {
		String comboTipoFichero = uploadForm.getParameter("comboTipoFichero");
		
		FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero est� vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }
        
        logger.info(fileItem.getFileName() + ": " + fileItem.getContentType());
        
        Integer max = getLimiteFichero(Parametrizacion.LIMITE_FICHERO_ASUNTO);

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(Long.parseLong(uploadForm.getParameter("id")));
        
        EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(fileItem);
        
        if (!Checks.esNulo(comboTipoFichero) && !comboTipoFichero.equals("")) {
			DDTipoFicheroAdjunto tipoFicheroAdjunto = genericdDao.get(DDTipoFicheroAdjunto.class, genericdDao.createFilter(FilterType.EQUALS, "codigo", comboTipoFichero));
			adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
		}
		
        adjuntoAsunto.setAsunto(asunto);
		
		//En caso de que estemos añadiendo un adjunto desde el propio procedimiento
        if (!Checks.esNulo(uploadForm.getParameter("prcId"))) {
			Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(Long.parseLong(uploadForm.getParameter("prcId")));
	        if(!Checks.esNulo(procedimiento)){
				adjuntoAsunto.setProcedimiento(procedimiento);
			}
        }
        // Id del documento del gestor documental
        adjuntoAsunto.setServicerId(idDocumento);
        
        Auditoria.save(adjuntoAsunto);
		asunto.getAdjuntos().add(adjuntoAsunto);

		proxyFactory.proxy(AsuntoApi.class).saveOrUpdateAsunto(asunto);

        return null;
		
	}
	
	 private Integer getLimiteFichero(String limite) {
	        try {
	            Parametrizacion param = (Parametrizacion) executor.execute(
	                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, limite);
	            return Integer.valueOf(param.getValor());
	        } catch (Exception e) {
	            logger.warn("No esta parametrizado el l�mite m�ximo del fichero en bytes para asuntos, se toma un valor por defecto (2Mb)");
	            return new Integer(2 * 1024 * 1024);
	        }
	    }
	
}
