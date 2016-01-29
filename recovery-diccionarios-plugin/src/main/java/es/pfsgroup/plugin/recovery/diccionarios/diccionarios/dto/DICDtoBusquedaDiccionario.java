package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dto;

import es.capgemini.devon.dto.WebDto;

public class DICDtoBusquedaDiccionario extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2873823139695259481L;
	
	private String nombre;

    private String descripcion;

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}


}
