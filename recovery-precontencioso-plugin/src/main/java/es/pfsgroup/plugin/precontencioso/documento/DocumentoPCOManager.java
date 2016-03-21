package es.pfsgroup.plugin.precontencioso.documento;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.dao.BienDao;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.documento.api.DocumentoPCOApi;
import es.pfsgroup.plugin.precontencioso.documento.assembler.DocumentoAssembler;
import es.pfsgroup.plugin.precontencioso.documento.dao.DocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.dao.SolicitudDocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentosUGPCODto;
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
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienEntidad;
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
    private ProcedimientoDao procedimientoDao;
    
	@Autowired
	ProcedimientoManager procedimientoManager;
  
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private SolicitudDocumentoPCODao solicituddocumentopcodao;
    
    @Autowired
	private GestorDespachoDao gestorDespachoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
    private UsuarioManager usuarioManager; 
	
    private final Log logger = LogFactory.getLog(getClass());
    private static SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");

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
	public List<DocumentoPCO> getDocumentosPorIdProcedimientoPCO(Long idProcedimientoPCO, Long idTipoDocumento){
    	List<DocumentoPCO> documentos = documentoPCODao.getDocumentosPorIdProcedimientoPCO(idProcedimientoPCO, idTipoDocumento);

		return documentos;
		
	};
	
    /**
	 * Obtiene los documentos de un procedimientoPCO No descartados
	 * 
	 * @param idProcPCO
	 * @return
	 */
    @Override
	public List<DocumentoPCO> getDocumentosPorIdProcedimientoPCONoDescartados(Long idProcedimientoPCO){
    	List<DocumentoPCO> documentos = documentoPCODao.getDocumentosPorIdProcedimientoPCONoDescartados(idProcedimientoPCO);

		return documentos;
		
	};
	
	@Override
	public List<DocumentoPCO> getDocumentosOrdenadosByUnidadGestion(List<DocumentoPCO> listDocPco) {
		List<DocumentoPCO> list = new ArrayList<DocumentoPCO>();
		List<Long> idsUndGestContrato = new ArrayList<Long>();
		List<Long> idsUndGestPersonas = new ArrayList<Long>();
		List<Long> idsUndGestBienes = new ArrayList<Long>();
		List<Contrato> contratos = new ArrayList<Contrato>();
		List<Persona> personas = new ArrayList<Persona>();
		List<NMBBienEntidad> bienes = new ArrayList<NMBBienEntidad>();
		
		for(DocumentoPCO docPco : listDocPco) {
			if (docPco.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.CONTRATOS)){
				idsUndGestContrato.add(docPco.getUnidadGestionId());
			}
			if (docPco.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.PERSONAS)){
				idsUndGestPersonas.add(docPco.getUnidadGestionId());
			}
			if (docPco.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.BIENES)){
				idsUndGestBienes.add(docPco.getUnidadGestionId());
			}
		}
		
		if(!Checks.estaVacio(idsUndGestContrato)) {
			contratos = documentoPCODao.getContratosByIdsOrderByDesc(convertirListLongToString(idsUndGestContrato));			
		}
		if(!Checks.estaVacio(idsUndGestPersonas)) {
			personas = documentoPCODao.getPersonasByIdsOrderByDesc(convertirListLongToString(idsUndGestPersonas));			
		}
		if(!Checks.estaVacio(idsUndGestBienes)) {
			bienes = documentoPCODao.getBienesByIdsOrderByDesc(convertirListLongToString(idsUndGestBienes));			
		}
		
		for(Contrato contrato : contratos){
			for(DocumentoPCO doc : listDocPco) {
				if(doc.getUnidadGestionId().equals(contrato.getId())) {
					list.add(doc);
				}
			}
		}
		
		for(Persona persona : personas){
			for(DocumentoPCO doc : listDocPco) {
				if(doc.getUnidadGestionId().equals(persona.getId())) {
					list.add(doc);
				}
			}
		}
		
		for(NMBBienEntidad bien : bienes){
			for(DocumentoPCO doc : listDocPco) {
				if(doc.getUnidadGestionId().equals(bien.getId())) {
					list.add(doc);
				}
			}
		}		
		
		if(bienes.size() != idsUndGestBienes.size()) {
			for(Long datoLong : idsUndGestBienes) {
				boolean existe = false;
				for(NMBBienEntidad bEnt : bienes) {
					if(bEnt.getId().equals(datoLong)){
						existe = true;
					}
				}
				if(!existe) {
					for(DocumentoPCO doc : listDocPco) {
						if(doc.getId().equals(datoLong)){
							list.add(doc);
						}
					}
				}
			}
		}
		
		return list;
	}
	
	private String convertirListLongToString(List<Long> longs) {
		String string = "";
		for(int i=0; i<longs.size(); i++) {
			string += longs.get(i);
			if(i < longs.size()-1){
				string += ",";				
			}
		}
		return string;
	}
	
	/**
	 * Crea un DTO de la solicitud a partir del documento y de la solicitud
	 * @param documento
	 * @param solicitud
	 * @return
	 */
	public SolicitudDocumentoPCODto crearSolicitudDocumentoDto(DocumentoPCO documento, SolicitudDocumentoPCO solicitud, 
																	boolean esDocumento, boolean tieneSolicitud){
		SolicitudDocumentoPCODto solDto=null;
		DDSiNo siNo;
		String descripcionUG = null;
		String ugIdDto = null;
		NMBBienEntidad bienEntidad;
		// Dependiendo del tipo unidad gestion (Contrato, Persona o Bien) hay que obtener los datos de forma diferente
		if (documento.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.CONTRATOS)){
			ugIdDto = contratoDao.get(documento.getUnidadGestionId()).getNroContrato();			//documento.getUnidadGestionId()+"";
			descripcionUG = contratoDao.get(documento.getUnidadGestionId()).getTipoProductoEntidad().getDescripcion();			
		}
		if (documento.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.PERSONAS)){
			ugIdDto = personaDao.get(documento.getUnidadGestionId()).getDocId();
			descripcionUG = personaDao.get(documento.getUnidadGestionId()).getNom50();
			
		}
		if (documento.getUnidadGestion().getCodigo().equals(DDUnidadGestionPCO.BIENES)){
			bienEntidad = genericDao.get(NMBBienEntidad.class, genericDao.createFilter(FilterType.EQUALS, "id", documento.getUnidadGestionId()));
			if (bienEntidad != null)
				ugIdDto = "Finca: "+bienEntidad.getNumFinca();					//documento.getUnidadGestionId()+"";
			else
				ugIdDto = "Finca: ";
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
				
		solDto = DocumentoAssembler.docAndSolEntityToSolicitudDto(documento, solicitud, ugIdDto, descripcionUG, 
																	esDocumento, tieneSolicitud, siNo, siNoNoAplica, documento.getId());
		
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
	 * Cambiar estado documento
	 * 
	 * @param idDocumento
	 * @param codigoEstado
	 * 
	 */
	@Override
	@Transactional(readOnly = false)	
	public void cambiarEstadoDocumento(Long idDocumento, String codigoEstado) {
		DocumentoPCO documento = documentoPCODao.get(idDocumento);
		DDEstadoDocumentoPCO estadoDocumento = (DDEstadoDocumentoPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoDocumentoPCO.class, codigoEstado);

		documento.setEstadoDocumento(estadoDocumento);
		
		documentoPCODao.saveOrUpdate(documento);
	}
	
	/**
	 * Anular solicitudes asociadas
	 * 
	 * @param idSolicitud
	 */
	@Override
	@Transactional(readOnly = false)	
	public void anularSolicitudes(Long idSolicitud, Long idDocumento){
		SolicitudDocumentoPCO solicitud = genericDao.get(SolicitudDocumentoPCO.class, genericDao.createFilter(FilterType.EQUALS, "id", idSolicitud));
		
		genericDao.deleteById(SolicitudDocumentoPCO.class, idSolicitud);
		
		// Si era la última solicitud del documento -> Cambiar el estado a PENDIENTE SOLICITAR		
		DocumentoPCO documento = documentoPCODao.get(idDocumento); 
		documento.getSolicitudes().remove(solicitud);
		documentoPCODao.saveOrUpdate(documento);
		if (documento.getSolicitudes().size() == 0){
			cambiarEstadoDocumento(idDocumento, DDEstadoDocumentoPCO.PENDIENTE_SOLICITAR);			
		}
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
		if(!Checks.esNulo(docDto.getProvinciaNotario())){
			DDProvincia provincia = genericDao.get(
					DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", docDto.getProvinciaNotario()));
			documento.setProvinciaNotario(provincia);
		}

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
		
		GestorDespacho gestDespActor = obtenerGestorDespacho(solDto);
		if (gestDespActor != null) {
			solicitud.setActor(gestDespActor);
		}
		
		solicitud.setFechaSolicitud(solDto.getFechaSolicitud());
		solicitud.setFechaResultado(solDto.getFechaResultado());
		solicitud.setFechaEnvio(solDto.getFechaEnvio());
		solicitud.setFechaRecepcion(solDto.getFechaRecepcion());
		
		//Se registra el usd_id del solicitante
		if(!Checks.esNulo(usuarioManager)){
			List<GestorDespacho> listaGestorDespacho = gestorDespachoDao.getGestorDespachoByUsuId(usuarioManager.getUsuarioLogado().getId());
			if(!Checks.esNulo(listaGestorDespacho.get(0))){
				solicitud.setSolicitante(listaGestorDespacho.get(0));
			}
		}
		
		if(!Checks.esNulo(solDto.getResultado())){ 
			DDResultadoSolicitudPCO resSolPco = genericDao.get(DDResultadoSolicitudPCO.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", solDto.getResultado()));
			solicitud.setResultadoSolicitud(resSolPco);
		}
		
		///Obtenemos el tipo de gestor para setear el codigo de actor que corresponde a ese gestor
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, 
				genericDao.createFilter(FilterType.EQUALS, "id", solDto.getIdTipoGestor()));
		DDTipoActorPCO tipoActorPco = genericDao.get(DDTipoActorPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "codigo", tipoGestor.getCodigo()));
		solicitud.setTipoActor(tipoActorPco);
		
		genericDao.save(SolicitudDocumentoPCO.class,solicitud);
		cambiarEstadoDocumento(documento.getId(), DDEstadoDocumentoPCO.SOLICITADO);
		return solicitud;
	}
	
	/** 
	 * Obtiene la lista de tipos de Documentos
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List<DDTipoFicheroAdjunto> getTiposDocumento(){
		List<DDTipoFicheroAdjunto> tiposDocumento = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionarioSinBorrado(DDTipoFicheroAdjunto.class);
		
		return tiposDocumento;
	}
	
	/** 
	 * Obtiene la lista de Unidades de Gestión
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List<DDUnidadGestionPCO> getUnidadesGestion(){
		List<DDUnidadGestionPCO> tiposUG = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionarioSinBorrado(DDUnidadGestionPCO.class);
		
		return tiposUG;
	}
	
	/** 
	 * Obtiene la lista de Provincias
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List<DDProvincia> getProvincias(){
		List<DDProvincia> listaProvincias = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionarioSinBorrado(DDProvincia.class);
		
		return listaProvincias;
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
	 * Crea un documento
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
			if(!Checks.esNulo(docDto.getFechaEscritura()))
				documento.setFechaEscritura(webDateFormat.parse(docDto.getFechaEscritura()));
		} catch (ParseException e) {
			logger.error("saveCrearDocumento fecha: " + e);
		}	
		
		DDTipoFicheroAdjunto tipoDocumento = genericDao.get(
				DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", docDto.getTipoDocumento()));
		documento.setTipoDocumento(tipoDocumento);
		
		if(!Checks.esNulo(docDto.getProvinciaNotario())){
			DDProvincia provincia = genericDao.get(
					DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", docDto.getProvinciaNotario()));
			documento.setProvinciaNotario(provincia);
		}
		
		DDUnidadGestionPCO unidadGestion = genericDao.get(
				DDUnidadGestionPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", docDto.getTipoUG())); 
		documento.setUnidadGestion(unidadGestion);
		
		documento.setUnidadGestionId(docDto.getId());
		
		DDEstadoDocumentoPCO estadoDocumento = genericDao.get(
				DDEstadoDocumentoPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumentoPCO.PENDIENTE_SOLICITAR)); 
		documento.setEstadoDocumento(estadoDocumento);

		ProcedimientoPCODTO procPCODto = proxyFactory.proxy(ProcedimientoPcoApi.class).getPrecontenciosoPorProcedimientoId(docDto.getIdProc());

		ProcedimientoPCO procPCO = genericDao.get(
				ProcedimientoPCO.class, genericDao.createFilter(FilterType.EQUALS, "id", procPCODto.getId()));
		
		documento.setProcedimientoPCO(procPCO);
			
		try {
			genericDao.save(DocumentoPCO.class, documento);
		} catch (Exception e) {
			logger.error("saveCrearDocumento: "+ e);
		}
	}
	

	/**
	 * Guardar los datos informados en la solicitud
	 * 
	 * @param dto
	 * 
	 */
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
		

//		if (!Checks.esNulo(dto.getActor())) {
//			Usuario usuario = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getActor()));
//			//solicitud.setActor(usuario);
//		}
		
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
	
	/**
	 * Helper Method - editar
	 * Recupera el GestorDespacho 
	 *
	 * @param liquidacionDto contiene los datos usu_id y des_id para realizar la busqueda del gestordespacho
	 * @return
	 */
	private GestorDespacho obtenerGestorDespacho(final SolicitudPCODto solDto) {
		Long usuarioId = Long.parseLong(solDto.getActor());
		Long despachoId = solDto.getIdDespachoExterno();

		GestorDespacho gestorDespacho = null;
		if (usuarioId != null && despachoId != null) {
			gestorDespacho = gestorDespachoDao.getGestorDespachoPorUsuarioyDespacho(usuarioId, despachoId);
		}

		return gestorDespacho;
	}

	/**
	 * Obtiene la lista de contratos, personas o bienes a mostrar en la
	 * pantalla de Incluir documentos
	 * 
	 * @param idProcedimiento
	 * @param codUG
	 * 
	 * @return Lista de documentos a mostrar en el doble combo
	 * 
	 */
	@SuppressWarnings("rawtypes")
	public List<DocumentosUGPCODto> getDocumentosUG(Long idProcedimiento,String codUG) {
		List<DocumentosUGPCODto> documentosUG = new ArrayList<DocumentosUGPCODto>(); 
		DocumentosUGPCODto docUG;
		Iterator it;
		Map.Entry e;
		
		// CONTRATOS y PERSONAS
		if (codUG.equals(DDUnidadGestionPCO.CONTRATOS) || codUG.equals(DDUnidadGestionPCO.PERSONAS)){
			Procedimiento procedimiento = procedimientoDao.get(new Long(idProcedimiento));
			List<ExpedienteContrato> procedimientos = procedimiento.getExpedienteContratos();
			Contrato contrato;
			Persona persona;
			HashMap<Long, Contrato> contratoH = new HashMap<Long, Contrato>();
			HashMap<Long, Persona> personaH = new HashMap<Long, Persona>();
			List<ContratoPersona> contratoPersonas;
			
			// Procesamos para no tener contratos y personas	 repetidos
			for (ExpedienteContrato expCnt : procedimientos){
				contratoH.put(expCnt.getContrato().getId(), expCnt.getContrato());
				
				// Por cada contrato averiguamos las personas
				contratoPersonas = expCnt.getContrato().getContratoPersona();
				for (ContratoPersona cntPer : contratoPersonas){
					personaH.put(cntPer.getPersona().getId(), cntPer.getPersona());
				}
			}
			
			// Procesar CONTRATOS
			if (codUG.equals(DDUnidadGestionPCO.CONTRATOS)){
				it = contratoH.entrySet().iterator();
				while (it.hasNext()) {
					e = (Map.Entry)it.next();
					contrato = (Contrato)e.getValue();
					docUG = new DocumentosUGPCODto();
					docUG.setId(contrato.getId());
					docUG.setContrato(contrato.getNroContrato());
					docUG.setUnidadGestionId(DDUnidadGestionPCO.CONTRATOS);
					docUG.setDescripcionUG(contrato.getTipoProductoEntidad().getDescripcion());			
					documentosUG.add(docUG);
				}
			}
						
			// Procesar PERSONAS
			if (codUG.equals(DDUnidadGestionPCO.PERSONAS)){
				it = personaH.entrySet().iterator();
				while (it.hasNext()) {
					e = (Map.Entry)it.next();
					persona = (Persona)e.getValue();
					docUG = new DocumentosUGPCODto();
					docUG.setId(persona.getId());
					docUG.setContrato(persona.getDocId());
					docUG.setUnidadGestionId(DDUnidadGestionPCO.PERSONAS);
					docUG.setDescripcionUG(persona.getNom50());			
					documentosUG.add(docUG);
				}		
			}
		}
			
		// BIENES
		if (codUG.equals(DDUnidadGestionPCO.BIENES)){
			List<Bien> bienes = procedimientoManager.getBienesDeUnProcedimiento(idProcedimiento);
			HashMap<Long, Bien> bienH = new HashMap<Long, Bien>();
			
			// Procesamos los bienes para no obtenerlos repetidos
			for (Bien bien: bienes){
				bienH.put(bien.getId(), bien);			
			}		
			Bien bienf;
			NMBBienEntidad bienEntidad;
			it = bienH.entrySet().iterator();
			while (it.hasNext()) {
				e = (Map.Entry)it.next();
				bienf = (Bien)e.getValue();
				bienEntidad = genericDao.get(NMBBienEntidad.class, genericDao.createFilter(FilterType.EQUALS, "id", bienf.getId()));				
				docUG = new DocumentosUGPCODto();
				docUG.setId(bienf.getId());
				docUG.setContrato("Finca: "+bienEntidad.getNumFinca());
				docUG.setUnidadGestionId(DDUnidadGestionPCO.BIENES);
				docUG.setDescripcionUG(bienf.getDescripcionBien());			
				documentosUG.add(docUG);
			}
		}
	
		return documentosUG;
	}
	
	@Override
	@BusinessOperation(PCO_VALIDAR_DOCUMENTO_UNICO)
	public boolean validarDocumentoUnico(String undGest, String tipoDoc, String protocolo, String notario){
		DDTipoFicheroAdjunto tipoDocumento = genericDao.get(
				DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDoc));
		
		undGest = undGest.substring(1, undGest.length()-1);
		StringTokenizer stIdUG = new StringTokenizer(undGest,",");
	
		while (stIdUG.hasMoreElements()){
			String tipoUG = stIdUG.nextToken();
			tipoUG = tipoUG.substring(1, tipoUG.length()-1);
			DDUnidadGestionPCO unidadGestion = genericDao.get(
					DDUnidadGestionPCO.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoUG));
			
			List<DocumentoPCO> listDocPco = genericDao.getList(DocumentoPCO.class, 
					genericDao.createFilter(FilterType.EQUALS, "tipoDocumento", tipoDocumento),
					genericDao.createFilter(FilterType.EQUALS, "unidadGestion", unidadGestion),
					genericDao.createFilter(FilterType.EQUALS, "protocolo", protocolo),
					genericDao.createFilter(FilterType.EQUALS, "notario", notario),
					genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		
			if(listDocPco != null && listDocPco.size() > 0) {
				return true;
			}
		}
		return false;
	}
	
	@Override
	@BusinessOperation(PCO_DOCUMENTO_BY_ID)
	public DocumentoPCO getDocumentoPCOById(Long idDocPCO){
		return documentoPCODao.get(idDocPCO);
	}

	@Override
	public Boolean esTipoGestorConAcceso(EXTDDTipoGestor tipoGestor) {
		List<DDTipoActorPCO> listActoresConAcceso = documentoPCODao.getTipoActoresConAcceso();
		for (DDTipoActorPCO tipoActor : listActoresConAcceso) {
			if (tipoActor.getCodigo().equals(tipoGestor.getCodigo())) {
				return true;
			}
		}

		return false;
	}
	
	@Override
	public List<GestorDespacho> getGestorDespachoByUsuIdAndTipoDespacho(Long usuId, String tipoDespachoExterno) {
		
		return gestorDespachoDao.getGestorDespachoByUsuIdAndTipoDespacho(usuId, tipoDespachoExterno);
		
	}
	
}
