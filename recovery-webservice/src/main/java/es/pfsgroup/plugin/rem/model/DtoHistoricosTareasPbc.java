package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;

public class DtoHistoricosTareasPbc {

	private String tipoTareaPbc;
	private Boolean activa;
	private Boolean aprobacion;
	private Date fechaSancion;
	private String informe;
	private Date fechaSolicitudEstadoRiesgo;
	private Date fechaComunicacionRiesgo;
	private Date fechaEnvioDocumentacionBc;
	
	
	public String getTipoTareaPbc() {
		return tipoTareaPbc;
	}
	public void setTipoTareaPbc(String tipoTareaPbc) {
		this.tipoTareaPbc = tipoTareaPbc;
	}
	public Boolean getActiva() {
		return activa;
	}
	public void setActiva(Boolean activa) {
		this.activa = activa;
	}
	public Boolean getAprobacion() {
		return aprobacion;
	}
	public void setAprobacion(Boolean aprobacion) {
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
