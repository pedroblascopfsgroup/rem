package es.pfsgroup.plugin.rem.model;


import es.capgemini.devon.dto.WebDto;

public class DtoObtencionDatosFinanciacion extends WebDto {

	private static final long serialVersionUID = 1L;

	private String idExpediente;
	private String numExpediente;
	private String codTipoRiesgo;
	
	public String getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(String idExpediente) {
		this.idExpediente = idExpediente;
	}
	public String getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}
	public String getCodTipoRiesgo() {
		return codTipoRiesgo;
	}
	public void setCodTipoRiesgo(String codTipoRiesgo) {
		this.codTipoRiesgo = codTipoRiesgo;
	}

}