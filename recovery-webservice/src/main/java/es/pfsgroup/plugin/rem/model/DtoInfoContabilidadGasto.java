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
	private Long diario1;
	private Long diario1Base;
	private Long diario1Tipo;
	private Long diario1Cuota;
	private Long diario2;
	private Long diario2Base;
	private Long diario2Tipo;
	private Long diario2Cuota;
	private Boolean isEmpty;
	private Boolean gicPlanVisitasBoolean;
	private String tipoComisionadoHreCodigo;
	private String tipoComisionadoHreDescripcion;
	private Long subPartidas;
	

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
	
	public Long getDiario1() {
		return diario1;
	}
	public void setDiario1(Long diario1) {
		this.diario1 = diario1;
	}
	public Long getDiario1Base() {
		return diario1Base;
	}
	public void setDiario1Base(Long diario1Base) {
		this.diario1Base = diario1Base;
	}
	public Long getDiario1Tipo() {
		return diario1Tipo;
	}
	public void setDiario1Tipo(Long diario1Tipo) {
		this.diario1Tipo = diario1Tipo;
	}
	public Long getDiario1Cuota() {
		return diario1Cuota;
	}
	public void setDiario1Cuota(Long diario1Cuota) {
		this.diario1Cuota = diario1Cuota;
	}
	public Long getDiario2() {
		return diario2;
	}
	public void setDiario2(Long diario2) {
		this.diario2 = diario2;
	}
	public Long getDiario2Base() {
		return diario2Base;
	}
	public void setDiario2Base(Long diario2Base) {
		this.diario2Base = diario2Base;
	}
	public Long getDiario2Tipo() {
		return diario2Tipo;
	}
	public void setDiario2Tipo(Long diario2Tipo) {
		this.diario2Tipo = diario2Tipo;
	}
	public Long getDiario2Cuota() {
		return diario2Cuota;
	}
	public void setDiario2Cuota(Long diario2Cuota) {
		this.diario2Cuota = diario2Cuota;
	}
	public Boolean getIsEmpty() {
		return isEmpty;
	}
	public void setIsEmpty(Boolean isEmpty) {
		this.isEmpty = isEmpty;
	}

	public Boolean getGicPlanVisitasBoolean() {
		return gicPlanVisitasBoolean;
	}
	public void setGicPlanVisitasBoolean(Boolean gicPlanVisitasBoolean) {
		this.gicPlanVisitasBoolean = gicPlanVisitasBoolean;
	}
	public String getTipoComisionadoHreCodigo() {
		return tipoComisionadoHreCodigo;
	}
	public void setTipoComisionadoHreCodigo(String tipoComisionadoHreCodigo) {
		this.tipoComisionadoHreCodigo = tipoComisionadoHreCodigo;
	}
	public String getTipoComisionadoHreDescripcion() {
		return tipoComisionadoHreDescripcion;
	}
	public void setTipoComisionadoHreDescripcion(String tipoComisionadoHreDescripcion) {
		this.tipoComisionadoHreDescripcion = tipoComisionadoHreDescripcion;
	}
	public Long getSubPartidas() {
		return subPartidas;
	}
	public void setSubPartidas(Long subPartidas) {
		this.subPartidas = subPartidas;
	}
	

   	
}
