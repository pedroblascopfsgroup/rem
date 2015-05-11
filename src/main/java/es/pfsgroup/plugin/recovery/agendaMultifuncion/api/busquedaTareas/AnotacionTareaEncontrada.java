package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.busquedaTareas;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class AnotacionTareaEncontrada {
	
	@Column(name = "USUARIODESTINOTAREA")
	private String usuarioDestinoTarea;
	
	@Column(name = "USUARIOORIGENTAREA")
    private String usuarioOrigenTarea;
	
	@Column(name = "TIPOANOTACION")
    private String tipoAnotacion;
	
	@Column(name = "FLAGENVIOCORREO")
    private String flagEnvioCorreo;
    
    
	public String getUsuarioDestinoTarea() {
		return usuarioDestinoTarea;
	}
	
	public void setUsuarioDestinoTarea(String usuarioDestinoTarea) {
		this.usuarioDestinoTarea = usuarioDestinoTarea;
	}
	
	public String getUsuarioOrigenTarea() {
		return usuarioOrigenTarea;
	}
	
	public void setUsuarioOrigenTarea(String usuarioOrigenTarea) {
		this.usuarioOrigenTarea = usuarioOrigenTarea;
	}
	
	public String getTipoAnotacion() {
		return tipoAnotacion;
	}
	
	public void setTipoAnotacion(String tipoAnotacion) {
		this.tipoAnotacion = tipoAnotacion;
	}
	
	public String getFlagEnvioCorreo() {
		return flagEnvioCorreo;
	}
	
	public void setFlagEnvioCorreo(String flagEnvioCorreo) {
		this.flagEnvioCorreo = flagEnvioCorreo;
	}
	

}
