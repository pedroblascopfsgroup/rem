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
	private String partidaPresupuestaria;
	private String cuentaContable;
	private Date fechaDevengoEspecial;
	private String periodicidadEspecialDescripcion;
	private String partidaPresupuestariaEspecial;
	private String cuentaContableEspecial;
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
	public String getPartidaPresupuestaria() {
		return partidaPresupuestaria;
	}
	public void setPartidaPresupuestaria(
			String partidaPresupuestaria) {
		this.partidaPresupuestaria = partidaPresupuestaria;
	}
	public String getCuentaContable() {
		return cuentaContable;
	}
	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}
	public Date getFechaDevengoEspecial() {
		return fechaDevengoEspecial;
	}
	public void setFechaDevengoEspecial(Date fechaDevengoEspecial) {
		this.fechaDevengoEspecial = fechaDevengoEspecial;
	}
	public String getPeriodicidadEspecialDescripcion() {
		return periodicidadEspecialDescripcion;
	}
	public void setPeriodicidadEspecialDescripcion(
			String periodicidadEspecialDescripcion) {
		this.periodicidadEspecialDescripcion = periodicidadEspecialDescripcion;
	}
	public String getPartidaPresupuestariaEspecial() {
		return partidaPresupuestariaEspecial;
	}
	public void setPartidaPresupuestariaEspecial(
			String partidaPresupuestariaEspecial) {
		this.partidaPresupuestariaEspecial = partidaPresupuestariaEspecial;
	}
	public String getCuentaContableEspecial() {
		return cuentaContableEspecial;
	}
	public void setCuentaContableEspecial(
			String cuentaContableEspecial) {
		this.cuentaContableEspecial = cuentaContableEspecial;
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
