package es.pfsgroup.plugin.liquidaciones.avanzado.dto;

import java.math.BigDecimal;

public class LIQDtoLiquidacionResumen {
	private BigDecimal totalDeuda;
	private BigDecimal impuestos;
	private BigDecimal comisiones;
	private BigDecimal costasLetrado;
	private BigDecimal costasProcurador;
	private BigDecimal otrosGastos;
	private BigDecimal totalPagar;
	public BigDecimal getTotalDeuda() {
		return totalDeuda;
	}
	public void setTotalDeuda(BigDecimal totalDeuda) {
		this.totalDeuda = totalDeuda;
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
	public BigDecimal getTotalPagar() {
		return totalPagar;
	}
	public void setTotalPagar(BigDecimal totalPagar) {
		this.totalPagar = totalPagar;
	}
}
