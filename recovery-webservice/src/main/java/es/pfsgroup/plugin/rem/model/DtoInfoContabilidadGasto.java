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
	private Date fechaDevengoEspecial;
	private String periodicidadEspecialDescripcion;
	private Date fechaContabilizacion;
	private String contabilizadoPorDescripcion;
	private Long idSubpartidaPresupuestaria;
	private String comboActivable;

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
	public Long getIdSubpartidaPresupuestaria() {
		return idSubpartidaPresupuestaria;
	}
	public void setIdSubpartidaPresupuestaria(Long idSubpartidaPresupuestaria) {
		this.idSubpartidaPresupuestaria = idSubpartidaPresupuestaria;
	}

	public String getComboActivable() {
		return comboActivable;
	}

	public void setComboActivable(String comboActivable) {
		this.comboActivable = comboActivable;
	}
   	
}
