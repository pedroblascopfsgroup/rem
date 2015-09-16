package es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dto;

import es.capgemini.devon.dto.AbstractDto;

public class ARQDtoEditarArqsMod extends AbstractDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4204613367662678941L;
	private Long id;
	private Long idArquetipo;
	private Long idModelo;
	private Long itinerario;
	private Long prioridad;
	private Boolean gestion;
	private Long plazoDisparo;
	private Long nivel;
	
	
	
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
	public void setPrioridad(Long prioridad) {
		this.prioridad = prioridad;
	}
	public Long getPrioridad() {
		return prioridad;
	}
	public void setGestion(Boolean gestion) {
		this.gestion = gestion;
	}
	public Boolean getGestion() {
		return gestion;
	}
	public void setPlazoDisparo(Long plazoDisparo) {
		this.plazoDisparo = plazoDisparo;
	}
	public Long getPlazoDisparo() {
		return plazoDisparo;
	}
	public void setIdArquetipo(Long idArquetipo) {
		this.idArquetipo = idArquetipo;
	}
	public Long getIdArquetipo() {
		return idArquetipo;
	}
	public void setIdModelo(Long idModelo) {
		this.idModelo = idModelo;
	}
	public Long getIdModelo() {
		return idModelo;
	}
	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}
	public Long getNivel() {
		return nivel;
	}

}
