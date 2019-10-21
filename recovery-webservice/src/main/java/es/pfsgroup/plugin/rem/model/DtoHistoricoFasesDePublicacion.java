package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoHistoricoFasesDePublicacion extends WebDto{
	private Long id;
	private String fasePublicacion;
	private String subfasePublicacion;
	private String usuario;
	private Date fechaInicio;
	private Date fechaFin;
	private String comentario;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getFasePublicacion() {
		return fasePublicacion;
	}
	public void setFasePublicacion(String fasePublicacion) {
		this.fasePublicacion = fasePublicacion;
	}
	public String getSubfasePublicacion() {
		return subfasePublicacion;
	}
	public void setSubfasePublicacion(String subfasePublicacion) {
		this.subfasePublicacion = subfasePublicacion;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public Date getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public Date getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
}
