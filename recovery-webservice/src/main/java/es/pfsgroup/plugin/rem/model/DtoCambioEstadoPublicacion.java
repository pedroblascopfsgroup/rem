package es.pfsgroup.plugin.rem.model;

public class DtoCambioEstadoPublicacion {

	private Long idActivo;
	private Boolean publicacionOrdinaria;
	private Boolean publicacionForzada;
	private Boolean ocultacionForzada;
	private Boolean oculacionPrecio;
	private Boolean despublicacionForzada;
	
	public Long getIdActivo(){
		return idActivo;
	}
	public void setActivo(Long idActivo){
		this.idActivo = idActivo;
	}
	public Boolean getPublicacionOrdinaria() {
		return publicacionOrdinaria;
	}
	public void setPublicacionOrdinaria(Boolean publicacionOrdinaria) {
		this.publicacionOrdinaria = publicacionOrdinaria;
	}
	public Boolean getPublicacionForzada() {
		return publicacionForzada;
	}
	public void setPublicacionForzada(Boolean publicacionForzada) {
		this.publicacionForzada = publicacionForzada;
	}
	public Boolean getOcultacionForzada() {
		return ocultacionForzada;
	}
	public void setOcultacionForzada(Boolean ocultacionForzada) {
		this.ocultacionForzada = ocultacionForzada;
	}
	public Boolean getOculacionPrecio() {
		return oculacionPrecio;
	}
	public void setOculacionPrecio(Boolean oculacionPrecio) {
		this.oculacionPrecio = oculacionPrecio;
	}
	public Boolean getDespublicacionForzada() {
		return despublicacionForzada;
	}
	public void setDespublicacionForzada(Boolean despublicacionForzada) {
		this.despublicacionForzada = despublicacionForzada;
	}
}
