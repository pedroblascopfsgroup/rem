package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;



/**
 *
 */
public class DtoCatastroCorrecto extends WebDto {

	private static final long serialVersionUID = 0L;
	
	private String refCatastral;
	private Boolean correcto;
	
	
	public String getRefCatastral() {
		return refCatastral;
	}
	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}
	public Boolean getCorrecto() {
		return correcto;
	}
	public void setCorrecto(Boolean correcto) {
		this.correcto = correcto;
	}
	
	
	
}