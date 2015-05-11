package es.capgemini.pfs.asunto.dto;

import java.math.BigDecimal;



public class DtoReportAsuntoRiesgoOrigen {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String ibanRiesgo;
	private String fechaFormalizacion;
	private String importeCapital;
	
	
	public String getFechaFormalizacion() {
		return fechaFormalizacion;
	}
	public void setFechaFormalizacion(String fechaFormalizacion) {
		this.fechaFormalizacion = fechaFormalizacion;
	}
	public String getImporteCapital() {
		return importeCapital;
	}
	public void setImporteCapital(String importeCapital) {
		this.importeCapital = importeCapital;
	}
	public String getIbanRiesgo() {
		return ibanRiesgo;
	}
	public void setIbanRiesgo(String ibanRiesgo) {
		this.ibanRiesgo = ibanRiesgo;
	}
	


	
	
}
