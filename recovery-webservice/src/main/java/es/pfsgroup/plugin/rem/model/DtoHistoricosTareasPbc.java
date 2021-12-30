package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.pfsgroup.plugin.rem.model.dd.DDEstadoTareaPbc;

public class DtoHistoricosTareasPbc {

	private Long estadoTareaPbc;
	private Integer activa;
	private Integer aprobacion;
	private Date fechaSancion;
	private String informe;
	private Date fechaSolicitudEstadoRiesgo;
	private Date fechaComunicacionRiesgo;
	private Date fechaEnvioDocumentacionBc;
	
	public Long getEstadoTareaPbc() {
		return estadoTareaPbc;
	}
	public void setEstadoTareaPbc(Long estadoTareaPbc) {
		this.estadoTareaPbc = estadoTareaPbc;
	}
	public Integer getActiva() {
		return activa;
	}
	public void setActiva(Integer activa) {
		this.activa = activa;
	}
	public Integer getAprobacion() {
		return aprobacion;
	}
	public void setAprobacion(Integer aprobacion) {
		this.aprobacion = aprobacion;
	}
	public Date getFechaSancion() {
		return fechaSancion;
	}
	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}
	public String getInforme() {
		return informe;
	}
	public void setInforme(String informe) {
		this.informe = informe;
	}
	public Date getFechaSolicitudEstadoRiesgo() {
		return fechaSolicitudEstadoRiesgo;
	}
	public void setFechaSolicitudEstadoRiesgo(Date fechaSolicitudEstadoRiesgo) {
		this.fechaSolicitudEstadoRiesgo = fechaSolicitudEstadoRiesgo;
	}
	public Date getFechaComunicacionRiesgo() {
		return fechaComunicacionRiesgo;
	}
	public void setFechaComunicacionRiesgo(Date fechaComunicacionRiesgo) {
		this.fechaComunicacionRiesgo = fechaComunicacionRiesgo;
	}
	public Date getFechaEnvioDocumentacionBc() {
		return fechaEnvioDocumentacionBc;
	}
	public void setFechaEnvioDocumentacionBc(Date fechaEnvioDocumentacionBc) {
		this.fechaEnvioDocumentacionBc = fechaEnvioDocumentacionBc;
	}
}
