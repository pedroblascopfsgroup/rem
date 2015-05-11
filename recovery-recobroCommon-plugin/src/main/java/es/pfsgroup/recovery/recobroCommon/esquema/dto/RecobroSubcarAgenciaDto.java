package es.pfsgroup.recovery.recobroCommon.esquema.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroSubcarAgenciaDto extends WebDto{
	private static final long serialVersionUID = 3771559956221537545L;
	
	private Long idCarteraEsquema;
	private Long idTipoReparto;
	private Long idSubCartera;
	private String nomSubCartera;
	private Integer particion;
	private String reparto;
	
	public Long getIdCarteraEsquema() {
		return idCarteraEsquema;
	}
	public void setIdCarteraEsquema(Long idCarteraEsquema) {
		this.idCarteraEsquema = idCarteraEsquema;
	}
	public Long getIdTipoReparto() {
		return idTipoReparto;
	}
	public void setIdTipoReparto(Long idTipoReparto) {
		this.idTipoReparto = idTipoReparto;
	}
	public Long getIdSubCartera() {
		return idSubCartera;
	}
	public void setIdSubCartera(Long idSubCartera) {
		this.idSubCartera = idSubCartera;
	}
	public String getNomSubCartera() {
		return nomSubCartera;
	}
	public void setNomSubCartera(String nomSubCartera) {
		this.nomSubCartera = nomSubCartera;
	}
	public Integer getParticion() {
		return particion;
	}
	public void setParticion(Integer particion) {
		this.particion = particion;
	}
	public String getReparto() {
		return reparto;
	}
	public void setReparto(String reparto) {
		this.reparto = reparto;
	}
	
}
