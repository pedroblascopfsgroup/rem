package es.pfsgroup.plugin.recovery.sidhiweb.api.hitoIter.model;

import java.util.Date;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIAccionJudicialInfo;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIIterJudicialInfo;

public interface SIDHIHitoIterInfo {
	
	  SIDHIAccionJudicialInfo getAccion();
//	  SIDHIAccionNoProcInfo getAccionNoProc();   
	  SIDHIIterJudicialInfo getIterJudicial();
	  Contrato getContrato();
	  Date getFechaExtraccion();
	  DDTipoPersona getTipoPersona();
	  String getCodigoPersona();
	  Persona getPersona();
	  SIDHIDDTipoHitoIterInfo getTipoHitoIter();
	  Date getFechaInicio();
	  Date getFechaCumplimiento();
	  Long getIdHito();
	  Long getIdAccion();
	  String getObservaciones();
	  String getGestor();
	  String getGestorCumplimiento();
	  Usuario getUsuarioCumplimiento();
	  Usuario getUsuario();

}
