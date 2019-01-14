package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoComercialActivo extends DtoTabActivo{

	private static final long serialVersionUID = 1L;

	private String id; // ID de activo.
	private String situacionComercialCodigo;
	private Date fechaVenta;
	private Boolean expedienteComercialVivo;
	private String observaciones;
	private Double importeVenta;
	private Boolean ventaExterna;
	private Boolean puja;


	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getSituacionComercialCodigo() {
		return situacionComercialCodigo;
	}

	public void setSituacionComercialCodigo(String situacionComercialCodigo) {
		this.situacionComercialCodigo = situacionComercialCodigo;
	}

	public Date getFechaVenta() {
		return fechaVenta;
	}

	public void setFechaVenta(Date fechaVenta) {
		this.fechaVenta = fechaVenta;
	}

	public Boolean getExpedienteComercialVivo() {
		return expedienteComercialVivo;
	}

	public void setExpedienteComercialVivo(Boolean expedienteComercialVivo) {
		this.expedienteComercialVivo = expedienteComercialVivo;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Double getImporteVenta() {
		return importeVenta;
	}

	public void setImporteVenta(Double importeVenta) {
		this.importeVenta = importeVenta;
	}

	public Boolean getVentaExterna() {
		return ventaExterna;
	}

	public void setVentaExterna(Boolean ventaExterna) {
		this.ventaExterna = ventaExterna;
	}
	
	public Boolean getPuja() {
		return puja;
	}

	public void setPuja(Boolean puja) {
		this.puja = puja;
	}

}
