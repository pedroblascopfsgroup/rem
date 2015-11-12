package es.pfsgroup.recovery.gestordocumental.dto;

import java.util.Date;

public class AdjuntoGridDto {

	private Long idAdjunto;
	private String nombre;
	private String tipoDocumento;
	private String descripcion;
	private String tamanyo;
	private String tipo;
	private Date fechaSubida;
	private Long numActuacion;
	private String descripcionEntidad;

	public Long getIdAdjunto() {
		return idAdjunto;
	}

	public void setIdAdjunto(Long idAdjunto) {
		this.idAdjunto = idAdjunto;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getTamanyo() {
		return tamanyo;
	}
	
	public void setTamanyo(String tamanyo) {
		this.tamanyo = tamanyo;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public Date getFechaSubida() {
		return fechaSubida;
	}

	public void setFechaSubida(Date fechaSubida) {
		this.fechaSubida = fechaSubida;
	}

	public Long getNumActuacion() {
		return numActuacion;
	}

	public void setNumActuacion(Long numActuacion) {
		this.numActuacion = numActuacion;
	}

	public String getDescripcionEntidad() {
		return descripcionEntidad;
	}

	public void setDescripcionEntidad(String descripcionEntidad) {
		this.descripcionEntidad = descripcionEntidad;
	}

}