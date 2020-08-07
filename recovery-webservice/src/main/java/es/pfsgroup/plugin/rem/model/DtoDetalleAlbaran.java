package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de DetalleAlbaran
 * @author Jonathan Ovalle
 *
 */
public class DtoDetalleAlbaran extends WebDto{

	private static final long serialVersionUID = 0L;

	private Long numPrefactura;
	private String propietario;
	private String anyo;
	private String estadoAlbaran;
	private Long numGasto;
	private String estadoGasto;
	private Double importeTotalDetalle;
	private Double importeTotalClienteDetalle;
	
	public Long getNumPrefactura() {
		return numPrefactura;
	}
	public void setNumPrefactura(Long numPrefactura) {
		this.numPrefactura = numPrefactura;
	}
	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}
	public String getAnyo() {
		return anyo;
	}
	public void setAnyo(String anyo) {
		this.anyo = anyo;
	}
	public String getEstadoAlbaran() {
		return estadoAlbaran;
	}
	public void setEstadoAlbaran(String estadoAlbaran) {
		this.estadoAlbaran = estadoAlbaran;
	}
	public Long getNumGasto() {
		return numGasto;
	}
	public void setNumGasto(Long numGasto) {
		this.numGasto = numGasto;
	}
	public String getEstadoGasto() {
		return estadoGasto;
	}
	public void setEstadoGasto(String estadoGasto) {
		this.estadoGasto = estadoGasto;
	}
	public Double getImporteTotalDetalle() {
		return importeTotalDetalle;
	}
	public void setImporteTotalDetalle(Double importeTotalDetalle) {
		this.importeTotalDetalle = importeTotalDetalle;
	}
	public Double getImporteTotalClienteDetalle() {
		return importeTotalClienteDetalle;
	}
	public void setImporteTotalClienteDetalle(Double importeTotalClienteDetalle) {
		this.importeTotalClienteDetalle = importeTotalClienteDetalle;
	}
	
	
	
	
	
}