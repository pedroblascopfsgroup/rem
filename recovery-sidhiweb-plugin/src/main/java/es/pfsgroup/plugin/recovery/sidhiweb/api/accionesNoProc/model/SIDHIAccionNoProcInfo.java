//package es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model;
//
//import java.util.Date;
//
//import es.capgemini.pfs.contrato.model.Contrato;
//import es.capgemini.pfs.persona.model.DDTipoPersona;
//import es.capgemini.pfs.persona.model.DDTipoTelefono;
//import es.capgemini.pfs.persona.model.Persona;
//import es.capgemini.pfs.users.domain.Usuario;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIIterJudicialInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIEstadoProcesal;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHISubestadoProcesal;
//
//public interface SIDHIAccionNoProcInfo {
//
//	 Long getIdAccion();
//	 String getGestor();
//	 Usuario getUsuario();
//	 DDTipoPersona getTipoPersona();
//	 String getCodigoPersona();
//	 Persona getPersona();
//	 DDTipoTelefono getTipoTelefono();
//	 String getNumeroTelefono();
//	 String getObservaciones();
//	 SIDHIIterJudicialInfo getIterJudicial();
//	 Contrato getContrato();
//	 SIDHIEstadoProcesal getEstadoProcesal();
//	 SIDHISubestadoProcesal getSubEstadoProcesal();
//	 SIDHIDDSubTipoAccionNoProcInfo getSubtipoAccionNoProc();
//	 SIDHIDDTipoAccionNoProcInfo getTipoAccionNoProc();
//	 SIDHIDDSubTipoResultadoInfo getSubTipoResultado();
//	 SIDHIDDTipoResultadoInfo getTipoResultado();
//	 Date getFechaAccion();
//	 Date getFechaExtraccion();
//
//}
