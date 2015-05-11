package es.capgemini.pfs.politica.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * @author Pablo Müller
 *
 */
public class DtoAnalisisParcelaPersona extends WebDto{

	private static final long serialVersionUID = -5183424966744490312L;

	private Long idAnalisisParcelaPersona;
	private Long idParcela;
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
	 * @return the idParcela
	 */
	public Long getIdParcela() {
		return idParcela;
	}
	/**
	 * @param idParcela the idParcela to set
	 */
	public void setIdParcela(Long idParcela) {
		this.idParcela = idParcela;
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
	 * @return the idAnalisisParcelaPersona
	 */
	public Long getIdAnalisisParcelaPersona() {
		return idAnalisisParcelaPersona;
	}
	/**
	 * @param idAnalisisParcelaPersona the idAnalisisParcelaPersona to set
	 */
	public void setIdAnalisisParcelaPersona(Long idAnalisisParcelaPersona) {
		this.idAnalisisParcelaPersona = idAnalisisParcelaPersona;
	}

}
