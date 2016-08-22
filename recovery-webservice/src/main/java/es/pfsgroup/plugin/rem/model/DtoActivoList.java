package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el listado de Activos
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoList extends WebDto {

	private static final long serialVersionUID = 0L;

	private String agrupacion;
	private String referenciaCatastral;
	private String fincaRegistral;
	private String idufir;

	private int page;
	private int start;
	private int limit;

	public String getAgrupacion() {
		return agrupacion;
	}
	public void setAgrupacion(String agrupacion) {
		this.agrupacion = agrupacion;
	}

	public String getIdufir() {
		return idufir;
	}
	public void setIdufir(String idufir) {
		this.idufir = idufir;
	}

	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getStart() {
		return start;
	}
	public void setStart(int start) {
		this.start = start;
	}
	public int getLimit() {
		return limit;
	}
	public void setLimit(int limit) {
		this.limit = limit;
	}
	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}
	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}
	public String getFincaRegistral() {
		return fincaRegistral;
	}
	public void setFincaRegistral(String fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}
	
	
}