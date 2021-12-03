package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de DetalleAlbaran
 * @author Jonathan Ovalle
 *
 */
public class DtoDetalleAlbaran extends WebDto implements Comparable<DtoDetalleAlbaran>{

	private static final long serialVersionUID = 1L;

	private Long numAlbaran;
	private Long numPrefactura;
	private String proveedor;
	private String propietario;
	private String anyo;
	private String estadoAlbaran;
	private Long numGasto;
	private String estadoGasto;
	private Integer numeroTrabajos;
	private Double importeTotalDetalle;
	private Double importeTotalClienteDetalle;
	private String fechaPrefactura;
	private String anyoTrabajo;
	private Long numTrabajo;
	private String estadoTrabajo;
	private String areaPeticionaria;
	private String codAreaPeticionaria;
	private Double importaTotalPrefacturas;
	
	
	public String getAreaPeticionaria() {
		return areaPeticionaria;
	}
	public void setAreaPeticionaria(String areaPeticionaria) {
		this.areaPeticionaria = areaPeticionaria;
	}
	public Long getNumPrefactura() {
		return numPrefactura;
	}
	public void setNumPrefactura(Long numPrefactura) {
		this.numPrefactura = numPrefactura;
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
	public int getNumeroTrabajos() {
		return numeroTrabajos;
	}
	public void setNumeroTrabajos(int numeroTrabajos) {
		this.numeroTrabajos = numeroTrabajos;
	}
	public Long getNumAlbaran() {
		return numAlbaran;
	}
	public void setNumAlbaran(Long numAlbaran) {
		this.numAlbaran = numAlbaran;
	}
	public void setNumeroTrabajos(Integer numeroTrabajos) {
		this.numeroTrabajos = numeroTrabajos;
	}
	public int compareTo(DtoDetalleAlbaran a) {
		return this.getNumPrefactura().intValue() - a.getNumPrefactura().intValue();
	}
	public String getFechaPrefactura() {
		return fechaPrefactura;
	}
	public void setFechaPrefactura(String fechaPrefactura) {
		this.fechaPrefactura = fechaPrefactura;
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
	public String getCodAreaPeticionaria() {
		return codAreaPeticionaria;
	}
	public void setCodAreaPeticionaria(String codAreaPeticionaria) {
		this.codAreaPeticionaria = codAreaPeticionaria;
	}
	public Double getImportaTotalPrefacturas() {
		return importaTotalPrefacturas;
	}
	public void setImportaTotalPrefacturas(Double importaTotalPrefacturas) {
		this.importaTotalPrefacturas = importaTotalPrefacturas;
	}
	
}