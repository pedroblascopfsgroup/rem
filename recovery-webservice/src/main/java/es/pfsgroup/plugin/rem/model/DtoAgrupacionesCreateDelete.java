package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.pfs.users.domain.Usuario;

/**
 * Dto para la creacion o eliminación de la busqueda de agrupaciones.
 * @author Benjamín Guerrero
 */
public class DtoAgrupacionesCreateDelete {

	private String id;
	private String nombre;
	private String descripcion;
	private String tipoAgrupacion;
	private Date fechaInicioVigencia;
	private Date fechaFinVigencia;
	private Usuario gestorComercial;
	private Long numAgrupacionRem;
	private String direccion;
	private Boolean esFormalizacion;	
	private String tipoAgrupacionDescripcion;

	private Usuario gestorComercialBackOffice;
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipoAgrupacion() {
		return tipoAgrupacion;
	}
	public void setTipoAgrupacion(String tipoAgrupacion) {
		this.tipoAgrupacion = tipoAgrupacion;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Date getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}
	public void setFechaInicioVigencia(Date fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}
	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}
	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}
	public Usuario getGestorComercial() {
		return gestorComercial;
	}
	public void setGestorComercial(Usuario gestorComercial) {
		this.gestorComercial = gestorComercial;
	}
	public Long getNumAgrupacionRem() {
		return numAgrupacionRem;
	}
	public void setNumAgrupacionRem(Long numAgrupacionRem) {
		this.numAgrupacionRem = numAgrupacionRem;
	}

	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public Boolean getEsFormalizacion() {
		return esFormalizacion;
	}
	public void setEsFormalizacion(Boolean esFormalizacion) {
		this.esFormalizacion = esFormalizacion;
	}
	public String getTipoAgrupacionDescripcion() {
		return tipoAgrupacionDescripcion;
	}
	public void setTipoAgrupacionDescripcion(String tipoAgrupacionDescripcion) {
		this.tipoAgrupacionDescripcion = tipoAgrupacionDescripcion;
	}

	public Usuario getGestorComercialBackOffice() {
		return gestorComercialBackOffice;
	}

	public void setGestorComercialBackOffice(Usuario gestorComercialBackOffice) {
		this.gestorComercialBackOffice = gestorComercialBackOffice;
	}
}