package es.pfsgroup.plugin.precontencioso.documento.api;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;

public interface DocumentoPCOApi {
	
		
	/**
	 * Obtiene las solicitudes de los documentos de precontencioso de un procedimiento
	 * @param idDocProcPCO
	 * @return
	 */
	List<SolicitudDocumentoPCO> getSolicitudesDocProcPCO(Long idDocProcPCO);	
	
}
