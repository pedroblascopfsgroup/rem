package es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto;

import es.capgemini.devon.dto.WebDto;

public class PTEDtoBusquedaPlazo extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3484729780020727780L;
	
	private Long id;
	private Long idTareaProcedimiento;
	private Long filtroProcedimiento;
	private Long idTipoJuzgado;
	private String idTipoPlaza;
	
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public void setIdTareaProcedimiento(Long idTareaProcedimiento) {
		this.idTareaProcedimiento = idTareaProcedimiento;
	}
	public Long getIdTareaProcedimiento() {
		return idTareaProcedimiento;
	}
	public void setFiltroProcedimiento(Long filtroProcedimiento) {
		this.filtroProcedimiento = filtroProcedimiento;
	}
	public Long getFiltroProcedimiento() {
		return filtroProcedimiento;
	}
	public void setIdTipoJuzgado(Long idTipoJuzgado) {
		this.idTipoJuzgado = idTipoJuzgado;
	}
	public Long getIdTipoJuzgado() {
		return idTipoJuzgado;
	}
	public void setIdTipoPlaza(String idTipoPlaza) {
		this.idTipoPlaza = idTipoPlaza;
	}
	public String getIdTipoPlaza() {
		return idTipoPlaza;
	}

}
