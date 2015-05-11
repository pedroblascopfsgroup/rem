package es.pfsgroup.recovery.recobroCommon.expediente.dto;

import es.capgemini.devon.dto.WebDto;

public class AcuerdoExpedienteDto extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -399021275282641192L;
	
	private Long idAcuerdo;
	private Long idExpediente;
	private String tipoPalanca;
	private String solicitante;
	private String estado;
	private String importePago;
	private String observaciones;
	private Integer quita;
	private Long idContrato;
	private String contratos;
	private Long idDespacho;
	
	public Long getIdAcuerdo() {
		return idAcuerdo;
	}
	public void setIdAcuerdo(Long idAcuerdo) {
		this.idAcuerdo = idAcuerdo;
	}
	public Long getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	public String getTipoPalanca() {
		return tipoPalanca;
	}
	public void setTipoPalanca(String tipoPalanca) {
		this.tipoPalanca = tipoPalanca;
	}
	public String getSolicitante() {
		return solicitante;
	}
	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	
	public String getImportePago() {
		return importePago;
	}
	public void setImportePago(String importePago) {
		this.importePago = importePago;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Integer getQuita() {
		return quita;
	}
	public void setQuita(Integer quita) {
		this.quita = quita;
	}
	public Long getIdContrato() {
		return idContrato;
	}
	public void setIdContrato(Long idContrato) {
		this.idContrato = idContrato;
	}
	public String getContratos() {
		return contratos;
	}
	public void setContratos(String contratos) {
		this.contratos = contratos;
	}
	public Long getIdDespacho() {
		return idDespacho;
	}
	public void setIdDespacho(Long idDespacho) {
		this.idDespacho = idDespacho;
	}

}
