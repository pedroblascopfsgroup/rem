package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoBusquedaAlbaran {

	private Long numAlbaran;
	private Date fechaAlbaran;
	private String estadoAlbaran;
	private Long numPrefactura;
	private Date fechaPrefactura;
	private String estadoPrefactura;
	private Long numTrabajo;
	private String anyoTrabajo;
	private String estadoTrabajo;
	private String tipologiaTrabajo;
	private String proveedor;
	private String propietario;
	public Long getNumAlbaran() {
		return numAlbaran;
	}
	public void setNumAlbaran(Long numAlbaran) {
		this.numAlbaran = numAlbaran;
	}
	public Date getFechaAlbaran() {
		return fechaAlbaran;
	}
	public void setFechaAlbaran(Date fechaAlbaran) {
		this.fechaAlbaran = fechaAlbaran;
	}
	public String getEstadoAlbaran() {
		return estadoAlbaran;
	}
	public void setEstadoAlbaran(String estadoAlbaran) {
		this.estadoAlbaran = estadoAlbaran;
	}
	public Long getNumPrefactura() {
		return numPrefactura;
	}
	public void setNumPrefactura(Long numPrefactura) {
		this.numPrefactura = numPrefactura;
	}
	public Date getFechaPrefactura() {
		return fechaPrefactura;
	}
	public void setFechaPrefactura(Date fechaPrefactura) {
		this.fechaPrefactura = fechaPrefactura;
	}
	public String getEstadoPrefactura() {
		return estadoPrefactura;
	}
	public void setEstadoPrefactura(String estadoPrefactura) {
		this.estadoPrefactura = estadoPrefactura;
	}
	public Long getNumTrabajo() {
		return numTrabajo;
	}
	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}
	public String getAnyoTrabajo() {
		return anyoTrabajo;
	}
	public void setAnyoTrabajo(String anyoTrabajo) {
		this.anyoTrabajo = anyoTrabajo;
	}
	public String getEstadoTrabajo() {
		return estadoTrabajo;
	}
	public void setEstadoTrabajo(String estadoTrabajo) {
		this.estadoTrabajo = estadoTrabajo;
	}
	public String getTipologiaTrabajo() {
		return tipologiaTrabajo;
	}
	public void setTipologiaTrabajo(String tipologiaTrabajo) {
		this.tipologiaTrabajo = tipologiaTrabajo;
	}
	public String getProveedor() {
		return proveedor;
	}
	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}
	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

}
