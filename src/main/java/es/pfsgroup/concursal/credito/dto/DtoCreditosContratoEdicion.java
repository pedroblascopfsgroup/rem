package es.pfsgroup.concursal.credito.dto;

public class DtoCreditosContratoEdicion {

	private Long idCredito;
	private Long idContrato;
	private String codigoContrato;
	private String estadoCredito;
	
	public Long getIdCredito() {
		return idCredito;
	}
	public void setIdCredito(Long idCredito) {
		this.idCredito = idCredito;
	}
	public Long getIdContrato() {
		return idContrato;
	}
	public void setIdContrato(Long idContrato) {
		this.idContrato = idContrato;
	}
	public void setEstadoCredito(String estadoCredito) {
		this.estadoCredito = estadoCredito;
	}
	public String getEstadoCredito() {
		return estadoCredito;
	}
	public void setCodigoContrato(String codigoContrato) {
		this.codigoContrato = codigoContrato;
	}
	public String getCodigoContrato() {
		return codigoContrato;
	}
}
