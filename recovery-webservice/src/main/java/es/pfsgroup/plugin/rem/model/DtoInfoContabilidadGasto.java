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
	private String diario1;
	private Double diario1Base;
	private Double diario1Tipo;
	private Double diario1Cuota;
	private String diario2;
	private Double diario2Base;
	private Double diario2Tipo;
	private Double diario2Cuota;
	private Boolean isEmpty;
	private Boolean gicPlanVisitasBoolean;
	private String tipoComisionadoHreCodigo;
	private String tipoComisionadoHreDescripcion;
	private String errorDiarios;
	private boolean resultadoDiarios;
	private Boolean inversionSujetoPasivoBoolean;
	

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
	
	public String getDiario1() {
		return diario1;
	}
	public void setDiario1(String diario1) {
		this.diario1 = diario1;
	}

	public Double getDiario1Base() {
		return diario1Base;
	}
	public void setDiario1Base(Double diario1Base) {
		this.diario1Base = diario1Base;
	}
	public Double getDiario1Tipo() {
		return diario1Tipo;
	}
	public void setDiario1Tipo(Double diario1Tipo) {
		this.diario1Tipo = diario1Tipo;
	}
	public Double getDiario1Cuota() {
		return diario1Cuota;
	}
	public void setDiario1Cuota(Double diario1Cuota) {
		this.diario1Cuota = diario1Cuota;
	}
	public String getDiario2() {
		return diario2;
	}
	public void setDiario2(String diario2) {
		this.diario2 = diario2;
	}
	public Double getDiario2Base() {
		return diario2Base;
	}
	public void setDiario2Base(Double diario2Base) {
		this.diario2Base = diario2Base;
	}
	public Double getDiario2Tipo() {
		return diario2Tipo;
	}
	public void setDiario2Tipo(Double diario2Tipo) {
		this.diario2Tipo = diario2Tipo;
	}
	public Double getDiario2Cuota() {
		return diario2Cuota;
	}
	public void setDiario2Cuota(Double diario2Cuota) {
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
	public String getErrorDiarios() {
		return errorDiarios;
	}
	public void setErrorDiarios(String errorDiarios) {
		this.errorDiarios = errorDiarios;
	}
	public boolean isResultadoDiarios() {
		return resultadoDiarios;
	}
	public void setResultadoDiarios(boolean resultadoDiarios) {
		this.resultadoDiarios = resultadoDiarios;
	}
	public Boolean getInversionSujetoPasivoBoolean() {
		return inversionSujetoPasivoBoolean;
	}
	public void setInversionSujetoPasivoBoolean(Boolean inversionSujetoPasivoBoolean) {
		this.inversionSujetoPasivoBoolean = inversionSujetoPasivoBoolean;
	}
	
	
}
