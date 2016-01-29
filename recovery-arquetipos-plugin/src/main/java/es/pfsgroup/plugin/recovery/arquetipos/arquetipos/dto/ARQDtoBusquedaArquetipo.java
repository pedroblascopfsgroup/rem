package es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dto;

import es.capgemini.devon.dto.WebDto;

public class ARQDtoBusquedaArquetipo extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -5677270589802489425L;
	
	private String nombre;
	
	private Long rule;
	
	private Long estado;
	
	private Long modelo;

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}

	public void setRule(Long rule) {
		this.rule = rule;
	}

	public Long getRule() {
		return rule;
	}

	public void setEstado(Long estado) {
		this.estado = estado;
	}

	public Long getEstado() {
		return estado;
	}

	public void setModelo(Long modelo) {
		this.modelo = modelo;
	}

	public Long getModelo() {
		return modelo;
	}
	

}
