package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto;

import java.util.Date;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionUsuarioInfo;

public class DtoCrearAnotacionUsuario implements DtoCrearAnotacionUsuarioInfo {

	private Long id;

	private boolean incorporar;

	private Date fecha;

	private boolean email;

	@Override
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public boolean isIncorporar() {
		return incorporar;
	}

	public void setIncorporar(boolean incorporar) {
		this.incorporar = incorporar;
	}

	@Override
	public Date getFecha() {
		return fecha != null ? ((Date) fecha.clone()) : null;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha != null ? ((Date) fecha.clone()) : null;
	}

	@Override
	public boolean isEmail() {
		return email;
	}

	public void setEmail(boolean email) {
		this.email = email;
	}

}
