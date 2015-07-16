package es.pfsgroup.plugin.precontencioso.documento;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.precontencioso.documento.api.DocumentoPCOApi;
import es.pfsgroup.plugin.precontencioso.documento.assembler.DocumentoAssembler;
import es.pfsgroup.plugin.precontencioso.documento.dao.DocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.dao.SolicitudDocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDUnidadGestionPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.assembler.LiquidacionAssembler;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDEstadoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
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
    private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
    private final Log logger = LogFactory.getLog(getClass());



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
	public SolicitudDocumentoPCODto crearSolicitudDocumentoDto(DocumentoPCO documento, SolicitudDocumentoPCO solicitud){
		SolicitudDocumentoPCODto solDto=null;
		
		solDto = DocumentoAssembler.docAndSolEntityToSolicitudDto(documento, solicitud);
		
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
		
		DocumentoPCODto docDto = DocumentoAssembler.docEntityToDocumentoDto(documento);
		
		return docDto;		
	};	
	
	/**
	 * Excluir un documentoPCO y sus solicitudes asociadas
	 * 
	 * @param idDocumentoPCO
	 */
	public void excluirDocumentosPorIdDocumentoPCO(Long idDocumentoPCO){
		//documentoPCODao.removeDocumentoPCOPorId(idDocumentoPCO);	
	}
	
	/**
	 * Descartar documentos (cambiar a estado Descartado)
	 */
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
		//docDto.setFechaEscritura(webRequest.getParameter("fechaEscritura"));
		documento.setAsiento(docDto.getAsiento());
		documento.setFinca(docDto.getFinca());
		documento.setTomo(docDto.getTomo());
		documento.setLibro(docDto.getLibro());
		documento.setFolio(docDto.getFolio());
		documento.setNroFinca(docDto.getNumFinca());
		documento.setNroRegistro(docDto.getNumRegistro());
		//docDto.setPlaza(webRequest.getParameter("plaza"));
		documento.setIdufir(docDto.getIdufir());

		documentoPCODao.saveOrUpdate(documento);
	}
	
	/**
	 * crearSolicitudesDocumento
	 * 
	 */
	public void saveCrearSolicitudes(SolicitudPCODto solDto){
		SolicitudDocumentoPCO solicitud = new SolicitudDocumentoPCO();
		DocumentoPCO documento = documentoPCODao.get(solDto.getIdDoc());
		
		solicitud.setDocumento(documento);
		//solicitud.setActor(actor);
		solicitud.setFechaSolicitud(solDto.getFechaSolicitud());
		
		genericDao.save(SolicitudDocumentoPCO.class,solicitud);
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
	public DDUnidadGestionPCO getUnidadGestionPorIdUG(Long idUnidadGestion){
		DDUnidadGestionPCO tipoUG = (DDUnidadGestionPCO)proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDUnidadGestionPCO.class, idUnidadGestion);
		
		return tipoUG;
	}
	
	/**
	 * Obtiene un Tipo de Documento
	 * 
	 * @param idTipoDocumento
	 * 
	 * @return TipoDocumento
	 */	
	public DDTipoFicheroAdjunto getTipoDocumentoPorIdTipo(Long idTipoDocumento){
		DDTipoFicheroAdjunto tipoDocumento = (DDTipoFicheroAdjunto)proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDTipoFicheroAdjunto.class, idTipoDocumento);
		
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
	public void saveCrearDocumento(DocumentoPCO documento){
		documentoPCODao.save(documento);
	};

 }
