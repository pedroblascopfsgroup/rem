package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el listado de reglas para la publicación automática.
 */
public class DtoReglasPublicacionAutomatica extends WebDto {

	private static final long serialVersionUID = 1L;

	private String idRegla;
	private String carteraCodigo;
	private int incluidoAgrupacionAsistida;
	private String tipoActivoCodigo;
	private String subtipoActivoCodigo;
	private int totalCount;


	public String getIdRegla() {
		return idRegla;
	}
	public void setIdRegla(String idRegla) {
		this.idRegla = idRegla;
	}
	public String getCarteraCodigo() {
		return carteraCodigo;
	}
	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}
	public int getIncluidoAgrupacionAsistida() {
		return incluidoAgrupacionAsistida;
	}
	public void setIncluidoAgrupacionAsistida(int incluidoAgrupacionAsistida) {
		this.incluidoAgrupacionAsistida = incluidoAgrupacionAsistida;
	}
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}
	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public int getTotalCount() {
		return totalCount;
	}
}