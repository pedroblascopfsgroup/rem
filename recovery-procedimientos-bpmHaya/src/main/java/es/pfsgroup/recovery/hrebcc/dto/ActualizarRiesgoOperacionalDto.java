package es.pfsgroup.recovery.hrebcc.dto;

import es.capgemini.devon.dto.WebDto;

public class ActualizarRiesgoOperacionalDto extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4339935642642871174L;
	
	private Long idContrato;
	private String codRiesgoOperacional;
	private boolean enviarDatos = true;
	
	public Long getIdContrato() {
		return idContrato;
	}
	public void setIdContrato(Long idContrato) {
		this.idContrato = idContrato;
	}
	public String getCodRiesgoOperacional() {
		return codRiesgoOperacional;
	}
	public void setCodRiesgoOperacional(String codRiesgoOperacional) {
		this.codRiesgoOperacional = codRiesgoOperacional;
	}
	
	public boolean isEnviarDatos() {
		return enviarDatos;
	}
	
	public void setEnviarDatos(boolean enviarDatos) {
		this.enviarDatos = enviarDatos;
	}
}
