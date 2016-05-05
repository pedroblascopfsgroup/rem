package es.pfsgroup.plugin.liquidaciones.avanzado.dto;

import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;


public class DtoCalculoLiquidacion extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	private Long id;
	private String nombre;
	private Long asunto;
	private Long actuacion;
	private Long contrato;
	private String nombrePersona;
	private String documentoId;
	private BigDecimal capital;
	private BigDecimal interesesOrdinarios;
	private BigDecimal interesesDemora;
	private BigDecimal comisiones;
	private BigDecimal impuestos;
	private BigDecimal gastos;
	private String fechaCierre;
	private BigDecimal costasLetrado;
	private BigDecimal costasProcurador;
	private BigDecimal otrosGastos;
	private Integer baseCalculo;
	private String fechaLiquidacion;
	private Float tipoMoraCierre;
	private BigDecimal totalCaculo;
	private Long estadoCalculo;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Long getAsunto() {
		return asunto;
	}

	public void setAsunto(Long asunto) {
		this.asunto = asunto;
	}

	public Long getActuacion() {
		return actuacion;
	}

	public void setActuacion(Long actuacion) {
		this.actuacion = actuacion;
	}

	public Long getContrato() {
		return contrato;
	}

	public void setContrato(Long contrato) {
		this.contrato = contrato;
	}

	public String getNombrePersona() {
		return nombrePersona;
	}

	public void setNombrePersona(String nombrePersona) {
		this.nombrePersona = nombrePersona;
	}

	public String getDocumentoId() {
		return documentoId;
	}

	public void setDocumentoId(String documentoId) {
		this.documentoId = documentoId;
	}

	public BigDecimal getCapital() {
		return capital;
	}

	public void setCapital(BigDecimal capital) {
		this.capital = capital;
	}

	public BigDecimal getInteresesOrdinarios() {
		return interesesOrdinarios;
	}

	public void setInteresesOrdinarios(BigDecimal interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}

	public BigDecimal getInteresesDemora() {
		return interesesDemora;
	}

	public void setInteresesDemora(BigDecimal interesesDemora) {
		this.interesesDemora = interesesDemora;
	}

	public BigDecimal getComisiones() {
		return comisiones;
	}

	public void setComisiones(BigDecimal comisiones) {
		this.comisiones = comisiones;
	}

	public BigDecimal getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(BigDecimal impuestos) {
		this.impuestos = impuestos;
	}

	public BigDecimal getGastos() {
		return gastos;
	}

	public void setGastos(BigDecimal gastos) {
		this.gastos = gastos;
	}

	public String getFechaCierre() {
		return fechaCierre;
	}

	public void setFechaCierre(String fechaCierre) {
		this.fechaCierre = fechaCierre;
	}

	public BigDecimal getCostasLetrado() {
		return costasLetrado;
	}

	public void setCostasLetrado(BigDecimal costasLetrado) {
		this.costasLetrado = costasLetrado;
	}

	public BigDecimal getCostasProcurador() {
		return costasProcurador;
	}

	public void setCostasProcurador(BigDecimal costasProcurador) {
		this.costasProcurador = costasProcurador;
	}

	public BigDecimal getOtrosGastos() {
		return otrosGastos;
	}

	public void setOtrosGastos(BigDecimal otrosGastos) {
		this.otrosGastos = otrosGastos;
	}

	public Integer getBaseCalculo() {
		return baseCalculo;
	}

	public void setBaseCalculo(Integer baseCalculo) {
		this.baseCalculo = baseCalculo;
	}

	public String getFechaLiquidacion() {
		return fechaLiquidacion;
	}

	public void setFechaLiquidacion(String fechaLiquidacion) {
		this.fechaLiquidacion = fechaLiquidacion;
	}

	public Float getTipoMoraCierre() {
		return tipoMoraCierre;
	}

	public void setTipoMoraCierre(Float tipoMoraCierre) {
		this.tipoMoraCierre = tipoMoraCierre;
	}

	public BigDecimal getTotalCaculo() {
		return totalCaculo;
	}

	public void setTotalCaculo(BigDecimal totalCaculo) {
		this.totalCaculo = totalCaculo;
	}
	
	public Long getEstadoCalculo() {
		return estadoCalculo;
	}

	public void setEstadoCalculo(Long estadoCalculo) {
		this.estadoCalculo = estadoCalculo;
	}
	
}
