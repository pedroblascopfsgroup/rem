package es.capgemini.pfs.politica.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * @author Pablo Müller
 *
 */
public class DtoAnalisisOperacion extends WebDto{

	private static final long serialVersionUID = -5183424966744490312L;

	private Long idAnalisisOperacion;
	private Long idContrato;
	private String codigoValoracion;
	private String codigoImpacto;
	private String comentario;
	private Long idPersona;

	/**
	 * @return the idPersona
	 */
	public Long getIdPersona() {
		return idPersona;
	}
	/**
	 * @param idPersona the idPersona to set
	 */
	public void setIdPersona(Long idPersona) {
		this.idPersona = idPersona;
	}
	/**
	 * @return the idContrato
	 */
	public Long getIdContrato() {
		return idContrato;
	}
	/**
	 * @param idContrato the idContrato to set
	 */
	public void setIdContrato(Long idContrato) {
		this.idContrato = idContrato;
	}
	/**
	 * @return the codigoValoracion
	 */
	public String getCodigoValoracion() {
		return codigoValoracion;
	}
	/**
	 * @param codigoValoracion the idValoracion to set
	 */
	public void setCodigoValoracion(String codigoValoracion) {
		this.codigoValoracion = codigoValoracion;
	}
	/**
	 * @return the codigoImpacto
	 */
	public String getCodigoImpacto() {
		return codigoImpacto;
	}
	/**
	 * @param codigoImpacto the idImpacto to set
	 */
	public void setCodigoImpacto(String codigoImpacto) {
		this.codigoImpacto = codigoImpacto;
	}
	/**
	 * @return the comentario
	 */
	public String getComentario() {
		return comentario;
	}
	/**
	 * @param comentario the comentario to set
	 */
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	/**
	 * @return the idAnalisisOperacion
	 */
	public Long getIdAnalisisOperacion() {
		return idAnalisisOperacion;
	}
	/**
	 * @param idAnalisisOperacion the idAnalisisOperacion to set
	 */
	public void setIdAnalisisOperacion(Long idAnalisisOperacion) {
		this.idAnalisisOperacion = idAnalisisOperacion;
	}

}
