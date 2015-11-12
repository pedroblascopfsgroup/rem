package es.pfsgroup.recovery.gestordocumental.dto;

import java.util.Date;

public class AdjuntoGridDto {

	// value="${dto.adjunto.id}
	private Long idAdjunto;
	// value="${dto.adjunto.nombre}"
	private String nombre;
	// value="${dto.adjunto.contentType}"
	private String tipoDocumento;
	// value="${dto.adjunto.descripcion}"
	private String descripcion;
	// value="${dto.adjunto.length}"
	private String tamaño;
	// <c:if test="${dto.adjunto.tipoFichero != null}">
	// <json:property name="tipoFichero"
	// value="${dto.adjunto.tipoFichero.descripcion}" />
	// </c:if>
	private String tipo;
	// <fmt:formatDate value="${dto.adjunto.auditoria.fechaCrear}"
	// pattern="dd/MM/yyyy" />
	private Date fechaSubida;
	// value="${dto.adjunto.procedimiento.id}"
	private Long numActuacion;
	// value="${entity.descripcion}"
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

	public String getTamaño() {
		return tamaño;
	}

	public void setTamaño(String tamaño) {
		this.tamaño = tamaño;
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