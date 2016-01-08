package es.pfsgroup.plugin.recovery.sidhiweb.api;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIIterJudicialInfo;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;

public interface SIDHIIterJudicialApi {
	
	public static final String SIDHI_BO_GET_INFO_JUCIAL_ASU = "plugin.sidhiweb.iterJudicial.getInfoJudicialAsunto";
	public static final String SIDHI_BO_GET_INFO_JUCIAL_EXP = "plugin.sidhiweb.iterJudicial.getInfoJudicialExpediente";
	public static final String SIDHI_BO_FIND_ITER_BY_IDEXPEXT = "plugin.sidhiweb.iterJudicial.findIterByIdExpedienteExterno";
	
	/**
	 * 
	 * @param dto
	 * @return devuelve las acciones judiciales relacionado con ese asunto 
	 * buscando a través del expediente
	 */
	@BusinessOperationDefinition(SIDHI_BO_GET_INFO_JUCIAL_ASU)
	Page getIterJudicialAsunto(SIDHIDtoBuscarAcciones dto);

	/**
	 * 
	 * @param dto
	 * @return devuelve las acciones judiciales relacionado con el expediente
	 * buscando a través de sus contratos
	 */
	@BusinessOperationDefinition(SIDHI_BO_GET_INFO_JUCIAL_EXP)
	Page getIterJudicialExpediente(
			SIDHIDtoBuscarAcciones dto);
	
	@BusinessOperationDefinition(SIDHI_BO_FIND_ITER_BY_IDEXPEXT)
	SIDHIIterJudicialInfo findIterByIdExpExt(Long idExpedienteExterno);

	

}
