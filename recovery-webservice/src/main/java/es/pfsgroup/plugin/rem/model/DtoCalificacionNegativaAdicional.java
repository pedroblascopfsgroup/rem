package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoCalificacionNegativaAdicional extends WebDto {

	private static final long serialVersionUID = -2537329516083931156L;

	
	private Long idActivo; 
	private String idMotivo;
	private String codigoEstadoMotivoCalificacionNegativa;
	private String motivoCalificacionNegativa; 
	private String descripcionCalificacionNegativa; 
	private String responsableSubsanar; 
	private String codigoResponsableSubsanar;
	private String estadoMotivoCalificacionNegativa; 
	private Date fechaSubsanacion; 
	private Date fechaCalificacionNegativa;
	private Date fechaPresentacionRegistroCN;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getMotivoCalificacionNegativa() {
		return motivoCalificacionNegativa;
	}
	public void setMotivoCalificacionNegativa(String motivoCalificacionNegativa) {
		this.motivoCalificacionNegativa = motivoCalificacionNegativa;
	}
	public String getDescripcionCalificacionNegativa() {
		return descripcionCalificacionNegativa;
	}
	public void setDescripcionCalificacionNegativa(String descripcionCalificacionNegativa) {
		this.descripcionCalificacionNegativa = descripcionCalificacionNegativa;
	}
	public String getResponsableSubsanar() {
		return responsableSubsanar;
	}
	public void setResponsableSubsanar(String responsableSubsanar) {
		this.responsableSubsanar = responsableSubsanar;
	}
	public String getEstadoMotivoCalificacionNegativa() {
		return estadoMotivoCalificacionNegativa;
	}
	public void setEstadoMotivoCalificacionNegativa(String estadoMotivoCalificacionNegativa) {
		this.estadoMotivoCalificacionNegativa = estadoMotivoCalificacionNegativa;
	}
	public Date getFechaSubsanacion() {
		return fechaSubsanacion;
	}
	public void setFechaSubsanacion(Date fechaSubsanacion) {
		this.fechaSubsanacion = fechaSubsanacion;
	}
	public String getCodigoEstadoMotivoCalificacionNegativa() {
		return codigoEstadoMotivoCalificacionNegativa;
	}
	public void setCodigoEstadoMotivoCalificacionNegativa(String codigoEstadoMotivoCalificacionNegativa) {
		this.codigoEstadoMotivoCalificacionNegativa = codigoEstadoMotivoCalificacionNegativa;
	}
	public String getIdMotivo() {
		return idMotivo;
	}
	public void setIdMotivo(String idMotivo) {
		this.idMotivo = idMotivo;
	}
	public String getCodigoResponsableSubsanar() {
		return codigoResponsableSubsanar;
	}
	public void setCodigoResponsableSubsanar(String codigoResponsableSubsanar) {
		this.codigoResponsableSubsanar = codigoResponsableSubsanar;
	}
	public Date getFechaCalificacionNegativa() {
		return fechaCalificacionNegativa;
	}
	public void setFechaCalificacionNegativa(Date fechaCalificacionNegativa) {
		this.fechaCalificacionNegativa = fechaCalificacionNegativa;
	}
	public Date getFechaPresentacionRegistroCN() {
		return fechaPresentacionRegistroCN;
	}
	public void setFechaPresentacionRegistroCN(Date fechaPresentacionRegistroCN) {
		this.fechaPresentacionRegistroCN = fechaPresentacionRegistroCN;
	}
	
	

}
