package es.pfsgroup.recovery.gestordocumental.dto;

import es.capgemini.pfs.auditoria.model.Auditoria;

public class AdjuntoGridDto {

	private Long id;
	private String nombre;
	private String contentType;
	private String descripcion;
	private String length;
	private String tipo;
	private Long numActuacion;
	private String descripcionEntidad;
	private String refCentera;
	private String ficheroBase64;
	private String extFichero;
	private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getNombre() {
		return nombre;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	public String getContentType() {
		return contentType;
	}
	
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	
	public String getDescripcion() {
		return descripcion;
	}
	
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	public String getLength() {
		return length;
	}
	
	public void setLength(String length) {
		this.length = length;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
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
	
	public String getRefCentera() {
		return refCentera;
	}
	
	public void setRefCentera(String refCentera) {
		this.refCentera = refCentera;
	}

	public String getFicheroBase64() {
		return ficheroBase64;
	}

	public void setFicheroBase64(String ficheroBase64) {
		this.ficheroBase64 = ficheroBase64;
	}
	
	public String getExtFichero() {
		return extFichero;
	}
	
	public void setExtFichero(String extFichero) {
		this.extFichero = extFichero;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}
	
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}