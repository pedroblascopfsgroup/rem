package es.pfsgroup.plugin.recovery.sidhiweb.api.hitoIter;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;

public interface SIDHIHitoIterApi {

	public static final String SIDHI_BO_HITO_FINDHITOBYASUNTO = "plugin.sidhiweb.hitoIter.getHitosAsunto";
	public static final String SIDHI_BO_HITO_FINDHITOBYEXPEDIENTE="plugin.sidhiweb.hitoIter.getHitosExpediente";
	
	@BusinessOperationDefinition(SIDHI_BO_HITO_FINDHITOBYASUNTO)
	Page getHitosAsunto(SIDHIDtoBuscarAcciones dto);

	@BusinessOperationDefinition(SIDHI_BO_HITO_FINDHITOBYEXPEDIENTE)
	Page getHitosExpediente(SIDHIDtoBuscarAcciones dto);

}
