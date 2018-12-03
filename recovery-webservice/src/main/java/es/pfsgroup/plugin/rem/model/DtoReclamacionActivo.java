package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoReclamacionActivo extends WebDto {
	
	private static final long serialVersionUID = -2437741500037132036L;
	
	private Date fechaAviso;
	private Date fechaReclamacion;
	
	public Date getFechaAviso() {
		return fechaAviso;
	}
	public void setFechaAviso(Date fechaAviso) {
		this.fechaAviso = fechaAviso;
	}
	public Date getFechaReclamacion() {
		return fechaReclamacion;
	}
	public void setFechaReclamacion(Date fechaReclamacion) {
		this.fechaReclamacion = fechaReclamacion;
	}
	
}
