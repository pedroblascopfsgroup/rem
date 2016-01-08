package es.pfsgroup.plugin.recovery.sidhiweb.api.model;

import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIAccionValor;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIEstadoProcesal;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHISubestadoProcesal;


public interface SIDHIAccionJudicialInfo {
	
	String getCodigoInterfaz();

	String getCodigoEstadoProcesal();

	String getCodigoSubestadoProcesal();

	Date getFechaAccion();

	String getValor(SIDHITipoAccionValorInfo tipoValor);
	
	SIDHIEstadoProcesal getEstadoProcesal();
	
	SIDHISubestadoProcesal getSubestadoProcesal();
	
	List<SIDHIAccionValor> getValores();
	
	Long getIdAccion();
}
