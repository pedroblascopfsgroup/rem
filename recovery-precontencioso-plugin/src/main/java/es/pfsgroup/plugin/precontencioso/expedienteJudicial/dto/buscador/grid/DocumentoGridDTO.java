package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DocumentoGridDTO extends WebDto {

	private static final long serialVersionUID = 5010922485498368922L;

	private String estado;
	private String ultimaRespuesta;
	private String ultimoActor;
	private Date fechaResultado;
	private Date fechaEnvio;
	private Date fechaRecepcion;
	private Boolean adjunto;
	//RECOVERY-21 Nuevos campos a mostrar en los resultados del buscador
	private String tipoDocumento;
	private String propietario;
	private String tipoProductoEntidad;
	private String numContrato;
	private String numSpec;
	
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getUltimaRespuesta() {
		return ultimaRespuesta;
	}
	public void setUltimaRespuesta(String ultimaRespuesta) {
		this.ultimaRespuesta = ultimaRespuesta;
	}
	public String getUltimoActor() {
		return ultimoActor;
	}
	public void setUltimoActor(String ultimoActor) {
		this.ultimoActor = ultimoActor;
	}
	public Date getFechaResultado() {
		return fechaResultado;
	}
	public void setFechaResultado(Date fechaResultado) {
		this.fechaResultado = fechaResultado;
	}
	public Date getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public Boolean getAdjunto() {
		return adjunto;
	}
	public void setAdjunto(Boolean adjunto) {
		this.adjunto = adjunto;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}
	
	public String getNumContrato() {
		return numContrato;
	}
	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}
	public String getNumSpec() {
		return numSpec;
	}
	public void setNumSpec(String numSpec) {
		this.numSpec = numSpec;
	}
	public String getTipoProductoEntidad() {
		return tipoProductoEntidad;
	}
	public void setTipoProductoEntidad(String tipoProductoEntidad) {
		this.tipoProductoEntidad = tipoProductoEntidad;
	}
}
