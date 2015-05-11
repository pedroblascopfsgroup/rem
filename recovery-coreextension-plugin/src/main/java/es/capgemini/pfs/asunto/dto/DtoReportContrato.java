package es.capgemini.pfs.asunto.dto;

import es.capgemini.pfs.contrato.model.Contrato;


public class DtoReportContrato{
	
	private Contrato contrato;
	private String principalFinal;
	private String insinuacionFinal;
	private String estadoCreditos;
	
	
	public Contrato getContrato() {
		return contrato;
	}
	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}
	public String getPrincipalFinal() {
		return principalFinal;
	}
	public void setPrincipalFinal(String principalFinal) {
		this.principalFinal = principalFinal;
	}
	public String getInsinuacionFinal() {
		return insinuacionFinal;
	}
	public void setInsinuacionFinal(String insinuacionFinal) {
		this.insinuacionFinal = insinuacionFinal;
	}
	public String getEstadoCreditos() {
		return estadoCreditos;
	}
	public void setEstadoCreditos(String estadoCreditos) {
		this.estadoCreditos = estadoCreditos;
	}	
	
}
