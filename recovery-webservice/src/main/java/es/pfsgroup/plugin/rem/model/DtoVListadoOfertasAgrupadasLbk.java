package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoVListadoOfertasAgrupadasLbk extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long numOfertaPrincipal;
	private Long numOfertaDependiente;
	private Long numActivo;
	private Double importeOfertaDependiente;
	private Double valorTasacionActivo;
	private Double valorNetoContable;
	private Double valorRazonable;
	
	public Long getNumOfertaPrincipal() {
		return numOfertaPrincipal;
	}
	public void setNumOfertaPrincipal(Long numOfertaPrincipal) {
		this.numOfertaPrincipal = numOfertaPrincipal;
	}
	public Long getNumOfertaDependiente() {
		return numOfertaDependiente;
	}
	public void setNumOfertaDependiente(Long numOfertaDependiente) {
		this.numOfertaDependiente = numOfertaDependiente;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Double getImporteOfertaDependiente() {
		return importeOfertaDependiente;
	}
	public void setImporteOfertaDependiente(Double importeOfertaDependiente) {
		this.importeOfertaDependiente = importeOfertaDependiente;
	}
	public Double getValorTasacionActivo() {
		return valorTasacionActivo;
	}
	public void setValorTasacionActivo(Double valorTasacionActivo) {
		this.valorTasacionActivo = valorTasacionActivo;
	}
	public Double getValorNetoContable() {
		return valorNetoContable;
	}
	public void setValorNetoContable(Double valorNetoContable) {
		this.valorNetoContable = valorNetoContable;
	}
	public Double getValorRazonable() {
		return valorRazonable;
	}
	public void setValorRazonable(Double valorRazonable) {
		this.valorRazonable = valorRazonable;
	}	
}
