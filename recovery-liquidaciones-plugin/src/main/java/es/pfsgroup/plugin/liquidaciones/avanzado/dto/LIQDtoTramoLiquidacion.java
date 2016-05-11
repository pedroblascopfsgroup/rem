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
    private BigDecimal intDemoraCierre = null;
    private BigDecimal impuestos = null;
    private BigDecimal comisiones = null;
    private BigDecimal gastos = null;
    private BigDecimal costasLetrado = null;
    private BigDecimal costasProcurador = null;
    private BigDecimal saldo = null;
    private BigDecimal intDemoraCierrePend = null;
    private BigDecimal interesesPendientes = null;
    private BigDecimal impuestosPendientes = null;
    private BigDecimal comisionesPendientes = null;
    private BigDecimal gastosPendientes = null;
    private BigDecimal costasLetradoPendientes = null;
    private BigDecimal costasProcuradorPendientes = null;
    private BigDecimal sobranteEntrega = null;
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
	public BigDecimal getIntDemoraCierre() {
		return intDemoraCierre;
	}
	public void setIntDemoraCierre(BigDecimal intDemoraCierre) {
		this.intDemoraCierre = intDemoraCierre;
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
	public BigDecimal getSaldo() {
		return saldo;
	}
	public void setSaldo(BigDecimal saldo) {
		this.saldo = saldo;
	}
	public BigDecimal getIntDemoraCierrePend() {
		return intDemoraCierrePend;
	}
	public void setIntDemoraCierrePend(BigDecimal intDemoraCierrePend) {
		this.intDemoraCierrePend = intDemoraCierrePend;
	}
	public BigDecimal getInteresesPendientes() {
		return interesesPendientes;
	}
	public void setInteresesPendientes(BigDecimal interesesPendientes) {
		this.interesesPendientes = interesesPendientes;
	}
	public BigDecimal getImpuestosPendientes() {
		return impuestosPendientes;
	}
	public void setImpuestosPendientes(BigDecimal impuestosPendientes) {
		this.impuestosPendientes = impuestosPendientes;
	}
	public BigDecimal getComisionesPendientes() {
		return comisionesPendientes;
	}
	public void setComisionesPendientes(BigDecimal comisionesPendientes) {
		this.comisionesPendientes = comisionesPendientes;
	}
	public BigDecimal getGastosPendientes() {
		return gastosPendientes;
	}
	public void setGastosPendientes(BigDecimal gastosPendientes) {
		this.gastosPendientes = gastosPendientes;
	}
	public BigDecimal getCostasLetradoPendientes() {
		return costasLetradoPendientes;
	}
	public void setCostasLetradoPendientes(BigDecimal costasLetradoPendientes) {
		this.costasLetradoPendientes = costasLetradoPendientes;
	}
	public BigDecimal getCostasProcuradorPendientes() {
		return costasProcuradorPendientes;
	}
	public void setCostasProcuradorPendientes(BigDecimal costasProcuradorPendientes) {
		this.costasProcuradorPendientes = costasProcuradorPendientes;
	}
	public BigDecimal getSobranteEntrega() {
		return sobranteEntrega;
	}
	public void setSobranteEntrega(BigDecimal sobranteEntrega) {
		this.sobranteEntrega = sobranteEntrega;
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
