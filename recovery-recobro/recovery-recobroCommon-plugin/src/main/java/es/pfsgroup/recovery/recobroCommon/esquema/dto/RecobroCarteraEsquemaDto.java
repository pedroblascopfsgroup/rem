package es.pfsgroup.recovery.recobroCommon.esquema.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroCarteraEsquemaDto extends WebDto{

	private static final long serialVersionUID = 7707942407367705916L;
	
	private Long id;
	private Long idEsquema;
	private Long idCartera;	 
	private String codigoTipoCarteraEsquema;
	private Integer prioridad;
	private Long idTipoGestionCarteraEsquema;
	private Long idAmbitoExpedienteRecobro;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdEsquema() {
		return idEsquema;
	}
	public void setIdEsquema(Long idEsquema) {
		this.idEsquema = idEsquema;
	}
	public Long getIdCartera() {
		return idCartera;
	}
	public void setIdCartera(Long idCartera) {
		this.idCartera = idCartera;
	}
	
	public Integer getPrioridad() {
		return prioridad;
	}
	public void setPrioridad(Integer prioridad) {
		this.prioridad = prioridad;
	}
	public Long getIdTipoGestionCarteraEsquema() {
		return idTipoGestionCarteraEsquema;
	}
	public void setIdTipoGestionCarteraEsquema(Long idTipoGestionCarteraEsquema) {
		this.idTipoGestionCarteraEsquema = idTipoGestionCarteraEsquema;
	}
	public Long getIdAmbitoExpedienteRecobro() {
		return idAmbitoExpedienteRecobro;
	}
	public void setIdAmbitoExpedienteRecobro(Long idAmbitoExpedienteRecobro) {
		this.idAmbitoExpedienteRecobro = idAmbitoExpedienteRecobro;
	}
	public String getCodigoTipoCarteraEsquema() {
		return codigoTipoCarteraEsquema;
	}
	public void setCodigoTipoCarteraEsquema(String codigoTipoCarteraEsquema) {
		this.codigoTipoCarteraEsquema = codigoTipoCarteraEsquema;
	}

}
