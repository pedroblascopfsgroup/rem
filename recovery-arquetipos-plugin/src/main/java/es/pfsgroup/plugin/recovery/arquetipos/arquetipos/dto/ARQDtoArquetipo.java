package es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class ARQDtoArquetipo extends WebDto{
	
	private static final long serialVersionUID = 5209769073775812336L;

	private Long id;
	
	@NotNull (message="plugin.arquetipos.messages.nombreNoVacio")
	@NotEmpty (message="plugin.arquetipos.messages.nombreNoVacio")
	private String nombre;
	
	@NotNull (message="plugin.arquetipos.messages.reglaNoVacio")
	private Long rule;
	
	private Boolean gestion;
	
	private Long plazoDisparo;
	
	private Long tipoSaltoNivel;
	
	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}

	public void setRule(Long rule) {
		this.rule = rule;
	}

	public Long getRule() {
		return rule;
	}

	public void setTipoSaltoNivel(Long tipoSaltoNivel) {
		this.tipoSaltoNivel = tipoSaltoNivel;
	}

	public Long getTipoSaltoNivel() {
		return tipoSaltoNivel;
	}

	public void setPlazoDisparo(Long plazoDisparo) {
		this.plazoDisparo = plazoDisparo;
	}

	public Long getPlazoDisparo() {
		return plazoDisparo;
	}

	public void setGestion(Boolean gestion) {
		this.gestion = gestion;
	}

	public Boolean getGestion() {
		return gestion;
	}

	
	
	
	

}
