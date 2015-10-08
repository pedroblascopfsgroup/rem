package es.pfsgroup.plugin.recovery.nuevoModeloBienes.relacionesContratoBien.dto;

import java.io.Serializable;

public class BusquedaContratoDTO implements Serializable {

	
	private static final long serialVersionUID = 7222651574331035023L;
	
	private String idContrato;
	private String numContrato;
	private String garantia;
	private String garantiaApp;
	private String tipoProducto;
	
	
	public String getNumContrato() {
		return numContrato;
	}
	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}
	public String getGarantia() {
		return garantia;
	}
	public void setGarantia(String garantia) {
		this.garantia = garantia;
	}
	public String getGarantiaApp() {
		return garantiaApp;
	}
	public void setGarantiaApp(String garantiaApp) {
		this.garantiaApp = garantiaApp;
	}
	public String getTipoProducto() {
		return tipoProducto;
	}
	public void setTipoProducto(String tipoProducto) {
		this.tipoProducto = tipoProducto;
	}
	public String getIdContrato() {
		return idContrato;
	}
	public void setIdContrato(String idContrato) {
		this.idContrato = idContrato;
	}

}
