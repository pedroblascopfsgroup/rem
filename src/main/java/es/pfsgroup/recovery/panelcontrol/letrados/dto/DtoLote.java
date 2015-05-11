package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoLote extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5835483098267217669L;
	
	private String lote;

	public void setLote(String lote) {
		this.lote = lote;
	}

	public String getLote() {
		return lote;
	}

}
