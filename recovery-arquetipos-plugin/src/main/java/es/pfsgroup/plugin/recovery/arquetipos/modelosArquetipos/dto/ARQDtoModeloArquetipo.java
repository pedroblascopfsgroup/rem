package es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dto;

import es.capgemini.devon.dto.WebDto;

public class ARQDtoModeloArquetipo extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6628915391906840132L;
	private Long id;
	private Long idModelo;
	private Long idArquetipo;
	private Long nivel;
	private Long prioridad;
	private Long idItinerario;
	private Long arquetipos;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdModelo() {
		return idModelo;
	}
	public void setIdModelo(Long idModelo) {
		this.idModelo = idModelo;
	}
	public Long getIdArquetipo() {
		return idArquetipo;
	}
	public void setIdArquetipo(Long idArquetipo) {
		this.idArquetipo = idArquetipo;
	}
	public Long getNivel() {
		return nivel;
	}
	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}
	public Long getPrioridad() {
		return prioridad;
	}
	public void setPrioridad(Long prioridad) {
		this.prioridad = prioridad;
	}
	public Long getIdItinerario() {
		return idItinerario;
	}
	public void setIdItinerario(Long idItinerario) {
		this.idItinerario = idItinerario;
	}
	public void setArquetipos(Long arquetipos) {
		this.arquetipos = arquetipos;
	}
	public Long getArquetipos() {
		return arquetipos;
	}
}
