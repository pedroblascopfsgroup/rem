package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoCartera extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3397506786128239977L;
	
	private String cartera;

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getCartera() {
		return cartera;
	}

}
