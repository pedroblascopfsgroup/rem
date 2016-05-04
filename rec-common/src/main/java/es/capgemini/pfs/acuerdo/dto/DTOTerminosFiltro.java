package es.capgemini.pfs.acuerdo.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;


public class DTOTerminosFiltro  extends PaginationParamsImpl {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4316512018756230018L;
	
	private String id;
	private String nroCliente;
	private String solicitante;
	private String estado;
	private String fechaAltaDesde;
	private String fechaAltaHasta;
	private String fechaEstadoDesde;
	private String fechaEstadoHasta;
	private String fechaVigenciaDesde;
	private String fechaVigenciaHasta;
	private String tipoAcuerdo;

	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
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
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getTipoAcuerdo() {
		return tipoAcuerdo;
	}
	public void setTipoAcuerdo(String tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}
	
}
