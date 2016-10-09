package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de la pestaña contabilidad de un gasto.
 *  
 * @author Luis Caballero
 *
 */
public class DtoInfoContabilidadGasto extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long ejercicioImputaGasto;
	private String periodicidadDescripcion;
	private String partidaPresupuestariaDescripcion;
	private String cuentaContableDescripcion;
	private Date fechaDevengo;
	private String periodicidadEspecialDescripcion;
	private String partidaPresupuestariaEspecialDescripcion;
	private String cuentaContableEspecialDescripcion;
	private Date fechaContabilizacion;
	private String contabilizadoPorDescripcion;

	public Long getEjercicioImputaGasto() {
		return ejercicioImputaGasto;
	}
	public void setEjercicioImputaGasto(Long ejercicioImputaGasto) {
		this.ejercicioImputaGasto = ejercicioImputaGasto;
	}
	public String getPeriodicidadDescripcion() {
		return periodicidadDescripcion;
	}
	public void setPeriodicidadDescripcion(String periodicidadDescripcion) {
		this.periodicidadDescripcion = periodicidadDescripcion;
	}
	public String getPartidaPresupuestariaDescripcion() {
		return partidaPresupuestariaDescripcion;
	}
	public void setPartidaPresupuestariaDescripcion(
			String partidaPresupuestariaDescripcion) {
		this.partidaPresupuestariaDescripcion = partidaPresupuestariaDescripcion;
	}
	public String getCuentaContableDescripcion() {
		return cuentaContableDescripcion;
	}
	public void setCuentaContableDescripcion(String cuentaContableDescripcion) {
		this.cuentaContableDescripcion = cuentaContableDescripcion;
	}
	public Date getFechaDevengo() {
		return fechaDevengo;
	}
	public void setFechaDevengo(Date fechaDevengo) {
		this.fechaDevengo = fechaDevengo;
	}
	public String getPeriodicidadEspecialDescripcion() {
		return periodicidadEspecialDescripcion;
	}
	public void setPeriodicidadEspecialDescripcion(
			String periodicidadEspecialDescripcion) {
		this.periodicidadEspecialDescripcion = periodicidadEspecialDescripcion;
	}
	public String getPartidaPresupuestariaEspecialDescripcion() {
		return partidaPresupuestariaEspecialDescripcion;
	}
	public void setPartidaPresupuestariaEspecialDescripcion(
			String partidaPresupuestariaEspecialDescripcion) {
		this.partidaPresupuestariaEspecialDescripcion = partidaPresupuestariaEspecialDescripcion;
	}
	public String getCuentaContableEspecialDescripcion() {
		return cuentaContableEspecialDescripcion;
	}
	public void setCuentaContableEspecialDescripcion(
			String cuentaContableEspecialDescripcion) {
		this.cuentaContableEspecialDescripcion = cuentaContableEspecialDescripcion;
	}
	public Date getFechaContabilizacion() {
		return fechaContabilizacion;
	}
	public void setFechaContabilizacion(Date fechaContabilizacion) {
		this.fechaContabilizacion = fechaContabilizacion;
	}
	public String getContabilizadoPorDescripcion() {
		return contabilizadoPorDescripcion;
	}
	public void setContabilizadoPorDescripcion(String contabilizadoPorDescripcion) {
		this.contabilizadoPorDescripcion = contabilizadoPorDescripcion;
	}
	
   	
}
