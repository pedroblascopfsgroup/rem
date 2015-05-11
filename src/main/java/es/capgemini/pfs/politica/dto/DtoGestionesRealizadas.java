package es.capgemini.pfs.politica.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * @author marruiz
 */
public class DtoGestionesRealizadas extends WebDto {

	private static final long serialVersionUID = 3930768994376786557L;

	private Long idAnalisisPersonaPolitica;
	private String observacionesGestiones;
	private String gestionesIncluir;


	/**
	 * @return the idAnalisisPersonaPolitica
	 */
	public Long getIdAnalisisPersonaPolitica() {
		return idAnalisisPersonaPolitica;
	}
	/**
	 * @param idAnalisisPersonaPolitica the idAnalisisPersonaPolitica to set
	 */
	public void setIdAnalisisPersonaPolitica(Long idAnalisisPersonaPolitica) {
		this.idAnalisisPersonaPolitica = idAnalisisPersonaPolitica;
	}
	/**
	 * @return the observacionesGestiones
	 */
	public String getObservacionesGestiones() {
		return observacionesGestiones;
	}
	/**
	 * @param observacionesGestiones the observacionesGestiones to set
	 */
	public void setObservacionesGestiones(
			String observacionesGestiones) {
		this.observacionesGestiones = observacionesGestiones;
	}
	/**
	 * @return the gestionesIncluir
	 */
	public String getGestionesIncluir() {
		return gestionesIncluir;
	}
	/**
	 * @param gestionesIncluir the gestionesIncluir to set
	 */
	public void setGestionesIncluir(String gestionesIncluir) {
		this.gestionesIncluir = gestionesIncluir;
	}
}
