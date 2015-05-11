package es.pfsgroup.plugin.recovery.masivo.dto;

public class MSVResultadoOperacionMasivaDto {
	
	private Integer numeroOperacionesRealizadas;
	private Integer numeroOperacionesFallidas;
	private String observaciones;
	
	public void setNumeroOperacionesRealizadas(
			Integer numeroOperacionesRealizadas) {
		this.numeroOperacionesRealizadas = numeroOperacionesRealizadas;
	}
	public Integer getNumeroOperacionesRealizadas() {
		return numeroOperacionesRealizadas;
	}
	public void setNumeroOperacionesFallidas(Integer numeroOperacionesFallidas) {
		this.numeroOperacionesFallidas = numeroOperacionesFallidas;
	}
	public Integer getNumeroOperacionesFallidas() {
		return numeroOperacionesFallidas;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getObservaciones() {
		return observaciones;
	}

}
