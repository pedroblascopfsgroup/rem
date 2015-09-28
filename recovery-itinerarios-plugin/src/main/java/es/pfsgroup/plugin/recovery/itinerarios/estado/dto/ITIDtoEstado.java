package es.pfsgroup.plugin.recovery.itinerarios.estado.dto;

import es.capgemini.devon.dto.WebDto;

public class ITIDtoEstado extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7992677675112859672L;

	private Long id;
	private Long itinerario;
	private Long plazo;
	private Long estadoItinerario;
	private Long gestorPerfil;
	private Long supervisor;
	private String gestorPerfilNombre;
	private String supervisorNombre;
	private Boolean automatico;
	private Long estadoTelecobro;
	private Long decisionComiteAutomatico;
	private Boolean telecobro;
	
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public void setItinerario(Long itinerario) {
		this.itinerario = itinerario;
	}
	public Long getItinerario() {
		return itinerario;
	}
	public void setPlazo(Long plazo) {
		this.plazo = plazo;
	}
	public Long getPlazo() {
		return plazo;
	}
	public void setEstadoItinerario(Long estadoItinerario) {
		this.estadoItinerario = estadoItinerario;
	}
	public Long getEstadoItinerario() {
		return estadoItinerario;
	}
	public void setGestorPerfil(Long gestorPerfil) {
		this.gestorPerfil = gestorPerfil;
	}
	public Long getGestorPerfil() {
		return gestorPerfil;
	}
	public void setSupervisor(Long supervisor) {
		this.supervisor = supervisor;
	}
	public Long getSupervisor() {
		return supervisor;
	}
	public void setAutomatico(Boolean automatico) {
		this.automatico = automatico;
	}
	public Boolean getAutomatico() {
		return automatico;
	}
	public void setEstadoTelecobro(Long estadoTelecobro) {
		this.estadoTelecobro = estadoTelecobro;
	}
	public Long getEstadoTelecobro() {
		return estadoTelecobro;
	}
	public void setDecisionComiteAutomatico(Long decisionComiteAutomatico) {
		this.decisionComiteAutomatico = decisionComiteAutomatico;
	}
	public Long getDecisionComiteAutomatico() {
		return decisionComiteAutomatico;
	}
	public void setTelecobro(Boolean telecobro) {
		this.telecobro = telecobro;
	}
	public Boolean getTelecobro() {
		return telecobro;
	}
	public void setGestorPerfilNombre(String gestorPerfilNombre) {
		this.gestorPerfilNombre = gestorPerfilNombre;
	}
	public String getGestorPerfilNombre() {
		return gestorPerfilNombre;
	}
	public void setSupervisorNombre(String supervisorNombre) {
		this.supervisorNombre = supervisorNombre;
	}
	public String getSupervisorNombre() {
		return supervisorNombre;
	}
	
}
