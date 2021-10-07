package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoTiposAlquilerNoComercial extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String codigoTipoAlquiler;
	private String isVulnerable;
	private String requiereAnalisisTecnico;
	private Long numExpedienteAnterior;
	
	
	public String getCodigoTipoAlquiler() {
		return codigoTipoAlquiler;
	}
	public void setCodigoTipoAlquiler(String codigoTipoAlquiler) {
		this.codigoTipoAlquiler = codigoTipoAlquiler;
	}
	public String getIsVulnerable() {
		return isVulnerable;
	}
	public void setIsVulnerable(String isVulnerable) {
		this.isVulnerable = isVulnerable;
	}
	public String getRequiereAnalisisTecnico() {
		return requiereAnalisisTecnico;
	}
	public void setRequiereAnalisisTecnico(String requiereAnalisisTecnico) {
		this.requiereAnalisisTecnico = requiereAnalisisTecnico;
	}
	public Long getNumExpedienteAnterior() {
		return numExpedienteAnterior;
	}
	public void setNumExpedienteAnterior(Long numExpedienteAnterior) {
		this.numExpedienteAnterior = numExpedienteAnterior;
	}
	
	
	
	
}
