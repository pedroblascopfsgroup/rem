package es.capgemini.pfs.acuerdo.dto;


public class BusquedaAcuerdosDTO {
	
	private String id;
	private String nroContrato;
	private String nroCliente;
	private String solicitante;
	private String tipoSolicitante;
	private String estado;
	private String fechaAlta;
	private String fechaEstado;
	private String fechaVigencia;
	private String tipoAcuerdo;

	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNroContrato() {
		return nroContrato;
	}
	public void setNroContrato(String nroContrato) {
		this.nroContrato = nroContrato;
	}
	public String getNroCliente() {
		return nroCliente;
	}
	public void setNroCliente(String nroCliente) {
		this.nroCliente = nroCliente;
	}
	public String getSolicitante() {
		return solicitante;
	}
	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}
	public String getTipoSolicitante() {
		return tipoSolicitante;
	}
	public void setTipoSolicitante(String tipoSolicitante) {
		this.tipoSolicitante = tipoSolicitante;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getFechaEstado() {
		return fechaEstado;
	}
	public void setFechaEstado(String fechaEstado) {
		this.fechaEstado = fechaEstado;
	}
	public String getFechaVigencia() {
		return fechaVigencia;
	}
	public void setFechaVigencia(String fechaVigencia) {
		this.fechaVigencia = fechaVigencia;
	}
	public String getTipoAcuerdo() {
		return tipoAcuerdo;
	}
	public void setTipoAcuerdo(String tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}

}
