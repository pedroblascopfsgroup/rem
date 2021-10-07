package es.pfsgroup.plugin.rem.model;

public class DtoDeposito {


	private Long id;
	private Double importeDeposito;
	private String fechaIngresoDeposito;
	private String estadoCodigo;
	private String fechaDevolucionDeposito;
	private String ibanDevolucionDeposito;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Double getImporteDeposito() {
		return importeDeposito;
	}
	public void setImporteDeposito(Double importeDeposito) {
		this.importeDeposito = importeDeposito;
	}
	public String getFechaIngresoDeposito() {
		return fechaIngresoDeposito;
	}
	public void setFechaIngresoDeposito(String fechaIngresoDeposito) {
		this.fechaIngresoDeposito = fechaIngresoDeposito;
	}
	public String getEstadoCodigo() {
		return estadoCodigo;
	}
	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}
	public String getFechaDevolucionDeposito() {
		return fechaDevolucionDeposito;
	}
	public void setFechaDevolucionDeposito(String fechaDevolucionDeposito) {
		this.fechaDevolucionDeposito = fechaDevolucionDeposito;
	}
	public String getIbanDevolucionDeposito() {
		return ibanDevolucionDeposito;
	}
	public void setIbanDevolucionDeposito(String ibanDevolucionDeposito) {
		this.ibanDevolucionDeposito = ibanDevolucionDeposito;
	}
	
	
}