package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los honorarios del expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoPrescriptoresComision extends WebDto {
	private static final long serialVersionUID = 3574353502838449106L;
	
	private Long prescriptorCodRem;
	private String tipoAccion;
	private String origenLead;
	
	public Long getPrescriptorCodRem() {
		return prescriptorCodRem;
	}
	public String getTipoAccion() {
		return tipoAccion;
	}
	public void setPrescriptorCodRem(Long prescriptorCodRem) {
		this.prescriptorCodRem = prescriptorCodRem;
	}
	public void setTipoAccion(String tipoAccion) {
		this.tipoAccion = tipoAccion;
	}
	public String getOrigenLead() {
		return origenLead;
	}
	public void setOrigenLead(String origenLead) {
		this.origenLead = origenLead;
	}
	
	
}
