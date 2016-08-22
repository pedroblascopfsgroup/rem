package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para mostrar las actuaciones
 * @author Daniel Gutiérrez
 *
 */
public class DtoListadoActuaciones extends WebDto {

	private static final long serialVersionUID = 0L;
	
	private Long idActuacion;

	private Long idTipoActuacion;
	
	private String tipoActuacion;
	
	private Long idActuacionPadre;

	private Long idActivo;
	
	private String nombre;
	
	private String estado;
	
	public Long getIdActuacion() {
		return idActuacion;
	}

	public void setIdActuacion(Long idActuacion) {
		this.idActuacion = idActuacion;
	}

	public Long getIdTipoActuacion() {
		return idTipoActuacion;
	}

	public void setIdTipoActuacion(Long idTipoActuacion) {
		this.idTipoActuacion = idTipoActuacion;
	}

	public String getTipoActuacion() {
		return tipoActuacion;
	}

	public void setTipoActuacion(String tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}

	public Long getIdActuacionPadre() {
		return idActuacionPadre;
	}

	public void setIdActuacionPadre(Long idActuacionPadre) {
		this.idActuacionPadre = idActuacionPadre;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

}