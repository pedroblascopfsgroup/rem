package es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.dto;

import es.capgemini.devon.dto.WebDto;

public class ITIDtoAltaReglaElevacion extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4086449184964591762L;
	
	private Long id;
	private Long estado;
	private Long ddTipoReglasElevacion;
	private Long ambitoExpediente;
	
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public void setEstado(Long estado) {
		this.estado = estado;
	}
	public Long getEstado() {
		return estado;
	}
	public void setDdTipoReglasElevacion(Long ddTipoReglasElevacion) {
		this.ddTipoReglasElevacion = ddTipoReglasElevacion;
	}
	public Long getDdTipoReglasElevacion() {
		return ddTipoReglasElevacion;
	}
	public void setAmbitoExpediente(Long ambitoExpediente) {
		this.ambitoExpediente = ambitoExpediente;
	}
	public Long getAmbitoExpediente() {
		return ambitoExpediente;
	}
}
