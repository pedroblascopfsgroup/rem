package es.pfsgroup.plugin.precontencioso.documento;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.dao.BienDao;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.documento.api.DocumentoPCOApi;
import es.pfsgroup.plugin.precontencioso.documento.assembler.DocumentoAssembler;
import es.pfsgroup.plugin.precontencioso.documento.dao.DocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.dao.SolicitudDocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SaveInfoSolicitudDTO;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDResultadoSolicitudPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDSiNoNoAplica;
import es.pfsgroup.plugin.precontencioso.documento.model.DDTipoActorPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDUnidadGestionPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;


/**
 * Servicio para los documentos de precontencioso.
 * @author amompo
 */
@Service
public class DocumentoPCOManager implements DocumentoPCOApi {

    @Autowired
    private DocumentoPCODao documentoPCODao;
    
    @Autowired
    private ContratoDao contratoDao;    
    
    @Autowired
    private PersonaDao personaDao;  
    
    @Autowired
    private BienDao bienDao;  
  
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private SolicitudDocumentoPCODao solicituddocumentopcodao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
    private final Log logger = LogFactory.getLog(getClass());
    private static SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");
    private static String ZERO_VALUE = "0";



    /**
     * Devolvemos todas las solicitudes de los documentos de un 
     * procedimiento de precontenciosos
     * 
     * @param idProcPCO Long
     * @return list documentosPCODTO
     */
    //@BusinessOperation(ExternaBusinessOperation.BO_PCO_SOLICITUDES_DOC_PROC)
    public List<SolicitudDocumentoPCO> getSolicitudesDocProcPCO(Long idProcPCO) {
        logger.debug("Obteniendo solicitudes doc PCO del documento" + idProcPCO);
        List<SolicitudDocumentoPCO> solicitudesPCO = new ArrayList<SolicitudDocumentoPCO>();
        List<SolicitudDocumentoPCO> solicitudes = new ArrayList<SolicitudDocumentoPCO>();
        
        // Primero obtenemos la lista de documentos de dicho procedimienot
        List<DocumentoPCO> docsPCO = new ArrayList<DocumentoPCO>();
        docsPCO = documentoPCODao.getDocumentosProc(idProcPCO);
        
        // Por cada documento obtenemos la lista de solicitudes
		for (DocumentoPCO doc : docsPCO) {
			solicitudesPCO = documentoPCODao.getSolicitudesDoc(doc.getId());
			solicitudes.addAll(solicitudesPCO);
		}
		
        return solicitudes;
    }
    
    /**
	 * Obtiene los documentos de un procedimientoPCO
	 * 
	 * @param idProcPCO
	 * @return
	 */
    @Override
	public List<DocumentoPCO> getDocumentosPorIdProcedimientoPCO(Long idProcedimientoPCO){
    	List<DocumentoPCO> documentos = documentoPCODao.getDocumentosPorIdProcedimientoPCO(idProcedimientoPCO);

		return documentos;
		
	};
	
	
	/**
	 * Crea un DTO de la solicitud a partir del documento y de la solicitud
	 * @param documento
	 * @param solicitud
	 * @return
	 */
	public SolicitudDocumentoPCODto crearSolicitudDocumentoDto(DocumentoPCO documento, SolicitudDocumentoPCO solicitud, boolean esDocumento){
		SolicitudDocumentoPCODto solDto=null;
		DDSiNo siNo;
		String descripcionUG = null;
		String ugIdDto = null;
		// Dependiendo del tipo unidad gestion (Contrato, Persona o Bien) hay que obtener los datos de forma diferente
		if (documento.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.CONTRATOS)){
			ugIdDto = documento.getUnidadGestionId()+"";
			descripcionUG = contratoDao.get(documento.getUnidadGestionId()).getTipoProductoEntidad().getDescripcion();			
		}
		if (documento.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.PERSONAS)){
			ugIdDto = personaDao.get(documento.getUnidadGestionId()).getDocId();
			descripcionUG = personaDao.get(documento.getUnidadGestionId()).getNom50();
			
		}
		if (documento.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.BIENES)){
			ugIdDto = documento.getUnidadGestionId()+"";
			descripcionUG = bienDao.get(documento.getUnidadGestionId()).getDescripcionBien();
		}
		
		if (documento.getAdjuntado())
			siNo = (DDSiNo) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSiNo.class, DDSiNo.SI);
		else
			siNo = (DDSiNo) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSiNo.class, DDSiNo.NO);
				
		Long codigoEjecutivo = documento.getEjecutivo();
		DDSiNoNoAplica siNoNoAplica = null;
		if (!Checks.esNulo(codigoEjecutivo)) {
			siNoNoAplica = (DDSiNoNoAplica) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDSiNoNoAplica.class, codigoEjecutivo);
		}
				
		solDto = DocumentoAssembler.docAndSolEntityToSolicitudDto(documento, solicitud, ugIdDto, descripcionUG, esDocumento, siNo, siNoNoAplica);
		
		return solDto;
	};
	
	/**
	 * Obtiene el DTO de un documentoPCO
	 * 
	 * @param idDocPCO
	 * @return
	 */
	public DocumentoPCODto getDocumentoPorIdDocumentoPCO(Long idDocPCO){
		DocumentoPCO documento = documentoPCODao.get(idDocPCO);

		DDSiNo siNo;
		if (documento.getAdjuntado())
			siNo = (DDSiNo) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSiNo.class, DDSiNo.SI);
		else
			siNo = (DDSiNo) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSiNo.class, DDSiNo.NO);

		Long codigoEjecutivo = documento.getEjecutivo();
		DDSiNoNoAplica siNoNoAplica = null;
		if (!Checks.esNulo(codigoEjecutivo)) {
			siNoNoAplica = (DDSiNoNoAplica) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDSiNoNoAplica.class, codigoEjecutivo);
		}

		DocumentoPCODto docDto = DocumentoAssembler.docEntityToDocumentoDto(documento, siNo, siNoNoAplica);
		
		return docDto;		
	};	
	
	/**
	 * Excluir un documentoPCO y sus solicitudes asociadas
	 * 
	 * @param idDocumentoPCO
	 */
	@Override
	@Transactional(readOnly = false)	
	public void excluirDocumentosPorIdDocumentoPCO(Long idDocumentoPCO){
		DocumentoPCO documento = documentoPCODao.get(idDocumentoPCO);
		List<SolicitudDocumentoPCO> solicitudes = documento.getSolicitudes();
		
		// Primero borramos las solicitudes del documento
		for (SolicitudDocumentoPCO sol : solicitudes) {
			genericDao.deleteById(SolicitudDocumentoPCO.class, sol.getId());
		}
			
		// Borramos el documento
		genericDao.deleteById(DocumentoPCO.class, idDocumentoPCO);
	}
	
	/**
	 * Descartar documentos (cambiar a estado Descartado)
	 */
	@Override
	@Transactional(readOnly = false)	
	public void descartarDocumentos(Long idDocumentoPCO){
		DocumentoPCO documento = documentoPCODao.get(idDocumentoPCO);
		DDEstadoDocumentoPCO estadoDocumento = (DDEstadoDocumentoPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoDocumentoPCO.class, DDEstadoDocumentoPCO.DESCARTADO);

		documento.setEstadoDocumento(estadoDocumento);
		
		documentoPCODao.saveOrUpdate(documento);
	}
	
	/**
	 * Editar un documento
	 * 
	 * @param docDto
	 * 
	 */
	@Transactional(readOnly = false)
	public void editarDocumento(DocumentoPCODto docDto) {
		DocumentoPCO documento = documentoPCODao.get(docDto.getId());

		documento.setId(docDto.getId());
		documento.setProtocolo(docDto.getProtocolo());
		documento.setNotario(docDto.getNotario());
		try {
			documento.setFechaEscritura(webDateFormat.parse(docDto.getFechaEscritura()));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		documento.setAsiento(docDto.getAsiento());
		documento.setFinca(docDto.getFinca());
		documento.setTomo(docDto.getTomo());
		documento.setLibro(docDto.getLibro());
		documento.setFolio(docDto.getFolio());
		documento.setNroFinca(docDto.getNumFinca());
		documento.setNroRegistro(docDto.getNumRegistro());
		documento.setPlaza(docDto.getPlaza());
		documento.setIdufir(docDto.getIdufir());

		documentoPCODao.saveOrUpdate(documento);
	}
	
	/**
	 * crearSolicitudesDocumento
	 * 
	 */
	@BusinessOperation(PCO_DOCUMENTO_CREAR_SOLICITUDES)
	@Transactional(readOnly = false)
	public SolicitudDocumentoPCO saveCrearSolicitudes(SolicitudPCODto solDto){
		SolicitudDocumentoPCO solicitud = new SolicitudDocumentoPCO();
		DocumentoPCO documento = documentoPCODao.get(solDto.getIdDoc());
		
		solicitud.setDocumento(documento);
		solicitud.setActor(genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(solDto.getActor()))));
		solicitud.setFechaSolicitud(solDto.getFechaSolicitud());
		solicitud.setFechaResultado(solDto.getFechaResultado());
		solicitud.setFechaEnvio(solDto.getFechaEnvio());
		solicitud.setFechaRecepcion(solDto.getFechaRecepcion());
		solicitud.setResultadoSolicitud(genericDao.get(DDResultadoSolicitudPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", solDto.getResultado())));
		
		///Obtenemos el tipo de gestor para setear el codigo de actor que corresponde a ese gestor
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "id", solDto.getIdTipoGestor()));
		solicitud.setTipoActor(genericDao.get(DDTipoActorPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoGestor.getCodigo())));
		
		Auditoria.save(solicitud);
		
		//genericDao.save(SolicitudDocumentoPCO.class,solicitud);
		try{
			solicituddocumentopcodao.save(solicitud);	
		}catch(Exception e){
			System.out.println(e);
		}
		
		
		return solicitud;

	}
	
	/** 
	 * Obtiene la lista de tipos de Documentos
	 * 
	 */
	public List<DDTipoFicheroAdjunto> getTiposDocumento(){
		List<DDTipoFicheroAdjunto> tiposDocumento = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionarioSinBorrado(DDTipoFicheroAdjunto.class);
		
		return tiposDocumento;
	}
	
	/** 
	 * Obtiene la lista de Unidades de Gestión
	 * 
	 */
	public List<DDUnidadGestionPCO> getUnidadesGestion(){
		List<DDUnidadGestionPCO> tiposUG = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionarioSinBorrado(DDUnidadGestionPCO.class);
		
		return tiposUG;
	}	
	
	/**
	 * Obtiene una Unidad de gestión
	 * 
	 * @param idUnidadGestion
	 * 
	 * @return UnidadGestion
	 */	
	public DDUnidadGestionPCO getUnidadGestionPorCodUG(String codUnidadGestion){
		DDUnidadGestionPCO tipoUG = (DDUnidadGestionPCO)proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDUnidadGestionPCO.class, codUnidadGestion);
		
		return tipoUG;
	}
	
	/**
	 * Obtiene un Tipo de Documento
	 * 
	 * @param codTipoDocumento
	 * 
	 * @return TipoDocumento
	 */	
	public DDTipoFicheroAdjunto getTipoDocumentoPorCodTipo(String codTipoDocumento){
		DDTipoFicheroAdjunto tipoDocumento = (DDTipoFicheroAdjunto)proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoFicheroAdjunto.class, codTipoDocumento);
		
		return tipoDocumento;
	}	
	
	/**
	 * Obtiene un Estado de documento a partir del código
	 * 
	 * @param codigoEstado
	 * 
	 * @return EstadoDocumento
	 */	
	public DDEstadoDocumentoPCO getEstadoDocumentoPorCodigo(String codigoEstado){
		DDEstadoDocumentoPCO estadoDocumento = (DDEstadoDocumentoPCO)proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoDocumentoPCO.class, codigoEstado);
		
		return estadoDocumento;
	}
	
	/**
	 * Crea un documento con sus solicitudes
	 * 
	 * @param documento
	 */
	@Override
	@Transactional(readOnly = false)
	public void saveCrearDocumento(DocumentoPCODto docDto){
			
		DocumentoPCO documento = new DocumentoPCO();
		documento.setAdjuntado(false);
		documento.setAsiento(docDto.getAsiento());
		documento.setFinca(docDto.getFinca());
		documento.setFolio(docDto.getFolio());
		documento.setIdufir(docDto.getIdufir());
		documento.setLibro(docDto.getLibro());
		documento.setNotario(docDto.getNotario());
		documento.setNroFinca(docDto.getNumFinca());
		documento.setNroRegistro(docDto.getNumRegistro());
		documento.setProtocolo(docDto.getProtocolo());
		documento.setTomo(docDto.getTomo());
		documento.setPlaza(docDto.getPlaza());
		try {
			documento.setFechaEscritura(webDateFormat.parse(docDto.getFechaEscritura()));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		
		DDTipoFicheroAdjunto tipoDocumento = genericDao.get(
				DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", docDto.getTipoDocumento()));
		documento.setTipoDocumento(tipoDocumento);
		
		
		DDUnidadGestionPCO unidadGestion = genericDao.get(
				DDUnidadGestionPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", docDto.getTipoUG())); 
		documento.setUnidadGestion(unidadGestion);
		
		documento.setUnidadGestionId(new Long(docDto.getContrato()));
		
		DDEstadoDocumentoPCO estadoDocumento = genericDao.get(
				DDEstadoDocumentoPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumentoPCO.PENDIENTE_SOLICITAR)); 
		documento.setEstadoDocumento(estadoDocumento);
		
		// Crear la solicitud primera
		SolicitudDocumentoPCO solicitud =new SolicitudDocumentoPCO();
		
		///////////////////////////////////////////////
		// TODO - DATOS PROVISIONALES
		GestorDespacho usuario = genericDao.get(GestorDespacho.class, genericDao.createFilter(FilterType.EQUALS, "id", new Long(1)));
		solicitud.setActor(usuario);
		
		DDResultadoSolicitudPCO resultadoSolicitud = genericDao.get(
				DDResultadoSolicitudPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "OK"));
		
		solicitud.setResultadoSolicitud(resultadoSolicitud);
		
		DDTipoActorPCO tipoActor = genericDao.get(
				DDTipoActorPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", docDto.getTipoActor()));
		solicitud.setTipoActor(tipoActor);
		
		Auditoria.save(solicitud);
		
		solicitud.setDocumento(documento);
		
		List<SolicitudDocumentoPCO> solicitudes = new ArrayList<SolicitudDocumentoPCO>();
		
		solicitudes.add(solicitud);
		
		documento.setSolicitudes(solicitudes);
		
		ProcedimientoPCO procPCO = genericDao.get(
				ProcedimientoPCO.class, genericDao.createFilter(FilterType.EQUALS, "id", new Long(1)));
		
		documento.setProcedimientoPCO(procPCO);
		///////////////////// FIN DATOS PROVISIONALES //////////////
	
			
		try {
			genericDao.save(DocumentoPCO.class, documento);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("Error: "+e);
		}
	}

	@Override
	@BusinessOperation(PCO_DOCUMENTO_SOLICITUD_INFORMAR)
	@Transactional(readOnly = false)
	public void saveInformarSolicitud(SaveInfoSolicitudDTO dto) {

		DocumentoPCO documento = documentoPCODao.get(Long.valueOf(dto.getIdDoc()));
		
		DDEstadoDocumentoPCO estadoDocumento = genericDao.get(
				DDEstadoDocumentoPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstado()));
		documento.setEstadoDocumento(estadoDocumento);
		documento.setAdjuntado(DDSiNo.SI.equals(dto.getAdjuntado()));
		documento.setEjecutivo(dto.getEjecutivo());
		documento.setObservaciones(dto.getComentario());
		genericDao.save(DocumentoPCO.class, documento);

		SolicitudDocumentoPCO solicitud = null;
		for (SolicitudDocumentoPCO sol : documento.getSolicitudes()) {
			if (sol.getId().equals(Long.valueOf(dto.getIdSolicitud()))) {
				solicitud = sol;
				break;
			}
		}
		
		if (!Checks.esNulo(dto.getActor())) {
			Usuario usuario = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getActor()));
			solicitud.setActor(usuario);
		}
		
		
		solicitud.setFechaResultado(dto.getFechaResultado());
		DDResultadoSolicitudPCO resultadoSolicitud = genericDao.get(
				DDResultadoSolicitudPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getResultado()));;
		
		solicitud.setResultadoSolicitud(resultadoSolicitud);
		
	    solicitud.setFechaEnvio(dto.getFechaEnvio());
	    
	    solicitud.setFechaRecepcion(dto.getFechaRecepcion());
		genericDao.save(SolicitudDocumentoPCO.class, solicitud);

		
	}

	@Override
	@BusinessOperation(PCO_DOCUMENTO_GET_TIPOS_GESTORES_ACTORES)
	public List<EXTDDTipoGestor> getTiposGestorActores() {
		return solicituddocumentopcodao.getTiposGestorActores();
	}

 }
