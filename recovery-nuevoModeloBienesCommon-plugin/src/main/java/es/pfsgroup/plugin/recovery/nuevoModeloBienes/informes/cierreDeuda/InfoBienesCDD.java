package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.cierreDeuda;

import java.util.List;

public class InfoBienesCDD {

	private Long idBien;
	private String descripcion;
	private String numRegistro;
	private String referenciaCatastral;
	private String numFinca;
	private String numeroActivo;
	private String valorTasacion;
	private String fechaTasacion;
	private String valorJudicial;
	private String datosLocalizacion;
	private String viviendaHabitual;
	private String resultadoAdjudicacion;
	private String importeAdjudicacion;
	private String fechaTestimonioAdjudicacionSareb;
	private List<String> contratosRelacionado;

	public Long getIdBien() {
		return idBien;
	}

	public void setIdBien(Long idBien) {
		this.idBien = idBien;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}

	public String getNumeroActivo() {
		return numeroActivo;
	}

	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}

	public String getValorTasacion() {
		return valorTasacion;
	}

	public void setValorTasacion(String valorTasacion) {
		this.valorTasacion = valorTasacion;
	}

	public String getFechaTasacion() {
		return fechaTasacion;
	}

	public void setFechaTasacion(String fechaTasacion) {
		this.fechaTasacion = fechaTasacion;
	}

	public String getValorJudicial() {
		return valorJudicial;
	}

	public void setValorJudicial(String valorJudicial) {
		this.valorJudicial = valorJudicial;
	}

	public String getDatosLocalizacion() {
		return datosLocalizacion;
	}

	public void setDatosLocalizacion(String datosLocalizacion) {
		this.datosLocalizacion = datosLocalizacion;
	}

	public String getViviendaHabitual() {
		return viviendaHabitual;
	}

	public void setViviendaHabitual(String viviendaHabitual) {
		this.viviendaHabitual = viviendaHabitual;
	}

	public String getResultadoAdjudicacion() {
		return resultadoAdjudicacion;
	}

	public void setResultadoAdjudicacion(String resultadoAdjudicacion) {
		this.resultadoAdjudicacion = resultadoAdjudicacion;
	}

	public String getImporteAdjudicacion() {
		return importeAdjudicacion;
	}

	public void setImporteAdjudicacion(String importeAdjudicacion) {
		this.importeAdjudicacion = importeAdjudicacion;
	}

	public String getFechaTestimonioAdjudicacionSareb() {
		return fechaTestimonioAdjudicacionSareb;
	}

	public void setFechaTestimonioAdjudicacionSareb(
			String fechaTestimonioAdjudicacionSareb) {
		this.fechaTestimonioAdjudicacionSareb = fechaTestimonioAdjudicacionSareb;
	}

	public List<String> getContratosRelacionado() {
		return contratosRelacionado;
	}

	public void setContratosRelacionado(List<String> contratosRelacionado) {
		this.contratosRelacionado = contratosRelacionado;
	}

}