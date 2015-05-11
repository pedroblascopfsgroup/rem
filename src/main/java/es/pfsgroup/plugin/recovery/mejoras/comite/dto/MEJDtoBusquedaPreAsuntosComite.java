package es.pfsgroup.plugin.recovery.mejoras.comite.dto;

import es.capgemini.devon.dto.WebDto;

public class MEJDtoBusquedaPreAsuntosComite extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9185986982264514972L;

	
	private String idComite;


	public void setIdComite(String idComite) {
		this.idComite = idComite;
	}


	public String getIdComite() {
		return idComite;
	}
}
