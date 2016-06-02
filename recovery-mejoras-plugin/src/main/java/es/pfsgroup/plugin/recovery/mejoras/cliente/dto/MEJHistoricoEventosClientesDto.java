package es.pfsgroup.plugin.recovery.mejoras.cliente.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class MEJHistoricoEventosClientesDto extends WebDto{
	
private static final long serialVersionUID = 5041223980322029317L;
	
	private String descripcion;
	private String tipoSolicitud;
	private Date fechaInicio;
	private Date fechaFin;
	private Date fechaVenc;
	private Boolean alertada;
	private Boolean finalizada;
	private String emisor;
	private String codigoSubtipoTarea;
	private String codigoTipoTarea;
	private Long idEntidad;
	private String codigoEntidadInformacion;
	private String descripcionTarea;
	private String descripcionEntidad;
	private String fcreacionEntidad;
	private String codigoSituacion;
	private Long idEntidadPersona;
	private String motivoProrroga;
	private Date fechaPropuestaProrroga;
	private Long id;
	private Long idTraza;
	private Long idTarea;
	private Long idRegistro;
	private Boolean isRegistro;
	
	
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipoSolicitud() {
		return tipoSolicitud;
	}
	public void setTipoSolicitud(String tipoSolicitud) {
		this.tipoSolicitud = tipoSolicitud;
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
	public Date getFechaVenc() {
		return fechaVenc;
	}
	public void setFechaVenc(Date fechaVenc) {
		this.fechaVenc = fechaVenc;
	}
	public Boolean getAlertada() {
		return alertada;
	}
	public void setAlertada(Boolean alertada) {
		this.alertada = alertada;
	}
	public Boolean getFinalizada() {
		return finalizada;
	}
	public void setFinalizada(Boolean finalizada) {
		this.finalizada = finalizada;
	}
	public String getEmisor() {
		return emisor;
	}
	public void setEmisor(String emisor) {
		this.emisor = emisor;
	}
	public String getCodigoSubtipoTarea() {
		return codigoSubtipoTarea;
	}
	public void setCodigoSubtipoTarea(String codigoSubtipoTarea) {
		this.codigoSubtipoTarea = codigoSubtipoTarea;
	}
	public String getCodigoTipoTarea() {
		return codigoTipoTarea;
	}
	public void setCodigoTipoTarea(String codigoTipoTarea) {
		this.codigoTipoTarea = codigoTipoTarea;
	}
	public Long getIdEntidad() {
		return idEntidad;
	}
	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}
	public String getCodigoEntidadInformacion() {
		return codigoEntidadInformacion;
	}
	public void setCodigoEntidadInformacion(String codigoEntidadInformacion) {
		this.codigoEntidadInformacion = codigoEntidadInformacion;
	}
	public String getDescripcionTarea() {
		return descripcionTarea;
	}
	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}
	public String getDescripcionEntidad() {
		return descripcionEntidad;
	}
	public void setDescripcionEntidad(String descripcionEntidad) {
		this.descripcionEntidad = descripcionEntidad;
	}
	public String getFcreacionEntidad() {
		return fcreacionEntidad;
	}
	public void setFcreacionEntidad(String fcreacionEntidad) {
		this.fcreacionEntidad = fcreacionEntidad;
	}
	public String getCodigoSituacion() {
		return codigoSituacion;
	}
	public void setCodigoSituacion(String codigoSituacion) {
		this.codigoSituacion = codigoSituacion;
	}
	public Long getIdEntidadPersona() {
		return idEntidadPersona;
	}
	public void setIdEntidadPersona(Long idEntidadPersona) {
		this.idEntidadPersona = idEntidadPersona;
	}
	public String getMotivoProrroga() {
		return motivoProrroga;
	}
	public void setMotivoProrroga(String motivoProrroga) {
		this.motivoProrroga = motivoProrroga;
	}
	public Date getFechaPropuestaProrroga() {
		return fechaPropuestaProrroga;
	}
	public void setFechaPropuestaProrroga(Date fechaPropuestaProrroga) {
		this.fechaPropuestaProrroga = fechaPropuestaProrroga;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdTraza() {
		return idTraza;
	}
	public void setIdTraza(Long idTraza) {
		this.idTraza = idTraza;
	}
	public Long getIdTarea() {
		return idTarea;
	}
	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
	public Long getIdRegistro() {
		return idRegistro;
	}
	public void setIdRegistro(Long idRegistro) {
		this.idRegistro = idRegistro;
	}
	public Boolean getIsRegistro() {
		return isRegistro;
	}
	public void setIsRegistro(Boolean isRegistro) {
		this.isRegistro = isRegistro;
	}
	
	
}
