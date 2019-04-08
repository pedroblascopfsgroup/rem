package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoReclamacionActivo extends WebDto {
	
	private static final long serialVersionUID = -2437741500037132036L;
	
    private Long id;
	private String fechaAviso;
	private String fechaReclamacion;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getFechaAviso() {
		return fechaAviso;
	}
	public void setFechaAviso(String fechaAviso) {
		this.fechaAviso = fechaAviso;
	}
	public String getFechaReclamacion() {
		return fechaReclamacion;
	}
	public void setFechaReclamacion(String fechaReclamacion) {
		this.fechaReclamacion = fechaReclamacion;
	}
}
