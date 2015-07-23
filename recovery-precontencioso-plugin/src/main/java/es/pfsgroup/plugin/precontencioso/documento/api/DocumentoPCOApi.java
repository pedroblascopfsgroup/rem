package es.pfsgroup.plugin.precontencioso.documento.api;

import java.util.List;

import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentosUGPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SaveInfoSolicitudDTO;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDUnidadGestionPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

public interface DocumentoPCOApi {
	
	static final String PCO_DOCUMENTO_SOLICITUD_INFORMAR = "es.pfsgroup.plugin.precontencioso.documento.saveInformarSolicitud";
	static final String PCO_DOCUMENTO_CREAR = "es.pfsgroup.plugin.precontencioso.documento.saveCrearDocumento";
		
	/**
	 * Obtiene las solicitudes de los documentos de precontencioso de un procedimiento
	 * 
	 * @param idDocProcPCO
	 * @return lista 
	 */
	List<SolicitudDocumentoPCO> getSolicitudesDocProcPCO(Long idDocProcPCO);	
	
	/**
	 * Obtiene los documentos de un procedimientoPCO
	 * 
	 * @param idProcPCO
	 * @return
	 */
	List<DocumentoPCO> getDocumentosPorIdProcedimientoPCO(Long idProcPCO);
	
	/**
	 * Crea un DTO de la solicitud a partir del documento y de la solicitud
	 * @param documento
	 * @param solicitud
	 * @param esDocumento
	 * 
	 * @return
	 */
	SolicitudDocumentoPCODto crearSolicitudDocumentoDto(DocumentoPCO documento, SolicitudDocumentoPCO solicitud, boolean esDocumento);
	
	/**
	 * Obtiene el DTO de un documentoPCO
	 * 
	 * @param idDocPCO
	 * @return
	 */
	DocumentoPCODto getDocumentoPorIdDocumentoPCO(Long idDocPCO);
	
	/**
	 * Excluir (borrar) un documento y sus solicitudes asociadas
	 * 
	 * @param idDocumento
	 */
	void excluirDocumentosPorIdDocumentoPCO(Long idDocumento);
	
	/**
	 * Descartar documentos (cambiar a estado descartado)
	 * 
	 * @param idDocumento
	 * 
	 */
	void descartarDocumentos(Long idDocumento);
	
	/**
	 * Edita un documento 
	 * 
	 * @param DTO documento
	 */
	void editarDocumento(DocumentoPCODto docDto);
	
	/**
	 * Crea una solicitud a un documento 
	 * 
	 * @param DTO documento
	 */
	void saveCrearSolicitudes(SolicitudPCODto solDto);	
	
	/**
	 * Devuelve los tipos de documentos
	 * 
	 */
	List<DDTipoFicheroAdjunto> getTiposDocumento();
	
	/**
	 * Devuelve los tipos de documentos
	 * 
	 */
	List<DDUnidadGestionPCO> getUnidadesGestion();	
	
	/**
	 * Devuelve una unidad de gestión
	 * @param codUnidadGestion
	 * @return
	 */
	DDUnidadGestionPCO getUnidadGestionPorCodUG(String codUnidadGestion);	
	
	/**
	 * Devuelve una unidad de gestión
	 * 
	 * @param idUnidadGestion
	 * @return
	 */
	DDTipoFicheroAdjunto getTipoDocumentoPorCodTipo(String codTipoDocumento);	
	
	/**
	 * Obtener el estado a partir del código
	 * 
	 * @param codigoEstado
	 * @return
	 */
	DDEstadoDocumentoPCO getEstadoDocumentoPorCodigo(String codigoEstado);
	
	/**
	 * Crea un documento con sus solicitudes
	 * 
	 * @param documento
	 */
	void saveCrearDocumento(DocumentoPCODto docDTO);

	/**
	 * Guarda la información de una solicitud (después de Informar Solicitud)
	 * 
	 * @param dto
	 */
	@BusinessOperationDefinition(PCO_DOCUMENTO_SOLICITUD_INFORMAR)
	void saveInformarSolicitud(SaveInfoSolicitudDTO dto);
	
	/**
	 * Obtener los contratos, personsas y bienes asocidado al procedimiento
	 * 
	 * @param idProcedimiento
	 * @param codUG
	 * 
	 */
	List<DocumentosUGPCODto> getDocumentosUG(Long idProcedimiento, String codUG);
}
