package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * @author juan.beltran@pfsgroup.es.
 */

public class TrabajoRespuestaDto implements Serializable {
	
	private static final long serialVersionUID = 4477872057616964258L;

	private Long numTrabajo;
	private Date fechaRealizacion;
	private String nombreContacto;
	private String telefonoContacto;
	private String emailContacto;
	private String descripcionContacto;
	private String nombreRequiriente;
	private String telefonoRequiriente;
	private String emailRequiriente;
	private String descripcionRequiriente;
	private boolean fechaExacta;
	private Date fechaPrioridadReq;
	private boolean urgentePrioridadReq;
	private boolean riesgoPrioridadReq;
	private List<Long> numActivo;

	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public Date getFechaRealizacion() {
		return fechaRealizacion;
	}

	public void setFechaRealizacion(Date fechaRealizacion) {
		this.fechaRealizacion = fechaRealizacion;
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

	public boolean isFechaExacta() {
		return fechaExacta;
	}

	public void setFechaExacta(boolean fechaExacta) {
		this.fechaExacta = fechaExacta;
	}

	public Date getFechaPrioridadReq() {
		return fechaPrioridadReq;
	}

	public void setFechaPrioridadReq(Date fechaPrioridadReq) {
		this.fechaPrioridadReq = fechaPrioridadReq;
	}

	public boolean isUrgentePrioridadReq() {
		return urgentePrioridadReq;
	}

	public void setUrgentePrioridadReq(boolean urgentePrioridadReq) {
		this.urgentePrioridadReq = urgentePrioridadReq;
	}

	public boolean isRiesgoPrioridadReq() {
		return riesgoPrioridadReq;
	}

	public void setRiesgoPrioridadReq(boolean riesgoPrioridadReq) {
		this.riesgoPrioridadReq = riesgoPrioridadReq;
	}

	public List<Long> getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(List<Long> numActivo) {
		this.numActivo = numActivo;
	}
}
