package es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto;

import java.util.Date;

public class DtoCrearAnotacionUsuario {

	private Long id;

	private boolean incorporar;

	private Date fecha;

	private boolean email;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public boolean isIncorporar() {
		return incorporar;
	}

	public void setIncorporar(boolean incorporar) {
		this.incorporar = incorporar;
	}

	public Date getFecha() {
		return fecha != null ? ((Date) fecha.clone()) : null;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha != null ? ((Date) fecha.clone()) : null;
	}

	public boolean isEmail() {
		return email;
	}

	public void setEmail(boolean email) {
		this.email = email;
	}

}
