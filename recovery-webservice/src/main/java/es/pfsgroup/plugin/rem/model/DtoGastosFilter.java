package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Gastos Proveedor
 * @author Luis Caballero
 *
 */
public class DtoGastosFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private Long numGastoHaya;
	private Long numFactura;
	private String tipo;
	private String subtipo;
	private String concepto;
	private String idProveedor;
	private String codigoProveedor;
	private String fechaEmision;
	private Double importeTotal;
	private String fechaTopePago;
	private String fechaPago;
	private String periodicidad;
	private String destinatario;
	private String idDetalleGasto;
	private Long idProvision;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumGastoHaya() {
		return numGastoHaya;
	}
	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}
	public Long getNumFactura() {
		return numFactura;
	}
	public void setNumFactura(Long numFactura) {
		this.numFactura = numFactura;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getSubtipo() {
		return subtipo;
	}
	public void setSubtipo(String subtipo) {
		this.subtipo = subtipo;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getIdProveedor() {
		return idProveedor;
	}
	public void setIdProveedor(String idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getCodigoProveedor() {
		return codigoProveedor;
	}
	public void setCodigoProveedor(String codigoProveedor) {
		this.codigoProveedor = codigoProveedor;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public Double getImporteTotal() {
		return importeTotal;
	}
	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}
	public String getFechaTopePago() {
		return fechaTopePago;
	}
	public void setFechaTopePago(String fechaTopePago) {
		this.fechaTopePago = fechaTopePago;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getDestinatario() {
		return destinatario;
	}
	public void setDestinatario(String destinatario) {
		this.destinatario = destinatario;
	}
	public String getIdDetalleGasto() {
		return idDetalleGasto;
	}
	public void setIdDetalleGasto(String idDetalleGasto) {
		this.idDetalleGasto = idDetalleGasto;
	}
	public Long getIdProvision() {
		return idProvision;
	}
	public void setIdProvision(Long idProvision) {
		this.idProvision = idProvision;
	}

	
}