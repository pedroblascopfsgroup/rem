package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


public class DtoDatosOfertaPdf extends WebDto {


	private static final long serialVersionUID = 0L;
	
	private Long id;
	private Long numOferta;
	private String nombre;
	private Double importeOferta;
	private String fechaOferta;
	private String estadoOferta;
	private String familiarCaixa;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public Double getImporteOferta() {
		return importeOferta;
	}
	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}
	public String getFechaOferta() {
		return fechaOferta;
	}
	public void setFechaOferta(String fechaOferta) {
		this.fechaOferta = fechaOferta;
	}
	public String getEstadoOferta() {
		return estadoOferta;
	}
	public void setEstadoOferta(String estadoOferta) {
		this.estadoOferta = estadoOferta;
	}
	public String getFamiliarCaixa() {
		return familiarCaixa;
	}
	public void setFamiliarCaixa(String familiarCaixa) {
		this.familiarCaixa = familiarCaixa;
	}
	
	
	
	
	
}