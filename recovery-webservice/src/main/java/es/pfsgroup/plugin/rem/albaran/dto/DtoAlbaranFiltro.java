package es.pfsgroup.plugin.rem.albaran.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoAlbaranFiltro extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3183688592914414983L;

	private Long numAlbaran;
	
	private String fechaAlbaran;
	
	private String estadoAlbaran;
	
	private Long numPrefactura;
	
	private String fechaPrefactura;
	
	private String estadoPrefactura;
	
	private Long numTrabajo;
	
	private String anyoTrabajo;
	
	private String estadoTrabajo;
	
	private String tipologiaTrabajo;
	
	private String proveedor;
	
	private String solicitante;
	
	private Long numPrefacturas;
	
	private Long numTrabajos;
	
	private Double importeTotal;
	
	private Double importeTotalCliente;
	
	private boolean validarAlbaran;

	public Long getNumAlbaran() {
		return numAlbaran;
	}

	public void setNumAlbaran(Long numAlbaran) {
		this.numAlbaran = numAlbaran;
	}

	public String getFechaAlbaran() {
		return fechaAlbaran;
	}

	public void setFechaAlbaran(String fechaAlbaran) {
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

	public String getFechaPrefactura() {
		return fechaPrefactura;
	}

	public void setFechaPrefactura(String fechaPrefactura) {
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

	public String getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}

	public Long getNumPrefacturas() {
		return numPrefacturas;
	}

	public void setNumPrefacturas(Long numPrefacturas) {
		this.numPrefacturas = numPrefacturas;
	}

	public Long getNumTrabajos() {
		return numTrabajos;
	}

	public void setNumTrabajos(Long numTrabajos) {
		this.numTrabajos = numTrabajos;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Double getImporteTotalCliente() {
		return importeTotalCliente;
	}

	public void setImporteTotalCliente(Double importeTotalCliente) {
		this.importeTotalCliente = importeTotalCliente;
	}

	public boolean isValidarAlbaran() {
		return validarAlbaran;
	}

	public void setValidarAlbaran(boolean validarAlbaran) {
		this.validarAlbaran = validarAlbaran;
	}
	
	
}
