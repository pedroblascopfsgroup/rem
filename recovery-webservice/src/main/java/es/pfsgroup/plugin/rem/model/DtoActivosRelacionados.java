package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;




/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoActivosRelacionados extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long activo;
	private String descripcion;
	private String localizacion;
	private String idContrato;
	public Long getActivo() {
		return activo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getLocalizacion() {
		return localizacion;
	}
	public String getIdContrato() {
		return idContrato;
	}
	public void setActivo(Long activo) {
		this.activo = activo;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setLocalizacion(String localizacion) {
		this.localizacion = localizacion;
	}
	public void setIdContrato(String idContrato) {
		this.idContrato = idContrato;
	}
}