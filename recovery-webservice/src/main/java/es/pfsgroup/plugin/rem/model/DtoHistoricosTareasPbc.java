package es.pfsgroup.plugin.rem.model;

public class DtoHistoricosTareasPbc {

	private String tipoTareaPbc;
	private Boolean activa;
	private Boolean aprobacion;
	private String fechaSancion;
	private String informe;
	private String fechaSolicitudEstadoRiesgo;
	private String fechaComunicacionRiesgo;
	private String fechaEnvioDocumentacionBc;
	
	
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
	public String getFechaSancion() {
		return fechaSancion;
	}
	public void setFechaSancion(String fechaSancion) {
		this.fechaSancion = fechaSancion;
	}
	public String getInforme() {
		return informe;
	}
	public void setInforme(String informe) {
		this.informe = informe;
	}
	public String getFechaSolicitudEstadoRiesgo() {
		return fechaSolicitudEstadoRiesgo;
	}
	public void setFechaSolicitudEstadoRiesgo(String fechaSolicitudEstadoRiesgo) {
		this.fechaSolicitudEstadoRiesgo = fechaSolicitudEstadoRiesgo;
	}
	public String getFechaComunicacionRiesgo() {
		return fechaComunicacionRiesgo;
	}
	public void setFechaComunicacionRiesgo(String fechaComunicacionRiesgo) {
		this.fechaComunicacionRiesgo = fechaComunicacionRiesgo;
	}
	public String getFechaEnvioDocumentacionBc() {
		return fechaEnvioDocumentacionBc;
	}
	public void setFechaEnvioDocumentacionBc(String fechaEnvioDocumentacionBc) {
		this.fechaEnvioDocumentacionBc = fechaEnvioDocumentacionBc;
	}
}
