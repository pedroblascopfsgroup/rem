package es.capgemini.pfs.acuerdo.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para asuntos.
 * Por el momento la única propiedad que se necesita es el id del gestor.
 * @author pamuller
 *
 */
public class DtoAnalisisAcuerdo extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long idAcuerdo;
	private String conclusionTitulos;
	private String observacionesTitulos;
	private String cambioCapPago;
	private Double aumentoCapPago;
	private String observacionesCapPago;
	private String cambioSolvencia;
	private Double aumentoSolvencia;
	private String observacionesSolvencia;


	/**
	 * @return the idAcuerdo
	 */
	public Long getIdAcuerdo() {
		return idAcuerdo;
	}


	/**
	 * @param idAcuerdo the idAcuerdo to set
	 */
	public void setIdAcuerdo(Long idAcuerdo) {
		this.idAcuerdo = idAcuerdo;
	}


	/**
	 * @return the conclusionTitulos
	 */
	public String getConclusionTitulos() {
		return conclusionTitulos;
	}


	/**
	 * @param conclusionTitulos the conclusionTitulos to set
	 */
	public void setConclusionTitulos(String conclusionTitulos) {
		this.conclusionTitulos = conclusionTitulos;
	}


	/**
	 * @return the observacionesTitulos
	 */
	public String getObservacionesTitulos() {
		return observacionesTitulos;
	}


	/**
	 * @param observacionesTitulos the observacionesTitulos to set
	 */
	public void setObservacionesTitulos(String observacionesTitulos) {
		this.observacionesTitulos = observacionesTitulos;
	}


	/**
	 * @return the cambioCapPago
	 */
	public String getCambioCapPago() {
		return cambioCapPago;
	}


	/**
	 * @param cambioCapPago the cambioCapPago to set
	 */
	public void setCambioCapPago(String cambioCapPago) {
		this.cambioCapPago = cambioCapPago;
	}


	/**
	 * @return the aumentoCapPago
	 */
	public Double getAumentoCapPago() {
		return aumentoCapPago;
	}


	/**
	 * @param aumentoCapPago the aumentoCapPago to set
	 */
	public void setAumentoCapPago(Double aumentoCapPago) {
		this.aumentoCapPago = aumentoCapPago;
	}


	/**
	 * @return the observacionesCapPago
	 */
	public String getObservacionesCapPago() {
		return observacionesCapPago;
	}


	/**
	 * @param observacionesCapPago the observacionesCapPago to set
	 */
	public void setObservacionesCapPago(String observacionesCapPago) {
		this.observacionesCapPago = observacionesCapPago;
	}


	/**
	 * @return the cambioSolvencia
	 */
	public String getCambioSolvencia() {
		return cambioSolvencia;
	}


	/**
	 * @param cambioSolvencia the cambioSolvencia to set
	 */
	public void setCambioSolvencia(String cambioSolvencia) {
		this.cambioSolvencia = cambioSolvencia;
	}


	/**
	 * @return the aumentoSolvencia
	 */
	public Double getAumentoSolvencia() {
		return aumentoSolvencia;
	}


	/**
	 * @param aumentoSolvencia the aumentoSolvencia to set
	 */
	public void setAumentoSolvencia(Double aumentoSolvencia) {
		this.aumentoSolvencia = aumentoSolvencia;
	}


	/**
	 * @return the observacionesSolvencia
	 */
	public String getObservacionesSolvencia() {
		return observacionesSolvencia;
	}


	/**
	 * @param observacionesSolvencia the observacionesSolvencia to set
	 */
	public void setObservacionesSolvencia(String observacionesSolvencia) {
		this.observacionesSolvencia = observacionesSolvencia;
	}

}
