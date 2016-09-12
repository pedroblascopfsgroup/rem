package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la propuesta de activos vinculados de informe comercial del activo.
 *
 */
public class DtoPropuestaActivosVinculados extends WebDto {
	private static final long serialVersionUID = 1L;
	
	private String id;
	private Long activoOrigenID;
	private Long activoVinculadoNumero;
	private Long activoVinculadoID;
	private int totalCount;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Long getActivoOrigenID() {
		return activoOrigenID;
	}
	public void setActivoOrigenID(Long activoOrigenID) {
		this.activoOrigenID = activoOrigenID;
	}
	public Long getActivoVinculadoNumero() {
		return activoVinculadoNumero;
	}
	public void setActivoVinculadoNumero(Long activoVinculadoNumero) {
		this.activoVinculadoNumero = activoVinculadoNumero;
	}

	// Usado para leer los activos vinculados, idActivo es el activo origen.
	public void setIdActivo(Long idActivo) {
		this.activoOrigenID = idActivo;
	}
	
	// Usado para almacenar un activo vinculado, idEntidad es el activo origen.
	public void setIdEntidad(Long idEntidad) {
		this.activoOrigenID = idEntidad;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public Long getActivoVinculadoID() {
		return activoVinculadoID;
	}
	public void setActivoVinculadoID(Long activoVinculadoID) {
		this.activoVinculadoID = activoVinculadoID;
	}
	
}