package es.pfsgroup.plugin.liquidaciones.avanzado.dto;

import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;


public class LIQDtoTramoLiquidacion extends WebDto {

    private static final long serialVersionUID = 1L;
    
    private String fechaValor;
    private String descripcion;
    private BigDecimal importe = null;
    private BigDecimal entregado = null;
    private BigDecimal intereses = null;
    private BigDecimal impuestos = null;
    private BigDecimal comisiones = null;
    private BigDecimal gastos = null;
    private BigDecimal saldo = null;
    private BigDecimal interesesPendientes = null;
    private Integer dias = null;
    private Float tipoDemora = null;
    private BigDecimal interesesDemora = null;
	public String getFechaValor() {
		return fechaValor;
	}
	public void setFechaValor(String fechaValor) {
		this.fechaValor = fechaValor;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public BigDecimal getImporte() {
		return importe;
	}
	public void setImporte(BigDecimal importe) {
		this.importe = importe;
	}
	public BigDecimal getEntregado() {
		return entregado;
	}
	public void setEntregado(BigDecimal entregado) {
		this.entregado = entregado;
	}
	public BigDecimal getIntereses() {
		return intereses;
	}
	public void setIntereses(BigDecimal intereses) {
		this.intereses = intereses;
	}
	public BigDecimal getImpuestos() {
		return impuestos;
	}
	public void setImpuestos(BigDecimal impuestos) {
		this.impuestos = impuestos;
	}
	public BigDecimal getComisiones() {
		return comisiones;
	}
	public void setComisiones(BigDecimal comisiones) {
		this.comisiones = comisiones;
	}
	public BigDecimal getGastos() {
		return gastos;
	}
	public void setGastos(BigDecimal gastos) {
		this.gastos = gastos;
	}
	public BigDecimal getSaldo() {
		return saldo;
	}
	public void setSaldo(BigDecimal saldo) {
		this.saldo = saldo;
	}
	public BigDecimal getInteresesPendientes() {
		return interesesPendientes;
	}
	public void setInteresesPendientes(BigDecimal interesesPendientes) {
		this.interesesPendientes = interesesPendientes;
	}
	public Integer getDias() {
		return dias;
	}
	public void setDias(Integer dias) {
		this.dias = dias;
	}
	public Float getTipoDemora() {
		return tipoDemora;
	}
	public void setTipoDemora(Float tipoDemora) {
		this.tipoDemora = tipoDemora;
	}
	public BigDecimal getInteresesDemora() {
		return interesesDemora;
	}
	public void setInteresesDemora(BigDecimal interesesDemora) {
		this.interesesDemora = interesesDemora;
	}
    
}
