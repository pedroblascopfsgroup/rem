package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class EditarInformacionCierreDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1042740703163518903L;

	private Long idSubasta;
	private Long idPlazaJuzgado;
	private String codigoPlaza;
	private Long idTipoJuzgado;
	private String codigoJuzgado;
	private BigDecimal principalDemanda;
	private String costasLetrado;
	private Long idValorCostasLetrado;
	private String costasProcurador;
	private Long idValorCostasProcurador;
	private String fechaSenyalamiento;
	private String conPostores;
	private Long idValorConPostores;
	private boolean habilitarEditarInformacionCDD;

	/**
	 * @return the idSubasta
	 */
	public Long getIdSubasta() {
		return idSubasta;
	}

	/**
	 * @param idSubasta
	 *            the idSubasta to set
	 */
	public void setIdSubasta(Long idSubasta) {
		this.idSubasta = idSubasta;
	}

	/**
	 * @return the idPlazaJuzgado
	 */
	public Long getIdPlazaJuzgado() {
		return idPlazaJuzgado;
	}

	/**
	 * @param idPlazaJuzgado
	 *            the idPlazaJuzgado to set
	 */
	public void setIdPlazaJuzgado(Long idPlazaJuzgado) {
		this.idPlazaJuzgado = idPlazaJuzgado;
	}

	/**
	 * @return the codigoPlaza
	 */
	public String getCodigoPlaza() {
		return codigoPlaza;
	}

	/**
	 * @param codigoPlaza
	 *            the codigoPlaza to set
	 */
	public void setCodigoPlaza(String codigoPlaza) {
		this.codigoPlaza = codigoPlaza;
	}

	/**
	 * @return the idTipoJuzgado
	 */
	public Long getIdTipoJuzgado() {
		return idTipoJuzgado;
	}

	/**
	 * @param idTipoJuzgado
	 *            the idTipoJuzgado to set
	 */
	public void setIdTipoJuzgado(Long idTipoJuzgado) {
		this.idTipoJuzgado = idTipoJuzgado;
	}

	/**
	 * @return the codigoJuzgado
	 */
	public String getCodigoJuzgado() {
		return codigoJuzgado;
	}

	/**
	 * @param codigoJuzgado
	 *            the codigoJuzgado to set
	 */
	public void setCodigoJuzgado(String codigoJuzgado) {
		this.codigoJuzgado = codigoJuzgado;
	}

	/**
	 * @return the principalDemanda
	 */
	public BigDecimal getPrincipalDemanda() {
		return principalDemanda;
	}

	/**
	 * @param principalDemanda
	 *            the principalDemanda to set
	 */
	public void setPrincipalDemanda(BigDecimal principalDemanda) {
		this.principalDemanda = principalDemanda;
	}

	/**
	 * @return the costasLetrado
	 */
	public String getCostasLetrado() {
		return costasLetrado;
	}

	/**
	 * @param costasLetrado
	 *            the costasLetrado to set
	 */
	public void setCostasLetrado(String costasLetrado) {
		this.costasLetrado = costasLetrado;
	}

	/**
	 * @return the idValorCostasLetrado
	 */
	public Long getIdValorCostasLetrado() {
		return idValorCostasLetrado;
	}

	/**
	 * @param idValorCostasLetrado
	 *            the idValorCostasLetrado to set
	 */
	public void setIdValorCostasLetrado(Long idValorCostasLetrado) {
		this.idValorCostasLetrado = idValorCostasLetrado;
	}

	/**
	 * @return the costasProcurador
	 */
	public String getCostasProcurador() {
		return costasProcurador;
	}

	/**
	 * @param costasProcurador
	 *            the costasProcurador to set
	 */
	public void setCostasProcurador(String costasProcurador) {
		this.costasProcurador = costasProcurador;
	}

	/**
	 * @return the idValorCostasProcurador
	 */
	public Long getIdValorCostasProcurador() {
		return idValorCostasProcurador;
	}

	/**
	 * @param idValorCostasProcurador
	 *            the idValorCostasProcurador to set
	 */
	public void setIdValorCostasProcurador(Long idValorCostasProcurador) {
		this.idValorCostasProcurador = idValorCostasProcurador;
	}

	/**
	 * @return the fechaSenyalamiento
	 */
	public String getFechaSenyalamiento() {
		return fechaSenyalamiento;
	}

	/**
	 * @param fechaSenyalamiento
	 *            the fechaSenyalamiento to set
	 */
	public void setFechaSenyalamiento(String fechaSenyalamiento) {
		this.fechaSenyalamiento = fechaSenyalamiento;
	}

	/**
	 * @return the conPostores
	 */
	public String getConPostores() {
		return conPostores;
	}

	/**
	 * @param conPostores
	 *            the conPostores to set
	 */
	public void setConPostores(String conPostores) {
		this.conPostores = conPostores;
	}

	/**
	 * @return the idValorConPostores
	 */
	public Long getIdValorConPostores() {
		return idValorConPostores;
	}

	/**
	 * @param idValorConPostores
	 *            the idValorConPostores to set
	 */
	public void setIdValorConPostores(Long idValorConPostores) {
		this.idValorConPostores = idValorConPostores;
	}

	/**
	 * @return the habilitarEditarInformacionCDD
	 */
	public boolean isHabilitarEditarInformacionCDD() {
		return habilitarEditarInformacionCDD;
	}

	/**
	 * @param habilitarEditarInformacionCDD the habilitarEditarInformacionCDD to set
	 */
	public void setHabilitarEditarInformacionCDD(
			boolean habilitarEditarInformacionCDD) {
		this.habilitarEditarInformacionCDD = habilitarEditarInformacionCDD;
	}

}
