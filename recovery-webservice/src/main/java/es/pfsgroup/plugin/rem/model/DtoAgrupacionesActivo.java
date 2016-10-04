package es.pfsgroup.plugin.rem.model;

import java.util.Date;




/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoAgrupacionesActivo {

	private static final long serialVersionUID = 0L;

	private String idAgrupacion;
	private String nombre;
	private String descripcion;
	private Date fechaAlta;
	private Date fechaBaja;
	private Date fechaInclusion;
	private Long numAgrupRem;
	private Long numAgrupUvem;
	private String tipoAgrupacionDescripcion;
	private String tipoAgrupacionCodigo;
	private String municipioDescripcion;
	private String provinciaDescripcion;
	private String numActivos;
	private Date fechaInicioVigencia;
	private Date fechaFinVigencia;
	private String numActivosPublicados;
	
	
	
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
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Date getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public Long getNumAgrupRem() {
		return numAgrupRem;
	}
	public void setNumAgrupRem(Long numAgrupRem) {
		this.numAgrupRem = numAgrupRem;
	}

	public Long getNumAgrupUvem() {
		return numAgrupUvem;
	}
	public void setNumAgrupUvem(Long numAgrupUvem) {
		this.numAgrupUvem = numAgrupUvem;
	}
	public String getTipoAgrupacionDescripcion() {
		return tipoAgrupacionDescripcion;
	}
	public void setTipoAgrupacionDescripcion(String tipoAgrupacionDescripcion) {
		this.tipoAgrupacionDescripcion = tipoAgrupacionDescripcion;
	}
	public String getMunicipioDescripcion() {
		return municipioDescripcion;
	}
	public void setMunicipioDescripcion(String municipioDescripcion) {
		this.municipioDescripcion = municipioDescripcion;
	}
	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}
	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}
	public Date getFechaInclusion() {
		return fechaInclusion;
	}
	public void setFechaInclusion(Date fechaInclusion) {
		this.fechaInclusion = fechaInclusion;
	}
	public String getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(String idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public String getTipoAgrupacionCodigo() {
		return tipoAgrupacionCodigo;
	}
	public void setTipoAgrupacionCodigo(String tipoAgrupacionCodigo) {
		this.tipoAgrupacionCodigo = tipoAgrupacionCodigo;
	}
	public String getNumActivos() {
		return numActivos;
	}
	public void setNumActivos(String numActivos) {
		this.numActivos = numActivos;
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
	public String getNumActivosPublicados() {
		return numActivosPublicados;
	}
	public void setNumActivosPublicados(String numActivosPublicados) {
		this.numActivosPublicados = numActivosPublicados;
	}

	
}