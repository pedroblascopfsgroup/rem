package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import es.pfsgroup.plugin.rem.model.dd.DDTerritorio;

public class DtoComercialActivo extends DtoTabActivo{

	private static final long serialVersionUID = 1L;

	private String id; // ID de activo.
	private String situacionComercialCodigo;
	private String situacionComercialDescripcion;
	private Date fechaVenta;
	private Boolean expedienteComercialVivo;
	private String observaciones;
	private Double importeVenta;
	private Boolean ventaExterna;
	private Boolean puja;
	private Boolean tramitable;
	private String motivoAutorizacionTramitacionCodigo;
	private String motivoAutorizacionTramitacionDescripcion;
	private String observacionesAutoTram;
	private String direccionComercial;
	private String direccionComercialDescripcion;
	private Boolean ventaSobrePlano;
	private String activoObraNuevaComercializacion;
	private Date activoObraNuevaComercializacionFecha;


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
	
	public String getSituacionComercialDescripcion() {
		return situacionComercialDescripcion;
	}

	public void setSituacionComercialDescripcion(String situacionComercialDescripcion) {
		this.situacionComercialDescripcion = situacionComercialDescripcion;
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
	
	public String getMotivoAutorizacionTramitacionCodigo() {
		return motivoAutorizacionTramitacionCodigo;
	}

	public void setMotivoAutorizacionTramitacionCodigo(String motivoAutorizacionTramitacionCodigo) {
		this.motivoAutorizacionTramitacionCodigo = motivoAutorizacionTramitacionCodigo;
	}
	
	public String getMotivoAutorizacionTramitacionDescripcion() {
		return motivoAutorizacionTramitacionDescripcion;
	}

	public void setMotivoAutorizacionTramitacionDescripcion(String motivoAutorizacionTramitacionDescripcion) {
		this.motivoAutorizacionTramitacionDescripcion = motivoAutorizacionTramitacionDescripcion;
	}

	public Boolean getTramitable() {
		return tramitable;
	}

	public void setTramitable(Boolean tramitable) {
		this.tramitable = tramitable;
	}

	public String getObservacionesAutoTram() {
		return observacionesAutoTram;
	}

	public void setObservacionesAutoTram(String observacionesAutoTram) {
		this.observacionesAutoTram = observacionesAutoTram;
	}

	public String getDireccionComercial() {
		return direccionComercial;
	}

	public void setDireccionComercial(String direccionComercial) {
		this.direccionComercial = direccionComercial;
	}
	
	public String getDireccionComercialDescripcion() {
		return direccionComercialDescripcion;
	}

	public void setDireccionComercialDescripcion(String direccionComercialDescripcion) {
		this.direccionComercialDescripcion = direccionComercialDescripcion;
	}
	
	public Boolean getVentaSobrePlano() {
		return ventaSobrePlano;
	}

	public void setVentaSobrePlano(Boolean ventaSobrePlano) {
		this.ventaSobrePlano = ventaSobrePlano;
	}

	public String getActivoObraNuevaComercializacion() {
		return activoObraNuevaComercializacion;
	}

	public void setActivoObraNuevaComercializacion(String activoObraNuevaComercializacion) {
		this.activoObraNuevaComercializacion = activoObraNuevaComercializacion;
	}

	public Date getActivoObraNuevaComercializacionFecha() {
		return activoObraNuevaComercializacionFecha;
	}

	public void setActivoObraNuevaComercializacionFecha(Date activoObraNuevaComercializacionFecha) {
		this.activoObraNuevaComercializacionFecha = activoObraNuevaComercializacionFecha;
	}

}
