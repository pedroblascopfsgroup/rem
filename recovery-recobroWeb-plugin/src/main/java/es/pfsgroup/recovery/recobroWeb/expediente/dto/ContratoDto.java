package es.pfsgroup.recovery.recobroWeb.expediente.dto;

import es.capgemini.pfs.diccionarios.Dictionary;

public class ContratoDto implements Dictionary {
	
	private Long id;
	private String codigo;
	private String descripcion;
	private String descripcionLarga;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}
	
	
	
}
