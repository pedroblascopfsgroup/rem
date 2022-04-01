package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para los datos del catastro de rem.
 * @author Ivan Rubio
 *
 */
public class DtoDatosCatastroGrid extends WebDto {

	private static final long serialVersionUID = 0L;
	
	private String nombre;
	private String datoRem;
	private String datoCatastro;
	private Boolean coincidencia;
	private String probabilidad;
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDatoRem() {
		return datoRem;
	}
	public void setDatoRem(String datoRem) {
		this.datoRem = datoRem;
	}
	public String getDatoCatastro() {
		return datoCatastro;
	}
	public void setDatoCatastro(String datoCatastro) {
		this.datoCatastro = datoCatastro;
	}
	public Boolean getCoincidencia() {
		return coincidencia;
	}
	public void setCoincidencia(Boolean coincidencia) {
		this.coincidencia = coincidencia;
	}
	public String getProbabilidad() {
		return probabilidad;
	}
	public void setProbabilidad(String probabilidad) {
		this.probabilidad = probabilidad;
	}
	
}