package es.pfsgroup.recovery.recobroWeb.expediente.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class BusquedaExpAcuerdoDto extends PaginationParamsImpl{

	private static final long serialVersionUID = -3963617084877125848L;


	
	private String tipoAcuerdo;
	
	private String estadoAcuerdo;
	
	private String solicitante;
	
	private String minporcentajeQuita;
	
	private String maxporcentajeQuita;
	
	private String fechaDesdeAcuerdo;
	
	private String fechaHastaAcuerdo;
	
	private String minImporteAcuerdo;
	
	private String maxImporteAcuerdo;

	public String getTipoAcuerdo() {
		return tipoAcuerdo;
	}

	public void setTipoAcuerdo(String tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}

	public String getEstadoAcuerdo() {
		return estadoAcuerdo;
	}

	public void setEstadoAcuerdo(String estadoAcuerdo) {
		this.estadoAcuerdo = estadoAcuerdo;
	}

	public String getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}

	public String getMinporcentajeQuita() {
		return minporcentajeQuita;
	}

	public void setMinporcentajeQuita(String minporcentajeQuita) {
		this.minporcentajeQuita = minporcentajeQuita;
	}

	public String getMaxporcentajeQuita() {
		return maxporcentajeQuita;
	}

	public void setMaxporcentajeQuita(String maxporcentajeQuita) {
		this.maxporcentajeQuita = maxporcentajeQuita;
	}

	public String getFechaDesdeAcuerdo() {
		return fechaDesdeAcuerdo;
	}

	public void setFechaDesdeAcuerdo(String fechaDesdeAcuerdo) {
		this.fechaDesdeAcuerdo = fechaDesdeAcuerdo;
	}

	public String getFechaHastaAcuerdo() {
		return fechaHastaAcuerdo;
	}

	public void setFechaHastaAcuerdo(String fechaHastaAcuerdo) {
		this.fechaHastaAcuerdo = fechaHastaAcuerdo;
	}

	public String getMinImporteAcuerdo() {
		return minImporteAcuerdo;
	}

	public void setMinImporteAcuerdo(String minImporteAcuerdo) {
		this.minImporteAcuerdo = minImporteAcuerdo;
	}

	public String getMaxImporteAcuerdo() {
		return maxImporteAcuerdo;
	}

	public void setMaxImporteAcuerdo(String maxImporteAcuerdo) {
		this.maxImporteAcuerdo = maxImporteAcuerdo;
	}
	
}
