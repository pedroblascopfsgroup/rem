package es.pfsgroup.plugin.recovery.masivo.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDocumentoPendienteDto;
import es.pfsgroup.plugin.recovery.masivo.model.documentacionPendiente.MSVDocumentoPendienteGenerar;

public interface MSVDocumentoPendienteGenerarApi {
	
	public static final String MSV_BO_ALTA_DOCUMENTO_PENDIENTE_PROCESAR = "es.pfsgroup.plugin.recovery.masivo.api.MSVDocumentoPendienteGenerarApi.crearNuevoDocumentoPendiente";
	public static final String MSV_BO_MODIFICAR_DOCUMENTO_PENDIENTE_PROCESAR = "es.pfsgroup.plugin.recovery.masivo.api.MSVDocumentoPendienteGenerarApi.modificarDocumentoPendiente";
	public static final String MSV_BO_GET_DOCUMENTO_PENDIENTE_PROCESAR_BY_ID = "es.pfsgroup.plugin.recovery.masivo.api.MSVDocumentoPendienteGenerarApi.getDocumentoPendienteById";
	public static final String MSV_BO_GET_DOCUMENTO_PENDIENTE_PROCESAR_BY_IDTOKEN = "es.pfsgroup.plugin.recovery.masivo.api.MSVDocumentoPendienteGenerarApi.getDocumentoPendienteByIdToken";
	
	
	@BusinessOperationDefinition(MSV_BO_ALTA_DOCUMENTO_PENDIENTE_PROCESAR)
	MSVDocumentoPendienteGenerar crearNuevoDocumentoPendiente (MSVDocumentoPendienteDto dto);

	@BusinessOperationDefinition(MSV_BO_MODIFICAR_DOCUMENTO_PENDIENTE_PROCESAR)
	void modificarDocumentoPendiente(MSVDocumentoPendienteDto dto);
	
	@BusinessOperationDefinition(MSV_BO_GET_DOCUMENTO_PENDIENTE_PROCESAR_BY_ID)
	MSVDocumentoPendienteGenerar getDocumentoPendienteById (Long id);
	
	@BusinessOperationDefinition(MSV_BO_GET_DOCUMENTO_PENDIENTE_PROCESAR_BY_IDTOKEN)
	MSVDocumentoPendienteGenerar getDocumentoPendienteByToken (Long idToken);
}
