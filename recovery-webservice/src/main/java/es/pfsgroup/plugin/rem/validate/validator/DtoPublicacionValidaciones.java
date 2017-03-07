package es.pfsgroup.plugin.rem.validate.validator;

import es.pfsgroup.plugin.rem.model.Activo;

public class DtoPublicacionValidaciones {
    
	private Activo activo;
	
	private boolean validarOKGestion;
	private boolean validarOKAdmision;
	private boolean validarOKPrecio;
	private boolean validarInfComercialTiposIguales;
	private boolean validarInfComercialAceptado;
	
	public Activo getActivo() {
		return activo;
	}
	public void setActivo(Activo activo) {
		this.activo = activo;
	}
	public boolean isValidarOKGestion() {
		return validarOKGestion;
	}
	public void setValidarOKGestion(boolean validarOKGestion) {
		this.validarOKGestion = validarOKGestion;
	}
	public boolean isValidarOKAdmision() {
		return validarOKAdmision;
	}
	public void setValidarOKAdmision(boolean validarOKAdmision) {
		this.validarOKAdmision = validarOKAdmision;
	}
	public boolean isValidarOKPrecio() {
		return validarOKPrecio;
	}
	public void setValidarOKPrecio(boolean validarOKPrecio) {
		this.validarOKPrecio = validarOKPrecio;
	}
	public boolean isValidarInfComercialTiposIguales() {
		return validarInfComercialTiposIguales;
	}
	public void setValidarInfComercialTiposIguales(boolean validarInfComercialTiposIguales) {
		this.validarInfComercialTiposIguales = validarInfComercialTiposIguales;
	}
	public boolean isValidarInfComercialAceptado() {
		return validarInfComercialAceptado;
	}
	public void setValidarInfComercialAceptado(boolean validarInfComercialAceptado) {
		this.validarInfComercialAceptado = validarInfComercialAceptado;
	}

	public void setValidacionesTodas(){
		this.validarOKGestion = true;
		this.validarOKAdmision = true;
		this.validarOKPrecio = true;
		this.validarInfComercialTiposIguales = true;
		this.validarInfComercialAceptado = true;
	}
	public void setValidacionesTramite(){
		this.validarOKGestion = true;
		this.validarOKAdmision = true;
		this.validarOKPrecio = true;
		this.validarInfComercialTiposIguales = true;
		this.validarInfComercialAceptado = false;
	}


}
