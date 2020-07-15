package es.pfsgroup.plugin.rem.model;
import java.util.Date;


/**
 * Dto para el grid de Albaran
 * @author Jonathan Ovalle
 *
 */
public class DtoAlbaran {

	private static final long serialVersionUID = 0L;

	private Long numAlbaran;
	private Date fechaAlbaran;
	private String estadoAlbaran;
	private Long numPrefacturas;
	private Long numTrabajos;
	private Double importeTotal;
	private Double importeTotalCliente;
	
	
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


	

	
	
}