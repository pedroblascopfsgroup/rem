package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * 
 * Dto para el grid de historico de destino comercial / tipo comercializacion de un activo
 * @author Angel Pastelero
 */

public class DtoHistoricoDestinoComercial extends WebDto {

	private static final long serialVersionUID = 1L;
	
	private String tipoComercializacion;
	private Date fechaInicio;
	private Date fechaFin;
	private String gestorActualizacion;
	
	
	public String getTipoComercializacion() {
		return tipoComercializacion;
	}
	public void setTipoComercializacion(String tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}
	public Date getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public Date getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getGestorActualizacion() {
		return gestorActualizacion;
	}
	public void setGestorActualizacion(String gestorActualizacion) {
		this.gestorActualizacion = gestorActualizacion;
	}

}