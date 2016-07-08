package es.pfsgroup.plugin.rem.model;

import java.util.Date;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoAdmisionDocumento {

	private static final long serialVersionUID = 0L;

	private Long idAdmisionDoc;
	private Long idActivo;
	private Long idConfiguracionDoc;
	private Integer numDocumento;
	private Date fechaSolicitud;
	private Date fechaEmision;
	private Date fechaCaducidad;
	private Date fechaEtiqueta;
	private Date fechaCalificacion;
	private Integer calificacion;
	private String tipoCalificacionCodigo;
	private String tipoCalificacionDescripcion;
	private Date fechaObtencion;
	private Date fechaVerificado;
	private Integer aplica;
	private String estadoDocumento;
	
	//Mapeado a mano
	private String descripcionTipoDocumentoActivo;
	

	public Long getIdAdmisionDoc() {
		return idAdmisionDoc;
	}

	public void setIdAdmisionDoc(Long idAdmisionDoc) {
		this.idAdmisionDoc = idAdmisionDoc;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getIdConfiguracionDoc() {
		return idConfiguracionDoc;
	}

	public void setIdConfiguracionDoc(Long idConfiguracionDoc) {
		this.idConfiguracionDoc = idConfiguracionDoc;
	}

	public Integer getNumDocumento() {
		return numDocumento;
	}

	public void setNumDocumento(Integer numDocumento) {
		this.numDocumento = numDocumento;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public Date getFechaCaducidad() {
		return fechaCaducidad;
	}

	public void setFechaCaducidad(Date fechaCaducidad) {
		this.fechaCaducidad = fechaCaducidad;
	}

	public String getDescripcionTipoDocumentoActivo() {
		return descripcionTipoDocumentoActivo;
	}

	public void setDescripcionTipoDocumentoActivo(String descripcionTipoDocumentoActivo) {
		this.descripcionTipoDocumentoActivo = descripcionTipoDocumentoActivo;
	}
	
	public Date getFechaEtiqueta() {
		return fechaEtiqueta;
	}

	public void setFechaEtiqueta(Date fechaEtiqueta) {
		this.fechaEtiqueta = fechaEtiqueta;
	}

	public Integer getCalificacion() {
		return calificacion;
	}

	public void setCalificacion(Integer calificacion) {
		this.calificacion = calificacion;
	}

	public Date getFechaObtencion() {
		return fechaObtencion;
	}

	public void setFechaObtencion(Date fechaObtencion) {
		this.fechaObtencion = fechaObtencion;
	}

	public Date getFechaVerificado() {
		return fechaVerificado;
	}

	public void setFechaVerificado(Date fechaVerificado) {
		this.fechaVerificado = fechaVerificado;
	}

	public Integer getAplica() {
		return aplica;
	}

	public void setAplica(Integer aplica) {
		this.aplica = aplica;
	}

	public String getEstadoDocumento() {
		return estadoDocumento;
	}

	public void setEstadoDocumento(String estadoDocumento) {
		this.estadoDocumento = estadoDocumento;
	}

	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}

	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}

	public String getTipoCalificacionCodigo() {
		return tipoCalificacionCodigo;
	}

	public void setTipoCalificacionCodigo(String tipoCalificacionCodigo) {
		this.tipoCalificacionCodigo = tipoCalificacionCodigo;
	}

	public String getTipoCalificacionDescripcion() {
		return tipoCalificacionDescripcion;
	}

	public void setTipoCalificacionDescripcion(
			String tipoCalificacionDescripcion) {
		this.tipoCalificacionDescripcion = tipoCalificacionDescripcion;
	}
	
}