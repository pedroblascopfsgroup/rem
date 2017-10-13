package es.pfsgroup.plugin.rem.rest.dto;

public class TitularDto {
	
	private Long numeroUrsus;
	private char tipoDocumentoCliente;
	private String numeroDocumento;
	private String nombreCompletoCliente;
	private Double porcentajeCompra;
	private Long conyugeNumeroUrsus;

	
	public Long getNumeroUrsus() {
		return numeroUrsus;
	}

	public void setNumeroUrsus(Long numeroUrsus) {
		this.numeroUrsus = numeroUrsus;
	}

	public char getTipoDocumentoCliente() {
		return tipoDocumentoCliente;
	}

	public void setTipoDocumentoCliente(char tipoDocumentoCliente) {
		this.tipoDocumentoCliente = tipoDocumentoCliente;
	}

	public String getNumeroDocumento() {
		return numeroDocumento;
	}

	public void setNumeroDocumento(String numeroDocumento) {
		this.numeroDocumento = numeroDocumento;
	}

	public String getNombreCompletoCliente() {
		return nombreCompletoCliente;
	}

	public void setNombreCompletoCliente(String nombreCompletoCliente) {
		this.nombreCompletoCliente = nombreCompletoCliente;
	}

	public Double getPorcentajeCompra() {
		return porcentajeCompra;
	}

	public void setPorcentajeCompra(Double porcentajeCompra) {
		this.porcentajeCompra = porcentajeCompra;
	}

	public Long getConyugeNumeroUrsus() {
		return conyugeNumeroUrsus;
	}

	public void setConyugeNumeroUrsus(Long conyugeNumeroUrsus) {
		this.conyugeNumeroUrsus = conyugeNumeroUrsus;
	}

}
