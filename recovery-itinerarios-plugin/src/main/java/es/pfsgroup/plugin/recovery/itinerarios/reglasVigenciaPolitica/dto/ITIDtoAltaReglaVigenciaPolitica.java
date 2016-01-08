package es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dto;

import es.capgemini.devon.dto.WebDto;

public class ITIDtoAltaReglaVigenciaPolitica extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5400559014344483701L;
	
	private Long id;
	private Long estado;
	private Long tipoReglaVigenciaPolitica;
	private String tiposReglasVigenciaPoliticaExclusion;
	
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public void setEstado(Long estado) {
		this.estado = estado;
	}
	public Long getEstado() {
		return estado;
	}
	public void setTipoReglaVigenciaPolitica(Long tipoReglaVigenciaPolitica) {
		this.tipoReglaVigenciaPolitica = tipoReglaVigenciaPolitica;
	}
	public Long getTipoReglaVigenciaPolitica() {
		return tipoReglaVigenciaPolitica;
	}
	public void setTiposReglasVigenciaPoliticaExclusion(
			String tiposReglasVigenciaPoliticaExclusion) {
		this.tiposReglasVigenciaPoliticaExclusion = tiposReglasVigenciaPoliticaExclusion;
	}
	public String getTiposReglasVigenciaPoliticaExclusion() {
		return tiposReglasVigenciaPoliticaExclusion;
	}

}
