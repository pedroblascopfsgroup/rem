package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoCampanya extends  WebDto{
	private static final long serialVersionUID = -2345472348736981181L;
	
	public String campanya;

	public String getCampanya() {
		return campanya;
	}

	public void setCampanya(String campanya) {
		this.campanya = campanya;
	}

}
