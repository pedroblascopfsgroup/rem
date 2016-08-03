package es.pfsgroup.plugin.rem.rest.controller;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Activos
 * @author Benjamín Guerrero
 *
 */
public class DtoWebServiceCliente extends WebDto {

	private static final long serialVersionUID = 0L;

	private String idClienteWebcom;
	private String idClienteRem;
	private String razonSocial;
	private String nombre;
	private String apellidos;
	
	
	public String getIdClienteWebcom() {
		return idClienteWebcom;
	}
	public void setIdClienteWebcom(String idClienteWebcom) {
		this.idClienteWebcom = idClienteWebcom;
	}
	public String getIdClienteRem() {
		return idClienteRem;
	}
	public void setIdClienteRem(String idClienteRem) {
		this.idClienteRem = idClienteRem;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellidos() {
		return apellidos;
	}
	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}
	
	


	
	
}