package es.capgemini.pfs.acuerdo.dto;

import java.util.Set;

import es.capgemini.devon.pagination.PaginationParamsImpl;


public class DTOTerminosFiltro  extends PaginationParamsImpl {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4316512018756230018L;
	
	private String nroContrato;
	private String nroCliente;
	private String tipoAcuerdo;
	private String tipoTermino;
	private String tipoSolicitante;
	private String solicitantes;
	private String estado;
	private String fechaAltaDesde;
	private String fechaAltaHasta;
	private String fechaEstadoDesde;
	private String fechaEstadoHasta;
	private String fechaVigenciaDesde;
	private String fechaVigenciaHasta;
	private String tipoGestor;
	private String despacho;
	private String gestores;
	private String jerarquia;
	private String centros;
	private Set<String> codigoZonas;
	
	
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
	public String getTipoAcuerdo() {
		return tipoAcuerdo;
	}
	public void setTipoAcuerdo(String tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}
	public String getTipoTermino() {
		return tipoTermino;
	}
	public void setTipoTermino(String tipoTermino) {
		this.tipoTermino = tipoTermino;
	}
	public String getTipoSolicitante() {
		return tipoSolicitante;
	}
	public void setTipoSolicitante(String tipoSolicitante) {
		this.tipoSolicitante = tipoSolicitante;
	}
	public String getSolicitantes() {
		return solicitantes;
	}
	public void setSolicitantes(String solicitantes) {
		this.solicitantes = solicitantes;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getFechaAltaDesde() {
		return fechaAltaDesde;
	}
	public void setFechaAltaDesde(String fechaAltaDesde) {
		this.fechaAltaDesde = fechaAltaDesde;
	}
	public String getFechaAltaHasta() {
		return fechaAltaHasta;
	}
	public void setFechaAltaHasta(String fechaAltaHasta) {
		this.fechaAltaHasta = fechaAltaHasta;
	}
	public String getFechaEstadoDesde() {
		return fechaEstadoDesde;
	}
	public void setFechaEstadoDesde(String fechaEstadoDesde) {
		this.fechaEstadoDesde = fechaEstadoDesde;
	}
	public String getFechaEstadoHasta() {
		return fechaEstadoHasta;
	}
	public void setFechaEstadoHasta(String fechaEstadoHasta) {
		this.fechaEstadoHasta = fechaEstadoHasta;
	}
	public String getFechaVigenciaDesde() {
		return fechaVigenciaDesde;
	}
	public void setFechaVigenciaDesde(String fechaVigenciaDesde) {
		this.fechaVigenciaDesde = fechaVigenciaDesde;
	}
	public String getFechaVigenciaHasta() {
		return fechaVigenciaHasta;
	}
	public void setFechaVigenciaHasta(String fechaVigenciaHasta) {
		this.fechaVigenciaHasta = fechaVigenciaHasta;
	}
	public String getTipoGestor() {
		return tipoGestor;
	}
	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}
	public String getDespacho() {
		return despacho;
	}
	public void setDespacho(String despacho) {
		this.despacho = despacho;
	}
	public String getGestores() {
		return gestores;
	}
	public void setGestores(String gestores) {
		this.gestores = gestores;
	}
	public String getJerarquia() {
		return jerarquia;
	}
	public void setJerarquia(String jerarquia) {
		this.jerarquia = jerarquia;
	}
	public String getCentros() {
		return centros;
	}
	public void setCentros(String centros) {
		this.centros = centros;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public Set<String> getCodigoZonas() {
		return codigoZonas;
	}
	public void setCodigoZonas(Set<String> codigoZonas) {
		this.codigoZonas = codigoZonas;
	}
	
}
