package es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroPoliticaAcuerdosPalancaDto extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1044718015926798585L;
	
	private Long idPalanca;
	private Long idPolitica;
	private String codigoTipoPalanca;
	private String codigoSubtipoPalanca;
	private String codigoSiNo;
	private Integer prioridad;
	private String tiempoInmunidad1;
	private String tiempoInmunidad2;
	
	public Long getIdPalanca() {
		return idPalanca;
	}
	public void setIdPalanca(Long idPalanca) {
		this.idPalanca = idPalanca;
	}
	public Long getIdPolitica() {
		return idPolitica;
	}
	public void setIdPolitica(Long idPolitica) {
		this.idPolitica = idPolitica;
	}
	public String getCodigoTipoPalanca() {
		return codigoTipoPalanca;
	}
	public void setCodigoTipoPalanca(String codigoTipoPalanca) {
		this.codigoTipoPalanca = codigoTipoPalanca;
	}
	public String getCodigoSubtipoPalanca() {
		return codigoSubtipoPalanca;
	}
	public void setCodigoSubtipoPalanca(String codigoSubtipoPalanca) {
		this.codigoSubtipoPalanca = codigoSubtipoPalanca;
	}
	public String getCodigoSiNo() {
		return codigoSiNo;
	}
	public void setCodigoSiNo(String codigoSiNo) {
		this.codigoSiNo = codigoSiNo;
	}
	public Integer getPrioridad() {
		return prioridad;
	}
	public void setPrioridad(Integer prioridad) {
		this.prioridad = prioridad;
	}
	public String getTiempoInmunidad1() {
		return tiempoInmunidad1;
	}
	public void setTiempoInmunidad1(String tiempoInmunidad1) {
		this.tiempoInmunidad1 = tiempoInmunidad1;
	}
	public String getTiempoInmunidad2() {
		return tiempoInmunidad2;
	}
	public void setTiempoInmunidad2(String tiempoInmunidad2) {
		this.tiempoInmunidad2 = tiempoInmunidad2;
	}
	
	

}
