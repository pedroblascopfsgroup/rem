package es.pfsgroup.plugin.rem.model;

import java.util.List;

import es.capgemini.devon.dto.WebDto;


public class DtoNumPlantas  extends WebDto{

	private String descripcionPlanta;
	private Long numPlanta;
	private Long idActivo;
	
	public String getDescripcionPlanta() {
		return descripcionPlanta;
	}
	public Long getNumPlanta() {
		return numPlanta;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setDescripcionPlanta(String descripcionPlanta) {
		this.descripcionPlanta = descripcionPlanta;
	}
	public void setNumPlanta(Long numPlanta) {
		this.numPlanta = numPlanta;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	
	
    
    
}