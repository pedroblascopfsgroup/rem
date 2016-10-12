package es.pfsgroup.plugin.rem.notificacion.dto;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacion;

public class CrearAnotacionDto extends DtoCrearAnotacion{

	private Long idTareaAppExterna;
	private String userNameSender;
	private String adjuntoCrear;
	private String adjuntoResp;

	public Long getIdTareaAppExterna() {
		return idTareaAppExterna;
	}

	public void setIdTareaAppExterna(Long idTareaAppExterna) {
		this.idTareaAppExterna = idTareaAppExterna;
	}

	public String getUserNameSender() {
		return userNameSender;
	}

	public void setUserNameSender(String userNameSender) {
		this.userNameSender = userNameSender;
	}

	public String getAdjuntoCrear() {
		return adjuntoCrear;
	}

	public void setAdjuntoCrear(String adjuntoCrear) {
		this.adjuntoCrear = adjuntoCrear;
	}

	public String getAdjuntoResp() {
		return adjuntoResp;
	}

	public void setAdjuntoResp(String adjuntoResp) {
		this.adjuntoResp = adjuntoResp;
	}


	

}
