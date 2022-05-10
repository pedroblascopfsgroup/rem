package es.pfsgroup.plugin.rem.model;

import java.util.List;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para encapsular la información de cada pestaña del activo *
 */
public class DtoActivoBbvaUic  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private Long idActivo;
	private String uicBbva;
	private Boolean activoEpa;
	private String cexperBbva;
    private String empresa;
    private String oficina;
    private String contrapartida;
    private String folio;
    private String cdpen;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getUicBbva() {
		return uicBbva;
	}
	public void setUicBbva(String uicBbva) {
		this.uicBbva = uicBbva;
	}
	public Boolean getActivoEpa() {
		return activoEpa;
	}
	public void setActivoEpa(Boolean activoEpa) {
		this.activoEpa = activoEpa;
	}
	public String getCexperBbva() {
		return cexperBbva;
	}
	public void setCexperBbva(String cexperBbva) {
		this.cexperBbva = cexperBbva;
	}
	public String getEmpresa() {
		return empresa;
	}
	public void setEmpresa(String empresa) {
		this.empresa = empresa;
	}
	public String getOficina() {
		return oficina;
	}
	public void setOficina(String oficina) {
		this.oficina = oficina;
	}
	public String getContrapartida() {
		return contrapartida;
	}
	public void setContrapartida(String contrapartida) {
		this.contrapartida = contrapartida;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getCdpen() {
		return cdpen;
	}
	public void setCdpen(String cdpen) {
		this.cdpen = cdpen;
	}  
    
}