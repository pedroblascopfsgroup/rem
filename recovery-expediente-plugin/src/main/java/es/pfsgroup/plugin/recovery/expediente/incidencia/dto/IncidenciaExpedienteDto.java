package es.pfsgroup.plugin.recovery.expediente.incidencia.dto;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.IncidenciaExpediente;

public class IncidenciaExpedienteDto extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2360488998270316715L;
	
	
	private IncidenciaExpediente incidencia;
	private String agencia;
	public IncidenciaExpediente getIncidencia() {
		return incidencia;
	}
	public void setIncidencia(IncidenciaExpediente incidencia) {
		this.incidencia = incidencia;
	}
	public String getAgencia() {
		return agencia;
	}
	public void setAgencia(String agencia) {
		this.agencia = agencia;
	}
	
	

}
