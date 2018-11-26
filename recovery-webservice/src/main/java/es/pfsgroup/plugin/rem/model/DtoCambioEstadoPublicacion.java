package es.pfsgroup.plugin.rem.model;

public class DtoCambioEstadoPublicacion extends DtoTabActivo {
// TODO: eliminar este archivo.
	private Long idActivo;
	private Boolean publicacionOrdinaria = false;
	private Boolean publicacionForzada = false;
	private Boolean ocultacionForzada = false;
	private Boolean ocultacionPrecio = false;
	private Boolean desOcultacionPrecio = false;
	private Boolean despublicacionForzada = false;
	private String motivoPublicacion;
	private String motivoOcultacionPrecio;
	private String motivoDespublicacionForzada;
	private String motivoOcultacionForzada;
	private String observaciones;
	
	public Long getIdActivo(){
		return idActivo;
	}
	public void setActivo(Long idActivo){
		this.idActivo = idActivo;
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
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getMotivoPublicacion() {
		return motivoPublicacion;
	}
	public void setMotivoPublicacion(String motivoPublicacion) {
		this.motivoPublicacion = motivoPublicacion;
	}
	public String getMotivoOcultacionPrecio() {
		return motivoOcultacionPrecio;
	}
	public void setMotivoOcultacionPrecio(String motivoOcultacionPrecio) {
		this.motivoOcultacionPrecio = motivoOcultacionPrecio;
	}
	public String getMotivoDespublicacionForzada() {
		return motivoDespublicacionForzada;
	}
	public void setMotivoDespublicacionForzada(String motivoDespublicacionForzada) {
		this.motivoDespublicacionForzada = motivoDespublicacionForzada;
	}
	public String getMotivoOcultacionForzada() {
		return motivoOcultacionForzada;
	}
	public void setMotivoOcultacionForzada(String motivoOcultacionForzada) {
		this.motivoOcultacionForzada = motivoOcultacionForzada;
	}
	public Boolean getPublicacionOrdinaria() {
		return publicacionOrdinaria;
	}
	public void setPublicacionOrdinaria(Boolean publicacionOrdinaria) {
		this.publicacionOrdinaria = publicacionOrdinaria;
	}
	public Boolean getDesOcultacionPrecio() {
		return desOcultacionPrecio;
	}
	public void setDesOcultacionPrecio(Boolean desOcultacionPrecio) {
		this.desOcultacionPrecio = desOcultacionPrecio;
	}
	
}
