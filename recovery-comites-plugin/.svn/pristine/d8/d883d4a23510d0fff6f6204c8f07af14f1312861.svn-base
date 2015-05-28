package es.pfsgroup.plugin.recovery.comites.comite.dto;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class CMTDtoAltaComite extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2744109126521582093L;
	
	private Long id;
	
	@NotNull (message="plugin.comites.messages.nombreNoVacio")
	@NotEmpty (message="plugin.comites.messages.nombreNoVacio")
	private String nombre;
	
	
	@NotNull (message="plugin.comites.messages.atMinNoVacio")
	private BigDecimal atribucionMinima;
	
	@NotNull (message="plugin.comites.messages.atMaxNoVacio")
	private BigDecimal atribucionMaxima;
	
	@NotNull (message="plugin.comites.messages.prioridadNoVacio")
	private Long prioridad;
	
	@NotNull (message="plugin.comites.messages.miembrosNoVacio")
	private Long miembros;
	
	@NotNull (message="plugin.comites.messages.miembrosRestNoVacio")
	private Long miembrosRestrict;
	
	@NotNull (message="plugin.comites.messages.zonaNoVacio")
	private Long zona;
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNombre() {
		return nombre;
	}
	
	public void setAtribucionMinima(BigDecimal atribucionMinima) {
		this.atribucionMinima = atribucionMinima;
	}
	public BigDecimal getAtribucionMinima() {
		return atribucionMinima;
	}
	public void setAtribucionMaxima(BigDecimal atribucionMaxima) {
		this.atribucionMaxima = atribucionMaxima;
	}
	public BigDecimal getAtribucionMaxima() {
		return atribucionMaxima;
	}
	
	public void setPrioridad(Long prioridad) {
		this.prioridad = prioridad;
	}
	public Long getPrioridad() {
		return prioridad;
	}
	public void setMiembros(Long miembros) {
		this.miembros = miembros;
	}
	public Long getMiembros() {
		return miembros;
	}
	public void setMiembrosRestrict(Long miembrosRestrict) {
		this.miembrosRestrict = miembrosRestrict;
	}
	public Long getMiembrosRestrict() {
		return miembrosRestrict;
	}
	public void setZona(Long zona) {
		this.zona = zona;
	}
	public Long getZona() {
		return zona;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}

}
