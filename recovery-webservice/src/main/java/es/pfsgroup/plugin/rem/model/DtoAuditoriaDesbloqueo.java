package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * @author Pablo
 *
 */
public class DtoAuditoriaDesbloqueo extends WebDto {
	
	private static final long serialVersionUID = 3574353502838449106L;
	
	private String idCombo;
	private String idEco;
	private String idUsuario;
	private String fechaDeDesbloqueo;
	private String motivoDeDesbloqueo;
	
	
	public String getIdCombo() {
		return idCombo;
	}
	public void setIdCombo(String id) {
		this.idCombo = id;
	}
	public String getIdEco() {
		return idEco;
	}
	public void setIdEco(String idEco) {
		this.idEco = idEco;
	}
	public String getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(String idUsuario) {
		this.idUsuario = idUsuario;
	}
	public String getFechaDeDesbloqueo() {
		return fechaDeDesbloqueo;
	}
	public void setFechaDeDesbloqueo(String fechaDeDesbloqueo) {
		this.fechaDeDesbloqueo = fechaDeDesbloqueo;
	}
	public String getMotivoDeDesbloqueo() {
		return motivoDeDesbloqueo;
	}
	public void setMotivoDeDesbloqueo(String motivoDeDesbloqueo) {
		this.motivoDeDesbloqueo = motivoDeDesbloqueo;
	}

	
}
