package es.pfsgroup.plugin.recovery.itinerarios.decisionComiteAutomatica.dto;

import es.capgemini.devon.dto.WebDto;

public class ITIDtoAltaDCA extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 6076040813004479848L;

	private Long id;
	
	private Long estado;
	
	private Boolean automatico;
	
	//@NotNull(message="plugin.itinerarios.messages.gestorNoVacio")
	private Long gestor;
	
	//@NotNull(message="plugin.itinerarios.messages.supervisorNoVacio")
	private Long supervisor;
	
	//@NotNull(message="plugin.itinerarios.messages.comiterNoVacio")
	private Long comite;
	
	//@NotNull(message="plugin.itinerarios.messages.tipoActuacionNoVacio")
	private Long tipoActuacion;
	
	//@NotNull(message="plugin.itinerarios.messages.tipoReclamacionNoVacio")
	private Long tipoReclamacion;
	
	//@NotNull(message="plugin.itinerarios.messages.tipoProcedimientoNoVacio")
	private Long tipoProcedimiento;
	
	//@NotNull(message="plugin.itinerarios.messages.porcentajeRecuperacionNoVacio")
	private Integer porcentajeRecuperacion;
	
	//@NotNull(message="plugin.itinerarios.messages.plazoRecuperaconrNoVacio")
	private Integer plazoRecuperacion;

	private Boolean aceptacionAutomatico;

	public void setGestor(Long gestor) {
		this.gestor = gestor;
	}

	public Long getGestor() {
		return gestor;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setSupervisor(Long supervisor) {
		this.supervisor = supervisor;
	}

	public Long getSupervisor() {
		return supervisor;
	}

	public void setComite(Long comite) {
		this.comite = comite;
	}

	public Long getComite() {
		return comite;
	}

	public void setTipoActuacion(Long tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}

	public Long getTipoActuacion() {
		return tipoActuacion;
	}

	public void setTipoReclamacion(Long tipoReclamacion) {
		this.tipoReclamacion = tipoReclamacion;
	}

	public Long getTipoReclamacion() {
		return tipoReclamacion;
	}

	public void setTipoProcedimiento(Long tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public Long getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setPorcentajeRecuperacion(Integer porcentajeRecuperacion) {
		this.porcentajeRecuperacion = porcentajeRecuperacion;
	}

	public Integer getPorcentajeRecuperacion() {
		return porcentajeRecuperacion;
	}

	public void setPlazoRecuperacion(Integer plazoRecuperacion) {
		this.plazoRecuperacion = plazoRecuperacion;
	}

	public Integer getPlazoRecuperacion() {
		return plazoRecuperacion;
	}

	public void setAceptacionAutomatico(Boolean aceptacionAutomatico) {
		this.aceptacionAutomatico = aceptacionAutomatico;
	}

	public Boolean getAceptacionAutomatico() {
		return aceptacionAutomatico;
	}

	public void setEstado(Long estado) {
		this.estado = estado;
	}

	public Long getEstado() {
		return estado;
	}

	public void setAutomatico(Boolean automatico) {
		this.automatico = automatico;
	}

	public Boolean getAutomatico() {
		return automatico;
	}

	
	
	
	
	
	
}
