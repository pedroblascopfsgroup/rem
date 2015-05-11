package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoLetrado extends  WebDto{
	private static final long serialVersionUID = -2345472348736981181L;
	
	public String letrado;

	public String getLetrado() {
		return letrado;
	}

	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}
	
}