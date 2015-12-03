package es.pfsgroup.plugin.precontencioso.documento.api;

import java.util.List;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
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
	static final String PCO_DOCUMENTO_CREAR_SOLICITUDES = "es.pfsgroup.plugin.precontencioso.documento.saveCrearSolicitudes";
	static final String PCO_DOCUMENTO_GET_TIPOS_GESTORES_ACTORES = "es.pfsgroup.plugin.precontencioso.documento.getTiposGestorActores";
	static final String PCO_DOCUMENTO_CREAR = "es.pfsgroup.plugin.precontencioso.documento.saveCrearDocumento";
	static final String PCO_VALIDAR_DOCUMENTO_UNICO = "es.pfsgroup.plugin.precontencioso.documento.validarDocumentoUnico";
	static final String PCO_DOCUMENTO_BY_ID = "es.pfsgroup.plugin.precontencioso.documento.getDocumentoPCOById";
		
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
	SolicitudDocumentoPCODto crearSolicitudDocumentoDto(DocumentoPCO documento, SolicitudDocumentoPCO solicitud, 
															boolean esDocumento, boolean tieneSolicitud, int idIdentificativo);
	
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
	 * Cambiar estado Documento )
	 * 
	 * @param idDocumento
	 * @param codigoEstado
	 * 
	 */
	void cambiarEstadoDocumento(Long idDocumento, String codigoEstado);
	
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
	@BusinessOperationDefinition(PCO_DOCUMENTO_CREAR_SOLICITUDES)
	SolicitudDocumentoPCO saveCrearSolicitudes(SolicitudPCODto solDto);	
	
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

	/**
	 * Recupera la lista de tipos de gestores que son actores
	 * 
	 */
	@BusinessOperationDefinition(PCO_DOCUMENTO_GET_TIPOS_GESTORES_ACTORES)
	List<EXTDDTipoGestor> getTiposGestorActores();
	
	/**
	 * Anular solicitudes (borrar)
	 * 
	 * @param idSolicitud
	 * @param idDocumento
	 * 
	 */
	void anularSolicitudes(Long idSolicitud, Long idDocumento);	
	
	@BusinessOperationDefinition(PCO_VALIDAR_DOCUMENTO_UNICO)
	boolean validarDocumentoUnico(String undGest, String tipoDoc, String protocolo, String notario);

	List<DocumentoPCO> getDocumentosOrdenadosByUnidadGestion(List<DocumentoPCO> listDocPco);
	
	@BusinessOperationDefinition(PCO_DOCUMENTO_BY_ID)
	DocumentoPCO getDocumentoPCOById(Long idDocPCO);

	/**
	 * Comprueba si es un tipo de gestor con acceso a recovery mediante la tabla de actores del documentos (DDTipoActorPCO)
	 * 
	 * @param idTipoDespacho
	 * @return
	 */
	Boolean esTipoGestorConAcceso(EXTDDTipoGestor tipoGestor);
}
