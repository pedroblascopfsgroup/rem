package es.pfsgroup.plugin.rem.model;

import java.util.List;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para encapsular la información de cada pestaña del activo *
 */
public class DtoActivoBbvaUic  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private Long idActivo;
	private String uicBbva;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getUicBbva() {
		return uicBbva;
	}
	public void setUicBbva(String uicBbva) {
		this.uicBbva = uicBbva;
	}  
    
}