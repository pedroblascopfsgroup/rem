package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class ActivoDto implements Serializable{
	
	private static final long serialVersionUID = -6901301764485295835L;
	
	private String descripcion;
	private String pais;
	private String provincia;
	private String direccion;
	private Long numActivo;
	
	

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getPais() {
		return pais;
	}

	public void setPais(String pais) {
		this.pais = pais;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	
	

}
