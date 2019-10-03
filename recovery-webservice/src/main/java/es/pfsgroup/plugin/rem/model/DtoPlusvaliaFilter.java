package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Gastos Proveedor
 * @author Luis Caballero
 *
 */
public class DtoPlusvaliaFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private Long numActivo;
	private Long numPlusvalia;
	private String provinciaCombo;
	private String municipioCombo;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Long getNumPlusvalia() {
		return numPlusvalia;
	}
	public void setNumPlusvalia(Long numPlusvalia) {
		this.numPlusvalia = numPlusvalia;
	}
	public String getProvinciaCombo() {
		return provinciaCombo;
	}
	public void setProvinciaCombo(String provinciaCombo) {
		this.provinciaCombo = provinciaCombo;
	}
	public String getMunicipioCombo() {
		return municipioCombo;
	}
	public void setMunicipioCombo(String municipioCombo) {
		this.municipioCombo = municipioCombo;
	}
		
}