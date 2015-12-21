//package es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc;
//
//import es.capgemini.devon.pagination.Page;
//import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
//
//public interface SIDHIAccionNoProcApi {
//	
//	public static final String SIDHI_BO_FIND_ACCIONES_NOPROC_ASU = "plugin.sidhiweb.accionNoProc.findAccionesNoProcByAsu";
//	public static final String SIDHI_BO_FIND_ACCIONES_NOPROC_EXP = "plugin.sidhiweb.accionNoProc.findAccionesNoProcByExp";
//
//	@BusinessOperationDefinition(SIDHI_BO_FIND_ACCIONES_NOPROC_ASU)
//	Page getAccionesNoProcAsunto(SIDHIDtoBuscarAcciones dto);
//
//	@BusinessOperationDefinition(SIDHI_BO_FIND_ACCIONES_NOPROC_EXP)
//	Page getAccionesNoProcExpediente(SIDHIDtoBuscarAcciones dto);
//
//}
