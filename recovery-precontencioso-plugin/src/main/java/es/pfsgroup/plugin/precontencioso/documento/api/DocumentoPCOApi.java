package es.pfsgroup.plugin.precontencioso.documento.api;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDUnidadGestionPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

public interface DocumentoPCOApi {
	
		
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
	 * @param idUnidadGestion
	 * @return
	 */
	DDUnidadGestionPCO getUnidadGestionPorIdUG(Long idUnidadGestion);	
	
	/**
	 * Devuelve una unidad de gestión
	 * 
	 * @param idUnidadGestion
	 * @return
	 */
	DDTipoFicheroAdjunto getTipoDocumentoPorIdTipo(Long idTipoDocumento);	
	
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
	void saveCrearDocumento(DocumentoPCO documento);
}
