package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoActivosPublicacion extends WebDto {
	private static final long serialVersionUID = 1L;

	private String numActivo;
	private String tipoActivo;
	private String subtipoActivo;
	private String cartera;
	private Boolean despubliForzada;
	private Boolean publiForzada;
	private Boolean admision;
	private Boolean gestion;
	private Boolean publicacion;
	private Boolean precio;
	private Boolean precioConsultar;


	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipo) {
		this.tipoActivo = tipo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public Boolean getDespubliForzada() {
		return despubliForzada;
	}

	public void setDespubliForzada(Boolean despubliForzada) {
		this.despubliForzada = despubliForzada;
	}

	public Boolean getPubliForzada() {
		return publiForzada;
	}

	public void setPubliForzada(Boolean publiForzada) {
		this.publiForzada = publiForzada;
	}

	public Boolean getAdmision() {
		return admision;
	}

	public void setAdmision(Boolean admision) {
		this.admision = admision;
	}

	public Boolean getGestion() {
		return gestion;
	}

	public void setGestion(Boolean gestion) {
		this.gestion = gestion;
	}

	public Boolean getPublicacion() {
		return publicacion;
	}

	public void setPublicacion(Boolean publicacion) {
		this.publicacion = publicacion;
	}

	public Boolean getPrecio() {
		return precio;
	}

	public void setPrecio(Boolean precio) {
		this.precio = precio;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public Boolean getPrecioConsultar() {
		return precioConsultar;
	}

	public void setPrecioConsultar(Boolean precioConsultar) {
		this.precioConsultar = precioConsultar;
	}

}
