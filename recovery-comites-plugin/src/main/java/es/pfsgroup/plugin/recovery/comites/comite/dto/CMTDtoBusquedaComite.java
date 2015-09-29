package es.pfsgroup.plugin.recovery.comites.comite.dto;

import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;

public class CMTDtoBusquedaComite extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3373526529611178698L;

	private Long id;
	private String nombre;
	private BigDecimal atribucionMinima;
	private BigDecimal atribucionMaxima;
	private Long itinerario;
	private String perfiles;
	private String centros;
	
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
	public void setItinerario(Long itinerario) {
		this.itinerario = itinerario;
	}
	public Long getItinerario() {
		return itinerario;
	}
	public void setPerfiles(String perfiles) {
		this.perfiles = perfiles;
	}
	public String getPerfiles() {
		return perfiles;
	}
	public void setCentros(String centros) {
		this.centros = centros;
	}
	public String getCentros() {
		return centros;
	}
}
