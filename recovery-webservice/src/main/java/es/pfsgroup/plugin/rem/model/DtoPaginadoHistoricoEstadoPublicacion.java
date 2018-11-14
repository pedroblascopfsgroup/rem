package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

import java.util.List;

/**
 * Dto para el histórico de estados, venta y alquiler, de las publicaciones de los activos.
 */
public class DtoPaginadoHistoricoEstadoPublicacion extends WebDto {

	private Long idActivo;
	private List<DtoHistoricoEstadoPublicacion> listado;
	private Integer totalCount;


	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public List<DtoHistoricoEstadoPublicacion> getListado() {
		return listado;
	}

	public void setListado(List<DtoHistoricoEstadoPublicacion> listado) {
		this.listado = listado;
	}

	public Integer getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}
}