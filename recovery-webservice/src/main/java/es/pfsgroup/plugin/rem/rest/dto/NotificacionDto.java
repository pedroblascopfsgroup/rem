package es.pfsgroup.plugin.rem.rest.dto;

import java.util.Date;

public class NotificacionDto extends RequestDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3044750907326664322L;
	
	private long idNotificacionWebcom;
	
	private long idNotificacionRem;
	
	private long idActivoHaya;
	
	private String codTipoNotificacion;
	
	private String titulo;
	
	private String descripcion;
	
	private Date fechaRealizacion;
	
	private Date fechaAccion;
	
	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	private long idUsuarioDestinoRem;
	
	private long idUsuarioRemAccion;

	public long getIdNotificacionWebcom() {
		return idNotificacionWebcom;
	}

	public void setIdNotificacionWebcom(long idNotificacionWebcom) {
		this.idNotificacionWebcom = idNotificacionWebcom;
	}

	public long getIdNotificacionRem() {
		return idNotificacionRem;
	}

	public void setIdNotificacionRem(long idNotificacionRem) {
		this.idNotificacionRem = idNotificacionRem;
	}

	public long getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}

	public String getCodTipoNotificacion() {
		return codTipoNotificacion;
	}

	public void setCodTipoNotificacion(String codTipoNotificacion) {
		this.codTipoNotificacion = codTipoNotificacion;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaRealizacion() {
		return fechaRealizacion;
	}

	public void setFechaRealizacion(Date fechaRealizacion) {
		this.fechaRealizacion = fechaRealizacion;
	}

	public long getIdUsuarioDestinoRem() {
		return idUsuarioDestinoRem;
	}

	public void setIdUsuarioDestinoRem(long idUsuarioDestinoRem) {
		this.idUsuarioDestinoRem = idUsuarioDestinoRem;
	}

	public long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}

	public void setIdUsuarioRemAccion(long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	
	

}
