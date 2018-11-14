package es.pfsgroup.plugin.rem.model;


import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de Datos de Contacto > Activos Integrados de la ficha proveedor 
 * y comunidades/entidades de la ficha del activo
 */
public class DtoComunidadpropietariosActivo extends DtoTabActivo {
	private static final long serialVersionUID = 0L;
	
	private Date fechaComunicacionComunidad;
	private Integer envioCartas;
	private Integer numCartas;
	private Integer contactoTel;
	private Integer visita;
	private Integer burofax;
	private Long situacionId;
	private String situacion;
	private Date fechaEnvioCarta;
	private String situacionDescripcion;
	private String situacionCodigo;
	
	

	public Date getFechaComunicacionComunidad() {
		return fechaComunicacionComunidad;
	}
	public void setFechaComunicacionComunidad(Date fechaComunicacionComunidad) {
		this.fechaComunicacionComunidad = fechaComunicacionComunidad;
	}
	public Integer getEnvioCartas() {
		return envioCartas;
	}
	public void setEnvioCartas(Integer envioCartas) {
		this.envioCartas = envioCartas;
	}
	public Integer getNumCartas() {
		return numCartas;
	}
	public void setNumCartas(Integer numCartas) {
		this.numCartas = numCartas;
	}
	public Integer getContactoTel() {
		return contactoTel;
	}
	public void setContactoTel(Integer contactoTel) {
		this.contactoTel = contactoTel;
	}
	public Integer getVisita() {
		return visita;
	}
	public void setVisita(Integer visita) {
		this.visita = visita;
	}
	public Integer getBurofax() {
		return burofax;
	}
	public void setBurofax(Integer burofax) {
		this.burofax = burofax;
	}
	public Long getSituacionId() {
		return situacionId;
	}
	public void setSituacionId(Long situacionId) {
		this.situacionId = situacionId;
	}
	public Date getFechaEnvioCarta() {
		return fechaEnvioCarta;
	}
	public void setFechaEnvioCarta(Date fechaEnvioCarta) {
		this.fechaEnvioCarta = fechaEnvioCarta;
	}
	public String getSituacion() {
		return situacion;
	}
	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}
	public String getSituacionDescripcion() {
		return situacionDescripcion;
	}
	public void setSituacionDescripcion(String situacionDescripcion) {
		this.situacionDescripcion = situacionDescripcion;
	}
	public String getSituacionCodigo() {
		return situacionCodigo;
	}
	public void setSituacionCodigo(String situacionCodigo) {
		this.situacionCodigo = situacionCodigo;
	}
	
	
	
	
}