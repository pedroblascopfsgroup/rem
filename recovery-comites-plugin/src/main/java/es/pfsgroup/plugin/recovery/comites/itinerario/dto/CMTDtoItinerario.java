package es.pfsgroup.plugin.recovery.comites.itinerario.dto;

import es.capgemini.devon.dto.WebDto;

public class CMTDtoItinerario extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1039718181878912391L;
	
	private Long idComite;
	private Long idItinerario;
	private String itinerario;
	private String tipoItinerario;
	private Boolean compatible;
	
	public void setIdItinerario(Long idItinerario) {
		this.idItinerario = idItinerario;
	}
	public Long getIdItinerario() {
		return idItinerario;
	}
	public void setItinerario(String itinerario) {
		this.itinerario = itinerario;
	}
	public String getItinerario() {
		return itinerario;
	}
	public void setCompatible(Boolean compatible) {
		this.compatible = compatible;
	}
	public Boolean getCompatible() {
		return compatible;
	}
	public void setTipoItinerario(String tipoItinerario) {
		this.tipoItinerario = tipoItinerario;
	}
	public String getTipoItinerario() {
		return tipoItinerario;
	}
	public void setIdComite(Long idComite) {
		this.idComite = idComite;
	}
	public Long getIdComite() {
		return idComite;
	}

}
