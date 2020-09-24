package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGastoAsociado;

public class DtoGastoAsociadoAdquisicion extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private Long activo;
	private String gastoAsociado;
	private String usuarioGestordeAlta;
	private Date fechaAltaGastoAsociado;
	private Date fechaSolicitudGastoAsociado;
	private Date fechaPagoGastoAsociado;
	private Double importe;
	private Double factura;
	private String observaciones;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getActivo() {
		return activo;
	}
	public void setActivo(Long activo) {
		this.activo = activo;
	}
	public String getGastoAsociado() {
		return gastoAsociado;
	}
	public void setGastoAsociado(String gastoAsociado) {
		this.gastoAsociado = gastoAsociado;
	}
	public String getUsuarioGestordeAlta() {
		return usuarioGestordeAlta;
	}
	public void setUsuarioGestordeAlta(String usuarioGestordeAlta) {
		this.usuarioGestordeAlta = usuarioGestordeAlta;
	}
	public Date getFechaAltaGastoAsociado() {
		return fechaAltaGastoAsociado;
	}
	public void setFechaAltaGastoAsociado(Date fechaAltaGastoAsociado) {
		this.fechaAltaGastoAsociado = fechaAltaGastoAsociado;
	}
	public Date getFechaSolicitudGastoAsociado() {
		return fechaSolicitudGastoAsociado;
	}
	public void setFechaSolicitudGastoAsociado(Date fechaSolicitudGastoAsociado) {
		this.fechaSolicitudGastoAsociado = fechaSolicitudGastoAsociado;
	}
	public Date getFechaPagoGastoAsociado() {
		return fechaPagoGastoAsociado;
	}
	public void setFechaPagoGastoAsociado(Date fechaPagoGastoAsociado) {
		this.fechaPagoGastoAsociado = fechaPagoGastoAsociado;
	}
	public Double getImporte() {
		return importe;
	}
	public void setImporte(Double importe) {
		this.importe = importe;
	}
	public Double getFactura() {
		return factura;
	}
	public void setFactura(Double factura) {
		this.factura = factura;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	
}
