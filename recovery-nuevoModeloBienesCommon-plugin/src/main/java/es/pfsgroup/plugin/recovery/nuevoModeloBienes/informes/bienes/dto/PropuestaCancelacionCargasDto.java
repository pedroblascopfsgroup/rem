package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.bienes.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

public class PropuestaCancelacionCargasDto implements Serializable {

	private static final long serialVersionUID = 5952051250650339702L;
	
	// Report fields
	private String nActivo;
	private String fichaInmovilizado;
	private String descripcion;
	private String numFinca;
	private String numRegistro;
	private String municipio;
	private Float importeTasacion;
	private BigDecimal importeAdjudicacion;
	private String observaciones;
	private String resumen;
	private String propuesta;
	private List<BienCargaDto> cargas;
	private List<BienProcedimientoDto> procedimientos;

	public String getnActivo() {
		return nActivo;
	}

	public void setnActivo(String nActivo) {
		this.nActivo = nActivo;
	}

	public String getFichaInmovilizado() {
		return fichaInmovilizado;
	}

	public void setFichaInmovilizado(String fichaInmovilizado) {
		this.fichaInmovilizado = fichaInmovilizado;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}

	public String getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public Float getImporteTasacion() {
		return importeTasacion;
	}

	public void setImporteTasacion(Float importeTasacion) {
		this.importeTasacion = importeTasacion;
	}

	public BigDecimal getImporteAdjudicacion() {
		return importeAdjudicacion;
	}

	public void setImporteAdjudicacion(BigDecimal importeAdjudicacion) {
		this.importeAdjudicacion = importeAdjudicacion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getResumen() {
		return resumen;
	}

	public void setResumen(String resumen) {
		this.resumen = resumen;
	}

	public String getPropuesta() {
		return propuesta;
	}

	public void setPropuesta(String propuesta) {
		this.propuesta = propuesta;
	}

	public List<BienCargaDto> getCargas() {
		return cargas;
	}

	public void setCargas(List<BienCargaDto> cargas) {
		this.cargas = cargas;
	}

	public List<BienProcedimientoDto> getProcedimientos() {
		return procedimientos;
	}

	public void setProcedimientos(List<BienProcedimientoDto> procedimientos) {
		this.procedimientos = procedimientos;
	}
}
