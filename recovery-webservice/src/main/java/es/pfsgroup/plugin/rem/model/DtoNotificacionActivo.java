package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoNotificacionActivo extends WebDto {

	private static final long serialVersionUID = -5099553289919679527L;
	
	private Long idActivo;
	private Long id;
	private String fechaNotificacion;
	private String motivoNotificacion;
	private String fechaSancionNotificacion;
	private String cierreNotificacion;
	private String idDocumento;
	private String nombre;
	private String nombreSancion;
	private String idHComunicacion;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getFechaNotificacion() {
		return fechaNotificacion;
	}
	public void setFechaNotificacion(String fechaNotificacion) {
		this.fechaNotificacion = fechaNotificacion;
	}
	public String getMotivoNotificacion() {
		return motivoNotificacion;
	}
	public void setMotivoNotificacion(String motivoNotificacion) {
		this.motivoNotificacion = motivoNotificacion;
	}
	public String getFechaSancionNotificacion() {
		return fechaSancionNotificacion;
	}
	public void setFechaSancionNotificacion(String fechaSancionNotificacion) {
		this.fechaSancionNotificacion = fechaSancionNotificacion;
	}
	public String getCierreNotificacion() {
		return cierreNotificacion;
	}
	public void setCierreNotificacion(String cierreNotificacion) {
		this.cierreNotificacion = cierreNotificacion;
	}
	public String getIdDocumento() {
		return idDocumento;
	}
	public void setIdDocumento(String idDocumento) {
		this.idDocumento = idDocumento;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNombreSancion() {
		return nombreSancion;
	}
	public void setNombreSancion(String nombreSancion) {
		this.nombreSancion = nombreSancion;
	}
	public String getIdHComunicacion() {
		return idHComunicacion;
	}
	public void setIdHComunicacion(String idHComunicacion) {
		this.idHComunicacion = idHComunicacion;
	}
	
}
