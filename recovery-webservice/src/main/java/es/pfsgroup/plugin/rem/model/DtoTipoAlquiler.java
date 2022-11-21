package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoTipoAlquiler extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private String codTipoAlquiler;
	private String codSubtipoAlquiler;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getCodTipoAlquiler() {
		return codTipoAlquiler;
	}
	public void setCodTipoAlquiler(String codTipoAlquiler) {
		this.codTipoAlquiler = codTipoAlquiler;
	}
	public String getCodSubtipoAlquiler() {
		return codSubtipoAlquiler;
	}
	public void setCodSubtipoAlquiler(String codSubtipoAlquiler) {
		this.codSubtipoAlquiler = codSubtipoAlquiler;
	}
	
}
