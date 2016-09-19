package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class TrabajoDto implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@NotNull
	private Long idTrabajoWebcom;
	@NotNull
	private Long idActivoHaya;
	@NotNull
	@Size(max=20)
	private String codTipoTrabajo;
	@NotNull
	@Size(max=20)
	private String codSubtipoTrabajo;
	@NotNull
	private Date fechaAccion;
	@NotNull
	private Long idUsuarioRemAccion;
	@NotNull
	@Size(max=256)
	private String descripcion;
	@NotNull
	private Long idProveedorRemResponsable;
	@Size(max=60)
	private String nombreContacto;
	@Size(max=14)
	private String telefonoContacto;
	@Size(max=60)
	private String emailContacto;
	@Size(max=250)
	private String descripcionContacto;
	@Size(max=60)
	private String nombreRequiriente;
	@Size(max=14)
	private String telefonoRequiriente;
	@Size(max=60)
	private String emailRequiriente;
	@Size(max=250)
	private String descripcionRequiriente;
	private Boolean fechaPrioridadRequirienteEsExacta;
	//private Date fechaTopeRequiriente;
	private Date fechaPrioridadRequiriente;	
	private Boolean urgentePrioridadRequiriente;
	private Boolean riesgoPrioridadRequiriente;
	
	
	
	public Long getIdTrabajoWebcom() {
		return idTrabajoWebcom;
	}
	public void setIdTrabajoWebcom(Long idTrabajoWebcom) {
		this.idTrabajoWebcom = idTrabajoWebcom;
	}
	public Long getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public String getCodTipoTrabajo() {
		return codTipoTrabajo;
	}
	public void setCodTipoTrabajo(String codTipoTrabajo) {
		this.codTipoTrabajo = codTipoTrabajo;
	}
	public String getCodSubtipoTrabajo() {
		return codSubtipoTrabajo;
	}
	public void setCodSubtipoTrabajo(String codSubtipoTrabajo) {
		this.codSubtipoTrabajo = codSubtipoTrabajo;
	}
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Long getIdProveedorRemResponsable() {
		return idProveedorRemResponsable;
	}
	public void setIdProveedorRemResponsable(Long idProveedorRemResponsable) {
		this.idProveedorRemResponsable = idProveedorRemResponsable;
	}
	public String getNombreContacto() {
		return nombreContacto;
	}
	public void setNombreContacto(String nombreContacto) {
		this.nombreContacto = nombreContacto;
	}
	public String getTelefonoContacto() {
		return telefonoContacto;
	}
	public void setTelefonoContacto(String telefonoContacto) {
		this.telefonoContacto = telefonoContacto;
	}
	public String getEmailContacto() {
		return emailContacto;
	}
	public void setEmailContacto(String emailContacto) {
		this.emailContacto = emailContacto;
	}
	public String getDescripcionContacto() {
		return descripcionContacto;
	}
	public void setDescripcionContacto(String descripcionContacto) {
		this.descripcionContacto = descripcionContacto;
	}
	public String getNombreRequiriente() {
		return nombreRequiriente;
	}
	public void setNombreRequiriente(String nombreRequiriente) {
		this.nombreRequiriente = nombreRequiriente;
	}
	public String getTelefonoRequiriente() {
		return telefonoRequiriente;
	}
	public void setTelefonoRequiriente(String telefonoRequiriente) {
		this.telefonoRequiriente = telefonoRequiriente;
	}
	public String getEmailRequiriente() {
		return emailRequiriente;
	}
	public void setEmailRequiriente(String emailRequiriente) {
		this.emailRequiriente = emailRequiriente;
	}
	public String getDescripcionRequiriente() {
		return descripcionRequiriente;
	}
	public void setDescripcionRequiriente(String descripcionRequiriente) {
		this.descripcionRequiriente = descripcionRequiriente;
	}	
	public Boolean getFechaPrioridadRequirienteEsExacta() {
		return fechaPrioridadRequirienteEsExacta;
	}
	public void setFechaPrioridadRequirienteEsExacta(
			Boolean fechaPrioridadRequirienteEsExacta) {
		this.fechaPrioridadRequirienteEsExacta = fechaPrioridadRequirienteEsExacta;
	}
	/*public Date getFechaTopeRequiriente() {
		return fechaTopeRequiriente;
	}
	public void setFechaTopeRequiriente(Date fechaTopeRequiriente) {
		this.fechaTopeRequiriente = fechaTopeRequiriente;
	}	
	public Date getFechaHoraConcretaRequiriente() {
		return fechaHoraConcretaRequiriente;
	}
	public void setFechaHoraConcretaRequiriente(Date fechaHoraConcretaRequiriente) {
		this.fechaHoraConcretaRequiriente = fechaHoraConcretaRequiriente;
	}*/
	public Date getFechaPrioridadRequiriente() {
		return fechaPrioridadRequiriente;
	}
	public void setFechaPrioridadRequiriente(Date fechaPrioridadRequiriente) {
		this.fechaPrioridadRequiriente = fechaPrioridadRequiriente;
	}
	public Boolean getUrgentePrioridadRequiriente() {
		return urgentePrioridadRequiriente;
	}
	public void setUrgentePrioridadRequiriente(Boolean urgentePrioridadRequiriente) {
		this.urgentePrioridadRequiriente = urgentePrioridadRequiriente;
	}
	public Boolean getRiesgoPrioridadRequiriente() {
		return riesgoPrioridadRequiriente;
	}
	public void setRiesgoPrioridadRequiriente(Boolean riesgoPrioridadRequiriente) {
		this.riesgoPrioridadRequiriente = riesgoPrioridadRequiriente;
	}
	
	
	
}
