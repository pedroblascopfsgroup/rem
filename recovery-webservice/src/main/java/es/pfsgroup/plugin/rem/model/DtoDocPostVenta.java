package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoDocPostVenta extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Date fechaContabilizacion;
	private Date fechaIngresoCheque;
	private String ventaCondicionSuspensiva;
	private Boolean ventaDirecta;
	
	public Date getFechaContabilizacion() {
		return fechaContabilizacion;
	}
	public void setFechaContabilizacion(Date fechaContabilizacion) {
		this.fechaContabilizacion = fechaContabilizacion;
	}
	public Date getFechaIngresoCheque() {
		return fechaIngresoCheque;
	}
	public void setFechaIngresoCheque(Date fechaIngresoCheque) {
		this.fechaIngresoCheque = fechaIngresoCheque;
	}
	public String getVentaCondicionSuspensiva() {
		return ventaCondicionSuspensiva;
	}
	public void setVentaCondicionSuspensiva(String ventaCondicionSuspensiva) {
		this.ventaCondicionSuspensiva = ventaCondicionSuspensiva;
	}
	public Boolean isVentaDirecta() {
		return ventaDirecta;
	}
	public void setVentaDirecta(Boolean ventaDirecta) {
		this.ventaDirecta = ventaDirecta;
	}
	
	
	
	
}
