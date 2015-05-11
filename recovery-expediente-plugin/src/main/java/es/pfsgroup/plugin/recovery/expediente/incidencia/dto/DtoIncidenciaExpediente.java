package es.pfsgroup.plugin.recovery.expediente.incidencia.dto;

public class DtoIncidenciaExpediente {

	private Long idPersona;
	private Long idContrato;
	private Long idTipoIncidencia;
	private Long idUsuario;
	private Long idProveedor;
	private String observaciones;
	private Long idExpediente;

	public Long getIdPersona() {
		return idPersona;
	}

	public void setIdPersona(Long idPersona) {
		this.idPersona = idPersona;
	}

	public Long getIdContrato() {
		return idContrato;
	}

	public void setIdContrato(Long idContrato) {
		this.idContrato = idContrato;
	}

	public Long getIdTipoIncidencia() {
		return idTipoIncidencia;
	}

	public void setIdTipoIncidencia(Long idTipoIncidencia) {
		this.idTipoIncidencia = idTipoIncidencia;
	}

	public Long getIdUsuario() {
		return idUsuario;
	}

	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

}
