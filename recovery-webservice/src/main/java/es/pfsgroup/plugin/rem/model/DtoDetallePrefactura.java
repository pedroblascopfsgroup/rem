package es.pfsgroup.plugin.rem.model;
import java.util.Date;


/**
 * Dto para el grid de DetallePrefactura
 * @author Jonathan Ovalle
 *
 */
public class DtoDetallePrefactura {

	private static final long serialVersionUID = 0L;

	private Long numTrabajo;
	private String descripcion;
	private Date fechaAlta;
	private String estadoTrabajo;
	private Double importeTotalPrefactura;
	private Double importeTotalClientePrefactura;
	private Boolean checkIncluirTrabajo;
	private Double totalPrefactura;
	private Double totalAlbaran;
	
	public Long getNumTrabajo() {
		return numTrabajo;
	}
	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getEstadoTrabajo() {
		return estadoTrabajo;
	}
	public void setEstadoTrabajo(String estadoTrabajo) {
		this.estadoTrabajo = estadoTrabajo;
	}
	public Double getImporteTotalPrefactura() {
		return importeTotalPrefactura;
	}
	public void setImporteTotalPrefactura(Double importeTotalPrefactura) {
		this.importeTotalPrefactura = importeTotalPrefactura;
	}
	public Double getImporteTotalClientePrefactura() {
		return importeTotalClientePrefactura;
	}
	public void setImporteTotalClientePrefactura(Double importeTotalClientePrefactura) {
		this.importeTotalClientePrefactura = importeTotalClientePrefactura;
	}
	public Boolean getCheckIncluirTrabajo() {
		return checkIncluirTrabajo;
	}
	public void setCheckIncluirTrabajo(Boolean checkIncluirTrabajo) {
		this.checkIncluirTrabajo = checkIncluirTrabajo;
	}
	public Double getTotalPrefactura() {
		return totalPrefactura;
	}
	public void setTotalPrefactura(Double totalPrefactura) {
		this.totalPrefactura = totalPrefactura;
	}
	public Double getTotalAlbaran() {
		return totalAlbaran;
	}
	public void setTotalAlbaran(Double totalAlbaran) {
		this.totalAlbaran = totalAlbaran;
	}
	
	
	



	

	
	
}