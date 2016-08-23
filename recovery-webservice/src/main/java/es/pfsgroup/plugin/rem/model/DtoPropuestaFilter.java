package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Propuestas
 *
 */
public class DtoPropuestaFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private String idActivo;
	private String numPropuesta;
	private String nombrePropuesta;
	private String entidadPropietariaCodigo;
	private String tipoDeFecha;
	private String fechaDesde;
	private String fechaHasta;
	private String estadoCodigo;
	private String estadoActivoCodigo;
	private String gestorPrecios;
	private String tipoPropuesta;
	
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}	
	public String getNumPropuesta() {
		return numPropuesta;
	}
	public void setNumPropuesta(String numPropuesta) {
		this.numPropuesta = numPropuesta;
	}
	public String getNombrePropuesta() {
		return nombrePropuesta;
	}
	public void setNombrePropuesta(String nombrePropuesta) {
		this.nombrePropuesta = nombrePropuesta;
	}
	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}
	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}
	public String getTipoDeFecha() {
		return tipoDeFecha;
	}
	public void setTipoDeFecha(String tipoDeFecha) {
		this.tipoDeFecha = tipoDeFecha;
	}
	public String getFechaDesde() {
		return fechaDesde;
	}
	public void setFechaDesde(String fechaDesde) {
		this.fechaDesde = fechaDesde;
	}
	public String getFechaHasta() {
		return fechaHasta;
	}
	public void setFechaHasta(String fechaHasta) {
		this.fechaHasta = fechaHasta;
	}
	public String getEstadoCodigo() {
		return estadoCodigo;
	}
	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}
	public String getEstadoActivoCodigo() {
		return estadoActivoCodigo;
	}
	public void setEstadoActivoCodigo(String estadoActivoCodigo) {
		this.estadoActivoCodigo = estadoActivoCodigo;
	}
	public String getGestorPrecios() {
		return gestorPrecios;
	}
	public void setGestorPrecios(String gestorPrecios) {
		this.gestorPrecios = gestorPrecios;
	}
	public String getTipoPropuesta() {
		return tipoPropuesta;
	}
	public void setTipoPropuesta(String tipoPropuesta) {
		this.tipoPropuesta = tipoPropuesta;
	}
	

}