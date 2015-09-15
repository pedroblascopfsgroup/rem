package es.pfsgroup.plugin.recovery.comites.puestosComite.dto;

import es.capgemini.devon.dto.WebDto;

public class CMTDtoAltaPuestosComite extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4240116212879784528L;
	
	private Long id;
	private Long comite;
	private Long perfil;
	private Boolean esRestrictivo;
	private Boolean esSupervisor;
	private Long zona;
	
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public void setComite(Long comite) {
		this.comite = comite;
	}
	public Long getComite() {
		return comite;
	}
	public void setPerfil(Long perfil) {
		this.perfil = perfil;
	}
	public Long getPerfil() {
		return perfil;
	}
	public void setEsRestrictivo(Boolean esRestrictivo) {
		this.esRestrictivo = esRestrictivo;
	}
	public Boolean getEsRestrictivo() {
		return esRestrictivo;
	}
	public void setEsSupervisor(Boolean esSupervisor) {
		this.esSupervisor = esSupervisor;
	}
	public Boolean getEsSupervisor() {
		return esSupervisor;
	}
	public void setZona(Long zona) {
		this.zona = zona;
	}
	public Long getZona() {
		return zona;
	}
	

}
