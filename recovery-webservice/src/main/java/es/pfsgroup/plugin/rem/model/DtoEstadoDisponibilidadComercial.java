package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

import java.util.List;

/**
 * Dto para el Estado de disponibilidad comercial
 */
public class DtoEstadoDisponibilidadComercial extends WebDto {

	private Long idActivo;
	private List<DtoVActivosAgrupacion> listado;
	private Integer totalCount;


	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Integer getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}

	public List<DtoVActivosAgrupacion> getListado() {
		return listado;
	}

	public void setListado(List<DtoVActivosAgrupacion> listado) {
		this.listado = listado;
	}

}