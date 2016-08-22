package es.pfsgroup.plugin.rem.model;

public class DtoCambioEstadoPublicacion {

	private Long idActivo;
	private Boolean publicacionOrdinaria;
	private Boolean publicacionForzada;
	private Boolean ocultacionForzada;
	private Boolean ocultacionPrecio;
	private Boolean despublicacionForzada;
	private String motivo;
	private String observaciones;
	
	
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
	public Boolean getOcultacionPrecio() {
		return ocultacionPrecio;
	}
	public void setOcultacionPrecio(Boolean ocultacionPrecio) {
		this.ocultacionPrecio = ocultacionPrecio;
	}
	public Boolean getDespublicacionForzada() {
		return despublicacionForzada;
	}
	public void setDespublicacionForzada(Boolean despublicacionForzada) {
		this.despublicacionForzada = despublicacionForzada;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
}
