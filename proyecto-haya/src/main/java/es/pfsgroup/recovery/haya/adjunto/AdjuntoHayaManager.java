package es.pfsgroup.recovery.haya.adjunto;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.adjuntos.manager.AdjuntoManager;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.expediente.api.ExpedienteManagerApi;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
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
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.haya.contenedor.model.ContenedorGestorDocumental;
import es.pfsgroup.recovery.haya.gestorDocumental.GestorDocToRecoveryAssembler;

@Service("adjuntoManagerHayaImpl")
public class AdjuntoHayaManager extends AdjuntoManager  implements AdjuntoApi {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
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
    
    @Override
	@Transactional(readOnly = false)
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
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		List<RespuestaDocumentosExpedientes> listRespuesta = new ArrayList<RespuestaDocumentosExpedientes>();
		try {
			for(String claseExpediente : getDistinctTipoProcedimientoFromAsunto(asun)) {
				UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);
				CabeceraPeticionRestClientDto cabecera = RecoveryToGestorDocAssembler.getCabeceraPeticionRestClient(id.toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExpediente);
				DocumentosExpedienteDto docExpDto = RecoveryToGestorDocAssembler.getDocumentosExpedienteDto(usuPass);
				listRespuesta.add(gestorDocumentalServicioDocumentosApi.documentosExpediente(cabecera, docExpDto));			
			}
		} catch (GestorDocumentalException e) {
			logger.error("getAdjuntosConBorrado error: " + e);
		}
		return adjuntoAssembler.listAdjuntoGridDtoToEXTAdjuntoDto(GestorDocToRecoveryAssembler.outputDtoToAdjuntoGridDto(listRespuesta), false);
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

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		return super.getAdjuntosContratosAsu(id);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		return super.getAdjuntosPersonaAsu(id);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		return super.getAdjuntosExpedienteAsu(id);
	}

	@Override
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
				Asunto asun = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto));
				listaContenedores = getContenedoresByAsunto(asun);
				for(String claseExpe : listaContenedores) {
					RespuestaCrearDocumento respuesta = uploadGestorDoc(idAsunto, claseExpe, uploadForm);
					if(!Checks.esNulo(respuesta.getIdDocumento())) {
						break;
					}
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
		CrearDocumentoDto crearDoc = RecoveryToGestorDocAssembler.getCrearDocumentoDto(uploadForm, usuPass, uploadForm.getParameter("comboTipoFichero"));
		try {
			respuesta = gestorDocumentalServicioDocumentosApi.crearDocumento(cabecera, crearDoc);
			super.uploadDoc(uploadForm, new Long(respuesta.getIdDocumento()));
		} catch (GestorDocumentalException e) {
			logger.error("upload error: " + e);
		}
		return respuesta;
	}
	
	private String getClaseExpedienteByProcedimientoPadre(Procedimiento prc) {
		String claseExp = "";
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

	@Override
	public String uploadPersona(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return super.uploadPersona(uploadForm);
		}else{
			return null;
		}
	}

	@Override
	public String uploadExpediente(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return super.uploadExpediente(uploadForm);
		}else{
			return null;
		}
	}

	@Override
	public String uploadContrato(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return super.uploadContrato(uploadForm);
		}else{
			return null;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		return super.getAdjuntosConBorradoByPrcId(prcId);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		return super.getAdjuntosConBorradoExp(id);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		return super.getAdjuntosPersonasExp(id);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		return super.getAdjuntosContratoExp(id);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id){
		return super.getAdjuntosCntConBorrado(id);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		return super.getAdjuntosPersonaConBorrado(id);
	}
	
	@Override
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
	
	@Override
	public FileItem bajarAdjuntoExpediente(String adjuntoId, String nombre, String extension) {
		return super.bajarAdjuntoExpediente(adjuntoId, nombre, extension);
	}

	@Override
	public FileItem bajarAdjuntoContrato(String adjuntoId, String nombre, String extension) {
		return super.bajarAdjuntoContrato(adjuntoId, nombre, extension);
	}

	@Override
	public FileItem bajarAdjuntoPersona(String adjuntoId, String nombre, String extension) {
		return super.bajarAdjuntoPersona(adjuntoId, nombre, extension);
	}

	
	private  boolean tieneFuncion(Usuario usuario, String codigo) {
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil per : perfiles) {
			for (Funcion fun : per.getFunciones()) {
				if (fun.getDescripcion().equals(codigo)) {
					return true;
				}
			}
		}

		return false;
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
	 * @return 0 - Ya existe contenedor; 1 - No existe contenedor y hay que crearlo; 2 - Tipo PRC no requiere contenedor
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
	private List<String> getContenedoresByAsunto(Asunto asun) {
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		List<ContenedorGestorDocumental> listaContenedor = genericDao.getListOrdered(ContenedorGestorDocumental.class, order ,genericDao.createFilter(FilterType.EQUALS, "asunto", asun));
		List<String> listaClaseExp = new ArrayList<String>();
		
		for(ContenedorGestorDocumental contenedor : listaContenedor) {
			listaClaseExp.add(contenedor.getCodigoClase());
		}
		
		return listaClaseExp;
	}
	
}
