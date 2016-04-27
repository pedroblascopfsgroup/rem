package es.pfsgroup.plugin.liquidaciones.avanzado.dto;

import java.math.BigDecimal;

public class LIQTramoPendientes {
	private BigDecimal saldo = BigDecimal.ZERO;
	private BigDecimal intereses = BigDecimal.ZERO;
	private BigDecimal impuestos = BigDecimal.ZERO;
	private BigDecimal comisiones = BigDecimal.ZERO;
	private BigDecimal gastos = BigDecimal.ZERO;
	private BigDecimal costasLetrado = BigDecimal.ZERO;
	private BigDecimal costasProcurador = BigDecimal.ZERO;
	private BigDecimal sobranteEntrega = BigDecimal.ZERO;
	public BigDecimal getSaldo() {
		return saldo;
	}
	public void setSaldo(BigDecimal saldo) {
		this.saldo = saldo;
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
	public BigDecimal getSobranteEntrega() {
		return sobranteEntrega;
	}
	public void setSobranteEntrega(BigDecimal sobranteEntrega) {
		this.sobranteEntrega = sobranteEntrega;
	}
}
