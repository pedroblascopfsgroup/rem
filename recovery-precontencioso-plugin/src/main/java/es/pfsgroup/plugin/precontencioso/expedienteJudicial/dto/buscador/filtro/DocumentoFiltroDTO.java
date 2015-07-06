package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.filtro;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DocumentoFiltroDTO extends WebDto {

	private static final long serialVersionUID = 5522877020724950464L;

	private String tipoDocumento;
	private String estado;
	private String ultimaRespuesta;
	private String ultimoActor;
	private Date fechaSolicitudDesde;
	private Date fechaSolicitudHasta;
	private Date fechaResultadoDesde;
	private Date fechaResultadoHasta;
	private Date fechaEnvioDesde;
	private Date fechaEnvioHasta;
	private Date fechaRecepcionDesde;
	private Date fechaRecepcionHasta;
	private Boolean adjunto;
	private Boolean solicitudPrevia;

	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
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
	public Date getFechaSolicitudDesde() {
		return fechaSolicitudDesde;
	}
	public void setFechaSolicitudDesde(Date fechaSolicitudDesde) {
		this.fechaSolicitudDesde = fechaSolicitudDesde;
	}
	public Date getFechaSolicitudHasta() {
		return fechaSolicitudHasta;
	}
	public void setFechaSolicitudHasta(Date fechaSolicitudHasta) {
		this.fechaSolicitudHasta = fechaSolicitudHasta;
	}
	public Date getFechaResultadoDesde() {
		return fechaResultadoDesde;
	}
	public void setFechaResultadoDesde(Date fechaResultadoDesde) {
		this.fechaResultadoDesde = fechaResultadoDesde;
	}
	public Date getFechaResultadoHasta() {
		return fechaResultadoHasta;
	}
	public void setFechaResultadoHasta(Date fechaResultadoHasta) {
		this.fechaResultadoHasta = fechaResultadoHasta;
	}
	public Date getFechaEnvioDesde() {
		return fechaEnvioDesde;
	}
	public void setFechaEnvioDesde(Date fechaEnvioDesde) {
		this.fechaEnvioDesde = fechaEnvioDesde;
	}
	public Date getFechaEnvioHasta() {
		return fechaEnvioHasta;
	}
	public void setFechaEnvioHasta(Date fechaEnvioHasta) {
		this.fechaEnvioHasta = fechaEnvioHasta;
	}
	public Date getFechaRecepcionDesde() {
		return fechaRecepcionDesde;
	}
	public void setFechaRecepcionDesde(Date fechaRecepcionDesde) {
		this.fechaRecepcionDesde = fechaRecepcionDesde;
	}
	public Date getFechaRecepcionHasta() {
		return fechaRecepcionHasta;
	}
	public void setFechaRecepcionHasta(Date fechaRecepcionHasta) {
		this.fechaRecepcionHasta = fechaRecepcionHasta;
	}
	public Boolean getAdjunto() {
		return adjunto;
	}
	public void setAdjunto(Boolean adjunto) {
		this.adjunto = adjunto;
	}
	public Boolean getSolicitudPrevia() {
		return solicitudPrevia;
	}
	public void setSolicitudPrevia(Boolean solicitudPrevia) {
		this.solicitudPrevia = solicitudPrevia;
	}
}
