package es.capgemini.pfs.acuerdo.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class DTOTerminosExcel extends PaginationParamsImpl {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6536142796018846714L;

	private String idAcuerdo;
	private String idTermino;
	private String idAsunto;
	private String nombreAsunto;
	private String idExpediente;
	private String descripcionExpediente;
	private String tipoExpediente;
	private String idContrato;
	private String cliente;
	private String tipoAcuerdo;
	private String solicitante;
	private String tipoSolicitante;
	private String estado;
	private String fechaAlta;
	private String fechaEstado;
	private String fechaVigencia;

	public String getIdAcuerdo() {
		return idAcuerdo;
	}

	public void setIdAcuerdo(String idAcuerdo) {
		this.idAcuerdo = idAcuerdo;
	}

	public String getIdTermino() {
		return idTermino;
	}

	public void setIdTermino(String idTermino) {
		this.idTermino = idTermino;
	}

	public String getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(String idAsunto) {
		this.idAsunto = idAsunto;
	}

	public String getNombreAsunto() {
		return nombreAsunto;
	}

	public void setNombreAsunto(String nombreAsunto) {
		this.nombreAsunto = nombreAsunto;
	}

	public String getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(String idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getDescripcionExpediente() {
		return descripcionExpediente;
	}

	public void setDescripcionExpediente(String descripcionExpediente) {
		this.descripcionExpediente = descripcionExpediente;
	}

	public String getTipoExpediente() {
		return tipoExpediente;
	}

	public void setTipoExpediente(String tipoExpediente) {
		this.tipoExpediente = tipoExpediente;
	}

	public String getIdContrato() {
		return idContrato;
	}

	public void setIdContrato(String idContrato) {
		this.idContrato = idContrato;
	}

	public String getCliente() {
		return cliente;
	}

	public void setCliente(String cliente) {
		this.cliente = cliente;
	}

	public String getTipoAcuerdo() {
		return tipoAcuerdo;
	}

	public void setTipoAcuerdo(String tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
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

}
