package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de la pestaña impugnacion de un gasto.
 *  
 * @author Luis Caballero
 *
 */
public class DtoImpugnacionGasto extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Date fechaTope;
	private Date fechaPresentacion;
	private Date fechaResolucion;
	private String resultadoCodigo;
	private String observaciones;
	

	public Date getFechaTope() {
		return fechaTope;
	}
	public void setFechaTope(Date fechaTope) {
		this.fechaTope = fechaTope;
	}
	public Date getFechaPresentacion() {
		return fechaPresentacion;
	}
	public void setFechaPresentacion(Date fechaPresentacion) {
		this.fechaPresentacion = fechaPresentacion;
	}
	public Date getFechaResolucion() {
		return fechaResolucion;
	}
	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}
	public String getResultadoCodigo() {
		return resultadoCodigo;
	}
	public void setResultadoCodigo(String resultadoCodigo) {
		this.resultadoCodigo = resultadoCodigo;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	
	
   	
   	
}
