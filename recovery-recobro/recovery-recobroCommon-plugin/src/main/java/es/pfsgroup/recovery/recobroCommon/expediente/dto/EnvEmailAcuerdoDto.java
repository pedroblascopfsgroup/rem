package es.pfsgroup.recovery.recobroCommon.expediente.dto;

/**
 * Clase intermedia para pasar datos del mensaje de correo a enviar
 * 
 * @author pedro
 *
 */
public class EnvEmailAcuerdoDto {

	String agencia;
	String tipoAcuerdo;
	String datosCliente;
	String importePago;
	String porcentajeQuita;
	String contratos;
	String observaciones;

	public String getAgencia() {
		return agencia;
	}
	public void setAgencia(String agencia) {
		this.agencia = agencia;
	}
	public String getTipoAcuerdo() {
		return tipoAcuerdo;
	}
	public void setTipoAcuerdo(String tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}
	public String getDatosCliente() {
		return datosCliente;
	}
	public void setDatosCliente(String datosCliente) {
		this.datosCliente = datosCliente;
	}
	public String getImportePago() {
		return importePago;
	}
	public void setImportePago(String importePago) {
		this.importePago = importePago;
	}
	public String getPorcentajeQuita() {
		return porcentajeQuita;
	}
	public void setPorcentajeQuita(String porcentajeQuita) {
		this.porcentajeQuita = porcentajeQuita;
	}
	public String getContratos() {
		return contratos;
	}
	public void setContratos(String contratos) {
		this.contratos = contratos;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
}
