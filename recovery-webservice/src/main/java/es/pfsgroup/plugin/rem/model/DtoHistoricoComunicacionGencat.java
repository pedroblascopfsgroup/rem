package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoHistoricoComunicacionGencat extends WebDto {

	private static final long serialVersionUID = -9018483560847754084L;
	
	private Long id;
	private Date fechaPreBloqueo;
	private Date fechaComunicacion;
	private Date fechaSancion;
	private String sancion;
	private String estadoComunicacion;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getFechaPreBloqueo() {
		return fechaPreBloqueo;
	}
	public void setFechaPreBloqueo(Date fechaPreBloqueo) {
		this.fechaPreBloqueo = fechaPreBloqueo;
	}
	public Date getFechaComunicacion() {
		return fechaComunicacion;
	}
	public void setFechaComunicacion(Date fechaComunicacion) {
		this.fechaComunicacion = fechaComunicacion;
	}
	public Date getFechaSancion() {
		return fechaSancion;
	}
	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}
	public String getSancion() {
		return sancion;
	}
	public void setSancion(String sancion) {
		this.sancion = sancion;
	}
	public String getEstadoComunicacion() {
		return estadoComunicacion;
	}
	public void setEstadoComunicacion(String estadoComunicacion) {
		this.estadoComunicacion = estadoComunicacion;
	}

}
