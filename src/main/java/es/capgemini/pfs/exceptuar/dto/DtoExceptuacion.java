package es.capgemini.pfs.exceptuar.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoExceptuacion extends WebDto {

	public static final String TIPO_PERSONA = "1";
	public static final String TIPO_CONTRATO = "2";

	/**
	 * 
	 */
	private static final long serialVersionUID = 5134829768519417027L;
	private Long excId;
	private String fechaHasta;
	private Long idMotivo;
	private Long idEntidad;
	private String tipo;
	private String observaciones;

	public Long getExcId() {
		return excId;
	}

	public void setExcId(Long excId) {
		this.excId = excId;
	}

	public String getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(String fechaHasta) {
		this.fechaHasta = fechaHasta;
	}

	public Long getIdMotivo() {
		return idMotivo;
	}

	public void setIdMotivo(Long idMotivo) {
		this.idMotivo = idMotivo;
	}

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

}
