package es.pfsgroup.plugin.recovery.itinerarios.itinerario.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class ITIDtoAltaItinerario extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2267457986285815582L;
	
	private Long id;
	
	@NotNull
	@NotEmpty
	private String nombre;
	
	@NotNull
	private Long dDtipoItinerario;
	
	private Long ambitoExpediente;
	
	private Long prePolitica;
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNombre() {
		return nombre;
	}
	public void setdDtipoItinerario(Long dDtipoItinerario) {
		this.dDtipoItinerario = dDtipoItinerario;
	}
	public Long getdDtipoItinerario() {
		return dDtipoItinerario;
	}
	public void setAmbitoExpediente(Long ambitoExpediente) {
		this.ambitoExpediente = ambitoExpediente;
	}
	public Long getAmbitoExpediente() {
		return ambitoExpediente;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public Long getPrePolitica() {
		return prePolitica;
	}
	public void setPrePolitica(Long prePolitica) {
		this.prePolitica = prePolitica;
	}

}
