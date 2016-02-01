package es.pfsgroup.plugin.recovery.itinerarios.itinerario.dto;

import es.capgemini.devon.dto.WebDto;

public class ITIDtoBusquedaItinerarios extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6830284771238071649L;
	
	private String nombre;
	private Long dDtipoItinerario;
	private Long ambitoExpediente;
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNombre() {
		return nombre;
	}
	
	public void setAmbitoExpediente(Long ambitoExpediente) {
		this.ambitoExpediente = ambitoExpediente;
	}
	public Long getAmbitoExpediente() {
		return ambitoExpediente;
	}
	public void setdDtipoItinerario(Long dDtipoItinerario) {
		this.dDtipoItinerario = dDtipoItinerario;
	}
	public Long getdDtipoItinerario() {
		return dDtipoItinerario;
	}
	
	

}
